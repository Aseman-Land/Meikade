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

#ifndef ASEMANABSTRACTAGENTCLIENT_H
#define ASEMANABSTRACTAGENTCLIENT_H

#include "asemanabstractclientsocket.h"
#include "asemanclientlib_global.h"

#ifdef QT_QML_LIB
#include <QJSEngine>
#endif //#ifdef QT_QML_LIB

class AsemanAbstractAgentClientPrivate;
class ASEMANCLIENTLIBSHARED_EXPORT AsemanAbstractAgentClient : public QObject
{
    Q_OBJECT
    Q_PROPERTY(AsemanAbstractClientSocket* socket READ socket WRITE setSocket NOTIFY socketChanged)

public:
    typedef AsemanAbstractClientSocket::CallbackError CallbackError;

    template<typename T>
    using Callback = std::function<void (qint64,T,CallbackError)>;

    AsemanAbstractAgentClient(QObject *parent = Q_NULLPTR);
    ~AsemanAbstractAgentClient();

    void setSocket(AsemanAbstractClientSocket *socket);
    AsemanAbstractClientSocket *socket() const;

Q_SIGNALS:
    void socketChanged();

public Q_SLOTS:
    qint64 pushRequest(const QString &service, int version, const QString &method, const QVariantList &args);

protected:
    virtual void processAnswer(qint64 id, const QVariant &result) = 0;
    virtual void processError(qint64 id, const CallbackError &result) = 0;
    virtual void processSignals(const QString &signalName, const QVariantList &args) = 0;

    void pushBase(qint64 msgId, QObject *base) {
        if(!base) return;
        mCallbackObjects[msgId] = base;
        connect(base, &QObject::destroyed, this, [this, msgId](){
            void *ptr = mCallbacks.take(msgId);
            if(!ptr) return;
            delete reinterpret_cast<Callback<int>*>(ptr);
        });
    }

#ifdef QT_QML_LIB
    template<typename T>
    void callBackJs(QJSValue jsCallback,const T &result, const CallbackError &error) {
        QJSEngine *engine = qjsEngine(this);
        const bool hasCallback = (jsCallback.isCallable() && !jsCallback.isNull() && engine);
        if(!hasCallback)
            return;

        QVariantMap errorMap;
        errorMap["code"] = error.errorCode;
        errorMap["value"] = error.errorValue;
        errorMap["null"] = error.null;

        QJSValueList args;
        args << engine->toScriptValue<T>(result);
        args << engine->toScriptValue<QVariantMap>(errorMap);

        jsCallback.call(args);
    }
#endif //#ifdef QT_QML_LIB

    template<typename T>
    void callBackPush(qint64 msgId, Callback<T> callback) {
        if(!callback || mCallbacks.contains(msgId)) return;
        void *ptr = new Callback<T>(callback);
        mCallbacks[msgId] = ptr;
    }

    template<typename T>
    Callback<T> callBackGet(qint64 msgId) {
        void *ptr = mCallbacks.value(msgId);
        if(!ptr) return 0;
        Callback<T> *callBack = reinterpret_cast<Callback<T>*>(ptr);
        return (*callBack);
    }

    template<typename T>
    void callBackCall(qint64 msgId, const T &result, const CallbackError &error = CallbackError()) {
        Callback<T> callBack = callBackGet<T>(msgId);
        void *ptr = mCallbacks.take(msgId);
        mCallbackObjects.remove(msgId);
        if(!ptr) return;
        callBack(msgId, result, error);
        delete reinterpret_cast<Callback<T>*>(ptr);
    }

private:
    AsemanAbstractAgentClientPrivate *p;
    QHash<qint64, void*> mCallbacks;
    QHash<qint64, QObject*> mCallbackObjects;
};

#endif // ASEMANABSTRACTAGENTCLIENT_H
