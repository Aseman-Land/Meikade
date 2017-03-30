#include "asemanabstractagentclient.h"

#include <QPointer>

class AsemanAbstractAgentClientPrivate
{
public:
    QPointer<AsemanAbstractClientSocket> socket;
};

AsemanAbstractAgentClient::AsemanAbstractAgentClient(QObject *parent) :
    QObject(parent)
{
    p = new AsemanAbstractAgentClientPrivate;
}

void AsemanAbstractAgentClient::setSocket(AsemanAbstractClientSocket *socket)
{
    if(p->socket == socket)
        return;

    if(p->socket)
    {
        disconnect(p->socket.data(), &AsemanAbstractClientSocket::answer, this, &AsemanAbstractAgentClient::processAnswer);
        disconnect(p->socket.data(), static_cast<void (AsemanAbstractClientSocket::*)(qint64,const CallbackError &)>(&AsemanAbstractClientSocket::error), this, &AsemanAbstractAgentClient::processError);
        disconnect(p->socket.data(), &AsemanAbstractClientSocket::signalEmitted, this, &AsemanAbstractAgentClient::processSignals);
    }

    p->socket = socket;
    if(p->socket)
    {
        connect(p->socket.data(), &AsemanAbstractClientSocket::answer, this, &AsemanAbstractAgentClient::processAnswer);
        connect(p->socket.data(), static_cast<void (AsemanAbstractClientSocket::*)(qint64,const CallbackError &)>(&AsemanAbstractClientSocket::error), this, &AsemanAbstractAgentClient::processError);
        connect(p->socket.data(), &AsemanAbstractClientSocket::signalEmitted, this, &AsemanAbstractAgentClient::processSignals);
    }

    Q_EMIT socketChanged();
}

AsemanAbstractClientSocket *AsemanAbstractAgentClient::socket() const
{
    return p->socket;
}

qint64 AsemanAbstractAgentClient::pushRequest(const QString &service, int version, const QString &method, const QVariantList &args)
{
    if(!p->socket)
        return 0;
    return p->socket->pushRequest(service, version, method, args);
}

AsemanAbstractAgentClient::~AsemanAbstractAgentClient()
{
    QHashIterator<qint64, void*> i(mCallbacks);
    while(i.hasNext())
    {
        i.next();
        Callback<int> *ptr = reinterpret_cast<Callback<int>*>(i.value());
        delete ptr;
    }
    mCallbacks.clear();
    delete p;
}
