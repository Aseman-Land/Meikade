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

#ifndef MEIKADEDATABASE_H
#define MEIKADEDATABASE_H

#include <QObject>

class ThreadedFileSystem;
class MeikadeDatabasePrivate;
class MeikadeDatabase : public QObject
{
    Q_OBJECT
public:
    MeikadeDatabase( ThreadedFileSystem *tfs, QObject *parent = 0);
    ~MeikadeDatabase();

    Q_INVOKABLE bool initialized() const;

signals:
    void initializeFinished();
    void extractProgress(int percent);
    void copyError();
    void poetsChanged();

public slots:
    void initialize();
    void refresh();

    QList<int> rootChilds() const;
    QList<int> childsOf( int id ) const;
    int parentOf( int id ) const;

    QString catName( int id );
    QList<int> catPoems(int cat);

    QString poemName( int id );
    int poemCat( int id );
    QString poemPhrase(int id);
    QList<int> poemVerses( int id );

    int catPoetId( int cat );
    QList<int> poets() const;
    QString poetDesctiption( int id );
    bool containsPoet(int id);

    QString verseText(int pid , int vid);
    int versePosition(int pid , int vid);

private:
    void init_buffer();
    void fetchPoem(int pid );

private slots:
    void initialize_prv(const QString & dst);

private:
    MeikadeDatabasePrivate *p;
};

#endif // MEIKADEDATABASE_H
