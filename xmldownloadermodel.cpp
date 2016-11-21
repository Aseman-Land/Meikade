#define XML_DOWNLOAD_LINK "http://aseman.land/download/meikade/2/data.xml"
#define XML_DATE_FORMAT "yyyy/MM/dd-HH:mm:ss"
#define XML_VERSION "1.0"
#define XML_REVISION_STRUCTURE 1

#include "xmldownloadermodel.h"
#include "poetscriptinstallerqueue.h"
#include "asemantools/asemandownloader.h"
#include "asemantools/asemanapplication.h"
#include "meikade.h"
#include "meikadedatabase.h"

#include <QDebug>
#include <QDomDocument>
#include <QDomAttr>
#include <QDateTime>
#include <QUrl>
#include <QPointer>
#include <QUuid>

class XmlDownloaderModelUnit
{
public:
    XmlDownloaderModelUnit() :
        poetId(0),
        fileSize(0),
        thumbSize(0),
        downloaded(false),
        downloading(false),
        downloadError(false),
        installed(false),
        installing(false),
        updateAvailable(false),
        downloadedBytes(0),
        structure(0),
        version(0)
    {}

    int poetId;
    QString name;

    QString guid;
    QDateTime date;
    QString mime;
    QString compress;

    QUrl url;
    QUrl thumb;

    qint64 fileSize;
    qint64 thumbSize;
    bool downloaded;
    bool downloading;
    bool downloadError;
    bool installed;
    bool installing;
    bool updateAvailable;
    qint64 downloadedBytes;

    int structure;
    int version;

    bool operator ==(const XmlDownloaderModelUnit &b) {
        return guid == b.guid;
    }
};

class XmlDownloaderModelPrivate
{
public:
    QStringList errors;
    QPointer<AsemanDownloader> xml_downloader;
    QHash<QString, AsemanDownloader*> downloaders;
    PoetScriptInstallerQueue *installer;

    QString name;
    QString description;
    QList<XmlDownloaderModelUnit> list;
    bool refreshing;
};

XmlDownloaderModel::XmlDownloaderModel(QObject *parent) :
    QAbstractListModel(parent)
{
    p = new XmlDownloaderModelPrivate;
    p->refreshing = false;
    p->installer = new PoetScriptInstallerQueue(this);

    connect(p->installer, SIGNAL(error(QString,QString))   , SLOT(installerError(QString,QString))   );
    connect(p->installer, SIGNAL(finished(QString,QString)), SLOT(installerFinished(QString,QString)));
}

XmlDownloaderModelUnit &XmlDownloaderModel::itemOf(const QModelIndex &index) const
{
    return p->list[index.row()];
}

int XmlDownloaderModel::indexOf(const QString &guid) const
{
    for(int i=0; i<p->list.count(); i++)
        if(p->list.at(i).guid == guid)
            return i;

    return -1;
}

int XmlDownloaderModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return count();
}

QVariant XmlDownloaderModel::data(const QModelIndex &index, int role) const
{
    const XmlDownloaderModelUnit &unit = itemOf(index);
    QVariant result;
    switch(role)
    {
    case DataRolePoetId:
        result = unit.poetId;
        break;

    case DataRolePoetName:
        result = unit.name;
        break;

    case DataRoleFileDownloadUrl:
        result = unit.url;
        break;

    case DataRoleFileMimeType:
        result = unit.mime;
        break;

    case DataRoleFileThumbUrl:
        result = unit.thumb;
        break;

    case DataRoleFileGuid:
        result = unit.guid;
        break;

    case DataRoleFileSize:
        result = unit.fileSize;
        break;

    case DataRoleFileThumbSize:
        result = unit.thumbSize;
        break;

    case DataRoleFileCompressMethod:
        result = unit.compress;
        break;

    case DataRoleFilePublicDate:
        result = unit.date;
        break;

    case DataRoleDownloadedStatus:
        result = unit.downloaded;
        break;

    case DataRoleDownloadingState:
        result = unit.downloading;
        break;

    case DataRoleDownloadError:
        result = unit.downloadError;
        break;

    case DataRoleDownloadedBytes:
        result = unit.downloadedBytes;
        break;

    case DataRoleInstalled:
        result = unit.installed;
        break;

    case DataRoleUpdateAvailable:
        result = unit.updateAvailable;
        break;

    case DataRoleInstalling:
        result = unit.installing;
        break;
    }

    return result;
}

bool XmlDownloaderModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    bool result = false;
    XmlDownloaderModelUnit &unit = itemOf(index);
    Q_UNUSED(unit)
    switch(role)
    {
    case DataRoleDownloadingState:
        if(value.toBool())
            startDownload(index);
        else
            stopDownload(index);
        break;

    case DataRolePoetId:
    case DataRolePoetName:
    case DataRoleFileDownloadUrl:
    case DataRoleFileMimeType:
    case DataRoleFileThumbUrl:
    case DataRoleFileGuid:
    case DataRoleFileSize:
    case DataRoleFileThumbSize:
    case DataRoleFileCompressMethod:
    case DataRoleFilePublicDate:
    case DataRoleDownloadedStatus:
    case DataRoleDownloadError:
    case DataRoleDownloadedBytes:
        break;
    }

    return result;
}

QHash<qint32, QByteArray> XmlDownloaderModel::roleNames() const
{
    QHash<qint32, QByteArray> *res = 0;
    if( res )
        return *res;

    res = new QHash<qint32, QByteArray>();
    res->insert( DataRolePoetId, "poetId");
    res->insert( DataRolePoetName, "poetName");
    res->insert( DataRoleFileDownloadUrl, "fileDownloadUrl");
    res->insert( DataRoleFileMimeType, "fileMimeType");
    res->insert( DataRoleFileThumbUrl, "fileThumbUrl");
    res->insert( DataRoleFileSize, "fileSize");
    res->insert( DataRoleFileThumbSize, "fileThumbSize");
    res->insert( DataRoleFileGuid, "fileGuid");
    res->insert( DataRoleFilePublicDate, "filePublicData");
    res->insert( DataRoleFileCompressMethod, "fileCompressMethod");
    res->insert( DataRoleDownloadedStatus, "downloadedStatus");
    res->insert( DataRoleDownloadingState, "downloadingState");
    res->insert( DataRoleDownloadError, "downloadError");
    res->insert( DataRoleDownloadedBytes, "downloadedBytes");
    res->insert( DataRoleInstalled, "installed");
    res->insert( DataRoleUpdateAvailable, "updateAvailable");
    res->insert( DataRoleInstalling, "installing");

    return *res;
}

int XmlDownloaderModel::count() const
{
    return p->list.count();
}

QStringList XmlDownloaderModel::errors() const
{
    return p->errors;
}

bool XmlDownloaderModel::refreshing() const
{
    return p->refreshing;
}

bool XmlDownloaderModel::processing() const
{
    return !p->downloaders.isEmpty() || p->installer->isActive();
}

void XmlDownloaderModel::refresh()
{
    if(processing())
        return;
    if(p->xml_downloader)
        return;

    changed(QList<XmlDownloaderModelUnit>());

    p->xml_downloader = new AsemanDownloader(this);
    p->xml_downloader->setPath(XML_DOWNLOAD_LINK);

    connect(p->xml_downloader, SIGNAL(error(QStringList))  , SLOT(error(QStringList))  );
    connect(p->xml_downloader, SIGNAL(finished(QByteArray)), SLOT(finished(QByteArray)));

    p->xml_downloader->start();

    p->refreshing = true;
    emit refreshingChanged();
}

void XmlDownloaderModel::error(const QStringList &error)
{
    p->xml_downloader->deleteLater();
    p->xml_downloader = 0;

    p->refreshing = false;
    p->errors == error;

    emit errorsChanged();
    emit refreshingChanged();
}

void XmlDownloaderModel::finished(const QByteArray &data)
{
    QList<XmlDownloaderModelUnit> result;
    QDomDocument dom;

    QString errorStr;
    int errorLine;
    int errorColumn;

    if(!dom.setContent(data, true, &errorStr, &errorLine, &errorColumn))
    {
        qDebug() << QString("Parse error at line %1, column %2:%3").arg(errorLine).arg(errorColumn).arg(errorStr);
        return;
    }
    if(dom.doctype().name() != "MeikadePoemsXml")
    {
        qDebug() << "Wrong doc type!";
        return;
    }

    QDomElement root = dom.documentElement();
    if(root.tagName() != "MeikadePoemsXml")
    {
        qDebug() << QString("The file is not an TS file.");
        return;
    }
    if(!root.hasAttribute("version") || root.attribute("version") < XML_VERSION)
    {
        qDebug() << QString("The file has old version.");
        return;
    }

    MeikadeDatabase *mdb = Meikade::instance()->database();

    QDomElement nameChild = root.firstChildElement("Name");
    QDomElement descChild = root.firstChildElement("Description");
    QDomElement poetsChild = root.firstChildElement("Poets");

    p->name = nameChild.text();
    p->description = descChild.text();

    QDomElement poetChild = poetsChild.firstChildElement("Poet");
    while(!poetChild.isNull())
    {
        const int poetId = poetChild.attribute("id").toInt();
        const QString &name = poetChild.attribute("name");

        XmlDownloaderModelUnit unit;
        unit.name = name;
        unit.poetId = poetId;

        QDomElement revision = poetChild.firstChildElement("Revision");
        while(!revision.isNull())
        {
            const int structure = revision.attribute("structure").toInt();
            const QDateTime &date = QDateTime::fromString(revision.attribute("date"), XML_DATE_FORMAT);
            if(structure > XML_REVISION_STRUCTURE || date < unit.date)
            {
                revision = revision.nextSiblingElement("Poet");
                continue;
            }

            const QString &guid = revision.attribute("guid");
            const QString &mime = revision.attribute("mimeType");
            const QString &compress = revision.attribute("compress");
            const int version = revision.attribute("version").toInt();

            QDomElement urlElement = revision.firstChildElement("Url");
            QDomElement thumbElement = revision.firstChildElement("Thumb");

            const QString &url = urlElement.text();
            const QString &thumb = thumbElement.text();

            const qint64 fileSize = urlElement.attribute("size").toLongLong();
            const qint64 thumbSize = thumbElement.attribute("size").toLongLong();

            unit.guid = guid;
            unit.mime = mime;
            unit.compress = compress;
            unit.url = url;
            unit.thumb = thumb;
            unit.fileSize = fileSize;
            unit.thumbSize = thumbSize;
            unit.version = version;
            unit.structure = structure;
            unit.updateAvailable = false;
            unit.installed = mdb->containsPoet(poetId);

            revision = revision.nextSiblingElement("Poet");
        }

        if(!unit.guid.isEmpty())
            result << unit;

        poetChild = poetChild.nextSiblingElement("Poet");
    }

    p->xml_downloader->deleteLater();
    p->xml_downloader = 0;

    changed(result);

    p->refreshing = false;
    emit refreshingChanged();
}

void XmlDownloaderModel::fileError(const QStringList &error)
{
    Q_UNUSED(error)
    AsemanDownloader *downloader = qobject_cast<AsemanDownloader*>(sender());
    if(!downloader)
        return;

    const QString guid = p->downloaders.key(downloader);
    if(guid.isEmpty())
        return;

    p->downloaders.remove(guid);
    downloader->deleteLater();

    const int idx = indexOf(guid);
    if(idx == -1)
        return;

    XmlDownloaderModelUnit &unit = p->list[idx];
    unit.downloadError = true;
    unit.downloading = false;
    unit.downloadedBytes = 0;

    QModelIndex index = QAbstractListModel::index(idx);
    emit dataChanged(index, index, QVector<int>()<<DataRoleDownloadingState
                     <<DataRoleDownloadError<<DataRoleDownloadedBytes);
}

void XmlDownloaderModel::fileFinished(const QByteArray &data)
{
    Q_UNUSED(data)
    AsemanDownloader *downloader = qobject_cast<AsemanDownloader*>(sender());
    if(!downloader)
        return;

    const QString guid = p->downloaders.key(downloader);
    if(guid.isEmpty())
        return;

    const QString filePath = downloader->destination();

    p->downloaders.remove(guid);
    downloader->deleteLater();

    const int idx = indexOf(guid);
    if(idx == -1)
        return;

    XmlDownloaderModelUnit &unit = p->list[idx];
    unit.downloadError = false;
    unit.downloading = true;
    unit.downloadedBytes = unit.fileSize;
    unit.installing = true;
    unit.installed = false;

    p->installer->append(filePath, unit.guid);

    QModelIndex index = QAbstractListModel::index(idx);
    emit dataChanged(index, index, QVector<int>()<<DataRoleDownloadingState
                     <<DataRoleDownloadError<<DataRoleDownloadedBytes
                     <<DataRoleInstalling<<DataRoleInstalled);
}

void XmlDownloaderModel::fileRecievedBytesChanged()
{
    AsemanDownloader *downloader = qobject_cast<AsemanDownloader*>(sender());
    if(!downloader)
        return;

    const QString guid = p->downloaders.key(downloader);
    if(guid.isEmpty())
        return;

    const int idx = indexOf(guid);
    if(idx == -1)
        return;

    XmlDownloaderModelUnit &unit = p->list[idx];
    unit.downloadedBytes = downloader->recievedBytes();

    QModelIndex index = QAbstractListModel::index(idx);
    emit dataChanged(index, index, QVector<int>()<<DataRoleDownloadedBytes);
}

void XmlDownloaderModel::installerError(const QString &file, const QString &guid)
{
    Q_UNUSED(file)

    const int idx = indexOf(guid);
    if(idx == -1)
        return;

    XmlDownloaderModelUnit &unit = p->list[idx];
    unit.downloadError = true;
    unit.downloading = false;
    unit.downloadedBytes = 0;
    unit.installing = false;
    unit.installed = false;

    QModelIndex index = QAbstractListModel::index(idx);
    emit dataChanged(index, index, QVector<int>()<<DataRoleDownloadingState
                     <<DataRoleDownloadError<<DataRoleDownloadedBytes
                     <<DataRoleInstalling<<DataRoleInstalled);
}

void XmlDownloaderModel::installerFinished(const QString &file, const QString &guid)
{
    Q_UNUSED(file)

    const int idx = indexOf(guid);
    if(idx == -1)
        return;

    XmlDownloaderModelUnit &unit = p->list[idx];
    unit.downloadError = false;
    unit.downloading = false;
    unit.downloadedBytes = 0;
    unit.installing = false;
    unit.installed = true;

    QModelIndex index = QAbstractListModel::index(idx);
    emit dataChanged(index, index, QVector<int>()<<DataRoleDownloadingState
                     <<DataRoleDownloadError<<DataRoleDownloadedBytes
                     <<DataRoleInstalling<<DataRoleInstalled);

    MeikadeDatabase *mdb = Meikade::instance()->database();
    mdb->refresh();
}

void XmlDownloaderModel::startDownload(const QModelIndex &index)
{
    XmlDownloaderModelUnit &unit = itemOf(index);
    if(unit.downloading || unit.downloaded)
        return;

    if(!p->downloaders.contains(unit.guid))
    {
        const QString tmpFile = AsemanApplication::tempPath() + "/" + QUuid::createUuid().toString() + "." + unit.compress;

        AsemanDownloader *downloader = new AsemanDownloader(this);
        downloader->setPath(unit.url.toString());
        downloader->setDestination(tmpFile);
        downloader->setDownloaderId(unit.poetId);

        connect(downloader, SIGNAL(error(QStringList))    , SLOT(fileError(QStringList))    );
        connect(downloader, SIGNAL(finished(QByteArray))  , SLOT(fileFinished(QByteArray))  );
        connect(downloader, SIGNAL(recievedBytesChanged()), SLOT(fileRecievedBytesChanged()));

        p->downloaders[unit.guid] = downloader;
        downloader->start();
    }

    unit.downloading = true;
    unit.downloadError = false;
    emit dataChanged(index, index, QVector<int>()<<DataRoleDownloadingState<<DataRoleDownloadError);
}

void XmlDownloaderModel::stopDownload(const QModelIndex &index)
{
    XmlDownloaderModelUnit &unit = itemOf(index);
    if(!unit.downloading || unit.downloaded)
        return;

    if(p->downloaders.contains(unit.guid))
    {
        AsemanDownloader *downloader = p->downloaders.take(unit.guid);
        downloader->deleteLater();
    }

    unit.downloading = false;
    emit dataChanged(index, index, QVector<int>()<<DataRoleDownloadingState);
}

void XmlDownloaderModel::changed(const QList<XmlDownloaderModelUnit> &list)
{
    bool count_changed = (list.count()==p->list.count());

    for( int i=0 ; i<p->list.count() ; i++ )
    {
        const XmlDownloaderModelUnit &file = p->list.at(i);
        if( list.contains(file) )
            continue;

        beginRemoveRows(QModelIndex(), i, i);
        p->list.removeAt(i);
        i--;
        endRemoveRows();
    }

    QList<XmlDownloaderModelUnit> temp_list = list;
    for( int i=0 ; i<temp_list.count() ; i++ )
    {
        const XmlDownloaderModelUnit &file = temp_list.at(i);
        if( p->list.contains(file) )
            continue;

        temp_list.removeAt(i);
        i--;
    }
    while( p->list != temp_list )
        for( int i=0 ; i<p->list.count() ; i++ )
        {
            const XmlDownloaderModelUnit &file = p->list.at(i);
            int nw = temp_list.indexOf(file);
            if( i == nw )
                continue;

            beginMoveRows( QModelIndex(), i, i, QModelIndex(), nw>i?nw+1:nw );
            p->list.move( i, nw );
            endMoveRows();
        }

    for( int i=0 ; i<list.count() ; i++ )
    {
        const XmlDownloaderModelUnit &file = list.at(i);
        if( p->list.contains(file) )
            continue;

        beginInsertRows(QModelIndex(), i, i );
        p->list.insert( i, file );
        endInsertRows();
    }

    if(count_changed)
        emit countChanged();

    emit listChanged();
}

XmlDownloaderModel::~XmlDownloaderModel()
{
    delete p;
}

