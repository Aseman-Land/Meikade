#include "poetinstaller.h"
#include "poetscriptinstaller.h"
#include "meikade.h"
#include "meikadedatabase.h"
#include "meikade_macros.h"

#include <asemanremotefile.h>

#include <QCoreApplication>
#include <QSet>
#include <QThread>
#include <QDebug>
#include <QPointer>
#include <QUuid>

class PoetInstaller::Private
{
public:
    static PoetScriptInstaller *installer;
    static QThread *thread;
    static QHash<qint32, qint32> installingStatus;
    static QHash<AsemanAbstractClientSocket*, QHash<QUrl, AsemanRemoteFile*> > files;

    qint32 poetId;
    bool installed;
    bool updateAvailable;
    QDateTime date;
    QString error;

    QPointer<AsemanRemoteFile> file;

    QUrl source;
    QPointer<AsemanAbstractClientSocket> socket;
};

PoetScriptInstaller *PoetInstaller::Private::installer = Q_NULLPTR;
QThread *PoetInstaller::Private::thread = Q_NULLPTR;
QHash<qint32, qint32> PoetInstaller::Private::installingStatus;
QHash<AsemanAbstractClientSocket*, QHash<QUrl, AsemanRemoteFile*> > PoetInstaller::Private::files;

PoetInstaller::PoetInstaller(QObject *parent) :
    QObject(parent)
{
    p = new Private;
    p->poetId = 0;
    p->installed = false;
    p->updateAvailable = false;
    p->file = Q_NULLPTR;

    initInstaller();

    connect(p->installer, &PoetScriptInstaller::finished, this, &PoetInstaller::finished, Qt::QueuedConnection);
}

void PoetInstaller::setPoetId(qint32 poetId)
{
    if(p->poetId == poetId)
        return;

    p->poetId = poetId;
    refresh();

    Q_EMIT poetIdChanged();
}

qint32 PoetInstaller::poetId() const
{
    return p->poetId;
}

void PoetInstaller::setDate(const QDateTime &date)
{
    if(p->date == date)
        return;

    p->date = date;
    refresh();

    Q_EMIT dateChanged();
}

QDateTime PoetInstaller::date() const
{
    return p->date;
}

QUrl PoetInstaller::source() const
{
    return p->source;
}

void PoetInstaller::setSource(const QUrl &source)
{
    if(p->source == source)
        return;

    p->source = source;
    Q_EMIT sourceChanged();
}

AsemanAbstractClientSocket *PoetInstaller::socket() const
{
    return p->socket;
}

void PoetInstaller::setSocket(AsemanAbstractClientSocket *socket)
{
    if(p->socket == socket)
        return;

    p->socket = socket;
    Q_EMIT socketChanged();
}

void PoetInstaller::setError(const QString &error)
{
    if(p->error == error)
        return;

    p->error = error;
    Q_EMIT errorChanged();
}

void PoetInstaller::setRemoteFile(AsemanRemoteFile *file)
{
    if(p->file == file)
        return;

    if(p->file)
    {
        disconnect(p->file, &AsemanRemoteFile::downloadingChanged, this, &PoetInstaller::downloadingChanged);
        disconnect(p->file, &AsemanRemoteFile::progressChanged, this, &PoetInstaller::progressChanged);
        disconnect(p->file, &AsemanRemoteFile::error, this, &PoetInstaller::fileError);
    }

    p->file = file;

    if(p->file)
    {
        connect(p->file, &AsemanRemoteFile::downloadingChanged, this, &PoetInstaller::downloadingChanged);
        connect(p->file, &AsemanRemoteFile::progressChanged, this, &PoetInstaller::progressChanged);
        connect(p->file, &AsemanRemoteFile::error, this, &PoetInstaller::fileError);
    }

    Q_EMIT downloadingChanged();
    Q_EMIT progressChanged();
}

QString PoetInstaller::error() const
{
    return p->error;
}

void PoetInstaller::setInstalled(bool installed)
{
    if(p->installed == installed)
        return;

    p->installed = installed;
    Q_EMIT installedChanged();
}

bool PoetInstaller::installed() const
{
    return p->installed;
}

bool PoetInstaller::updateAvailable() const
{
    return p->updateAvailable;
}

void PoetInstaller::setUpdateAvailable(bool updateAvailable)
{
    if(p->updateAvailable == updateAvailable)
        return;

    p->updateAvailable = updateAvailable;
    Q_EMIT updateAvailableChanged();
}

bool PoetInstaller::installing() const
{
    return PoetInstaller::Private::installingStatus.value(p->poetId) == 1;
}

void PoetInstaller::setInstalling(bool installing)
{
    if( uninstalling() )
        return;

    if(installing)
        PoetInstaller::Private::installingStatus.insert(p->poetId, 1);
    else
        PoetInstaller::Private::installingStatus.remove(p->poetId);

    Q_EMIT installingChanged();
    Q_EMIT uninstallingChanged();
}

bool PoetInstaller::uninstalling() const
{
    return PoetInstaller::Private::installingStatus.value(p->poetId) == -1;
}

void PoetInstaller::setUninstalling(bool uninstalling)
{
    if( installing() )
        return;

    if(uninstalling)
        PoetInstaller::Private::installingStatus.insert(p->poetId, -1);
    else
        PoetInstaller::Private::installingStatus.remove(p->poetId);

    Q_EMIT installingChanged();
    Q_EMIT uninstallingChanged();
}

bool PoetInstaller::downloading() const
{
    return p->file? p->file->downloading() : false;
}

qreal PoetInstaller::progress() const
{
    return p->file? p->file->progress() : 0;
}

void PoetInstaller::refresh()
{
    MeikadeDatabase *mdb = Meikade::instance()->database();
    bool installed = mdb->containsPoet(p->poetId);
    QDateTime dbDate = mdb->poetLastUpdate( mdb->poetCat(p->poetId) );

    setInstalled(installed);
    setUpdateAvailable( !dbDate.isNull() && dbDate < p->date );
    Q_EMIT uninstallingChanged();
    Q_EMIT installingChanged();
}

void PoetInstaller::install()
{
    if(!p->poetId || PoetInstaller::Private::installingStatus.contains(p->poetId))
        return;
    if(p->source.isEmpty() || !p->socket)
        return;

    AsemanRemoteFile *file = PoetInstaller::Private::files.value(p->socket).value(p->source);
    if(!file)
    {
        const QString tmpFile = TEMP_PATH + "/" + QUuid::createUuid().toString();

        file = new AsemanRemoteFile();
        file->setSocket(p->socket);
        file->setSource(p->source);
        file->setDestination( QUrl::fromLocalFile(tmpFile) );

        PoetInstaller::Private::files[p->socket][p->source] = file;
    }

    setRemoteFile(file);

    qint32 poetId = p->poetId;
    QDateTime date = p->date;

    QPointer<PoetInstaller> dis = this;
    connect(file, &AsemanRemoteFile::downloadingChanged, file, [dis, file, date, poetId](){
        QString path = file->finalPath().toLocalFile();
        if(path.isEmpty() || file->downloading())
            return;

        if(dis)
            dis->setInstalling(true);

        PoetInstaller::Private::installingStatus.insert(poetId, 1);
        QMetaObject::invokeMethod(PoetInstaller::Private::installer, "installFile", Qt::QueuedConnection,
                                  Q_ARG(QString,path),
                                  Q_ARG(int,poetId),
                                  Q_ARG(QDateTime,date));

        PoetInstaller::Private::files[file->socket()].remove(file->source());
        file->deleteLater();
    });
    connect(file, &AsemanRemoteFile::error, this, [this](qint32 errorCode, const QVariant &errorValue){
        Q_UNUSED(errorCode)
        setError(errorValue.toString());
    });
}

void PoetInstaller::remove()
{
    if(PoetInstaller::Private::installingStatus.contains(p->poetId))
        return;

    setUninstalling(true);
    QMetaObject::invokeMethod(p->installer, "remove", Qt::QueuedConnection,
                              Q_ARG(int,p->poetId));
}

void PoetInstaller::initInstaller()
{
    if(PoetInstaller::Private::installer)
        return;

    QThread *thread = new QThread();
    thread->start();

    PoetScriptInstaller *installer = new PoetScriptInstaller();
    installer->moveToThread(thread);

    connect(thread, &QThread::finished, installer, &PoetScriptInstaller::deleteLater);
    connect(QCoreApplication::instance(), &QCoreApplication::aboutToQuit, thread, [thread](){
        thread->quit();
        thread->wait();
    }, Qt::QueuedConnection);
    connect(installer, &PoetScriptInstaller::finished, Meikade::instance(), [](int poetId, bool installed, const QString &error){
        Q_UNUSED(installed)
        PoetInstaller::Private::installingStatus.remove(poetId);
        Meikade::instance()->database()->refresh();
    }, Qt::QueuedConnection);

    PoetInstaller::Private::installer = installer;
    PoetInstaller::Private::thread = thread;
}

void PoetInstaller::finished(int poetId, bool installed, const QString &error)
{
    if(p->poetId != poetId)
        return;

    setInstalled(installed);
    setError(error);
    setInstalling(false);
    setUninstalling(false);

    refresh();
}

void PoetInstaller::fileError(qint32 errorCode, const QVariant &errorValue)
{
    Q_UNUSED(errorCode)
    setError(errorValue.toString());
}

PoetInstaller::~PoetInstaller()
{
    delete p;
}
