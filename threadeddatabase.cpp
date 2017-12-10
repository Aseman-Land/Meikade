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

#define DESTROY_QUERY \
    if(p->find_query) { \
        delete p->find_query; \
        p->find_query = 0; \
    }

#include "threadeddatabase.h"
#include "meikadedatabase.h"
#include "meikade_macros.h"

#include <QMutex>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QDir>
#include <QUuid>
#include <QTimer>
#include <QVariant>
#include <QDebug>

class ThreadedDatabasePrivate
{
public:
    QString keyword;
    int poet;
    int pointer;
    int length;
    bool reset;
    bool terminate;

    QString connectionName;

    QMutex mutex;
    QSqlDatabase db;
    MeikadeDatabase *pdb;

    QSqlQuery *find_query;
};

ThreadedDatabase::ThreadedDatabase( MeikadeDatabase *pdb, QObject *parent) :
    QThread(parent)
{
    p = new ThreadedDatabasePrivate;
    p->pointer = -1;
    p->length = 0;
    p->poet = -1;
    p->reset = false;
    p->terminate = false;
    p->pdb = pdb;
    p->find_query = 0;

    if(p->pdb)
    {
        connect( pdb, SIGNAL(initializeFinished()), SLOT(initialize()), Qt::QueuedConnection );
        connect( pdb, &MeikadeDatabase::databaseLocationChanged, this, [this](){
            if(!p->pdb->initialized())
                return;

            p->db.close();
            p->connectionName.clear();
            initialize();
        });

        if(p->pdb->initialized())
            initialize();
    }
    else
        QTimer::singleShot(1000, this, SLOT(initialize()));
}

void ThreadedDatabase::initialize()
{
    if(!p->connectionName.isEmpty() || !p->pdb)
        return;

    QString dbPath = p->pdb->databasePath();
    p->connectionName = QUuid::createUuid().toString();

    p->db = QSqlDatabase::addDatabase( "QSQLITE", p->connectionName );
    p->db.setDatabaseName(dbPath);
    p->db.open();
}

void ThreadedDatabase::terminateThread()
{
    p->terminate = true;
}

void ThreadedDatabase::find(const QString &keyword, int poet)
{
    p->mutex.lock();
    p->keyword = keyword;
    p->poet = poet;
    p->pointer = -1;
    p->length = 0;
    p->reset = true;
    p->terminate = false;
    p->mutex.unlock();
}

bool ThreadedDatabase::next(int length)
{
    if( p->length == -1 )
    {
        Q_EMIT noMoreResult();
        return false;
    }

    p->mutex.lock();
    p->length += length;
    p->mutex.unlock();

    start();
    return true;
}

void ThreadedDatabase::run()
{
    for( int i=p->pointer; i<p->length; i++ )
    {
        if(p->terminate)
        {
            DESTROY_QUERY
            p->terminate = false;
            Q_EMIT terminated();
            return;
        }

        if( p->reset )
        {
            p->mutex.lock();
            if(p->find_query)
                delete p->find_query;

            p->find_query = new QSqlQuery(p->db);
            if(p->poet == -1)
            {
                p->find_query->prepare("SELECT poem_id, vorder FROM verse WHERE text LIKE :keyword");
                p->find_query->bindValue(":keyword","%" + p->keyword + "%");
            }
            else
            {
                p->find_query->prepare("SELECT poem_id, vorder FROM verse WHERE poet=:poet AND text LIKE :keyword");
                p->find_query->bindValue(":keyword","%" + p->keyword + "%");
                p->find_query->bindValue(":poet", p->poet);
            }

            p->reset = false;
            i = -1;
            p->mutex.unlock();
            p->find_query->exec();
        }
        if(!p->find_query)
            return;

        if( !p->find_query->next() )
        {
            DESTROY_QUERY
            p->length = -1;
            Q_EMIT noMoreResult();
            return;
        }

        QSqlRecord record = p->find_query->record();
        if( !p->reset )
            Q_EMIT found( record.value(0).toInt(), record.value(1).toInt() );

        p->pointer++;
    }
}

ThreadedDatabase::~ThreadedDatabase()
{
    if(p->find_query)
        delete p->find_query;

    QString connectionName = p->connectionName;
    delete p;
    QSqlDatabase::removeDatabase(connectionName);
}
