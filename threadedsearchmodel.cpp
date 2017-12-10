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

#include "threadedsearchmodel.h"
#include "threadeddatabase.h"
#include "meikadedatabase.h"
#include "meikade.h"

#include <QList>
#include <QTimer>
#include <QPointer>
#include <QDebug>

class ThreadedSearchModelListItem
{
public:
    ThreadedSearchModelListItem():
        poem(0), vorder(0) {}

    int poem;
    int vorder;

    bool operator ==(const ThreadedSearchModelListItem &b) {
        return poem == b.poem &&
               vorder == b.vorder;
    }
};

class ThreadedSearchModelPrivate
{
public:
    QString keyword;
    QList<ThreadedSearchModelListItem> list;

    int stepCount;
    bool finished;
    bool refreshing;
    int poet;

    QTimer *timer;
    QPointer<ThreadedDatabase> threaded;
    QPointer<MeikadeDatabase> database;
};

ThreadedSearchModel::ThreadedSearchModel(QObject *parent) :
    QAbstractListModel(parent)
{
    p = new ThreadedSearchModelPrivate;
    p->threaded = 0;
    p->stepCount = 50;
    p->finished = false;
    p->refreshing = false;
    p->poet = -1;

    p->timer = new QTimer(this);
    p->timer->setInterval(500);
    p->timer->setSingleShot(true);

    connect(p->timer, SIGNAL(timeout()), SLOT(refresh_prv()));
}

int ThreadedSearchModel::id(const QModelIndex &index) const
{
    return index.row();
}

int ThreadedSearchModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return count();
}

QVariant ThreadedSearchModel::data(const QModelIndex &index, int role) const
{
    QVariant result;
    const int row = id(index);
    switch(role)
    {
    case PoemIdRole:
        result = p->list.at(row).poem;
        break;

    case VorderIdRole:
        result = p->list.at(row).vorder;
        break;
    }

    return result;
}

QHash<qint32, QByteArray> ThreadedSearchModel::roleNames() const
{
    static QHash<qint32, QByteArray> *res = 0;
    if( res )
        return *res;

    res = new QHash<qint32, QByteArray>();
    res->insert( PoemIdRole, "poem");
    res->insert( VorderIdRole, "vorder");

    return *res;
}

int ThreadedSearchModel::count() const
{
    return p->list.count();
}

void ThreadedSearchModel::setDatabase(MeikadeDatabase *db)
{
    if(p->database == db)
        return;

    p->database = db;
    Q_EMIT databaseChanged();

    refresh();
}

MeikadeDatabase *ThreadedSearchModel::database() const
{
    return p->database;
}

void ThreadedSearchModel::setKeyword(const QString &keyword)
{
    if(p->keyword == keyword)
        return;

    p->keyword = keyword;
    Q_EMIT keywordChanged();

    refresh();
}

QString ThreadedSearchModel::keyword() const
{
    return p->keyword;
}

void ThreadedSearchModel::setPoet(int pid)
{
    if(p->poet == pid)
        return;

    p->poet = pid;
    Q_EMIT poetChanged();

    refresh();
}

int ThreadedSearchModel::poet() const
{
    return p->poet;
}

void ThreadedSearchModel::setDelay(int ms)
{
    if(p->timer->interval() == ms)
        return;

    p->timer->setInterval(ms);
    if(p->timer->isActive())
        refresh();

    Q_EMIT delayChanged();
}

int ThreadedSearchModel::delay() const
{
    return p->timer->interval();
}

void ThreadedSearchModel::setStepCount(int count)
{
    if(p->stepCount == count)
        return;

    p->stepCount = count;
    Q_EMIT stepCountChanged();
}

int ThreadedSearchModel::stepCount() const
{
    return p->stepCount;
}

bool ThreadedSearchModel::refreshing() const
{
    return p->refreshing;
}

bool ThreadedSearchModel::finished() const
{
    return p->finished;
}

void ThreadedSearchModel::refresh()
{
    p->refreshing = false;
    Q_EMIT refreshingChanged();

    p->timer->stop();
    p->timer->start();
}

void ThreadedSearchModel::more()
{
    if(!p->threaded)
        return;

    p->refreshing = p->threaded->next(p->stepCount);
    p->finished = !p->refreshing;
    Q_EMIT finishedChanged();
    Q_EMIT refreshingChanged();
}

void ThreadedSearchModel::refresh_prv()
{
    beginResetModel();
    p->list.clear();
    endResetModel();
    Q_EMIT countChanged();

    if(p->keyword.isEmpty())
        return;
    if(!p->database)
        return;

    if(p->threaded)
    {
        if(p->threaded->isRunning())
        {
            disconnect(p->threaded, SIGNAL(found(int,int)), this, SLOT(founded(int,int)));
            disconnect(p->threaded, SIGNAL(finished())    , this, SLOT(fetchDone())     );
            disconnect(p->threaded, SIGNAL(noMoreResult()), this, SLOT(noMoreResult())  );

            connect(p->threaded, SIGNAL(finished()), p->threaded, SLOT(deleteLater()));
            p->threaded->quit();
            p->threaded->wait();
        }

        p->threaded->deleteLater();
    }

    p->threaded = new ThreadedDatabase(p->database, this);
    p->threaded->find(p->keyword, p->poet);

    connect(p->threaded, SIGNAL(found(int,int)), this, SLOT(founded(int,int)));
    connect(p->threaded, SIGNAL(finished())    , this, SLOT(fetchDone())     );
    connect(p->threaded, SIGNAL(noMoreResult()), this, SLOT(noMoreResult())  );

    more();
}

void ThreadedSearchModel::founded(int poem, int vorder)
{
    ThreadedSearchModelListItem item;
    item.poem = poem;
    item.vorder = vorder;

    beginInsertRows(QModelIndex(), count(), count() );
    p->list << item;
    endInsertRows();

    Q_EMIT countChanged();
}

void ThreadedSearchModel::fetchDone()
{
    p->refreshing = false;
    Q_EMIT refreshingChanged();
}

void ThreadedSearchModel::noMoreResult()
{
    p->finished = true;
    Q_EMIT finishedChanged();
}

ThreadedSearchModel::~ThreadedSearchModel()
{
    delete p;
}
