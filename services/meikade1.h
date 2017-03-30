#ifndef MEIKADE1_H
#define MEIKADE1_H

#include <asemanabstractagentclient.h>

#ifdef QT_QML_LIB
#include <QJSValue>
#endif

class Meikade1: public AsemanAbstractAgentClient
{
    Q_OBJECT

public:

    Meikade1(QObject *parent = Q_NULLPTR) :
        AsemanAbstractAgentClient(parent),
        _service("meikade"),
        _version(1) {
    }
    ~Meikade1() {
    }

    qint64 ping(int num, QObject *base = 0, Callback<QString> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "ping", QVariantList() << QVariant::fromValue<int>(num));
        _calls[id] = "ping";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    qint64 lastMessage(QObject *base = 0, Callback<QVariantMap> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "lastMessage", QVariantList());
        _calls[id] = "lastMessage";
        pushBase(id, base);
        callBackPush<QVariantMap>(id, callBack);
        return id;
    }

    qint64 getAdvertise(QObject *base = 0, Callback<QVariantMap> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "getAdvertise", QVariantList());
        _calls[id] = "getAdvertise";
        pushBase(id, base);
        callBackPush<QVariantMap>(id, callBack);
        return id;
    }

    qint64 pushActivity(QString type, int time, QString comment, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "pushActivity", QVariantList() << QVariant::fromValue<QString>(type) << QVariant::fromValue<int>(time) << QVariant::fromValue<QString>(comment));
        _calls[id] = "pushActivity";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 pushAction(QString action, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "pushAction", QVariantList() << QVariant::fromValue<QString>(action));
        _calls[id] = "pushAction";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 pushDeviceModel(QString device, double screen, double density, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "pushDeviceModel", QVariantList() << QVariant::fromValue<QString>(device) << QVariant::fromValue<double>(screen) << QVariant::fromValue<double>(density));
        _calls[id] = "pushDeviceModel";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }


#ifdef QT_QML_LIB
public Q_SLOTS:
    /*!
     * Callbacks gives result value and error map as arguments.
     */
    qint64 ping(int num, const QJSValue &jsCallback) {
        return ping(num, this, [this, jsCallback](qint64, const QString &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 lastMessage(const QJSValue &jsCallback) {
        return lastMessage(this, [this, jsCallback](qint64, const QVariantMap &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 getAdvertise(const QJSValue &jsCallback) {
        return getAdvertise(this, [this, jsCallback](qint64, const QVariantMap &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 pushActivity(QString type, int time, QString comment, const QJSValue &jsCallback) {
        return pushActivity(type, time, comment, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 pushAction(QString action, const QJSValue &jsCallback) {
        return pushAction(action, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 pushDeviceModel(QString device, double screen, double density, const QJSValue &jsCallback) {
        return pushDeviceModel(device, screen, density, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }

#endif //QT_QML_LIB

Q_SIGNALS:
    void pingAnswer(qint64 id, QString result);
    void lastMessageAnswer(qint64 id, QVariantMap result);
    void getAdvertiseAnswer(qint64 id, QVariantMap result);
    void pushActivityAnswer(qint64 id, bool result);
    void pushActionAnswer(qint64 id, bool result);
    void pushDeviceModelAnswer(qint64 id, bool result);

protected:
    void processError(qint64 id, const CallbackError &error) {
        processResult(id, QVariant(), error);
    }

    void processAnswer(qint64 id, const QVariant &result) {
        processResult(id, result, CallbackError());
    }

    void processResult(qint64 id, const QVariant &result, const CallbackError &error) {
        const QString method = _calls.value(id);
        if(method == "ping") {
            callBackCall<QString>(id, result.value<QString>(), error);
            _calls.remove(id);
            Q_EMIT pingAnswer(id, result.value<QString>());
        } else
        if(method == "lastMessage") {
            callBackCall<QVariantMap>(id, result.value<QVariantMap>(), error);
            _calls.remove(id);
            Q_EMIT lastMessageAnswer(id, result.value<QVariantMap>());
        } else
        if(method == "getAdvertise") {
            callBackCall<QVariantMap>(id, result.value<QVariantMap>(), error);
            _calls.remove(id);
            Q_EMIT getAdvertiseAnswer(id, result.value<QVariantMap>());
        } else
        if(method == "pushActivity") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT pushActivityAnswer(id, result.value<bool>());
        } else
        if(method == "pushAction") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT pushActionAnswer(id, result.value<bool>());
        } else
        if(method == "pushDeviceModel") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT pushDeviceModelAnswer(id, result.value<bool>());
        } else
            Q_UNUSED(result);
    }

    void processSignals(const QString &method, const QVariantList &args) {
            Q_UNUSED(args);
    }

private:
    QString _service;
    int _version;
    QHash<qint64, QString> _calls;
};


#endif //MEIKADE1_H

