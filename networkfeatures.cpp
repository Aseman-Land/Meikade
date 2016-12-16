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

#define LAST_MESSAGE_UUID "LastMessage/uuid"
#define LAST_MESSAGE_MSG "LastMessage/message"
#define LAST_MESSAGE_ALW_DEVICE "LastMessage/allowedDevices"
#define LAST_MESSAGE_ACTION "LastMessage/urlAction"
#define LAST_MESSAGE_VISIBLED "LastMessage/visibled"

#define ADVERTISE_CODE "Advertise/code"
#define ADVERTISE_LINK "Advertise/link"

#include "networkfeatures.h"
#include "apilayer.h"
#include "asemantools/asemannetworksleepmanager.h"
#include "asemantools/asemandevices.h"
#include "meikade_macros.h"

#include <QPointer>
#include <QDebug>
#include <QSettings>
#include <QTimer>

class NetworkFeaturesPrivate
{
public:
    AsemanNetworkSleepManager *networkManager;
    QPointer<ApiLayer> api;
    QSettings *settings;

    ApiLayer_LastMessage lastMsg;
    ApiLayer_LastAdvertise adv;

    bool activePush;

    QString advertiseQml;
    QString advertisePhoto;
};

NetworkFeatures::NetworkFeatures(QObject *parent) :
    QObject(parent)
{
    p = new NetworkFeaturesPrivate;
    p->activePush = true;

    p->settings = new QSettings(HOME_PATH + "/network-featurs.ini", QSettings::IniFormat, this);
    p->api = new ApiLayer(this);

    p->networkManager = new AsemanNetworkSleepManager(this);
    p->networkManager->setHost("aseman.land");
    p->networkManager->setPort(80);
    p->networkManager->setInterval(5000);

    connect(p->networkManager, SIGNAL(wake()), SLOT(wake()));
    connect(p->networkManager, SIGNAL(sleep()), SLOT(sleep()));

    connect(p->api, SIGNAL(pushGetAdvertiseRequestAnswer(qint64,ApiLayer_LastAdvertise)),
            SLOT(pushGetAdvertiseRequestAnswer(qint64,ApiLayer_LastAdvertise)));
    connect(p->api, SIGNAL(pushLastMessageRequestAnswer(qint64,ApiLayer_LastMessage)),
            SLOT(pushLastMessageRequestAnswer(qint64,ApiLayer_LastMessage)));

    QTimer::singleShot(2000, this, SLOT(getStart()));
    init();
}

void NetworkFeatures::pushActivity(const QString &type, int ms, const QString &comment)
{
    if(!p->activePush || type.isEmpty() || ms == 0)
        return;

    p->api->pushActivityRequest(type, ms, comment);
}

void NetworkFeatures::pushAction(const QString &action)
{
    if(!p->activePush || action.isEmpty())
        return;

    p->api->pushActionRequest(action);
}

void NetworkFeatures::pushDeviceModel(const QString &name, qreal screen, qreal density)
{
    if(!p->activePush || name.isEmpty())
        return;

    p->api->pushDeviceModelRequest(name, screen, density);
}

void NetworkFeatures::wake()
{
    p->api->wake();
    qDebug() << "Wakked up...";
}

void NetworkFeatures::sleep()
{
    p->api->sleep();
    qDebug() << "Slept...";
}

void NetworkFeatures::getStart()
{
    p->api->pushGetAdvertiseRequest();
    p->api->pushLastMessageRequest();

    if(!p->lastMsg.uuid.isEmpty() && p->settings->value(LAST_MESSAGE_VISIBLED).toString() != p->lastMsg.uuid)
    {
        emit showMessage(p->lastMsg.message, p->lastMsg.okUrlAction);
        p->settings->setValue(LAST_MESSAGE_VISIBLED, p->lastMsg.uuid);
    }
}

void NetworkFeatures::pushLastMessageRequestAnswer(qint64 id, const ApiLayer_LastMessage &msg)
{
    Q_UNUSED(id)
    p->settings->setValue(LAST_MESSAGE_UUID, msg.uuid);
    p->settings->setValue(LAST_MESSAGE_MSG, msg.message);
    p->settings->setValue(LAST_MESSAGE_ALW_DEVICE, msg.allowedDeviceIds);
    p->settings->setValue(LAST_MESSAGE_ACTION, msg.okUrlAction);
}

void NetworkFeatures::pushGetAdvertiseRequestAnswer(qint64 id, const ApiLayer_LastAdvertise &adv)
{
    Q_UNUSED(id)

    p->settings->setValue(ADVERTISE_CODE, adv.imageUrl.toUtf8());
    p->settings->setValue(ADVERTISE_LINK, adv.link);

    p->adv = adv;
    analizeAdvCode(p->adv.imageUrl);

    emit advertiseChanged();
}

void NetworkFeatures::init()
{
    QString code = p->settings->value(ADVERTISE_CODE).toByteArray();
    analizeAdvCode(code);
    if(p->advertiseQml.isEmpty())
        p->advertisePhoto.clear();
    else
    {
        p->adv.imageUrl = code;
        p->adv.link = p->settings->value(ADVERTISE_LINK).toString();
    }

    p->lastMsg.uuid = p->settings->value(LAST_MESSAGE_UUID).toString();
    p->lastMsg.message = p->settings->value(LAST_MESSAGE_MSG).toString();
    p->lastMsg.allowedDeviceIds = p->settings->value(LAST_MESSAGE_ALW_DEVICE).toString();
    p->lastMsg.okUrlAction = p->settings->value(LAST_MESSAGE_ACTION).toString();
}

void NetworkFeatures::analizeAdvCode(const QString &code)
{
    p->advertisePhoto.clear();
    p->advertiseQml.clear();

    const int protocol_idx = code.indexOf("://");
    if(code.trimmed().isEmpty())
        ;
    else
    if(0<protocol_idx && protocol_idx<16)
        p->advertisePhoto = code;
    else
    if(!code.contains("import") && !code.contains("Qt.create") &&
       !code.contains("Qt.include") && !code.contains("Qt.quit") &&
       !code.contains(QRegExp("Meikade|Database|"
                              "UserData|Backuper|"
                              "System|ThreadedFileSystem")) )
        p->advertiseQml = QString("import AsemanTools.Secure 1.0\n"
                          "import QtQuick 2.3\n Item { anchors.fill: parent;"
                          " clip: true; \n%1\n }").arg(code);
}

QString NetworkFeatures::lastMessageUuid() const
{
    return p->lastMsg.uuid;
}

QString NetworkFeatures::lastMessageMessage() const
{
    return p->lastMsg.message;
}

bool NetworkFeatures::lastMessageAllow() const
{
    return AsemanDevices::deviceId().contains(QRegExp(p->lastMsg.allowedDeviceIds));
}

QString NetworkFeatures::lastMessageUrl() const
{
    return p->lastMsg.okUrlAction;
}

QString NetworkFeatures::advertisePhoto() const
{
    return p->advertisePhoto;
}

QString NetworkFeatures::advertiseLink() const
{
    return p->adv.link;
}

QString NetworkFeatures::advertiseQml() const
{
    return p->advertiseQml;
}

void NetworkFeatures::setActivePush(bool stt)
{
    if(p->activePush == stt)
        return;

    p->activePush = stt;
    emit activePushChanged();
}

bool NetworkFeatures::activePush() const
{
    return p->activePush;
}

NetworkFeatures::~NetworkFeatures()
{
    delete p;
}
