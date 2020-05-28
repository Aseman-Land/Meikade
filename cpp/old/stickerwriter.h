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
    virtual ~StickerWriter();

    void setItem(QQuickItem *item);
    QQuickItem *item() const;

public Q_SLOTS:
    void save(const QString &dest, const QSize &size);

Q_SIGNALS:
    void itemChanged();
    void saved(const QString &dest);
    void failed();

private Q_SLOTS:
    void ready();

private:
    StickerWriterPrivate *p;
};

#endif // STICKERWRITER_H
