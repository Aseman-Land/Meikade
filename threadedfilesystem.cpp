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

#include "threadedfilesystem.h"
#include "meikade.h"
#include "meikade_macros.h"

#include <QFile>
#include <QFileInfo>
#include <QThread>
#include <QDebug>
#include <QDir>

class ThreadedFileSystemThread: public QThread
{
public:
    ThreadedFileSystemThread(QObject *child, QObject *parent): QThread(parent){
        child_obj = child;
    }
    virtual ~ThreadedFileSystemThread() {
        delete child_obj;
    }

private:
    QObject *child_obj;
};

class ThreadedFileSystemPrivate
{
public:
    ThreadedFileSystemThread *thread;
};

ThreadedFileSystem::ThreadedFileSystem(QObject *parent) :
    QObject()
{
    p = new ThreadedFileSystemPrivate;
    p->thread = new ThreadedFileSystemThread(this,parent);

    moveToThread( p->thread );
    p->thread->start();
}

void ThreadedFileSystem::copy(const QString &src, const QString &dst)
{
    QMetaObject::invokeMethod( this, "copy_prv", Qt::QueuedConnection, Q_ARG(QString,src), Q_ARG(QString,dst) );
}

void ThreadedFileSystem::extract(const QString &src, int counter, const QString &dst)
{
    QMetaObject::invokeMethod( this, "extract_prv", Qt::QueuedConnection, Q_ARG(QString,src), Q_ARG(int,counter), Q_ARG(QString,dst) );
}

void ThreadedFileSystem::extract_prv(const QString &src, int counter, const QString &dst)
{
    QFile::remove(dst);
    QFile dstFile(dst);
    if( !dstFile.open(QFile::WriteOnly) )
    {
        dstFile.close();
        dstFile.remove();
        Q_EMIT extractError();
        return;
    }

    const QString & temp = TEMP_PATH;
    QDir().mkpath(temp);

    qreal percent = 0;
    const qreal big_step = 100.0/counter;
    const qreal sml_step = big_step/3;

    for( int i=0; i<counter; i++ )
    {
        const QString & src_path = src + QString::number(i);

        percent += sml_step;
        Q_EMIT extractProgress(percent);

        percent += sml_step;
        Q_EMIT extractProgress(percent);

        QFile tmpFile(src_path);
        if( !tmpFile.exists() || !tmpFile.open(QFile::ReadOnly) )
        {
            dstFile.close();
            dstFile.remove();
            Q_EMIT extractError();
            return;
        }

        QByteArray data = qUncompress( tmpFile.readAll() );
        if( dstFile.write(data) == -1 )
        {
            dstFile.close();
            dstFile.remove();
            Q_EMIT extractError();
            return;
        }
        if( !dstFile.flush() )
        {
            dstFile.close();
            dstFile.remove();
            Q_EMIT extractError();
            return;
        }

        tmpFile.close();
        tmpFile.remove();
        percent += sml_step;
        Q_EMIT extractProgress(percent);
    }

    dstFile.close();

    Q_EMIT extractProgress(100);
    Q_EMIT extractFinished(dst);
}

void ThreadedFileSystem::copy_prv(const QString &src, const QString &dst)
{
    QThread::sleep(3);

    QFileInfo src_info(src);
    QFileInfo dst_info(dst);
    if( src_info.size() != dst_info.size() )
        QFile::remove(dst);
    else
    {
        Q_EMIT copyFinished(dst);
        return;
    }


    bool done = QFile::copy(src,dst);
    if( done )
        Q_EMIT copyFinished(dst);
    else
        Q_EMIT copyError();
}

ThreadedFileSystem::~ThreadedFileSystem()
{
    if(p->thread)
    {
        p->thread->quit();
        p->thread->wait();
    }
    delete p;
}
