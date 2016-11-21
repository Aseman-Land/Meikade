#define THUMB_WEB_LINK QString("http://aseman.land/download/meikade/2/thumbs/%1.png").arg(p->poet)
#define THUMB_QRC_LINK QString(":/qml/Meikade/poets/%1.png").arg(p->poet)
#define THUMB_DNL_LINK QString(p->downloadPath+"/%1.png").arg(p->poet)
#define THUMB_DEFAULT QString(":/qml/Meikade/poets/default.png")

#include "poetimageprovider.h"
#include "asemantools/asemandownloader.h"
#include "asemantools/asemanapplication.h"
#include "meikade_macros.h"

#include <QPointer>
#include <QFileInfo>
#include <QDir>

class PoetImageProviderPrivate
{
public:
    int poet;
    QUrl path;
    QString downloadPath;

    QPointer<AsemanDownloader> downloader;
};

PoetImageProvider::PoetImageProvider(QObject *parent) :
    QObject(parent)
{
    p = new PoetImageProviderPrivate;
    p->poet = 0;
    p->downloadPath = HOME_PATH + "/thumbs/poets";

    QDir().mkpath(p->downloadPath);
}

void PoetImageProvider::setPoet(int poet)
{
    if(p->poet == poet)
        return;

    p->poet = poet;
    refresh();

    emit poetChanged();
}

int PoetImageProvider::poet() const
{
    return p->poet;
}

QUrl PoetImageProvider::path() const
{
    return p->path;
}

void PoetImageProvider::refresh()
{
    if(p->downloader)
        return;
    if(!p->poet)
        return;

    QUrl result;
    if(QFileInfo::exists(THUMB_QRC_LINK))
        result = "qrc" + THUMB_QRC_LINK;
    else
    if(QFileInfo::exists(THUMB_DNL_LINK))
        result = QUrl::fromLocalFile(THUMB_DNL_LINK);
    else
    {
        p->downloader = new AsemanDownloader(this);
        p->downloader->setPath(THUMB_WEB_LINK);
        p->downloader->setDestination(THUMB_DNL_LINK);

        connect(p->downloader, SIGNAL(finished(QByteArray)), SLOT(finished(QByteArray)));

        p->downloader->start();
        result = "qrc" + THUMB_DEFAULT;
    }

    p->path = result;
    emit pathChanged();
}

void PoetImageProvider::finished(const QByteArray &data)
{
    Q_UNUSED(data)

    if(p->downloader)
    {
        p->downloader->deleteLater();
        p->downloader = 0;
    }

    QUrl result;
    if(QFileInfo::exists(THUMB_DNL_LINK))
        result = QUrl::fromLocalFile(THUMB_DNL_LINK);
    else
        return;

    p->path = result;
    emit pathChanged();
}

PoetImageProvider::~PoetImageProvider()
{
    delete p;
}

