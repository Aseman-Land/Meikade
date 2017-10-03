/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    TelegramStats is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TelegramStats is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

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
