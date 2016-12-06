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
#include <QFile>
#include <QThread>
#include <QDir>
#include <QVariant>
#include <QDateTime>

class ThreadedFileSystem;
class MeikadeDatabasePrivate;
class MeikadeDatabase : public QObject
{
    Q_OBJECT
    Q_ENUMS(DatabaseLocation)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(int containsHafez READ containsHafez NOTIFY countChanged)
    Q_PROPERTY(int databaseLocation READ databaseLocation WRITE setDatabaseLocation NOTIFY databaseLocationChanged)
    Q_PROPERTY(bool copyingDatabase READ copyingDatabase NOTIFY copyingDatabaseChanged)

public:
    enum DatabaseLocation {
        InternalMemoryDatabase,
        ApplicationMemoryDatabase,
        ExternalSdCardDatabase
    };

    MeikadeDatabase( ThreadedFileSystem *tfs, QObject *parent = 0);
    ~MeikadeDatabase();

    Q_INVOKABLE bool initialized() const;
    int count() const;
    bool containsHafez() const;

    void setDatabaseLocation(int dbLocation);
    int databaseLocation() const;

    QString databasePath() const;
    static QString databasePath(int dbLocation);

    bool copyingDatabase() const;

signals:
    void initializeFinished();
    void extractProgress(int percent);
    void copyError();
    void poetsChanged();
    void countChanged();
    void databaseLocationChanged();
    void copyingDatabaseChanged();

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
    int poetCat( int id );
    QDateTime poetLastUpdate( int id );
    bool containsPoet(int id);

    QString verseText(int pid , int vid);
    int versePosition(int pid , int vid);

    QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;
    bool setValue(const QString &key, const QVariant &value);

private:
    void init_buffer();
    void fetchPoem(int pid );
    bool checkUpdate();

private slots:
    void initialize_prv(const QString & dst);

private:
    MeikadeDatabasePrivate *p;
};


class MeikadeDatabaseThreadedCopy : public QThread
{
    Q_OBJECT
public:
    void copy(const QString &source, const QString &destination) {
        if(isRunning())
            return;

        _source = source;
        _destination = destination;
        start();
    }

signals:
    void copyFinished(const QString &source, const QString &destination, bool result);

protected:
    void run() {
        QString destPath = QFileInfo(_destination).dir().path();
        QDir().mkpath(destPath);
        bool result = QFile::copy(_source, _destination);
        Q_EMIT copyFinished(_source, _destination, result);
    }

private:
    QString _source;
    QString _destination;
};

#endif // MEIKADEDATABASE_H
