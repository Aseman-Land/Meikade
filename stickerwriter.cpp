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
    emit itemChanged();
}

QQuickItem *StickerWriter::item() const
{
    return p->item;
}

void StickerWriter::save(const QString &dest, const QSize &size)
{
    if(!p->item)
    {
        emit failed();
        return;
    }

    p->result = p->item->grabToImage(size);
    if(!p->result)
    {
        emit failed();
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

    emit saved(p->dest);
}

StickerWriter::~StickerWriter()
{
    delete p;
}

