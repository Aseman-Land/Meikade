#ifndef XMLDOWNLOADERPROXYMODEL_H
#define XMLDOWNLOADERPROXYMODEL_H

#include "asemantools/asemanabstractlistmodel.h"
#include "xmldownloadermodel.h"

class XmlDownloaderProxyModelPrivate;
class XmlDownloaderProxyModel : public AsemanAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(XmlDownloaderModel* model READ model WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(int type READ type WRITE setType NOTIFY typeChanged)

public:
    XmlDownloaderProxyModel(QObject *parent = nullptr);
    ~XmlDownloaderProxyModel();

    void setModel(XmlDownloaderModel *model);
    XmlDownloaderModel *model() const;

    void setType(int type);
    int type() const;

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::DisplayRole);

    QHash<qint32,QByteArray> roleNames() const;

signals:
    void modelChanged();
    void typeChanged();

public slots:
    void refresh();

protected:
    QModelIndex mapToModel(const QModelIndex &index) const;
    QModelIndex mapFromModel(const QModelIndex &index) const;

private slots:
    void dataChanged_slt(const QModelIndex & topLeft, const QModelIndex & bottomRight, const QVector<int> & roles = QVector<int> ());

private:
    XmlDownloaderProxyModelPrivate *p;
};

#endif // XMLDOWNLOADERPROXYMODEL_H
