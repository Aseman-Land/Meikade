#ifndef GANJOORDOWNLOADERMODEL_H
#define GANJOORDOWNLOADERMODEL_H

#include <QAbstractListModel>

class GanjoorDownloaderModelPrivate;
class GanjoorDownloaderModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum DataRoles {
        DataRolePoemId = Qt::UserRole,
        DataRoleCatId,
        DataRoleDownloadUrl,
        DataRoleFileExtension,
        DataRoleImageDownloadUrl,
        DataRoleImageUrl,
        DataRoleFileSize,
        DataRoleLowestPoemId,
        DataRolePublicData,
        DataRoleDownloadedStatus,
        DataRoleDownloadingState,
        DataRoleDownloadedBytes
    };

    GanjoorDownloaderModel(QObject *parent = 0);
    ~GanjoorDownloaderModel();

    int itemOf( const QModelIndex &index ) const;

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

    QHash<qint32,QByteArray> roleNames() const;
    int count() const;

public slots:
    void refresh();

signals:
    void countChanged();

private:
    GanjoorDownloaderModelPrivate *p;
};

#endif // GANJOORDOWNLOADERMODEL_H
