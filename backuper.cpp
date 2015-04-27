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

#include "backuper.h"
#include "resourcemanager.h"
#include "meikade_macros.h"

#include <QThread>
#include <QDateTime>
#include <QDir>
#include <QDebug>

class BackuperPrivate
{
public:
    QThread *thread;
    BackuperCore *core;
    bool active;
};

Backuper::Backuper() :
    QObject()
{
    p = new BackuperPrivate;
    p->active = false;

    p->thread = new QThread();

    p->core = new BackuperCore();
    p->core->moveToThread(p->thread);

    connect( p->core, SIGNAL(success()), SLOT(process_successed()), Qt::QueuedConnection );
    connect( p->core, SIGNAL(failed()) , SLOT(process_failed())   , Qt::QueuedConnection );

    p->thread->start();
}

bool Backuper::isActive() const
{
    return p->active;
}

void Backuper::makeBackup()
{
    if( isActive() )
        return;

    p->active = true;
    emit activeChanged();

    QMetaObject::invokeMethod( p->core, "makeBackup" );
}

bool Backuper::restore( const QString & path )
{
    if( isActive() )
        return false;

    p->active = true;
    emit activeChanged();

    QMetaObject::invokeMethod( p->core, "restore", Q_ARG(QString,path) );
    return true;
}

void Backuper::process_successed()
{
    p->active = false;
    emit success();
    emit activeChanged();
}

void Backuper::process_failed()
{
    p->active = false;
    emit failed();
    emit activeChanged();
}

Backuper::~Backuper()
{
    p->thread->deleteLater();
    p->core->deleteLater();
    delete p;
}



class BackuperCorePrivate
{
public:
};

BackuperCore::BackuperCore()
{
    p = new BackuperCorePrivate;
}

void BackuperCore::makeBackup()
{
    QString path = BACKUP_PATH;
    QDir().mkpath(path);

    QString dest = path + "/meikade_backup_" + QDateTime::currentDateTime().toString("ddd - MMM dd yyyy - hh_mm") + ".mkdb";

    ResourceManager rsrc( dest, true );
    rsrc.writeHead();
    rsrc.addFile( HOME_PATH + "/userdata.sqlite" );
    rsrc.close();

    QThread::sleep(3);
    emit success();
}

void BackuperCore::restore(const QString &path)
{
    ResourceManager rsrc( path, false );
    if( !rsrc.checkHead() )
    {
        emit failed();
        return;
    }

    QFile::remove( HOME_PATH + "/userdata.sqlite" );
    QString tmp_file = HOME_PATH + "/tmp_file";
    QString fileName = rsrc.extractFile( tmp_file );

    QFile(tmp_file).rename(HOME_PATH + "/" + fileName);

    QThread::sleep(3);
    emit success();
}

BackuperCore::~BackuperCore()
{
    delete p;
}
