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

#include "poetscriptinstaller.h"
#include "asemantools/asemanapplication.h"
#include "meikade_macros.h"
#include "poetremover.h"

#include <QDir>
#include <QUuid>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QThread>
#include <QDebug>

class PoetScriptInstallerPrivate
{
public:
    QSqlDatabase db;
    QString path;
};

PoetScriptInstaller::PoetScriptInstaller(QObject *parent) :
    QObject(parent)
{
    p = new PoetScriptInstallerPrivate;

#ifdef Q_OS_ANDROID
    p->path = ANDROID_OLD_DB_PATH "/data.sqlite";
    if(!QFileInfo::exists(p->path))
        p->path = HOME_PATH + "/data.sqlite";
#else
    p->path = HOME_PATH + "/data.sqlite";
#endif
}

void PoetScriptInstaller::installFile(const QString &path, int poetId, const QDateTime &date, bool removeFile)
{
    QFile file(path);
    if(!file.open(QFile::ReadOnly))
    {
        emit finished(true);
        if(removeFile)
            file.remove();
        return;
    }

    QByteArray data = qUncompress( file.readAll() );
    file.close();

    if(removeFile)
        file.remove();

    install(data, poetId, date);

    emit finished(false);
}

void PoetScriptInstaller::install(const QString &scr, int poetId, const QDateTime &date)
{
    QString script = QString(scr).replace("\r\n", "\n");
    initDb();
    PoetRemover::removePoetCat(p->db, poetId);

    int pos = 0;
    int from = 0;
    while( (pos=script.indexOf(";\n", from)) != -1 )
    {
        const QString &scr = script.mid(from, pos-from);

        QSqlQuery query(p->db);
        query.prepare(scr);
        int res = query.exec();
        if(!res)
            qDebug() << __PRETTY_FUNCTION__ << query.lastError().text() << scr;

        from = pos+2;
    }

    QSqlQuery query(p->db);
    query.prepare("UPDATE poet SET lastUpdate=:date WHERE id=:id");
    query.bindValue(":id", poetId);
    query.bindValue(":date", date);
    int res = query.exec();
    if(!res)
        qDebug() << __PRETTY_FUNCTION__ << query.lastError().text();
}

void PoetScriptInstaller::remove(int poetId)
{
    initDb();
    PoetRemover::removePoetCat(p->db, poetId);
    PoetRemover::vacuum(p->db);
    emit finished(false);
}

void PoetScriptInstaller::initDb()
{
    QFile(p->path).setPermissions(QFileDevice::ReadUser|QFileDevice::WriteUser|
                                  QFileDevice::ReadGroup|QFileDevice::WriteGroup);

    if(p->db.isOpen())
        return;

    p->db = QSqlDatabase::addDatabase("QSQLITE", QUuid::createUuid().toString());
    p->db.setDatabaseName(p->path);
    p->db.open();

    qDebug() << p->path << p->db.lastError().text();
}

PoetScriptInstaller::~PoetScriptInstaller()
{
    delete p;
}
