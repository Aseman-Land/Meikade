#include "asemanabstractclientsocket.h"

AsemanAbstractClientSocket::AsemanAbstractClientSocket(QObject *parent) :
    QObject(parent),
    _ssl(true),
    _port(0),
    _autoTrust(false)
{

}

AsemanAbstractClientSocket::~AsemanAbstractClientSocket()
{

}
