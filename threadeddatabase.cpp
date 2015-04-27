/*
    Copyright (C) 2015 Nile Group
    http://nilegroup.org

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

#include "threadeddatabase.h"
#include "meikadedatabase.h"
#include "meikade_macros.h"

#include <QMutex>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QDir>
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

    QString path;

    QMutex mutex;
    QSqlDatabase db;
    MeikadeDatabase *pdb;

    QSqlQuery find_query;
};

ThreadedDatabase::ThreadedDatabase( MeikadeDatabase *pdb, QObject *parent) :
    QThread(parent)
{
    p = new ThreadedDatabasePrivate;
    p->pointer = -1;
    p->length = 0;
    p->poet = -1;
    p->reset = false;
    p->pdb = pdb;

    connect( pdb, SIGNAL(initializeFinished()), SLOT(initialize()), Qt::QueuedConnection );
}

void ThreadedDatabase::initialize()
{
#ifdef Q_OS_ANDROID
    p->path = "/sdcard/NileGroup/Meikade/data.sqlite";
#else
    p->path = HOME_PATH + "/data.sqlite";
#endif

    p->db = QSqlDatabase::addDatabase( "QSQLITE", THREADED_DATA_DB_CONNECTION );
    p->db.setDatabaseName(p->path);
    p->db.open();
}

void ThreadedDatabase::find(const QString &keyword, int poet)
{
    p->mutex.lock();
    p->keyword = keyword;
    p->poet = poet;
    p->pointer = -1;
    p->length = 0;
    p->reset = true;
    p->mutex.unlock();
}

bool ThreadedDatabase::next(int length)
{
    if( p->length == -1 )
    {
        emit noMoreResult();
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
        if( p->reset )
        {
            p->mutex.lock();
            p->find_query = QSqlQuery(p->db);
            if(p->poet == -1)
            {
                p->find_query.prepare("SELECT poem_id, vorder FROM verse WHERE text LIKE :keyword");
                p->find_query.bindValue(":keyword","%" + p->keyword + "%");
            }
            else
            {
                p->find_query.prepare("SELECT poem_id, vorder FROM verse WHERE poet=:poet AND text LIKE :keyword");
                p->find_query.bindValue(":keyword","%" + p->keyword + "%");
                p->find_query.bindValue(":poet", p->poet);
            }

            p->reset = false;
            i = -1;
            p->mutex.unlock();
            p->find_query.exec();
        }

        if( !p->find_query.next() )
        {
            p->length = -1;
            emit noMoreResult();
            return;
        }

        QSqlRecord record = p->find_query.record();
        if( !p->reset )
            emit found( record.value(0).toInt(), record.value(1).toInt() );

        p->pointer++;
    }
}

ThreadedDatabase::~ThreadedDatabase()
{
    delete p;
}
