#ifndef ASEMANABSTRACTCLIENTSOCKET_H
#define ASEMANABSTRACTCLIENTSOCKET_H

#ifdef Q_OS_WIN
#define LOCALFILE_PRE__PATH QString("file:///")
#else
#define LOCALFILE_PRE__PATH QString("file://")
#endif

#include <QObject>
#include <QDateTime>
#include <QStringList>
#include <QTcpSocket>
#include <QVariant>
#include <QUrl>
#include <QFile>
#include <QSslSocket>

#include <functional>

#include "asemanclientlib_global.h"

class ASEMANCLIENTLIBSHARED_EXPORT AsemanAbstractClientSocket : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString hostAddress READ hostAddress WRITE setHostAddress NOTIFY hostAddressChanged)
    Q_PROPERTY(qint32 port READ port WRITE setPort NOTIFY portChanged)
    Q_PROPERTY(QUrl certificate READ certificate WRITE setCertificate NOTIFY certificateChanged)
    Q_PROPERTY(bool ssl READ ssl WRITE setSsl NOTIFY sslChanged)
    Q_PROPERTY(bool autoTrust READ autoTrust WRITE setAutoTrust NOTIFY autoTrustChanged)

public:
    AsemanAbstractClientSocket(QObject *parent = Q_NULLPTR);
    ~AsemanAbstractClientSocket();

    class CallbackError {
    public:
        CallbackError() : errorCode(0), null(true) {}
        qint32 errorCode;
        QVariant errorValue;
        bool null;
    };

    void setHostAddress(const QString &hostAddress) {
        if(hostAddress == _hostAddress)
            return;

        _hostAddress = hostAddress;
        reconnect();
        Q_EMIT hostAddressChanged();
    }
    QString hostAddress() const { return _hostAddress; }

    void setCertificate(const QUrl &certificate) {
        if(certificate == _certificate)
            return;

        _certificate = certificate;

        QString res = _certificate.toLocalFile();
        if(res.isEmpty())
            res = _certificate.toString();
        if(res.left(5) == "qrc:/")
            res.remove(0, 3);
        int idx1 = res.indexOf(":/");
        if(idx1 != -1)
        {
            int idx2 = res.lastIndexOf(":/");
            if(idx2 != -1)
                res.remove(idx1, idx2-idx1);
        }
        if(res.left(LOCALFILE_PRE__PATH.size()) == LOCALFILE_PRE__PATH)
            res = res.mid(LOCALFILE_PRE__PATH.size());

        if(!res.isEmpty())
        {
            QFile file(res);
            file.open(QFile::ReadOnly);

            QSslSocket::addDefaultCaCertificate( QSslCertificate(file.readAll()) );
        }

        initSocket();
        Q_EMIT certificateChanged();
    }
    QUrl certificate() const { return _certificate; }

    void setSsl(bool ssl) {
        if(_ssl == ssl)
            return;

        _ssl = ssl;
        initSocket();
        Q_EMIT sslChanged();
    }
    bool ssl() const { return _ssl; }

    void setPort(qint32 port) {
        if(_port == port)
            return;

        _port = port;
        reconnect();
        Q_EMIT portChanged();
    }
    qint32 port() const { return _port; }

    void setAutoTrust(bool autoTrust) {
        if(_autoTrust == autoTrust)
            return;

        _autoTrust = autoTrust;
        Q_EMIT autoTrustChanged();
    }

    bool autoTrust() const { return _autoTrust; }

Q_SIGNALS:
    void hostAddressChanged();
    void certificateChanged();
    void sslChanged();
    void portChanged();
    void autoTrustChanged();
    void connected();
    void answer(qint64 id, const QVariant &result);
    void error(qint64 id, const CallbackError &result);
    void error(const QString &text);
    void signalEmitted(const QString &signalName, const QVariantList &args);

public Q_SLOTS:
    virtual void wake() {}
    virtual void sleep() {}
    virtual qint64 pushRequest(const QString &service, int version, const QString &method, const QVariantList &args) {
        Q_UNUSED(service)
        Q_UNUSED(version)
        Q_UNUSED(method)
        Q_UNUSED(args)
        return 0;
    }

protected:
    virtual void reconnect() {}
    virtual void initSocket() {}

private:
    QString _hostAddress;
    QUrl _certificate;
    bool _ssl;
    qint32 _port;
    bool _autoTrust;
};

#endif // ASEMANABSTRACTCLIENTSOCKET_H
