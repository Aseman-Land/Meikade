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

#include "userdata.h"
#include "meikade.h"
#include "meikade_macros.h"

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QHash>
#include <QDir>
#include <QSet>
#include <QFile>
#include <QMap>
#include <QVariant>
#include <QDateTime>
#include <QDebug>
#include <QCoreApplication>

class UserDataPrivates
{
public:
    QSqlDatabase db;
    QString path;
};

UserData::UserData(QObject *parent) :
    QObject(parent)
{
    p = new UserDataPrivates;
    p->path = HOME_PATH + "/userdata.sqlite";

    if( !Meikade::settings()->value("initialize/userdata_db",false).toBool() )
#ifdef Q_OS_ANDROID
        QFile::copy(":/database/userdata.sqlite",p->path);
#else
        QFile::copy(QCoreApplication::applicationDirPath() + "/database/userdata.sqlite",p->path);
#endif
    Meikade::settings()->setValue("initialize/userdata_db",true);
    QFile(p->path).setPermissions(QFileDevice::WriteOwner|QFileDevice::WriteGroup|QFileDevice::ReadUser|QFileDevice::ReadGroup);

    p->db = QSqlDatabase::addDatabase("QSQLITE",USERDATAS_DB_CONNECTION);
    p->db.setDatabaseName(p->path);

    reconnect();
    initDb();
}

void UserData::disconnect()
{
    p->db.close();
}

void UserData::reconnect()
{
    p->db.open();
}

void UserData::initDb()
{
    QFile file(":/database/userdata.sql");
    file.open(QFile::ReadOnly);

    QString script = QString(file.readAll()).replace("\r\n", "\n");

    int pos = 0;
    int from = 0;
    while( (pos=script.indexOf(";\n", from)) != -1 )
    {
        const QString &scr = script.mid(from, pos-from);

        QSqlQuery query(p->db);
        query.prepare(scr);
        int res = query.exec();
        if(!res)
            qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text() << scr;

        from = pos+2;
    }
}

void UserData::favorite(int pid, int vid)
{
    QSqlQuery query(p->db);
    query.prepare("INSERT OR REPLACE INTO favorites (poem_id,vorder,date) VALUES (:pid,:vid,:date)");
    query.bindValue(":pid",pid);
    query.bindValue(":vid",vid);
    query.bindValue(":date" ,QString::number(QDateTime::currentDateTime().toMSecsSinceEpoch()));
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();
    Q_EMIT favorited(pid,vid);
}

void UserData::unfavorite(int pid, int vid)
{
    QSqlQuery query(p->db);
    query.prepare("DELETE FROM favorites WHERE poem_id=:pid AND vorder=:vid" );
    query.bindValue(":pid",pid);
    query.bindValue(":vid",vid);
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();
    Q_EMIT unfavorited(pid,vid);
}

bool UserData::isFavorited(int pid, int vid)
{
    QSqlQuery query(p->db);
    query.prepare("SELECT poem_id FROM favorites WHERE poem_id=:pid AND vorder=:vid" );
    query.bindValue(":pid",pid);
    query.bindValue(":vid",vid);
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();

    return query.next();
}

QStringList UserData::favorites()
{
    QMap<qint64,QString> result;

    QSqlQuery query(p->db);
    query.prepare("SELECT poem_id, vorder, date FROM favorites");
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();

    while( query.next() )
    {
        QSqlRecord record = query.record();
        int pid = record.value(0).toInt();
        int vid = record.value(1).toInt();
        qint64 date = record.value(2).toInt();
        result.insert( date, QString("%1:%2").arg(pid).arg(vid) );
    }

    return result.values();
}

void UserData::setNote(int pid, int vid, const QString &note)
{
    if( note.isEmpty() )
    {
        QSqlQuery query(p->db);
        query.prepare("DELETE FROM notes WHERE poem_id=:pid AND vorder=:vid" );
        query.bindValue(":pid",pid);
        query.bindValue(":vid",vid);
        if(!query.exec())
            qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();
    }
    else
    {
        QSqlQuery query(p->db);
        query.prepare("INSERT OR REPLACE INTO notes (poem_id,vorder,text, date) VALUES (:pid,:vid,:note, :date)");
        query.bindValue(":pid",pid);
        query.bindValue(":vid",vid);
        query.bindValue(":note" ,note);
        query.bindValue(":date" ,QString::number(QDateTime::currentDateTime().toMSecsSinceEpoch()));
        if(!query.exec())
            qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();
    }
    Q_EMIT noteChanged(pid,vid);
}

QString UserData::note(int pid, int vid)
{
    QSqlQuery query(p->db);
    query.prepare("SELECT text FROM notes WHERE poem_id=:pid AND vorder=:vid");
    query.bindValue(":pid",pid);
    query.bindValue(":vid",vid);
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();

    if( !query.next() )
        return QString();

    QSqlRecord record = query.record();
    return record.value(0).toString();
}

QStringList UserData::notes()
{
    QMap<qint64,QString> result;

    QSqlQuery query(p->db);
    query.prepare("SELECT poem_id, vorder, date FROM notes");
    if(!query.exec())
        qDebug() << __PRETTY_FUNCTION__ << "SQL Error:" << query.lastError().text();

    while( query.next() )
    {
        QSqlRecord record = query.record();
        int pid = record.value(0).toInt();
        int vid = record.value(1).toInt();
        qint64 date = record.value(2).toLongLong();
        result.insert( date, QString("%1:%2").arg(pid).arg(vid) );
    }

    return result.values();
}

int UserData::extractPoemIdFromStringId(const QString &str_id)
{
    const QStringList & list = str_id.split(":",QString::SkipEmptyParts);
    if( list.count() != 2 )
        return -1;

    return list.first().toInt();
}

int UserData::extractVerseIdFromStringId(const QString &str_id)
{
    const QStringList & list = str_id.split(":",QString::SkipEmptyParts);
    if( list.count() != 2 )
        return -1;

    return list.last().toInt();
}

UserData::~UserData()
{
    delete p;
}
