#include "poetscriptinstallerqueue.h"
#include "poetscriptinstaller.h"

#include <QThread>
#include <QDebug>

class PoetScriptInstallerQueueUnit
{
public:
    QString file;
    QString guid;

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

    connect(p->core, SIGNAL(finished(bool)), SLOT(finished(bool)), Qt::QueuedConnection);
}

void PoetScriptInstallerQueue::append(const QString &file, const QString &guid)
{
    init_core();
    PoetScriptInstallerQueueUnit unit;
    unit.file = file;
    unit.guid = guid;

    if(p->list.contains(unit))
        return;

    p->list << unit;
    next();
}

void PoetScriptInstallerQueue::finished(bool error)
{
    if(error)
        emit PoetScriptInstallerQueue::error(p->current.file, p->current.guid);
    else
        emit PoetScriptInstallerQueue::finished(p->current.file, p->current.guid);

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
    QMetaObject::invokeMethod(p->core, "installFile", Qt::QueuedConnection, Q_ARG(QString,p->current.file));
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

