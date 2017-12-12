/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    Meikade is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Meikade is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#define THUMB_WEB_LINK QString("http://aseman.land/download/meikade/2/thumbs/%1.png").arg(p->poet)
#define THUMB_QRC_LINK QString(":/qml/Meikade/poets/%1.png").arg(p->poet)
#define THUMB_DNL_LINK QString(p->downloadPath+"/%1.png").arg(p->poet)
#define THUMB_DEFAULT QString(":/qml/Meikade/poets/default.png")

#include "poetimageprovider.h"
#include "meikade_macros.h"
#include "aseman/asemandownloader.h"
#include "meikade.h"

#include <QPointer>
#include <QFileInfo>
#include <QDir>
#include <QFileInfo>

class PoetImageProviderPrivate
{
public:
    int poet;
    QUrl path;
    QString downloadPath;
    QString downloadPath_new;

    QPointer<AsemanDownloader> downloader;
};

PoetImageProvider::PoetImageProvider(QObject *parent) :
    QObject(parent)
{
    p = new PoetImageProviderPrivate;
    p->poet = 0;
    p->downloadPath = HOME_PATH + "/thumbs/poets";
    p->downloadPath_new = Meikade::instance()->thumbsPath();

    QDir().mkpath(p->downloadPath);
    QDir().mkpath(p->downloadPath_new);
}

void PoetImageProvider::setPoet(int poet)
{
    if(p->poet == poet)
        return;

    p->poet = poet;
    refresh();

    Q_EMIT poetChanged();
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
    p->path = QUrl::fromLocalFile(p->downloadPath_new + "/" + QString::number(p->poet) + ".png");
    if(!QFileInfo::exists(p->path.toLocalFile()))
    {
        p->path = QUrl::fromLocalFile(p->downloadPath + "/" + QString::number(p->poet) + ".png");
        if(!QFileInfo::exists(p->path.toLocalFile()))
            p->path.clear();
    }

    Q_EMIT pathChanged();
}

PoetImageProvider::~PoetImageProvider()
{
    delete p;
}
