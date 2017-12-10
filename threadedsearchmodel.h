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

#ifndef THREADEDSEARCHMODEL_H
#define THREADEDSEARCHMODEL_H

#include <QAbstractListModel>

class MeikadeDatabase;
class ThreadedSearchModelPrivate;
class ThreadedSearchModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QString keyword READ keyword WRITE setKeyword NOTIFY keywordChanged)
    Q_PROPERTY(int delay READ delay WRITE setDelay NOTIFY delayChanged)
    Q_PROPERTY(int stepCount READ stepCount WRITE setStepCount NOTIFY stepCountChanged)
    Q_PROPERTY(bool refreshing READ refreshing NOTIFY refreshingChanged)
    Q_PROPERTY(bool finished READ finished NOTIFY finishedChanged)
    Q_PROPERTY(int poet READ poet WRITE setPoet NOTIFY poetChanged)
    Q_PROPERTY(MeikadeDatabase* database READ database WRITE setDatabase NOTIFY databaseChanged)

public:
    enum ModelRoles {
        PoemIdRole = Qt::UserRole,
        VorderIdRole
    };

    ThreadedSearchModel(QObject *parent = 0);
    virtual ~ThreadedSearchModel();

    int id( const QModelIndex &index ) const;

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

    QHash<qint32,QByteArray> roleNames() const;
    int count() const;

    void setDatabase(MeikadeDatabase *db);
    MeikadeDatabase *database() const;

    void setKeyword(const QString &keyword);
    QString keyword() const;

    void setPoet(int pid);
    int poet() const;

    void setDelay(int ms);
    int delay() const;

    void setStepCount(int count);
    int stepCount() const;

    bool refreshing() const;
    bool finished() const;

public Q_SLOTS:
    void refresh();
    void more();

Q_SIGNALS:
    void countChanged();
    void keywordChanged();
    void databaseChanged();
    void delayChanged();
    void stepCountChanged();
    void refreshingChanged();
    void finishedChanged();
    void poetChanged();

private Q_SLOTS:
    void refresh_prv();
    void founded( int poem, int vorder );
    void fetchDone();
    void noMoreResult();

private:
    ThreadedSearchModelPrivate *p;
};

#endif // THREADEDSEARCHMODEL_H
