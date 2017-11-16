/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    Meikade is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Meikade is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef XMLDOWNLOADERPROXYMODEL_H
#define XMLDOWNLOADERPROXYMODEL_H

#include "aseman/asemanabstractlistmodel.h"
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
