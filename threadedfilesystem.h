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

#ifndef THREADEDFILESYSTEM_H
#define THREADEDFILESYSTEM_H

#include <QObject>

class ThreadedFileSystemPrivate;
class ThreadedFileSystem : public QObject
{
    Q_OBJECT
public:
    ThreadedFileSystem(QObject *parent = 0);
    virtual ~ThreadedFileSystem();

public Q_SLOTS:
    void copy( const QString & src, const QString & dst );
    void extract( const QString & src, int counter, const QString & dst );

Q_SIGNALS:
    void copyFinished( const QString & dst );
    void copyError();

    void extractFinished( const QString & dst );
    void extractError();

    void extractProgress( int percent );

private Q_SLOTS:
    void copy_prv( const QString & src, const QString & dst );
    void extract_prv( const QString & src, int counter, const QString & dst );

private:
    ThreadedFileSystemPrivate *p;
};

#endif // THREADEDFILESYSTEM_H
