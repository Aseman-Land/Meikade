#ifndef MEIKADEOFFLINEMANAGER_H
#define MEIKADEOFFLINEMANAGER_H

#include <QFile>
#include <QMutex>
#include <QNetworkAccessManager>
#include <QObject>
#include <QQueue>
#include <QPair>
#include <QThread>

#ifdef QT_SQL_LIB
#include <QSqlDatabase>
#endif

class MeikadeOfflineItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString sourceUrl READ sourceUrl WRITE setSourceUrl NOTIFY sourceUrlChanged)
    Q_PROPERTY(QString databasePath READ databasePath WRITE setDatabasePath NOTIFY databasePathChanged)
    Q_PROPERTY(qint32 poetId READ poetId WRITE setPoetId NOTIFY poetIdChanged)
    Q_PROPERTY(qint32 catId READ catId WRITE setCatId NOTIFY catIdChanged)
    Q_PROPERTY(qint32 size READ size NOTIFY sizeChanged)
    Q_PROPERTY(qint32 downloadedBytes READ downloadedBytes NOTIFY downloadedBytesChanged)
    Q_PROPERTY(bool downloading READ downloading NOTIFY doingChanged)
    Q_PROPERTY(bool installing READ installing NOTIFY doingChanged)
    Q_PROPERTY(bool uninstalling READ uninstalling NOTIFY doingChanged)
    Q_PROPERTY(bool installed READ installed NOTIFY installedChanged)
    Q_PROPERTY(bool ignoreSslErrors READ ignoreSslErrors WRITE setIgnoreSslErrors NOTIFY ignoreSslErrorsChanged)

    class Private;

public:
    MeikadeOfflineItem(QObject *parent = Q_NULLPTR);
    virtual ~MeikadeOfflineItem();

    void setSourceUrl(const QString &sourceUrl);
    QString sourceUrl() const;

    void setDatabasePath(const QString &databasePath);
    QString databasePath() const;

    void setPoetId(qint32 poetId);
    qint32 poetId() const;

    void setCatId(qint32 catId);
    qint32 catId() const;

    qint32 size() const;
    qint32 downloadedBytes() const;
    bool downloading() const;
    bool installing() const;
    bool uninstalling() const;
    bool installed() const;

    bool ignoreSslErrors() const;
    void setIgnoreSslErrors(bool newIgnoreSslErrors);

Q_SIGNALS:
    void sourceUrlChanged();
    void databasePathChanged();
    void countChanged();
    void poetIdChanged();
    void catIdChanged();
    void listChanged();
    void sizeChanged();
    void downloadedBytesChanged();
    void doingChanged();
    void installedChanged();
    void ignoreSslErrorsChanged();

public Q_SLOTS:
    void install(bool active = true);
    void stop();
    int checkCount() const;

private:
    void connectToInstaller(const QString &hintHash = QString());
    QString getHash() const;

private:
    Private *p;
};

class MeikadeOfflineItemGlobal : public QObject
{
    Q_OBJECT
public:
    MeikadeOfflineItemGlobal(QObject *parent = Q_NULLPTR);
    virtual ~MeikadeOfflineItemGlobal();

Q_SIGNALS:
    void offlineInstalled(qint32 poetId, qint32 catId);
    void offlineUninstalled(qint32 poetId, qint32 catId);
    void offlineRefreshed(qint32 poetId, qint32 catId);
};

class MeikadeOfflineItemInstaller : public QObject
{
    Q_OBJECT
public:
    class InstallThread;

    MeikadeOfflineItemInstaller(const QString &databasePath, const QString &sourceUrl, qint32 poetId, qint32 catId, QObject *parent = Q_NULLPTR);
    virtual ~MeikadeOfflineItemInstaller();

    qint64 size() const;
    qint64 downloadedBytes() const;
    bool downloading() const;
    bool installing() const;
    bool uninstalling() const;

    bool ignoreSslErrors() const;
    void setIgnoreSslErrors(bool newIgnoreSslErrors);

public Q_SLOTS:
    void download();
    void install(const QString &filePath);
    void stop();

Q_SIGNALS:
    void sizeChanged() const;
    void downloadedBytesChanged() const;
    void downloadingChanged() const;
    void doingChanged() const;

private:
    QString mDatabasePath;
    QString mSourceUrl;
    qint32 mPoetId;
    qint32 mCatId;
    qint64 mSize = 0;
    qint64 mDownloadedBytes = 0;
    bool mDoing = false;
    bool mIgnoreSslErrors = false;

    QNetworkAccessManager mAccessManager;
    QNetworkReply *mReply = Q_NULLPTR;

    static QHash<QString, InstallThread*> mThreads;
};

class MeikadeOfflineItemInstaller::InstallThread: public QThread
{
    Q_OBJECT
public:
    class PathUnit {
    public:
        QString databasePath;
        QString filePath;
        qint32 poetId;
        qint32 catId;
    };

    InstallThread(QObject *parent = Q_NULLPTR) : QThread(parent) {}
    virtual ~InstallThread() {}

    QQueue<PathUnit> filePaths;
    QMutex mutex;

Q_SIGNALS:
    void pathFinished(const InstallThread::PathUnit &unit);

protected:
    void run();

#ifdef QT_SQL_LIB
    void moveTables(QSqlDatabase &srcDb, QSqlDatabase &dstDb, const QString &table);
    void deletePoet(QSqlDatabase &db, qint32 poetId);
    void deleteCat(QSqlDatabase &db, qint32 poetId, qint32 catId);
#endif
};

Q_DECLARE_METATYPE(MeikadeOfflineItemInstaller::InstallThread::PathUnit)

#endif // MEIKADEOFFLINEMANAGER_H
