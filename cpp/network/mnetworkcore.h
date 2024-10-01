#ifndef MNETWORKCORE_H
#define MNETWORKCORE_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QJsonDocument>

class MNetworkCore : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged FINAL)
    Q_PROPERTY(QString error READ error NOTIFY errorChanged FINAL)
    Q_PROPERTY(QString authenticationToken READ authenticationToken WRITE setAuthenticationToken NOTIFY authenticationTokenChanged FINAL)

public:
    enum Method {
        GET,
        POST,
        PATCH,
        PUT,
        DELETE_METHOD,
    };

    MNetworkCore(QObject *parent = nullptr);
    virtual ~MNetworkCore();

    bool loading() const;
    QString error() const;

    QString authenticationToken() const;
    void setAuthenticationToken(const QString &newAuthenticationToken);

Q_SIGNALS:
    void loadingChanged();
    void errorChanged();
    void authenticationTokenChanged();

protected:
    typedef std::function<void(const QVariant &result, bool error)> Callback;

    void doRequest(Method method, const QString &path, const QMap<QString, QString> &queryList, const QVariantMap &postData, QObject *receiver, Callback callback) {
        doRequest(method, path, queryList, QJsonDocument::fromVariant(postData), receiver, callback);
    }

    void doRequest(Method method, const QString &path, const QMap<QString, QString> &queryList, const QJsonDocument &json, QObject *receiver, Callback callback);
    void setError(const QString &newError);

private:
    QNetworkAccessManager *mAm = nullptr;
    QString mAuthenticationToken;

    QSet<QNetworkReply*> mReplies;
    QString mError;
};

#endif // MNETWORKCORE_H
