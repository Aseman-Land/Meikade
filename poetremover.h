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

#ifndef POETREMOVER_H
#define POETREMOVER_H

#include <QSqlQuery>
#include <QSqlDatabase>
#include <QSqlError>
#include <QSqlRecord>
#include <QDebug>

namespace PoetRemover {

void begin(QSqlDatabase & db)
{
    QSqlQuery query(db);
    query.prepare("BEGIN");
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();
}

void commit(QSqlDatabase & db)
{
    QSqlQuery query(db);
    query.prepare("COMMIT");
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();
}

void removePoem( QSqlDatabase & db, int poem_id )
{
    QSqlQuery delete_verse_query(db);
    delete_verse_query.prepare("DELETE FROM verse WHERE poem_id=:pid");
    delete_verse_query.bindValue(":pid", poem_id);
    if(!delete_verse_query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << delete_verse_query.lastError().text();
}

void removeCatChild( QSqlDatabase & db, int parent_id )
{
    QSqlQuery query(db);
    query.prepare("SELECT id FROM cat WHERE parent_id=:pid");
    query.bindValue(":pid", parent_id);
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();

    while( query.next() )
    {
        int id = query.record().value(0).toInt();
        removeCatChild( db, id );
    }

    QSqlQuery poem_query(db);
    poem_query.prepare("SELECT id FROM poem WHERE cat_id=:cid");
    poem_query.bindValue(":cid", parent_id);
    if(!poem_query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << poem_query.lastError().text();

    while( poem_query.next() )
    {
        int id = poem_query.record().value(0).toInt();
        removePoem( db, id );
    }

    QSqlQuery delete_poem_query(db);
    delete_poem_query.prepare("DELETE FROM poem WHERE cat_id=:cid");
    delete_poem_query.bindValue(":cid", parent_id);
    if(!delete_poem_query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << delete_poem_query.lastError().text();

    QSqlQuery delete_cat_query(db);
    delete_cat_query.prepare("DELETE FROM cat WHERE parent_id=:pid");
    delete_cat_query.bindValue(":pid", parent_id);
    if(!delete_cat_query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << delete_cat_query.lastError().text();
}

void removePoetCat( QSqlDatabase & db, int poet_id )
{
    QSqlQuery poetName(db);
    poetName.prepare("SELECT name FROM poet WHERE id=:pid");
    poetName.bindValue(":pid", poet_id);
    if(!poetName.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << poetName.lastError().text();

    if(!poetName.next())
        return;

    begin(db);

    QSqlQuery query(db);
    query.prepare("SELECT id FROM cat WHERE poet_id=:pid");
    query.bindValue(":pid", poet_id);
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();

    while( query.next() )
    {
        int id = query.record().value(0).toInt();
        removeCatChild( db, id );
    }

    QSqlQuery delete_cat_query(db);
    delete_cat_query.prepare("DELETE FROM cat WHERE poet_id=:pid");
    delete_cat_query.bindValue(":pid", poet_id);
    if(!delete_cat_query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << delete_cat_query.lastError().text();

    QSqlQuery delete_poet_query(db);
    delete_poet_query.prepare("DELETE FROM poet WHERE id=:id");
    delete_poet_query.bindValue(":id", poet_id);
    if(!delete_poet_query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << delete_poet_query.lastError().text();

    commit(db);
}

void setPoemPoet(QSqlDatabase & db, int poem, int poet)
{
    QSqlQuery query(db);
    query.prepare("UPDATE verse SET poet=:poet WHERE poem_id=:poem_id");
    query.bindValue(":poem_id", poem);
    query.bindValue(":poet", poet);
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();
}

int findCatPoet(QSqlDatabase & db, int cid)
{
    QSqlQuery query(db);
    query.prepare("SELECT poet_id FROM cat WHERE id=:id");
    query.bindValue(":id", cid);
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();

    if(!query.next())
        return -1;

    return query.record().value(0).toInt();
}

void indexVersesPoets(QSqlDatabase & db)
{
    QSqlQuery query(db);
    query.prepare("SELECT id, cat_id FROM poem");
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();

    while( query.next() )
    {
        QSqlRecord record = query.record();
        int id  = record.value(0).toInt();
        int cid = record.value(1).toInt();
        int pid = findCatPoet(db, cid);

        setPoemPoet(db, id, pid);
    }
}

void vacuum(QSqlDatabase & db)
{
    QSqlQuery query(db);
    query.prepare("VACUUM");
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();
}
}

#endif // POETREMOVER_H
