#ifndef AUTH1_H
#define AUTH1_H

#include <asemanabstractagentclient.h>

#define ASEMAN_AGENT_PING_CALLBACK ASEMAN_AGENT_CALLBACK(QString)
#define ASEMAN_AGENT_CHECKUSERNAME_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_CHECKEMAIL_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_RESETPASSWORDSENDEMAIL_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_RESETPASSWORD_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_CHANGEPASSWORD_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_TRUSTPASSWORD_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_ISTRUSTED_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_SIGNUP_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_LOGIN_CALLBACK ASEMAN_AGENT_CALLBACK(QString)
#define ASEMAN_AGENT_LOGOUT_CALLBACK ASEMAN_AGENT_CALLBACK(bool)
#define ASEMAN_AGENT_ACTIVESESSION_CALLBACK ASEMAN_AGENT_CALLBACK(bool)


#ifdef QT_QML_LIB
#include <QJSValue>
#endif

class Auth1: public AsemanAbstractAgentClient
{
    Q_OBJECT
    Q_ENUMS(ActiveSessionResult)
    Q_ENUMS(Errors)
    Q_PROPERTY(QString name_ping READ name_ping NOTIFY fakeSignal)
    Q_PROPERTY(QString name_checkUsername READ name_checkUsername NOTIFY fakeSignal)
    Q_PROPERTY(QString name_checkEmail READ name_checkEmail NOTIFY fakeSignal)
    Q_PROPERTY(QString name_resetPasswordSendEmail READ name_resetPasswordSendEmail NOTIFY fakeSignal)
    Q_PROPERTY(QString name_resetPassword READ name_resetPassword NOTIFY fakeSignal)
    Q_PROPERTY(QString name_changePassword READ name_changePassword NOTIFY fakeSignal)
    Q_PROPERTY(QString name_trustPassword READ name_trustPassword NOTIFY fakeSignal)
    Q_PROPERTY(QString name_isTrusted READ name_isTrusted NOTIFY fakeSignal)
    Q_PROPERTY(QString name_signUp READ name_signUp NOTIFY fakeSignal)
    Q_PROPERTY(QString name_logIn READ name_logIn NOTIFY fakeSignal)
    Q_PROPERTY(QString name_logOut READ name_logOut NOTIFY fakeSignal)
    Q_PROPERTY(QString name_activeSession READ name_activeSession NOTIFY fakeSignal)

public:
    enum ActiveSessionResult {
        Actived = 0xC851D0,
        Expired = 0x32D062,
        InvalidSessionId = 0x47D0CE,
        InvalidApp = 0x7FD066
    };
    enum Errors {
        ErrorIncorrectUerName = 0xFBE632,
        ErrorCantChangePassword = 0xCDADB4,
        ErrorIncorrectPassword = 0x4237A7,
        ErrorUnknownError = 0x41F7C0,
        ErrorPasswordIsShort = 0xEB41F7,
        ErrorUsernameExists = 0xB470B3,
        ErrorIncorrectSession = 0xA66DF8,
        ErrorIncorrectAppId = 0x31B50B,
        ErrorExpiredSession = 0xE3FD4B,
        ErrorPermissionDenied = 0x1D240,
        ErrorSessionError = 0x620299,
        ErrorNotTrusted = 0x9F68A8
    };

    Auth1(QObject *parent = Q_NULLPTR) :
        AsemanAbstractAgentClient(parent),
        _service("auth"),
        _version(1) {
    }
    virtual ~Auth1() {
    }

    virtual qint64 pushRequest(const QString &method, const QVariantList &args) {
        return AsemanAbstractAgentClient::pushRequest(_service, _version, method, args);
    }

    QString name_ping() const { return "ping"; }
    qint64 ping(int num, QObject *base = 0, Callback<QString> callBack = 0) {
        qint64 id = pushRequest("ping", QVariantList() << QVariant::fromValue<int>(num));
        _calls[id] = "ping";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    QString name_checkUsername() const { return "checkUsername"; }
    qint64 checkUsername(QString username, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("checkUsername", QVariantList() << QVariant::fromValue<QString>(username));
        _calls[id] = "checkUsername";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_checkEmail() const { return "checkEmail"; }
    qint64 checkEmail(QString email, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("checkEmail", QVariantList() << QVariant::fromValue<QString>(email));
        _calls[id] = "checkEmail";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_resetPasswordSendEmail() const { return "resetPasswordSendEmail"; }
    qint64 resetPasswordSendEmail(QString email, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("resetPasswordSendEmail", QVariantList() << QVariant::fromValue<QString>(email));
        _calls[id] = "resetPasswordSendEmail";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_resetPassword() const { return "resetPassword"; }
    qint64 resetPassword(QString token, QString newPassword, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("resetPassword", QVariantList() << QVariant::fromValue<QString>(token) << QVariant::fromValue<QString>(newPassword));
        _calls[id] = "resetPassword";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_changePassword() const { return "changePassword"; }
    qint64 changePassword(QString userName, QString oldPassword, QString newPassword, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("changePassword", QVariantList() << QVariant::fromValue<QString>(userName) << QVariant::fromValue<QString>(oldPassword) << QVariant::fromValue<QString>(newPassword));
        _calls[id] = "changePassword";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_trustPassword() const { return "trustPassword"; }
    qint64 trustPassword(QString password, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("trustPassword", QVariantList() << QVariant::fromValue<QString>(password));
        _calls[id] = "trustPassword";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_isTrusted() const { return "isTrusted"; }
    qint64 isTrusted(QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("isTrusted", QVariantList());
        _calls[id] = "isTrusted";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_signUp() const { return "signUp"; }
    qint64 signUp(QString userName, QString password, QString email, QString fullName, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("signUp", QVariantList() << QVariant::fromValue<QString>(userName) << QVariant::fromValue<QString>(password) << QVariant::fromValue<QString>(email) << QVariant::fromValue<QString>(fullName));
        _calls[id] = "signUp";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_logIn() const { return "logIn"; }
    qint64 logIn(QString userName, QString password, QString device, int application, qlonglong permissions, QObject *base = 0, Callback<QString> callBack = 0) {
        qint64 id = pushRequest("logIn", QVariantList() << QVariant::fromValue<QString>(userName) << QVariant::fromValue<QString>(password) << QVariant::fromValue<QString>(device) << QVariant::fromValue<int>(application) << QVariant::fromValue<qlonglong>(permissions));
        _calls[id] = "logIn";
        pushBase(id, base);
        callBackPush<QString>(id, callBack);
        return id;
    }

    QString name_logOut() const { return "logOut"; }
    qint64 logOut(QString sessionId, int application, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("logOut", QVariantList() << QVariant::fromValue<QString>(sessionId) << QVariant::fromValue<int>(application));
        _calls[id] = "logOut";
        pushBase(id, base);
        callBackPush<bool>(id, callBack);
        return id;
    }

    QString name_activeSession() const { return "activeSession"; }
    qint64 activeSession(QString sessionId, int application, QObject *base = 0, Callback<bool> callBack = 0) {
        qint64 id = pushRequest("activeSession", QVariantList() << QVariant::fromValue<QString>(sessionId) << QVariant::fromValue<int>(application));
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
    qint64 trustPassword(QString password, const QJSValue &jsCallback) {
        return trustPassword(password, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 isTrusted(const QJSValue &jsCallback) {
        return isTrusted(this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 signUp(QString userName, QString password, QString email, QString fullName, const QJSValue &jsCallback) {
        return signUp(userName, password, email, fullName, this, [this, jsCallback](qint64, const bool &result, const CallbackError &error) {
            callBackJs(jsCallback, result, error);
        });
    }
    qint64 logIn(QString userName, QString password, QString device, int application, qlonglong permissions, const QJSValue &jsCallback) {
        return logIn(userName, password, device, application, permissions, this, [this, jsCallback](qint64, const QString &result, const CallbackError &error) {
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
    void fakeSignal();
    void pingAnswer(qint64 id, QString result);
    void pingError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void disconnected(QString sessionId);
    void checkUsernameAnswer(qint64 id, bool result);
    void checkUsernameError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void checkEmailAnswer(qint64 id, bool result);
    void checkEmailError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void resetPasswordSendEmailAnswer(qint64 id, bool result);
    void resetPasswordSendEmailError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void resetPasswordAnswer(qint64 id, bool result);
    void resetPasswordError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void changePasswordAnswer(qint64 id, bool result);
    void changePasswordError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void trustPasswordAnswer(qint64 id, bool result);
    void trustPasswordError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void isTrustedAnswer(qint64 id, bool result);
    void isTrustedError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void signUpAnswer(qint64 id, bool result);
    void signUpError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void logInAnswer(qint64 id, QString result);
    void logInError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void logOutAnswer(qint64 id, bool result);
    void logOutError(qint64 id, qint32 errorCode, const QVariant &errorValue);
    void activeSessionAnswer(qint64 id, bool result);
    void activeSessionError(qint64 id, qint32 errorCode, const QVariant &errorValue);

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
            if(error.null) Q_EMIT pingAnswer(id, result.value<QString>());
            else Q_EMIT pingError(id, error.errorCode, error.errorValue);
        } else
        if(method == "checkUsername") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT checkUsernameAnswer(id, result.value<bool>());
            else Q_EMIT checkUsernameError(id, error.errorCode, error.errorValue);
        } else
        if(method == "checkEmail") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT checkEmailAnswer(id, result.value<bool>());
            else Q_EMIT checkEmailError(id, error.errorCode, error.errorValue);
        } else
        if(method == "resetPasswordSendEmail") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT resetPasswordSendEmailAnswer(id, result.value<bool>());
            else Q_EMIT resetPasswordSendEmailError(id, error.errorCode, error.errorValue);
        } else
        if(method == "resetPassword") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT resetPasswordAnswer(id, result.value<bool>());
            else Q_EMIT resetPasswordError(id, error.errorCode, error.errorValue);
        } else
        if(method == "changePassword") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT changePasswordAnswer(id, result.value<bool>());
            else Q_EMIT changePasswordError(id, error.errorCode, error.errorValue);
        } else
        if(method == "trustPassword") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT trustPasswordAnswer(id, result.value<bool>());
            else Q_EMIT trustPasswordError(id, error.errorCode, error.errorValue);
        } else
        if(method == "isTrusted") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT isTrustedAnswer(id, result.value<bool>());
            else Q_EMIT isTrustedError(id, error.errorCode, error.errorValue);
        } else
        if(method == "signUp") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT signUpAnswer(id, result.value<bool>());
            else Q_EMIT signUpError(id, error.errorCode, error.errorValue);
        } else
        if(method == "logIn") {
            callBackCall<QString>(id, result.value<QString>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT logInAnswer(id, result.value<QString>());
            else Q_EMIT logInError(id, error.errorCode, error.errorValue);
        } else
        if(method == "logOut") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT logOutAnswer(id, result.value<bool>());
            else Q_EMIT logOutError(id, error.errorCode, error.errorValue);
        } else
        if(method == "activeSession") {
            callBackCall<bool>(id, result.value<bool>(), error);
            _calls.remove(id);
            if(error.null) Q_EMIT activeSessionAnswer(id, result.value<bool>());
            else Q_EMIT activeSessionError(id, error.errorCode, error.errorValue);
        } else
            Q_UNUSED(result);
        if(!error.null) Q_EMIT AsemanAbstractAgentClient::error(id, error.errorCode, error.errorValue);
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

