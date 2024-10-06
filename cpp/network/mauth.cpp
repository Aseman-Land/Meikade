#include "mauth.h"

MAuth::MAuth(QObject *parent)
    : MNetworkCore{parent}
{
}

MAuth::~MAuth()
{
}

void MAuth::login(const QString &username, const QString &password, QObject *receiver, const QJSValue &callback)
{
    doRequest(Method::GET, "/auth/login", {}, {{"username", username}, {"password", password}}, receiver, [this, callback](const QVariant &json, bool hasError){
        if (!callback.isCallable())
            return;

        QJSValueList list;
        list << json.toMap().value("token").toString();
        list << hasError;

        QJSValue(callback).call(list);
    });
}

void MAuth::signup(const QString &name, const QString &email, const QString &username, const QString &password, QObject *receiver, const QJSValue &callback)
{

}

void MAuth::logout(QObject *receiver, const QJSValue &callback)
{

}

void MAuth::checkAuthentication(const QString &username, QObject *receiver, const QJSValue &callback)
{

}

void MAuth::checkUsernameAvailibility(const QString &username, QObject *receiver, const QJSValue &callback)
{

}

void MAuth::initForgetPassword(const QString &username, QObject *receiver, const QJSValue &callback)
{

}

void MAuth::loginWithForgetPassword(const QString &token, const QString &code, QObject *receiver, const QJSValue &callback)
{

}
