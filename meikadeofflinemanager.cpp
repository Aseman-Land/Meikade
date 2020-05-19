#include "meikadeofflinemanager.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QUrl>
#include <QDir>
#include <QDataStream>
#include <QPointer>
#include <QThread>
#include <QMutex>
#include <QQueue>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>

class MeikadeOfflineItem::Private
{
public:
    QString sourceUrl;
    QString databasePath;
    qint32 poetId = 0;
    qint32 catId = -1;

    QNetworkAccessManager accessManager;

    QPointer<MeikadeOfflineItemInstaller> currentInstaller;

    static QSet<MeikadeOfflineItem*> objects;
    static QHash<QString, MeikadeOfflineItemInstaller*> installers;
};

QSet<MeikadeOfflineItem*> MeikadeOfflineItem::Private::objects;
QHash<QString, MeikadeOfflineItemInstaller*> MeikadeOfflineItem::Private::installers;

MeikadeOfflineItem::MeikadeOfflineItem(QObject *parent) :
    QObject(parent)
{
    p = new Private;

    Private::objects.insert(this);
}

void MeikadeOfflineItem::setSourceUrl(const QString &sourceUrl)
{
    if (p->sourceUrl == sourceUrl)
        return;

    p->sourceUrl = sourceUrl;
    connectToInstaller();
    Q_EMIT sourceUrlChanged();
}

QString MeikadeOfflineItem::sourceUrl() const
{
    return p->sourceUrl;
}

void MeikadeOfflineItem::setDatabasePath(const QString &databasePath)
{
    if (p->databasePath == databasePath)
        return;

    p->databasePath = databasePath;
    connectToInstaller();
    Q_EMIT databasePathChanged();
}

QString MeikadeOfflineItem::databasePath() const
{
    return p->databasePath;
}

void MeikadeOfflineItem::setPoetId(qint32 poetId)
{
    if (p->poetId == poetId)
        return;

    p->poetId = poetId;
    connectToInstaller();
    Q_EMIT poetIdChanged();
}

qint32 MeikadeOfflineItem::poetId() const
{
    return p->poetId;
}

void MeikadeOfflineItem::setCatId(qint32 catId)
{
    if (p->catId == catId)
        return;

    p->catId = catId;
    connectToInstaller();
    Q_EMIT catIdChanged();
}

qint32 MeikadeOfflineItem::catId() const
{
    return p->catId;
}

qint32 MeikadeOfflineItem::size() const
{
    return p->currentInstaller? p->currentInstaller->size() : 0;
}

qint32 MeikadeOfflineItem::downloadedBytes() const
{
    return p->currentInstaller? p->currentInstaller->downloadedBytes() : 0;
}

bool MeikadeOfflineItem::downloading() const
{
    return p->currentInstaller? p->currentInstaller->downloading() : 0;
}

bool MeikadeOfflineItem::installing() const
{
    return p->currentInstaller? p->currentInstaller->installing() : 0;
}

void MeikadeOfflineItem::download()
{
    if (downloading() || installing())
        return;

    const QString hash = getHash();
    if (hash.isEmpty())
        return;

    MeikadeOfflineItemInstaller *installer = new MeikadeOfflineItemInstaller(p->databasePath, p->sourceUrl, p->poetId, p->catId);
    installer->download();

    Private::installers[hash] = installer;

    for (MeikadeOfflineItem *item: Private::objects)
        item->connectToInstaller(hash);
}

void MeikadeOfflineItem::stop()
{
    if (!p->currentInstaller)
        return;

    p->currentInstaller->stop();
}

void MeikadeOfflineItem::connectToInstaller(const QString &hintHash)
{
    const QString hash = getHash();
    if (hintHash.count() && hash != hintHash)
        return;

    if (p->currentInstaller)
    {
        disconnect(p->currentInstaller, &MeikadeOfflineItemInstaller::sizeChanged, this, &MeikadeOfflineItem::sizeChanged);
        disconnect(p->currentInstaller, &MeikadeOfflineItemInstaller::downloadedBytesChanged, this, &MeikadeOfflineItem::downloadedBytesChanged);
        disconnect(p->currentInstaller, &MeikadeOfflineItemInstaller::downloadingChanged, this, &MeikadeOfflineItem::downloadingChanged);
        disconnect(p->currentInstaller, &MeikadeOfflineItemInstaller::installingChanged, this, &MeikadeOfflineItem::installingChanged);
    }

    MeikadeOfflineItemInstaller *installer = Private::installers.value(hash);
    if (installer && p->currentInstaller != installer)
    {
        connect(installer, &MeikadeOfflineItemInstaller::sizeChanged, this, &MeikadeOfflineItem::sizeChanged);
        connect(installer, &MeikadeOfflineItemInstaller::downloadedBytesChanged, this, &MeikadeOfflineItem::downloadedBytesChanged);
        connect(installer, &MeikadeOfflineItemInstaller::downloadingChanged, this, &MeikadeOfflineItem::downloadingChanged);
        connect(installer, &MeikadeOfflineItemInstaller::installingChanged, this, &MeikadeOfflineItem::installingChanged);

        p->currentInstaller = installer;
    }

    Q_EMIT sizeChanged();
    Q_EMIT downloadedBytesChanged();
    Q_EMIT downloadingChanged();
    Q_EMIT installingChanged();
}

QString MeikadeOfflineItem::getHash() const
{
    if (p->poetId == 0 || p->catId < 0 || p->databasePath.isEmpty() || p->sourceUrl.isEmpty())
        return QString();

    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    stream << p->poetId;
    stream << p->catId;
    stream << p->databasePath;
    stream << p->sourceUrl;

    return QCryptographicHash::hash(data, QCryptographicHash::Md5).toHex();
}

MeikadeOfflineItem::~MeikadeOfflineItem()
{
    Private::objects.remove(this);
    delete p;
}


QHash<QString, MeikadeOfflineItemInstaller::InstallThread*> MeikadeOfflineItemInstaller::mThreads;

MeikadeOfflineItemInstaller::MeikadeOfflineItemInstaller(const QString &databasePath, const QString &sourceUrl, qint32 poetId, qint32 catId, QObject *parent) :
    QObject(parent),
    mDatabasePath(databasePath),
    mSourceUrl(sourceUrl),
    mPoetId(poetId),
    mCatId(catId)
{
}

void MeikadeOfflineItemInstaller::download()
{
    if (mReply || mInstalling)
        return;

    if (mSourceUrl.right(1) != "/")
        mSourceUrl += "/";

    const QString fileName = "poet_" + QString::number(mPoetId) + (mCatId? "-cat_" + QString::number(mCatId) : "") + ".sqlite.gz";
    QString path = mSourceUrl + fileName;

    QNetworkRequest request;
    request.setUrl(path);

    mReply = mAccessManager.get(request);

    const QString downloadLocation = QDir::tempPath() + "/" + fileName;

    QFile *file = new QFile(downloadLocation, this);
    file->open(QFile::WriteOnly);

    connect(mReply, &QNetworkReply::downloadProgress, this, [this](qint64 bytesReceived, qint64 bytesTotal){
        mDownloadedBytes = bytesReceived;
        mSize = bytesTotal;

        Q_EMIT downloadedBytesChanged();
        Q_EMIT sizeChanged();
    });

    connect(mReply, &QNetworkReply::readyRead, this, [this, file](){
        file->write( mReply->readAll() );
    });

    connect(mReply, &QNetworkReply::finished, this, [this, file, downloadLocation](){
        file->close();
        if (!mReply)
            return;

        mReply->deleteLater();
        mReply = Q_NULLPTR;

        install(downloadLocation);

        Q_EMIT downloadingChanged();
    });

    Q_EMIT downloadingChanged();
}

void MeikadeOfflineItemInstaller::install(const QString &filePath)
{
    mInstalling = true;
    Q_EMIT installingChanged();

    if (!mThreads.contains(mDatabasePath))
        mThreads[mDatabasePath] = new InstallThread;

    InstallThread *thread = mThreads.value(mDatabasePath);
    thread->mutex.lock();
    thread->filePaths << QPair<QString, QString>(filePath, mDatabasePath);
    thread->mutex.unlock();

    thread->start();

    connect(thread, &InstallThread::pathFinished, this, [this, filePath](const QString &path){
        if (filePath != path)
            return;

        mInstalling = false;
        Q_EMIT installingChanged();
    });

}

void MeikadeOfflineItemInstaller::stop()
{
    if (!mReply)
        return;

    mReply->deleteLater();
    mReply = Q_NULLPTR;
    Q_EMIT downloadingChanged();
}

bool MeikadeOfflineItemInstaller::installing() const
{
    return mInstalling;
}

bool MeikadeOfflineItemInstaller::downloading() const
{
    return mReply;
}

qint64 MeikadeOfflineItemInstaller::downloadedBytes() const
{
    return mDownloadedBytes;
}

qint64 MeikadeOfflineItemInstaller::size() const
{
    return mSize;
}

MeikadeOfflineItemInstaller::~MeikadeOfflineItemInstaller()
{
}


void MeikadeOfflineItemInstaller::InstallThread::run() {
    mutex.lock();
    while (filePaths.count())
    {
        auto pair = filePaths.takeFirst();
        mutex.unlock();

        QString filePath = pair.first;
        QString destPath = filePath.left(filePath.length() - 3);

        QFile destFile(destPath);
        destFile.open(QFile::WriteOnly);

        QFile file(filePath);
        file.open(QFile::ReadOnly);

        destFile.write( qUncompress(file.readAll()) );

        file.close();
        destFile.close();

        QFile::remove(filePath);

        const QString hash = QCryptographicHash::hash(destPath.toUtf8(), QCryptographicHash::Md5).toHex();
        const QString srcHash = hash + "_src";
        const QString dstHash = hash + "_dst";
        {
            QSqlDatabase srcDb = QSqlDatabase::addDatabase("QSQLITE", srcHash);
            srcDb.setDatabaseName(destPath);
            srcDb.open();

            QSqlDatabase dstDb = QSqlDatabase::addDatabase("QSQLITE", dstHash);
            dstDb.setDatabaseName(pair.second);
            dstDb.open();

            const QStringList &tables = srcDb.tables();
            for (const QString &t: tables)
                moveTables(srcDb, dstDb, t);
        }
        QSqlDatabase::removeDatabase(srcHash);
        QSqlDatabase::removeDatabase(dstHash);

        Q_EMIT pathFinished(filePath);

        mutex.lock();
    }
    mutex.unlock();
}

void MeikadeOfflineItemInstaller::InstallThread::moveTables(QSqlDatabase &srcDb, QSqlDatabase &dstDb, const QString &table)
{
    QSqlQuery("BEGIN", dstDb).exec();

    QSqlQuery srcQuery(srcDb);
    srcQuery.prepare("SELECT * FROM " + table);
    srcQuery.exec();

    while (srcQuery.next())
    {
        QSqlRecord r = srcQuery.record();

        QString queryStr = "INSERT OR REPLACE INTO " + table + " VALUES (";
        for (int i=0; i<r.count(); i++)
        {
            if (i) queryStr += ", ";
            queryStr += "?";
        }
        queryStr += ")";

        QSqlQuery q(dstDb);
        q.prepare(queryStr);
        for (int i=0; i<r.count(); i++)
            q.addBindValue(r.value(i));

        q.exec();
    }

    QSqlQuery("COMMIT", dstDb).exec();
}
