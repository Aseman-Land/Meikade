/*
    Copyright (C) 2014 Aseman Labs
    http://labs.aseman.org

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

#include "listobject.h"

#include <QVariantList>
#include <QDebug>

class ListObjectPrivate
{
public:
    QVariantList list;
};

ListObject::ListObject(QObject *parent) :
    QObject(parent)
{
    p = new ListObjectPrivate;
}

void ListObject::removeAll(const QVariant &v)
{
    p->list.removeAll( v );
    emit countChanged();
}

void ListObject::removeOne(const QVariant &v)
{
    p->list.removeOne( v );
    emit countChanged();
}

void ListObject::removeAt(int index)
{
    p->list.removeAt( index );
    emit countChanged();
}

QVariant ListObject::takeLast()
{
    if( p->list.isEmpty() )
        return QVariant();

    const QVariant & res = p->list.takeLast();
    emit countChanged();

    return res;
}

QVariant ListObject::takeFirst()
{
    if( p->list.isEmpty() )
        return QVariant();

    const QVariant & res = p->list.takeFirst();
    emit countChanged();

    return res;
}

QVariant ListObject::takeAt(int index)
{
    const QVariant & res = p->list.takeAt( index );
    emit countChanged();

    return res;
}

QVariant ListObject::last() const
{
    if( p->list.isEmpty() )
        return QVariant();

    return p->list.last();
}

QVariant ListObject::first() const
{
    if( p->list.isEmpty() )
        return QVariant();

    return p->list.first();
}

void ListObject::insert(int index, const QVariant &v)
{
    p->list.insert( index, v );
    emit countChanged();
}

void ListObject::append(const QVariant &v)
{
    p->list.append( v );
    emit countChanged();
}

void ListObject::prepend(const QVariant &v)
{
    p->list.prepend( v );
    emit countChanged();
}

int ListObject::count() const
{
    return p->list.count();
}

bool ListObject::isEmpty() const
{
    return p->list.isEmpty();
}

QVariant ListObject::at(int index) const
{
    return p->list.at(index);
}

int ListObject::indexOf(const QVariant &v) const
{
    return p->list.indexOf(v);
}

void ListObject::fromList(const QVariantList &list)
{
    p->list = list;
}

QVariantList ListObject::toList() const
{
    return p->list;
}

bool ListObject::contains(const QVariant &v) const
{
    return p->list.contains(v);
}

ListObject::~ListObject()
{
    delete p;
}
