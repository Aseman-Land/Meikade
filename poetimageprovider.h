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

#ifndef POETIMAGEPROVIDER_H
#define POETIMAGEPROVIDER_H

#include <QObject>
#include <QUrl>

class PoetImageProviderPrivate;
class PoetImageProvider : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int poet READ poet WRITE setPoet NOTIFY poetChanged)
    Q_PROPERTY(QUrl path READ path NOTIFY pathChanged)

public:
    PoetImageProvider(QObject *parent = 0);
    virtual ~PoetImageProvider();

    void setPoet(int poet);
    int poet() const;

    QUrl path() const;

public Q_SLOTS:
    void refresh();

Q_SIGNALS:
    void poetChanged();
    void pathChanged();

private Q_SLOTS:
    void finished( const QByteArray & data );

private:
    PoetImageProviderPrivate *p;
};

#endif // POETIMAGEPROVIDER_H
