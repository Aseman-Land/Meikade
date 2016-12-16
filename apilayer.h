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

#ifndef APILAYER_H
#define APILAYER_H

#include <QObject>
#include <QDateTime>
#include <QStringList>
#include <QTcpSocket>

class ApiLayer_LastMessage
{
public:
    QString uuid;
    QString message;
    QString okUrlAction;
    QString allowedDeviceIds;
};

class ApiLayer_LastAdvertise
{
public:
    QString imageUrl;
    QString link;
};

class ApiLayerPrivate;
class ApiLayer : public QObject
{
    Q_OBJECT

public:
    enum StructRoles {
        PushLastMessageRequestStruct = 0x81b522,
        PushLastMessageStruct = 0x4f97a9,
        PushGetAdvertiseRequestStruct = 0xfd00dd,
        PushGetAdvertiseStruct = 0xd759c4,
        PushActivityRequestStruct = 0x6bfdf8,
        PushActivityStruct = 0xe2732b,
        PushActionRequestStruct = 0x8df1ba,
        PushActionStruct = 0x74153e,
        PushDeviceModelRequestStruct = 0x468b4f,
        PushDeviceModelStruct = 0x615e0e
    };

    enum ServicesRoles {
        ApiId = 0x6cbd56,
        PushLastMessageService = 0x47db96,
        PushGetAdvertiseService = 0xc42aa1,
        PushActivityService = 0xf4aa95,
        PushActionService = 0xd6ae0c,
        PushDeviceModelService = 0xa4387d
    };

    ApiLayer(QObject *parent = 0);
    ~ApiLayer();

    qint64 pushLastMessageRequest();
    qint64 pushGetAdvertiseRequest();
    qint64 pushActivityRequest(const QString &type, int ms, const QString &comment);
    qint64 pushActionRequest(const QString &action);
    qint64 pushDeviceModelRequest(const QString &name, qreal screen, qreal density);

public slots:
    void startDestroying();
    void wake();
    void sleep();

signals:
    void pushLastMessageRequestAnswer(qint64 id, const ApiLayer_LastMessage &msg);
    void pushGetAdvertiseRequestAnswer(qint64 id, const ApiLayer_LastAdvertise &adv);
    void pushActivityRequestAnswer(qint64 id, bool ok);
    void pushActionRequestAnswer(qint64 id, bool ok);
    void pushDeviceModelRequestAnswer(qint64 id, bool ok);
    void error(const QString &text);
    void queueFinished();

private slots:
    void onReadyRead();
    void onPushLastMessageRequestAnswer(QByteArray data);
    void onPushGetAdvertiseRequestAnswer(QByteArray data);
    void onPushActivityRequestAnswer(QByteArray data);
    void onPushActionRequestAnswer(QByteArray data);
    void onPushDeviceModelRequestAnswer(QByteArray data);

    void error_prv(QAbstractSocket::SocketError socketError);
    void writeQueue();
    void disconnected();
    void reconnect();

private:
    bool write(QByteArray data, bool queueFailed = true);
    QByteArray read(qint64 maxlen = 0);
    QTcpSocket *getSocket();

    void startTimeOut(qint64 id);
    void checkTimeOut(qint64 id);

    void initSocket();

protected:
    void timerEvent(QTimerEvent *e);

private:
    ApiLayerPrivate *p;
};

#endif // APILAYER_H
