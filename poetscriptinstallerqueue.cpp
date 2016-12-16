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

#include "poetscriptinstallerqueue.h"
#include "poetscriptinstaller.h"

#include <QThread>
#include <QDebug>

class PoetScriptInstallerQueueUnit
{
public:
    enum Type {
        Install,
        Remove
    };

    PoetScriptInstallerQueueUnit(): poetId(0), type(Install){}

    QString file;
    QString guid;
    int poetId;
    QDateTime date;
    int type;

    bool operator ==(const PoetScriptInstallerQueueUnit &b) {
        return guid == b.guid;
    }
};

class PoetScriptInstallerQueuePrivate
{
public:
    PoetScriptInstaller *core;
    QThread *thread;
    bool active;

    QList<PoetScriptInstallerQueueUnit> list;
    PoetScriptInstallerQueueUnit current;
};

PoetScriptInstallerQueue::PoetScriptInstallerQueue(QObject *parent) :
    QObject(parent)
{
    p = new PoetScriptInstallerQueuePrivate;
    p->core = 0;
    p->thread = 0;
    p->active = false;
}

bool PoetScriptInstallerQueue::isActive()
{
    return p->active;
}

void PoetScriptInstallerQueue::init_core()
{
    if(p->core || p->thread)
        return;

    p->thread = new QThread(this);

    p->core = new PoetScriptInstaller();
    p->core->moveToThread(p->thread);

    p->thread->start();

    connect(p->core, &PoetScriptInstaller::finished, this, &PoetScriptInstallerQueue::finishedSlt, Qt::QueuedConnection);
}

void PoetScriptInstallerQueue::append(const QString &file, const QString &guid, int poetId, const QDateTime &date)
{
    init_core();
    PoetScriptInstallerQueueUnit unit;
    unit.file = file;
    unit.guid = guid;
    unit.poetId = poetId;
    unit.date = date;
    unit.type = PoetScriptInstallerQueueUnit::Install;

    if(p->list.contains(unit))
        return;

    p->list << unit;
    next();
}

void PoetScriptInstallerQueue::remove(const QString &guid, int poetId)
{
    init_core();
    PoetScriptInstallerQueueUnit unit;
    unit.guid = guid;
    unit.poetId = poetId;
    unit.type = PoetScriptInstallerQueueUnit::Remove;

    if(p->list.contains(unit))
        return;

    p->list << unit;
    next();
}

void PoetScriptInstallerQueue::finishedSlt(bool error)
{
    switch(p->current.type)
    {
        case PoetScriptInstallerQueueUnit::Install:
        if(error)
            emit PoetScriptInstallerQueue::error(p->current.file, p->current.guid);
        else
            emit PoetScriptInstallerQueue::finished(p->current.file, p->current.guid);
        break;

    case PoetScriptInstallerQueueUnit::Remove:
        if(error)
            emit PoetScriptInstallerQueue::removeError(p->current.guid);
        else
            emit PoetScriptInstallerQueue::removed(p->current.guid);
        break;
    }

    p->current = PoetScriptInstallerQueueUnit();
    next();
}

void PoetScriptInstallerQueue::next()
{
    p->active = false;
    if(!p->current.guid.isEmpty())
        return;
    if(p->list.isEmpty())
        return;

    p->active = true;
    p->current = p->list.takeFirst();

    switch(p->current.type)
    {
    case PoetScriptInstallerQueueUnit::Install:
        QMetaObject::invokeMethod(p->core, "installFile", Qt::QueuedConnection,
                                  Q_ARG(QString,p->current.file),
                                  Q_ARG(int,p->current.poetId),
                                  Q_ARG(QDateTime,p->current.date));
        break;

    case PoetScriptInstallerQueueUnit::Remove:
        QMetaObject::invokeMethod(p->core, "remove", Qt::QueuedConnection,
                                  Q_ARG(int,p->current.poetId));
        break;
    }
}

PoetScriptInstallerQueue::~PoetScriptInstallerQueue()
{
    if(p->thread && p->core)
    {
        p->thread->quit();
        p->thread->wait();
        p->core->deleteLater();
    }

    delete p;
}
