/*
    Copyright (C) 2015 Nile Group
    http://nilegroup.org

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

#ifndef RESOURCEMANAGER_H
#define RESOURCEMANAGER_H

#include <QString>

class ResourceManagerPrivate;
class ResourceManager
{
public:
    ResourceManager(const QString & path, bool writeMode = false );
    ~ResourceManager();

    void addFile(const QString & filePath , const QString &password = QString());
    QString extractFile(const QString & filePath , const QString &password = QString());

    void writeHead( const QString & password = QString() );
    bool checkHead( const QString & password = QString() );

    void close();

    qint64 size();
    qint64 currentPosition();

private:
    ResourceManagerPrivate *p;
};

#endif // RESOURCEMANAGER_H
