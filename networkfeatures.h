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

#ifndef NETWORKFEATURES_H
#define NETWORKFEATURES_H

#include <QObject>

class ApiLayer_LastMessage;
class ApiLayer_LastAdvertise;
class NetworkFeaturesPrivate;
class NetworkFeatures : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString lastMessageUuid READ lastMessageUuid NOTIFY lastMessageChanged)
    Q_PROPERTY(QString lastMessageMessage READ lastMessageMessage NOTIFY lastMessageChanged)
    Q_PROPERTY(bool lastMessageAllow READ lastMessageAllow NOTIFY lastMessageChanged)
    Q_PROPERTY(QString lastMessageUrl READ lastMessageUrl NOTIFY lastMessageChanged)

    Q_PROPERTY(QString advertisePhoto READ advertisePhoto NOTIFY advertiseChanged)
    Q_PROPERTY(QString advertiseQml READ advertiseQml NOTIFY advertiseChanged)
    Q_PROPERTY(QString advertiseLink READ advertiseLink NOTIFY advertiseChanged)

    Q_PROPERTY(bool activePush READ activePush WRITE setActivePush NOTIFY activePushChanged)

public:
    NetworkFeatures(QObject *parent = 0);
    ~NetworkFeatures();

    QString lastMessageUuid() const;
    QString lastMessageMessage() const;
    bool lastMessageAllow() const;
    QString lastMessageUrl() const;

    QString advertisePhoto() const;
    QString advertiseLink() const;
    QString advertiseQml() const;

    void setActivePush(bool stt);
    bool activePush() const;

public slots:
    void pushActivity(const QString &type, int ms, const QString &comment);
    void pushAction(const QString &action);
    void pushDeviceModel(const QString &name, qreal screen, qreal density);

signals:
    void advertiseChanged();
    void lastMessageChanged();
    void showMessage(const QString &message, const QString &url);
    void activePushChanged();

private slots:
    void wake();
    void sleep();
    void getStart();

    void pushLastMessageRequestAnswer(qint64 id, const ApiLayer_LastMessage &msg);
    void pushGetAdvertiseRequestAnswer(qint64 id, const ApiLayer_LastAdvertise &adv);

private:
    void init();
    void analizeAdvCode(const QString &code);

private:
    NetworkFeaturesPrivate *p;
};

#endif // NETWORKFEATURES_H
