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

#ifndef USERDATA_H
#define USERDATA_H

#include <QObject>
#include <QStringList>

class UserDataPrivates;
class UserData : public QObject
{
    Q_OBJECT
public:
    UserData(QObject *parent = 0);
    ~UserData();

public slots:
    void favorite( int pid, int vid );
    void unfavorite( int pid, int vid );
    bool isFavorited( int pid, int vid );
    QStringList favorites();

    void setNote( int pid, int vid, const QString & note );
    QString note( int pid, int vid );
    QStringList notes();

    int extractPoemIdFromStringId( const QString & str_id );
    int extractVerseIdFromStringId( const QString & str_id );

    void disconnect();
    void reconnect();

signals:
    void favorited( int pid, int vid );
    void unfavorited( int pid, int vid );
    void noteChanged( int pid, int vid );

private:
    UserDataPrivates *p;
};

#endif // USERDATA_H
