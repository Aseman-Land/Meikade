#ifndef POETINSTALLER_H
#define POETINSTALLER_H

#include <QDateTime>
#include <QObject>
#include <QUrl>

class AsemanAbstractClientSocket;
class PoetInstaller : public QObject
{
    Q_OBJECT
    class Private;

    Q_PROPERTY(qint32 poetId READ poetId WRITE setPoetId NOTIFY poetIdChanged)
    Q_PROPERTY(bool installed READ installed NOTIFY installedChanged)
    Q_PROPERTY(QDateTime date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QString error READ error NOTIFY errorChanged)
    Q_PROPERTY(bool installing READ installing NOTIFY installingChanged)
    Q_PROPERTY(bool uninstalling READ uninstalling NOTIFY uninstallingChanged)
    Q_PROPERTY(bool updateAvailable READ updateAvailable NOTIFY updateAvailableChanged)
    Q_PROPERTY(qreal progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(bool downloading READ downloading NOTIFY downloadingChanged)
    Q_PROPERTY(AsemanAbstractClientSocket* socket READ socket WRITE setSocket NOTIFY socketChanged)
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)

public:
    PoetInstaller(QObject *parent = Q_NULLPTR);
    virtual ~PoetInstaller();

    void setPoetId(qint32 poetId);
    qint32 poetId() const;

    void setDate(const QDateTime &date);
    QDateTime date() const;

    QUrl source() const;
    void setSource(const QUrl &source);

    AsemanAbstractClientSocket *socket() const;
    void setSocket(AsemanAbstractClientSocket *socket);

    QString error() const;

    bool installed() const;
    bool updateAvailable() const;
    bool installing() const;
    bool uninstalling() const;
    bool downloading() const;
    qreal progress() const;

Q_SIGNALS:
    void poetIdChanged();
    void dateChanged();
    void installedChanged();
    void updateAvailableChanged();
    void installingChanged();
    void uninstallingChanged();
    void errorChanged();
    void downloadingChanged();
    void progressChanged();
    void sourceChanged();
    void socketChanged();

public Q_SLOTS:
    void refresh();
    void install();
    void remove();

protected:
    void setInstalled(bool installed);
    void setUpdateAvailable(bool updateAvailable);
    void setInstalling(bool installing);
    void setUninstalling(bool uninstalling);
    void setError(const QString &error);
    void setRemoteFile(class AsemanRemoteFile *file);
    static void initInstaller();

private:
    void finished(int poetId, bool installed, const QString &error);
    void fileError(qint32 errorCode, const QVariant &errorValue);

private:
    Private *p;
};

#endif // POETINSTALLER_H
