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
    Q_ENUMS(Errors)

public:
    enum ActiveSessionResult {
        Actived = 0xC851D0,
        Expired = 0x32D062,
        InvalidSessionId = 0x47D0CE,
        InvalidApp = 0x7FD066
    };
    enum Errors {
        ErrorIncorrectUerName = 0x1,
        ErrorCantChangePassword = 0x2,
        ErrorIncorrectPassword = 0x4,
        ErrorUnknownError = 0x8,
        ErrorPasswordIsShort = 0x10,
        ErrorUsernameExists = 0x20,
        ErrorIncorrectSession = 0x40,
        ErrorIncorrectAppId = 0x80,
        ErrorExpiredSession = 0x100
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

    qint64 checkEmail(QString email, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "checkEmail", QVariantList() << QVariant::fromValue<QString>(email));
        _calls[id] = "checkEmail";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 resetPasswordSendEmail(QString email, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "resetPasswordSendEmail", QVariantList() << QVariant::fromValue<QString>(email));
        _calls[id] = "resetPasswordSendEmail";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 resetPassword(QString token, QString newPassword, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "resetPassword", QVariantList() << QVariant::fromValue<QString>(token) << QVariant::fromValue<QString>(newPassword));
        _calls[id] = "resetPassword";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 changePassword(QString userName, QString oldPassword, QString newPassword, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "changePassword", QVariantList() << QVariant::fromValue<QString>(userName) << QVariant::fromValue<QString>(oldPassword) << QVariant::fromValue<QString>(newPassword));
        _calls[id] = "changePassword";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 signUp(QString userName, QString password, QString email, QString fullName, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "signUp", QVariantList() << QVariant::fromValue<QString>(userName) << QVariant::fromValue<QString>(password) << QVariant::fromValue<QString>(email) << QVariant::fromValue<QString>(fullName));
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

    qint64 logOut(QString sessionId, int application, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "logOut", QVariantList() << QVariant::fromValue<QString>(sessionId) << QVariant::fromValue<int>(application));
        _calls[id] = "logOut";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    qint64 activeSession(QString sessionId, int application, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest(_service, _version, "activeSession", QVariantList() << QVariant::fromValue<QString>(sessionId) << QVariant::fromValue<int>(application));
        _calls[id] = "activeSession";
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
    qint64 checkUsername(QString username, const QJSValue &jsCallback) {
        return checkUsername(username, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 checkEmail(QString email, const QJSValue &jsCallback) {
        return checkEmail(email, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 resetPasswordSendEmail(QString email, const QJSValue &jsCallback) {
        return resetPasswordSendEmail(email, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 resetPassword(QString token, QString newPassword, const QJSValue &jsCallback) {
        return resetPassword(token, newPassword, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 changePassword(QString userName, QString oldPassword, QString newPassword, const QJSValue &jsCallback) {
        return changePassword(userName, oldPassword, newPassword, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 signUp(QString userName, QString password, QString email, QString fullName, const QJSValue &jsCallback) {
        return signUp(userName, password, email, fullName, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 logIn(QString userName, QString password, QString device, int application, const QJSValue &jsCallback) {
        return logIn(userName, password, device, application, this, [this, jsCallback](qint64, const QString &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 logOut(QString sessionId, int application, const QJSValue &jsCallback) {
        return logOut(sessionId, application, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 activeSession(QString sessionId, int application, const QJSValue &jsCallback) {
        return activeSession(sessionId, application, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }

#endif //QT_QML_LIB

Q_SIGNALS:
    void pingAnswer(qint64 id, QString result);
    void disconnected(QString sessionId);
    void checkUsernameAnswer(qint64 id, bool result);
    void checkEmailAnswer(qint64 id, bool result);
    void resetPasswordSendEmailAnswer(qint64 id, bool result);
    void resetPasswordAnswer(qint64 id, bool result);
    void changePasswordAnswer(qint64 id, bool result);
    void signUpAnswer(qint64 id, bool result);
    void logInAnswer(qint64 id, QString result);
    void logOutAnswer(qint64 id, bool result);
    void activeSessionAnswer(qint64 id, bool result);

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
        if(method == "checkUsername") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT checkUsernameAnswer(id, result.value<bool>());
        } else
        if(method == "checkEmail") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT checkEmailAnswer(id, result.value<bool>());
        } else
        if(method == "resetPasswordSendEmail") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT resetPasswordSendEmailAnswer(id, result.value<bool>());
        } else
        if(method == "resetPassword") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT resetPasswordAnswer(id, result.value<bool>());
        } else
        if(method == "changePassword") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT changePasswordAnswer(id, result.value<bool>());
        } else
        if(method == "signUp") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT signUpAnswer(id, result.value<bool>());
        } else
        if(method == "logIn") {
            callBackCall<QString>(id, result.value<QString>(), error);
            _calls.remove(id);
            Q_EMIT logInAnswer(id, result.value<QString>());
        } else
        if(method == "logOut") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT logOutAnswer(id, result.value<bool>());
        } else
        if(method == "activeSession") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            Q_EMIT activeSessionAnswer(id, result.value<bool>());
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

