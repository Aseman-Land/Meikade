#include "mnetworkcore.h"

#include <QUrlQuery>
#include <QNetworkReply>
#include <QPointer>
#include <QJsonObject>
#include <QJsonArray>

MNetworkCore::MNetworkCore(QObject *parent)
    : QObject{parent}
{}

MNetworkCore::~MNetworkCore()
{

}

bool MNetworkCore::loading() const
{
    return !mReplies.isEmpty();
}

QString MNetworkCore::error() const
{
    return mError;
}

void MNetworkCore::doRequest(Method method, const QString &path, const QMap<QString, QString> &queryMap, const QJsonDocument &json, QObject *receiver, Callback callback)
{
    QUrlQuery query;
    for (const auto &[k,v]: queryMap.toStdMap())
        query.addQueryItem(k, v);

    QUrl url(QStringLiteral("https://api.meikade.com/api/") + path);
    url.setQuery(query);

    QNetworkRequest req;
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
    req.setUrl(url);

    if (!mAuthenticationToken.isEmpty())
        req.setRawHeader("User-token", mAuthenticationToken.toUtf8());

    if (!mAm)
        mAm = new QNetworkAccessManager(this);

    QByteArray data;
    if (!json.isNull())
        data = json.toJson(QJsonDocument::Compact);

    QNetworkReply *reply = nullptr;
    switch (static_cast<int>(method))
    {
    case Method::GET:
        reply = mAm->get(req);
        break;

    case Method::PATCH:
        reply = mAm->sendCustomRequest(req, "PATCH", data);
        break;

    case Method::POST:
        reply = mAm->post(req, data);
        break;

    case Method::PUT:
        reply = mAm->put(req, data);
        break;

    case Method::DELETE_METHOD:
        reply = mAm->deleteResource(req);
        break;

    default:
        if (mReplies.isEmpty())
        {
            mAm->deleteLater();
            mAm = nullptr;
        }
        return;
    }

    QPointer<QObject> receiverObj = receiver;
    connect(reply, &QNetworkReply::finished, this, [reply, this, receiverObj, callback](){
        const auto data = reply->readAll();
        const auto statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toString().toInt();
        const bool hasError = (statusCode % 100 != 2);
        const auto jsonRoot = QJsonDocument::fromJson(data).toVariant().toMap();
        if (hasError)
        {
            if (!jsonRoot.isEmpty())
                setError( jsonRoot.value("message").toString() );
            else
                setError( reply->errorString() );
        }
        if (callback && receiverObj)
            callback(jsonRoot.value("result"), hasError);

        reply->deleteLater();
        mReplies.remove(reply);
        if (mReplies.isEmpty())
        {
            mAm->deleteLater();
            mAm = nullptr;
            Q_EMIT loadingChanged();
        }
    });

    mReplies.insert(reply);
    if (mReplies.count() == 1)
        Q_EMIT loadingChanged();
}

void MNetworkCore::setError(const QString &newError)
{
    if (mError == newError)
        return;
    mError = newError;
    Q_EMIT errorChanged();
}

QString MNetworkCore::authenticationToken() const
{
    return mAuthenticationToken;
}

void MNetworkCore::setAuthenticationToken(const QString &newAuthenticationToken)
{
    if (mAuthenticationToken == newAuthenticationToken)
        return;
    mAuthenticationToken = newAuthenticationToken;
    Q_EMIT authenticationTokenChanged();
}
