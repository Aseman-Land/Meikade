#ifndef STICKERWRITER_H
#define STICKERWRITER_H

#include <QObject>
#include <QQuickItem>

class StickerWriterPrivate;
class StickerWriter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQuickItem* item READ item WRITE setItem NOTIFY itemChanged)

public:
    StickerWriter(QObject *parent = 0);
    ~StickerWriter();

    void setItem(QQuickItem *item);
    QQuickItem *item() const;

public slots:
    void save(const QString &dest, const QSize &size);

signals:
    void itemChanged();
    void saved(const QString &dest);
    void failed();

private slots:
    void ready();

private:
    StickerWriterPrivate *p;
};

#endif // STICKERWRITER_H
