#ifndef MEIKADEOFFLINEMANAGER_H
#define MEIKADEOFFLINEMANAGER_H

#include <QFile>
#include <QMutex>
#include <QNetworkAccessManager>
#include <QObject>
#include <QQueue>
#include <QPair>
#include <QThread>
#include <QSqlDatabase>

class MeikadeOfflineItem : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString sourceUrl READ sourceUrl WRITE setSourceUrl NOTIFY sourceUrlChanged)
    Q_PROPERTY(QString databasePath READ databasePath WRITE setDatabasePath NOTIFY databasePathChanged)
    Q_PROPERTY(qint32 poetId READ poetId WRITE setPoetId NOTIFY poetIdChanged)
    Q_PROPERTY(qint32 catId READ catId WRITE setCatId NOTIFY catIdChanged)
    Q_PROPERTY(qint32 size READ size NOTIFY sizeChanged)
    Q_PROPERTY(qint32 downloadedBytes READ downloadedBytes NOTIFY downloadedBytesChanged)
    Q_PROPERTY(bool downloading READ downloading NOTIFY downloadingChanged)
    Q_PROPERTY(bool installing READ installing NOTIFY installingChanged)

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

Q_SIGNALS:
    void sourceUrlChanged();
    void databasePathChanged();
    void countChanged();
    void poetIdChanged();
    void catIdChanged();
    void listChanged();

    void sizeChanged() const;
    void downloadedBytesChanged() const;
    void downloadingChanged() const;
    void installingChanged() const;

public Q_SLOTS:
    void download();
    void stop();

private:
    void connectToInstaller(const QString &hintHash = QString());
    QString getHash() const;

private:
    Private *p;
};

class MeikadeOfflineItemInstaller : public QObject
{
    Q_OBJECT
    class InstallThread;

public:
    MeikadeOfflineItemInstaller(const QString &databasePath, const QString &sourceUrl, qint32 poetId, qint32 catId, QObject *parent = Q_NULLPTR);
    virtual ~MeikadeOfflineItemInstaller();

    qint64 size() const;
    qint64 downloadedBytes() const;
    bool downloading() const;
    bool installing() const;

public Q_SLOTS:
    void download();
    void install(const QString &filePath);
    void stop();

Q_SIGNALS:
    void sizeChanged() const;
    void downloadedBytesChanged() const;
    void downloadingChanged() const;
    void installingChanged() const;

private:
    QString mDatabasePath;
    QString mSourceUrl;
    qint32 mPoetId;
    qint32 mCatId;
    qint64 mSize = 0;
    qint64 mDownloadedBytes = 0;
    bool mInstalling = false;

    QNetworkAccessManager mAccessManager;
    QNetworkReply *mReply = Q_NULLPTR;

    static QHash<QString, InstallThread*> mThreads;
};

class MeikadeOfflineItemInstaller::InstallThread: public QThread
{
    Q_OBJECT
public:
    InstallThread(QObject *parent = Q_NULLPTR) : QThread(parent) {}
    virtual ~InstallThread() {}

    QQueue< QPair<QString, QString> > filePaths;
    QMutex mutex;

Q_SIGNALS:
    void pathFinished(const QString &path);

protected:
    void run();
    void moveTables(QSqlDatabase &srcDb, QSqlDatabase &dstDb, const QString &table);
};

#endif // MEIKADEOFFLINEMANAGER_H
