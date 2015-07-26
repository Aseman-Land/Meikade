#ifndef XMLDOWNLOADERMODEL_H
#define XMLDOWNLOADERMODEL_H

#include <QAbstractListModel>
#include <QStringList>

class XmlDownloaderModelUnit;
class XmlDownloaderModelPrivate;
class XmlDownloaderModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QStringList errors READ errors NOTIFY errorsChanged)
    Q_PROPERTY(bool refreshing READ refreshing NOTIFY refreshingChanged)
    Q_PROPERTY(bool processing READ processing NOTIFY processingChanged)

public:
    enum DataRoles {
        DataRolePoetId = Qt::UserRole,
        DataRolePoetName,
        DataRoleFileDownloadUrl,
        DataRoleFileMimeType,
        DataRoleFileThumbUrl,
        DataRoleFileSize,
        DataRoleFileThumbSize,
        DataRoleFilePublicDate,
        DataRoleFileGuid,
        DataRoleFileCompressMethod,
        DataRoleDownloadedStatus,
        DataRoleDownloadingState,
        DataRoleDownloadError,
        DataRoleDownloadedBytes,
        DataRoleInstalled,
        DataRoleUpdateAvailable,
        DataRoleInstalling
    };

    XmlDownloaderModel(QObject *parent = 0);
    ~XmlDownloaderModel();

    XmlDownloaderModelUnit &itemOf( const QModelIndex &index ) const;
    int indexOf(const QString &guid) const;

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::DisplayRole);

    QHash<qint32,QByteArray> roleNames() const;
    int count() const;

    QStringList errors() const;
    bool refreshing() const;
    bool processing() const;

public slots:
    void refresh();

signals:
    void countChanged();
    void errorsChanged();
    void refreshingChanged();
    void processingChanged();
    void listChanged();

private slots:
    void error( const QStringList & error );
    void finished( const QByteArray & data );
    void fileError( const QStringList & error );
    void fileFinished( const QByteArray & data );
    void fileRecievedBytesChanged();
    void installerError(const QString &file, const QString &guid);
    void installerFinished(const QString &file, const QString &guid);

private:
    void startDownload(const QModelIndex &index);
    void stopDownload(const QModelIndex &index);

    void changed(const QList<XmlDownloaderModelUnit> &list);

private:
    XmlDownloaderModelPrivate *p;
};

#endif // XMLDOWNLOADERMODEL_H
