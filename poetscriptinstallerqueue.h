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

#ifndef POETSCRIPTINSTALLERQUEUE_H
#define POETSCRIPTINSTALLERQUEUE_H

#include <QObject>
#include <QDateTime>

class PoetScriptInstallerQueuePrivate;
class PoetScriptInstallerQueue : public QObject
{
    Q_OBJECT
public:
    PoetScriptInstallerQueue(QObject *parent = 0);
    ~PoetScriptInstallerQueue();

    bool isActive();

public slots:
    void append(const QString &file, const QString &guid, int poetId, const QDateTime &date);
    void remove(const QString &guid, int poetId);

signals:
    void error(const QString &file, const QString &guid);
    void finished(const QString &file, const QString &guid);
    void removed(const QString &guid);
    void removeError(const QString &guid);

private slots:
    void finishedSlt(bool error);

private:
    void next();
    void init_core();

private:
    PoetScriptInstallerQueuePrivate *p;
};

#endif // POETSCRIPTINSTALLERQUEUE_H
