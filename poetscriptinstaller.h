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

#ifndef POETSCRIPTINSTALLER_H
#define POETSCRIPTINSTALLER_H

#include <QDateTime>
#include <QObject>

class PoetScriptInstallerPrivate;
class PoetScriptInstaller : public QObject
{
    Q_OBJECT
public:
    PoetScriptInstaller(QObject *parent = 0);
    virtual ~PoetScriptInstaller();

public Q_SLOTS:
    void installFile(const QString &path, int poetId, const QDateTime &date, bool removeFile = true);
    void install(const QString &script, int poetId, const QDateTime &date);
    void remove(int poetId);

Q_SIGNALS:
    void finished(int poetId, bool installed, const QString &error);

private:
    void initDb();

private:
    PoetScriptInstallerPrivate *p;
};

#endif // POETSCRIPTINSTALLER_H
