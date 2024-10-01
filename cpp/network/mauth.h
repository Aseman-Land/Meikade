#ifndef MAUTH_H
#define MAUTH_H

#include "mnetworkcore.h"

#include <QJSValue>

class MAuth : public MNetworkCore
{
    Q_OBJECT

public:
    MAuth(QObject *parent = nullptr);
    virtual ~MAuth();

public Q_SLOTS:
    void login(const QString &username, const QString &password, QObject *receiver, const QJSValue &callback);
    void signup(const QString &name, const QString &email, const QString &username, const QString &password, QObject *receiver, const QJSValue &callback);
    void logout(QObject *receiver, const QJSValue &callback);
    void checkAuthentication(const QString &username, QObject *receiver, const QJSValue &callback);
    void checkUsernameAvailibility(const QString &username, QObject *receiver, const QJSValue &callback);
    void initForgetPassword(const QString &username, QObject *receiver, const QJSValue &callback);
    void loginWithForgetPassword(const QString &token, const QString &code, QObject *receiver, const QJSValue &callback);

private:
};

#endif // MAUTH_H
