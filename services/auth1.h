#ifndef AUTH1_H
#define AUTH1_H

#include <asemanabstractagentclient.h>

#ifdef QT_QML_LIB
#include <QJSValue>
#endif

class Auth1: public AsemanAbstractAgentClient
{
    Q_OBJECT
    Q_ENUMS(ActiveSessionResult)

public:
    enum ActiveSessionResult {
        actived = 0xC851D0,
        expired = 0x32D062,
        invalidSessionId = 0x47D0CE,
        invalidApp = 0x7FD066
    };

    Auth1(QObject *parent = Q_NULLPTR) :
        AsemanAbstractAgentClient(parent),
        _service("auth"),
        _version(1) {
    }
    ~Auth1() {
    }

    qint64 ping(int num, QObject *base = 0, Callback<QString> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "ping", QVariantList() << QVariant::fromValue<int>(num));
        _calls[id] = "ping";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    qint64 checkUsername(QString username, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "checkUsername", QVariantList() << QVariant::fromValue<QString>(username));
        _calls[id] = "checkUsername";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 signUp(QString userName, QString password, QString email, QString firstName, QString lastName, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "signUp", QVariantList() << QVariant::fromValue<QString>(userName) << QVariant::fromValue<QString>(password) << QVariant::fromValue<QString>(email) << QVariant::fromValue<QString>(firstName) << QVariant::fromValue<QString>(lastName));
        _calls[id] = "signUp";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 logIn(QString userName, QString password, QString device, int application, QObject *base = 0, Callback<QString> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "logIn", QVariantList() << QVariant::fromValue<QString>(userName) << QVariant::fromValue<QString>(password) << QVariant::fromValue<QString>(device) << QVariant::fromValue<int>(application));
        _calls[id] = "logIn";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    qint64 loginUsingGoogle(QString googleId, QString tokenId, QString fullName, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "loginUsingGoogle", QVariantList() << QVariant::fromValue<QString>(googleId) << QVariant::fromValue<QString>(tokenId) << QVariant::fromValue<QString>(fullName));
        _calls[id] = "loginUsingGoogle";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 logOut(QString sessionId, int application, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "logOut", QVariantList() << QVariant::fromValue<QString>(sessionId) << QVariant::fromValue<int>(application));
        _calls[id] = "logOut";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 activeSession(QString sessionId, int application, QObject *base = 0, Callback<int> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "activeSession", QVariantList() << QVariant::fromValue<QString>(sessionId) << QVariant::fromValue<int>(application));
        _calls[id] = "activeSession";
        pushBase(id, base);
        callBackPush<int>(id, callBack);
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
    qint64 checkUsername(QString username, const QJSValue &jsCallback) {
        return checkUsername(username, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 signUp(QString userName, QString password, QString email, QString firstName, QString lastName, const QJSValue &jsCallback) {
        return signUp(userName, password, email, firstName, lastName, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 logIn(QString userName, QString password, QString device, int application, const QJSValue &jsCallback) {
        return logIn(userName, password, device, application, this, [this, jsCallback](qint64, const QString &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 loginUsingGoogle(QString googleId, QString tokenId, QString fullName, const QJSValue &jsCallback) {
        return loginUsingGoogle(googleId, tokenId, fullName, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 logOut(QString sessionId, int application, const QJSValue &jsCallback) {
        return logOut(sessionId, application, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 activeSession(QString sessionId, int application, const QJSValue &jsCallback) {
        return activeSession(sessionId, application, this, [this, jsCallback](qint64, const int &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }

#endif //QT_QML_LIB

Q_SIGNALS:
    void pingAnswer(qint64 id, QString result);
    void disconnected(QString sessionId);
    void checkUsernameAnswer(qint64 id, bool result);
    void signUpAnswer(qint64 id, bool result);
    void logInAnswer(qint64 id, QString result);
    void loginUsingGoogleAnswer(qint64 id, bool result);
    void logOutAnswer(qint64 id, bool result);
    void activeSessionAnswer(qint64 id, int result);

protected:
    void processAnswer(qint64 id, const QVariant &result) {
        const QString method = _calls.value(id);
        if(method == "ping") {
            callBackCall<QString>(id, result.value<QString>());
            _calls.remove(id);
            Q_EMIT pingAnswer(id, result.value<QString>());
        } else
        if(method == "checkUsername") {
            callBackCall<bool>(id, result.value<bool>());
            _calls.remove(id);
            Q_EMIT checkUsernameAnswer(id, result.value<bool>());
        } else
        if(method == "signUp") {
            callBackCall<bool>(id, result.value<bool>());
            _calls.remove(id);
            Q_EMIT signUpAnswer(id, result.value<bool>());
        } else
        if(method == "logIn") {
            callBackCall<QString>(id, result.value<QString>());
            _calls.remove(id);
            Q_EMIT logInAnswer(id, result.value<QString>());
        } else
        if(method == "loginUsingGoogle") {
            callBackCall<bool>(id, result.value<bool>());
            _calls.remove(id);
            Q_EMIT loginUsingGoogleAnswer(id, result.value<bool>());
        } else
        if(method == "logOut") {
            callBackCall<bool>(id, result.value<bool>());
            _calls.remove(id);
            Q_EMIT logOutAnswer(id, result.value<bool>());
        } else
        if(method == "activeSession") {
            callBackCall<int>(id, result.value<int>());
            _calls.remove(id);
            Q_EMIT activeSessionAnswer(id, result.value<int>());
        } else
            Q_UNUSED(result);
    }

    void processSignals(const QString &method, const QVariantList &args) {
        if(method == "disconnected") {
            if(args.count() != 1) return;
            Q_EMIT disconnected(args[0].value<QString>());
        } else
            Q_UNUSED(args);
    }

private:
    QString _service;
    int _version;
    QHash<qint64, QString> _calls;
};


#endif //AUTH1_H

