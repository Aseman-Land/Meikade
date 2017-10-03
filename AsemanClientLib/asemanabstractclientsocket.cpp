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

#include "asemanabstractclientsocket.h"

AsemanAbstractClientSocket::AsemanAbstractClientSocket(QObject *parent) :
    QObject(parent),
    _ssl(true),
    _port(0),
    _autoTrust(false),
    _trustingSystem(true)
{

}

AsemanAbstractClientSocket::~AsemanAbstractClientSocket()
{

}
