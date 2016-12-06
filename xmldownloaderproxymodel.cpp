#include "xmldownloaderproxymodel.h"

#include <QPointer>

class XmlDownloaderProxyModelPrivate
{
public:
    QPointer<XmlDownloaderModel> model;
    int type;
};

XmlDownloaderProxyModel::XmlDownloaderProxyModel(QObject *parent) :
    AsemanAbstractListModel(parent)
{
    p = new XmlDownloaderProxyModelPrivate;
    p->type = 2047;
}

void XmlDownloaderProxyModel::setModel(XmlDownloaderModel *model)
{
    if(p->model == model)
        return;

    beginResetModel();
    if(p->model)
    {
        disconnect(p->model.data(), &XmlDownloaderModel::dataChanged, this, &XmlDownloaderProxyModel::dataChanged_slt);
        disconnect(p->model.data(), &XmlDownloaderModel::countChanged, this, &XmlDownloaderProxyModel::refresh);
    }

    p->model = model;
    if(p->model)
    {
        connect(p->model.data(), &XmlDownloaderModel::dataChanged, this, &XmlDownloaderProxyModel::dataChanged_slt);
        connect(p->model.data(), &XmlDownloaderModel::countChanged, this, &XmlDownloaderProxyModel::refresh);
    }

    endResetModel();

    Q_EMIT modelChanged();
}

XmlDownloaderModel *XmlDownloaderProxyModel::model() const
{
    return p->model;
}

void XmlDownloaderProxyModel::setType(int type)
{
    if(p->type == type)
        return;

    beginResetModel();
    p->type = type;
    endResetModel();

    Q_EMIT typeChanged();
}

int XmlDownloaderProxyModel::type() const
{
    return p->type;
}

int XmlDownloaderProxyModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    if(!p->model)
        return 0;

    int count = 0;
    for(int i=0; i<p->model->count(); i++)
    {
        QModelIndex idx = p->model->index(i);
        int type = p->model->data(idx, XmlDownloaderModel::DataRolePoetType).toInt();
        if(p->type & type)
            count++;
    }

    return count;
}

QVariant XmlDownloaderProxyModel::data(const QModelIndex &index, int role) const
{
    QModelIndex idx = mapToModel(index);
    if(!idx.isValid())
        return QVariant();
    else
        return p->model->data(idx, role);
}

bool XmlDownloaderProxyModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    QModelIndex idx = mapToModel(index);
    if(!idx.isValid())
        return false;
    else
        return p->model->setData(idx, value, role);
}

QHash<qint32, QByteArray> XmlDownloaderProxyModel::roleNames() const
{
    if(!p->model)
        return QHash<qint32, QByteArray>();
    else
        return p->model->roleNames();
}

void XmlDownloaderProxyModel::refresh()
{
    beginResetModel();
    endResetModel();
}

QModelIndex XmlDownloaderProxyModel::mapToModel(const QModelIndex &index) const
{
    if(!p->model)
        return QModelIndex();

    int count = 0;
    for(int i=0; i<p->model->count(); i++)
    {
        QModelIndex idx = p->model->index(i);
        int type = p->model->data(idx, XmlDownloaderModel::DataRolePoetType).toInt();
        if(p->type & type)
        {
            if(count == index.row())
                return idx;
            count++;
        }
    }

    return QModelIndex();
}

QModelIndex XmlDownloaderProxyModel::mapFromModel(const QModelIndex &index) const
{
    if(!p->model)
        return QModelIndex();
    int type = p->model->data(index, XmlDownloaderModel::DataRolePoetType).toInt();
    if((p->type & type) == 0)
        return QModelIndex();

    int count = 0;
    for(int i=0; i<=index.row(); i++)
    {
        QModelIndex idx = p->model->index(i);
        int type = p->model->data(idx, XmlDownloaderModel::DataRolePoetType).toInt();
        if(p->type & type)
            count++;
    }

    return p->model->index(count-1);
}

void XmlDownloaderProxyModel::dataChanged_slt(const QModelIndex &topLeft, const QModelIndex &bottomRight, const QVector<int> &roles)
{
    QModelIndex tlIdx = mapFromModel(topLeft);
    QModelIndex brIdx = mapFromModel(bottomRight);
    if(!tlIdx.isValid() || !brIdx.isValid())
        return;

    Q_EMIT dataChanged(tlIdx, brIdx, roles);
}

XmlDownloaderProxyModel::~XmlDownloaderProxyModel()
{
    delete p;
}
