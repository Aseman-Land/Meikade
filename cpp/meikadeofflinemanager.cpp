#include "meikadeofflinemanager.h"

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrlQuery>
#include <QUuid>
#include <QUrl>
#include <QDir>
#include <QDataStream>
#include <QPointer>
#include <QThread>
#include <QMutex>
#include <QQueue>
#include <QSet>
#include <QCryptographicHash>

#ifdef QT_SQL_LIB
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#endif

#define QUERY_EXEC(QUERY) \
    if (!QUERY.exec()) qDebug() << __FUNCTION__ << __LINE__ << QUERY.lastError().text() << QUERY.lastQuery()

static QSet<MeikadeOfflineItemGlobal*> meikadeOfflineItemGlobal_objects;

class MeikadeOfflineItem::Private
{
public:
    QString connectionName;

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
    p->connectionName = QUuid::createUuid().toString();

#ifdef QT_SQL_LIB
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE", p->connectionName);
#endif

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

#ifdef QT_SQL_LIB
    QSqlDatabase db = QSqlDatabase::database(p->connectionName);
    if (db.isOpen())
        db.close();
    if (p->databasePath.length())
    {
        db.setDatabaseName(p->databasePath);
        db.open();
    }
#endif

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

bool MeikadeOfflineItem::uninstalling() const
{
    return p->currentInstaller? p->currentInstaller->uninstalling() : 0;
}

bool MeikadeOfflineItem::installed() const
{
#ifdef QT_SQL_LIB
    QSqlDatabase db = QSqlDatabase::database(p->connectionName);

    QSqlQuery q(db);
    q.prepare("SELECT state FROM offline INNER JOIN poet ON offline.poet_id = poet.id "
              "WHERE offline.poet_id = :poet_id AND offline.cat_id = :cat_id AND state = 1");
    q.bindValue(":poet_id", p->poetId);
    q.bindValue(":cat_id", p->catId <= 0? 0 : p->catId);
    q.exec();

    return q.next();
#else
    return false;
#endif
}

int MeikadeOfflineItem::checkCount() const
{
#ifdef QT_SQL_LIB
    QSqlDatabase db = QSqlDatabase::database(p->connectionName);

    QSqlQuery q(db);
    q.prepare("SELECT COUNT(*) FROM (SELECT poet_id FROM offline WHERE state = 1 GROUP BY poet_id)");
    q.exec();

    if (!q.next())
        return 0;

    return q.record().value(0).toInt();
#else
    return 0;
#endif
}

void MeikadeOfflineItem::install(bool active)
{
    if (downloading() || installing())
        return;

    const QString hash = getHash();
    if (hash.isEmpty())
        return;

    if (Private::installers.contains(hash))
        Private::installers.take(hash)->deleteLater();

    MeikadeOfflineItemInstaller *installer = new MeikadeOfflineItemInstaller(p->databasePath, (active? p->sourceUrl : ""), p->poetId, p->catId);
    installer->download();

    Private::installers[hash] = installer;
    connect(installer, &MeikadeOfflineItemInstaller::doingChanged, installer, [installer, hash](){
        if (!installer->downloading() && !installer->installing())
            Private::installers.take(hash)->deleteLater();
    });

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
        disconnect(p->currentInstaller, &MeikadeOfflineItemInstaller::downloadingChanged, this, &MeikadeOfflineItem::installedChanged);
        disconnect(p->currentInstaller, &MeikadeOfflineItemInstaller::doingChanged, this, &MeikadeOfflineItem::doingChanged);
    }

    MeikadeOfflineItemInstaller *installer = Private::installers.value(hash);
    if (installer && p->currentInstaller != installer)
    {
        connect(installer, &MeikadeOfflineItemInstaller::sizeChanged, this, &MeikadeOfflineItem::sizeChanged);
        connect(installer, &MeikadeOfflineItemInstaller::downloadedBytesChanged, this, &MeikadeOfflineItem::downloadedBytesChanged);
        connect(installer, &MeikadeOfflineItemInstaller::downloadingChanged, this, &MeikadeOfflineItem::installedChanged);
        connect(installer, &MeikadeOfflineItemInstaller::doingChanged, this, &MeikadeOfflineItem::doingChanged);

        p->currentInstaller = installer;
    }

    Q_EMIT sizeChanged();
    Q_EMIT downloadedBytesChanged();
    Q_EMIT doingChanged();
    Q_EMIT installedChanged();
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

#ifdef QT_SQL_LIB
    QSqlDatabase::removeDatabase(p->connectionName);
#endif
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
    qRegisterMetaType<MeikadeOfflineItemInstaller::InstallThread::PathUnit>("InstallThread::PathUnit");

    connect(this, &MeikadeOfflineItemInstaller::doingChanged, this, [this](){
        if (mDoing)
            return;

        for (MeikadeOfflineItemGlobal *g: meikadeOfflineItemGlobal_objects)
            Q_EMIT g->offlineInstalled(mPoetId, mCatId);
    });
}

void MeikadeOfflineItemInstaller::download()
{
    if (mReply || mDoing)
        return;

    if (mSourceUrl.isEmpty()) // It means it's uninstall mode.
    {
        install("");
        return;
    }
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
    mDoing = true;
    Q_EMIT doingChanged();

    if (!mThreads.contains(mDatabasePath))
        mThreads[mDatabasePath] = new InstallThread;

    InstallThread::PathUnit unit;
    unit.filePath = filePath;
    unit.databasePath = mDatabasePath;
    unit.poetId = mPoetId;
    unit.catId = mCatId;

    InstallThread *thread = mThreads.value(mDatabasePath);
    thread->mutex.lock();
    thread->filePaths << unit;
    thread->mutex.unlock();

    thread->start();

    connect(thread, &InstallThread::pathFinished, this, [this, filePath](const InstallThread::PathUnit &unit){
        if (unit.filePath != filePath || unit.poetId != mPoetId || unit.catId != mCatId)
            return;

        mDoing = false;
        Q_EMIT doingChanged();
    });

}

void MeikadeOfflineItemInstaller::stop()
{
    if (!mReply)
        return;

    mReply->deleteLater();
    mReply = Q_NULLPTR;
    mDoing = false;
    Q_EMIT downloadingChanged();
    Q_EMIT doingChanged();
}

bool MeikadeOfflineItemInstaller::installing() const
{
    return mDoing && !mSourceUrl.isEmpty();
}

bool MeikadeOfflineItemInstaller::uninstalling() const
{
    return mDoing && mSourceUrl.isEmpty();
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
#ifdef QT_SQL_LIB
    mutex.lock();
    while (filePaths.count())
    {
        auto unit = filePaths.takeFirst();
        mutex.unlock();

        if (unit.filePath.isEmpty()) // Uninstall mode
        {
            const QString hash = QCryptographicHash::hash(unit.filePath.toUtf8(), QCryptographicHash::Md5).toHex();
            {
                QSqlDatabase dstDb = QSqlDatabase::addDatabase("QSQLITE", hash);
                dstDb.setDatabaseName(unit.databasePath);
                dstDb.open();

                if (unit.catId > 0)
                    deleteCat(dstDb, unit.poetId, unit.catId);
                else
                    deletePoet(dstDb, unit.poetId);
            }
            QSqlDatabase::removeDatabase(hash);
        }
        else
        {
            QString filePath = unit.filePath;
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
                dstDb.setDatabaseName(unit.databasePath);
                dstDb.open();

                const QStringList &tables = srcDb.tables();
                for (const QString &t: tables)
                    moveTables(srcDb, dstDb, t);

                QSqlQuery q(dstDb);
                q.prepare("INSERT OR REPLACE INTO offline (poet_id, cat_id, state) SELECT poet_id, id, 1 FROM cat WHERE poet_id = :poet_id");
                q.bindValue(":poet_id", unit.poetId);
                QUERY_EXEC(q);

                if (unit.catId <= 0)
                {
                    QSqlQuery q(dstDb);
                    q.prepare("INSERT OR REPLACE INTO offline (poet_id, cat_id, state) VALUES (:poet_id, 0, 1)");
                    q.bindValue(":poet_id", unit.poetId);
                    QUERY_EXEC(q);
                }
            }
            QSqlDatabase::removeDatabase(srcHash);
            QSqlDatabase::removeDatabase(dstHash);

            QFile::remove(destPath);
        }

        Q_EMIT pathFinished(unit);

        mutex.lock();
    }
    mutex.unlock();
#endif
}

#ifdef QT_SQL_LIB
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

        QUERY_EXEC(q);
    }

    QSqlQuery("COMMIT", dstDb).exec();
}

void MeikadeOfflineItemInstaller::InstallThread::deletePoet(QSqlDatabase &db, qint32 poetId)
{
    QSqlQuery q(db);
    q.prepare("SELECT id FROM cat WHERE poet_id = :poet_id AND parent_id = 0");
    q.bindValue(":poet_id", poetId);
    QUERY_EXEC(q);

    while (q.next())
    {
        QSqlRecord r = q.record();
        deleteCat(db, poetId, r.value("id").toInt());
    }

    q.prepare("DELETE FROM poet WHERE id = :poet_id");
    q.bindValue(":poet_id", poetId);
    QUERY_EXEC(q);
}

void MeikadeOfflineItemInstaller::InstallThread::deleteCat(QSqlDatabase &db, qint32 poetId, qint32 catId)
{
    QSqlQuery q(db);
    q.prepare("DELETE FROM poet WHERE id = :poet_id");
    q.bindValue(":poet_id", poetId);
    QUERY_EXEC(q);

    q.prepare("DELETE FROM offline WHERE poet_id = :poet_id AND cat_id = 0");
    q.bindValue(":poet_id", poetId);
    QUERY_EXEC(q);

    q.prepare("DELETE FROM cat WHERE id = :cat_id");
    q.bindValue(":cat_id", catId);
    QUERY_EXEC(q);

    q.prepare("DELETE FROM offline WHERE poet_id = :poet_id AND cat_id = :cat_id");
    q.bindValue(":poet_id", poetId);
    q.bindValue(":cat_id", catId);
    QUERY_EXEC(q);

    q.prepare("SELECT id FROM poem WHERE cat_id = :cat_id");
    q.bindValue(":cat_id", catId);
    QUERY_EXEC(q);

    while (q.next())
    {
        QSqlRecord r = q.record();

        QSqlQuery pq(db);
        pq.prepare("DELETE FROM verse WHERE poem_id = :poem_id");
        pq.bindValue(":poem_id", r.value("id"));
        QUERY_EXEC(pq);
    }

    q.prepare("DELETE FROM poem WHERE cat_id = :cat_id");
    q.bindValue(":cat_id", catId);
    QUERY_EXEC(q);

    q.prepare("SELECT id FROM cat WHERE parent_id = :cat_id");
    q.bindValue(":cat_id", catId);
    QUERY_EXEC(q);

    while (q.next())
    {
        QSqlRecord r = q.record();
        deleteCat(db, poetId, r.value("id").toInt());
    }
}
#endif


MeikadeOfflineItemGlobal::MeikadeOfflineItemGlobal(QObject *parent) :
    QObject(parent)
{
    meikadeOfflineItemGlobal_objects.insert(this);
}

MeikadeOfflineItemGlobal::~MeikadeOfflineItemGlobal()
{
    meikadeOfflineItemGlobal_objects.remove(this);
}
