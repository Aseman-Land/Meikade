#include "ganjoordownloadermodel.h"

class GanjoorDownloaderModelPrivate
{
public:
    QList< QHash<int,QVariant> > list;
};

GanjoorDownloaderModel::GanjoorDownloaderModel(QObject *parent) :
    QObject(parent)
{
    p = new GanjoorDownloaderModelPrivate;
}

int GanjoorDownloaderModel::itemOf(const QModelIndex &index) const
{
    return index.row();
}

int GanjoorDownloaderModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return count();
}

QVariant GanjoorDownloaderModel::data(const QModelIndex &index, int role) const
{
    const int row = itemOf(index);
    QVariant result;
    switch(role)
    {
    case DataRolePoemId:
    case DataRoleCatId:
    case DataRoleDownloadUrl:
    case DataRoleFileExtension:
    case DataRoleImageDownloadUrl:
    case DataRoleImageUrl:
    case DataRoleFileSize:
    case DataRoleLowestPoemId:
    case DataRolePublicData:
    case DataRoleDownloadedStatus:
    case DataRoleDownloadingState:
    case DataRoleDownloadedBytes:
        result = p->list[row][role];
        break;
    }

    return result;
}

QHash<qint32, QByteArray> GanjoorDownloaderModel::roleNames() const
{
    QHash<qint32, QByteArray> *res = 0;
    if( res )
        return *res;

    res = new QHash<qint32, QByteArray>();
    res->insert( DataRolePoemId, "poemId");
    res->insert( DataRoleCatId, "catId");
    res->insert( DataRoleDownloadUrl, "downloadUrl");
    res->insert( DataRoleFileExtension, "fileExtension");
    res->insert( DataRoleImageDownloadUrl, "imageDownloadUrl");
    res->insert( DataRoleImageUrl, "imageUrl");
    res->insert( DataRoleFileSize, "fileSize");
    res->insert( DataRoleLowestPoemId, "lowestPoemId");
    res->insert( DataRolePublicData, "publicData");
    res->insert( DataRoleDownloadedStatus, "downloadedStatus");
    res->insert( DataRoleDownloadingState, "downloadingState");
    res->insert( DataRoleDownloadedBytes, "downloadedBytes");

    return *res;
}

int GanjoorDownloaderModel::count() const
{
    return p->list.count();
}

void GanjoorDownloaderModel::refresh()
{

}

GanjoorDownloaderModel::~GanjoorDownloaderModel()
{
    delete p;
}

