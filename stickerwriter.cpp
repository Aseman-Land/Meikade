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

#include "stickerwriter.h"

#include <QPointer>
#include <QQuickItemGrabResult>
#include <QImageWriter>
#include <QDir>
#include <QUuid>

class StickerWriterPrivate
{
public:
    QPointer<QQuickItem> item;
    QSharedPointer<QQuickItemGrabResult> result;
    QString dest;
};

StickerWriter::StickerWriter(QObject *parent) :
    QObject(parent)
{
    p = new StickerWriterPrivate;
}

void StickerWriter::setItem(QQuickItem *item)
{
    if(p->item == item)
        return;

    p->item = item;
    Q_EMIT itemChanged();
}

QQuickItem *StickerWriter::item() const
{
    return p->item;
}

void StickerWriter::save(const QString &dest, const QSize &size)
{
    if(!p->item)
    {
        Q_EMIT failed();
        return;
    }

    p->result = p->item->grabToImage(size);
    if(!p->result)
    {
        Q_EMIT failed();
        return;
    }

    connect(p->result.data(), SIGNAL(ready()), this, SLOT(ready()));

    QDir().mkpath(dest);
    p->dest = dest + "/" + QUuid::createUuid().toString().remove("{").remove("}") + ".png";
}

void StickerWriter::ready()
{
    disconnect(p->result.data(), SIGNAL(ready()), this, SLOT(ready()));

    const QImage & img = p->result->image();

    QImageWriter writer(p->dest);
    writer.write(img);

    Q_EMIT saved(p->dest);
}

StickerWriter::~StickerWriter()
{
    delete p;
}
