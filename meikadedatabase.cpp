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

#define CURRENT_DB_VERSION 4

#include "meikadedatabase.h"
#include "threadedfilesystem.h"
#include "meikade_macros.h"
#include "meikade.h"

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QFile>
#include <QFileDevice>
#include <QDir>
#include <QDebug>
#include <QThread>
#include <QStandardPaths>
#include <QCoreApplication>

const QString sort_string = QString::fromUtf8("اَُِبپتثجچحخدذرزژسشصضطظعغفقکگلمنوهی");

bool sortPersianString( const QString & a, const QString & b )
{
    for( int i=0; i<a.size() && i<b.size(); i++ )
    {
        const QChar & ca = a[i];
        const QChar & cb = b[i];

        const int ia = sort_string.indexOf(ca);
        const int ib = sort_string.indexOf(cb);

        if( ia != ib )
            return ia < ib;
    }

    return a.size() < b.size();
}

class MeikadeDatabasePrivate
{
public:
    QSqlDatabase db;
    QString src;

    QMultiHash<int,int> childs;
    QHash<int,int> parents;

    QHash<int, QHash<QString,QVariant> > cats;
    QHash<int, QHash<QString,QVariant> > poems_cache;
    QHash<int, QHash<QString,QVariant> > poets;

    QHash<int,int> cat_poets;
    QHash<QString, int> poets_cats;
    QList<int> sorted_poets;
    QSet<int> poets_set;

    ThreadedFileSystem *tfs;
    bool initialized;
    int databaseLocation;

    int fetchedPoem;
    QHash<int, QHash<QString,QVariant> > fetchedPoemData;
    QHash<QString,QVariant> values;

    static MeikadeDatabaseThreadedCopy *copy;
};

MeikadeDatabaseThreadedCopy *MeikadeDatabasePrivate::copy = 0;

MeikadeDatabase::MeikadeDatabase(ThreadedFileSystem *tfs, QObject *parent) :
    QObject(parent)
{
    p = new MeikadeDatabasePrivate;
    p->tfs = tfs;
    p->fetchedPoem = -1;
    p->databaseLocation = ApplicationMemoryDatabase;

    for(int i=ApplicationMemoryDatabase; i<=ExternalSdCardDatabase; i++)
    {
        QString path = databasePath(i);
        if(QFileInfo::exists(path))
            p->databaseLocation = static_cast<DatabaseLocation>(i);
    }

    const QString dbPath = databasePath();

#ifndef OLD_DATABASE
    p->initialized = true;
#ifdef Q_OS_ANDROID
    if(!QFileInfo::exists(ANDROID_OLD_DB_PATH "/data.sqlite"))
#endif
    {
        if(!QFileInfo::exists(databasePath()) )
#ifdef Q_OS_ANDROID
            QFile::copy("assets:/database/data.sqlite", dbPath);
#else
            QFile::copy(QCoreApplication::applicationDirPath() + "/database/data.sqlite", dbPath);
#endif
    }

    Meikade::settings()->setValue("initialize/data_db",true);
    QFile(dbPath).setPermissions(QFileDevice::ReadUser|QFileDevice::WriteUser|
                                 QFileDevice::ReadGroup|QFileDevice::WriteGroup);

    p->db = QSqlDatabase::addDatabase("QSQLITE",DATA_DB_CONNECTION);
    p->db.setDatabaseName(dbPath);
    if(!p->db.open())
        qDebug() << __PRETTY_FUNCTION__ << p->db.lastError().text();

    qDebug() << dbPath << p->db.lastError().text();

    init_buffer();
#else
    p->initialized = false;
    initialize();
#endif
}

void MeikadeDatabase::setDatabaseLocation(int dbLocation)
{
    if(p->databaseLocation == dbLocation)
        return;

    if(p->copy)
        return;

    QString src = databasePath(p->databaseLocation);
    QString dst = databasePath(dbLocation);
    if(src == dst)
        return;

    p->copy = new MeikadeDatabaseThreadedCopy();
    connect(p->copy, &MeikadeDatabaseThreadedCopy::copyFinished, this, [this, dbLocation](const QString &source, const QString &destination, bool result){
        if(!result) {
            p->copy->deleteLater();
            p->copy = 0;
            Q_EMIT copyingDatabaseChanged();
            return;
        }

        p->db.close();
        QFile::remove(source);
        p->databaseLocation = dbLocation;

        p->db.setDatabaseName(destination);
        p->db.open();
        init_buffer();

        p->copy->deleteLater();
        p->copy = 0;

        Q_EMIT copyingDatabaseChanged();
        Q_EMIT databaseLocationChanged();
    }, Qt::QueuedConnection);

    p->copy->copy(src, dst);
    Q_EMIT copyingDatabaseChanged();
}

int MeikadeDatabase::databaseLocation() const
{
    return p->databaseLocation;
}

QString MeikadeDatabase::databasePath() const
{
    return databasePath(p->databaseLocation);
}

QString MeikadeDatabase::databasePath(int dbLocation)
{
#ifdef Q_OS_ANDROID
    switch(static_cast<int>(dbLocation))
    {
    case ExternalSdCardDatabase:
        return ANDROID_SDCARD1_DB_PATH "/data.sqlite";
        break;

    default:
    case ApplicationMemoryDatabase:
    case InternalMemoryDatabase:
        if(QFileInfo::exists(ANDROID_OLD_DB_PATH "/data.sqlite"))
            return ANDROID_OLD_DB_PATH "/data.sqlite";
        else
            return HOME_PATH + "/data.sqlite";
        break;
    }
#else
    Q_UNUSED(dbLocation)
    if(dbLocation == ExternalSdCardDatabase)
        return "/home/bardia/data.sqlite";
    return HOME_PATH + "/data.sqlite";
#endif
}

bool MeikadeDatabase::copyingDatabase() const
{
    return p->copy;
}

bool MeikadeDatabase::initialized() const
{
    return p->initialized;
}

int MeikadeDatabase::count() const
{
    return p->poets.count();
}

bool MeikadeDatabase::containsHafez() const
{
    return p->poets.contains(9);
}

void MeikadeDatabase::initialize()
{
    const QString dbPath = databasePath();

#ifdef Q_OS_ANDROID
    p->src = "assets:/database/data/data";
    QDir().mkpath(ANDROID_OLD_DB_PATH);
#else
    p->src = "database/data/data";
#endif

    int db_version = Meikade::settings()->value("initialize/dataVersion",0).toInt();
    if( db_version < CURRENT_DB_VERSION || !QFileInfo(dbPath).exists() || QFileInfo(dbPath).size() < 105000000 )
    {
        QFile::remove(dbPath);

        connect( p->tfs, SIGNAL(extractProgress(int)), SIGNAL(extractProgress(int)), Qt::QueuedConnection );
        connect( p->tfs, SIGNAL(extractFinished(QString)), SLOT(initialize_prv(QString)), Qt::QueuedConnection );
        connect( p->tfs, SIGNAL(extractError()), SIGNAL(copyError()), Qt::QueuedConnection );
        p->tfs->extract(p->src,22,dbPath);
    }
    else
    {
        QMetaObject::invokeMethod( this, "initialize_prv", Qt::QueuedConnection, Q_ARG(QString,dbPath) );
        p->initialized = true;
    }
}

void MeikadeDatabase::refresh()
{
    init_buffer();
    emit poetsChanged();
}

void MeikadeDatabase::initialize_prv(const QString &dst)
{
    if( dst.isEmpty() )
        return;

    const QString dbPath = databasePath();

    disconnect( p->tfs, SIGNAL(extractProgress(int)), this, SIGNAL(extractProgress(int)) );
    disconnect( p->tfs, SIGNAL(extractFinished(QString)), this, SLOT(initialize_prv(QString)) );
    disconnect( p->tfs, SIGNAL(extractError()), this, SIGNAL(copyError()) );

    Meikade::settings()->setValue("initialize/dataVersion",CURRENT_DB_VERSION);
    QFile(dbPath).setPermissions(QFileDevice::ReadUser|QFileDevice::ReadGroup);

    p->db = QSqlDatabase::addDatabase("QSQLITE",DATA_DB_CONNECTION);
    p->db.setDatabaseName(dbPath);
    p->db.open();

    p->initialized = true;
    init_buffer();

    emit initializeFinished();
}

QList<int> MeikadeDatabase::rootChilds() const
{
    return childsOf(0);
}

QList<int> MeikadeDatabase::childsOf(int id) const
{
    QList<int> childs = p->childs.values(id);
    qSort( childs.begin(), childs.end() );
    return childs;
}

int MeikadeDatabase::parentOf(int id) const
{
    return p->parents.value(id);
}

QString MeikadeDatabase::catName(int id)
{
    return p->cats[id].value("text").toString();
}

QList<int> MeikadeDatabase::catPoems(int cat)
{
    QList<int> result;

    QSqlQuery query( p->db );
    query.prepare("SELECT id, title, url, cat_id FROM poem WHERE cat_id=:cat");
    query.bindValue(":cat",cat);
    query.exec();

    while( query.next() )
    {
        QSqlRecord record = query.record();
        int id = record.value(0).toInt();
        for( int i=0; i<record.count(); i++ )
            p->poems_cache[id].insert( record.fieldName(i), record.value(i) );

        result << id;
    }

    return result;
}

QString MeikadeDatabase::poemName(int id)
{
    if( !p->poems_cache.value(id).contains("title") )
    {
        QSqlQuery query( p->db );
        query.prepare("SELECT title FROM poem WHERE id=:id");
        query.bindValue(":id",id);
        query.exec();

        if( !query.next() )
            return 0;

        p->poems_cache[id]["title"] = query.record().value(0).toString();
    }

    return p->poems_cache[id].value("title").toString();
}

int MeikadeDatabase::poemCat(int id)
{
    if( !p->poems_cache.value(id).contains("cat_id") )
    {
        QSqlQuery query( p->db );
        query.prepare("SELECT cat_id FROM poem WHERE id=:id");
        query.bindValue(":id",id);
        query.exec();

        if( !query.next() )
            return 0;

        p->poems_cache[id]["cat_id"] = query.record().value(0).toInt();
    }

    return p->poems_cache[id].value("cat_id").toInt();
}

QString MeikadeDatabase::poemPhrase(int id)
{
    if(!p->db.isOpen())
        return QString();

    if( !p->poems_cache.value(id).contains("phrase") )
    {
        QSqlQuery query( p->db );
        query.prepare("SELECT phrase FROM poem WHERE id=:id");
        query.bindValue(":id",id);
        query.exec();

        if( !query.next() )
            return 0;

        p->poems_cache[id]["phrase"] = query.record().value(0).toString();
    }

    return p->poems_cache[id].value("phrase").toString();
}

QList<int> MeikadeDatabase::poemVerses(int id)
{
    QList<int> result;

    QSqlQuery query( p->db );
    query.prepare("SELECT vorder FROM verse WHERE poem_id=:id");
    query.bindValue(":id",id);
    query.exec();

    while( query.next() )
    {
        QSqlRecord record = query.record();
        result << record.value(0).toInt();
    }

    return result;
}

int MeikadeDatabase::catPoetId(int cat)
{
    return p->cat_poets.value(cat);
}

QList<int> MeikadeDatabase::poets() const
{
    return p->sorted_poets;
}

QString MeikadeDatabase::poetDesctiption(int id)
{
    return p->poets[id]["description"].toString();
}

int MeikadeDatabase::poetCat(int id)
{
    return p->cat_poets.key(id);
}

QDateTime MeikadeDatabase::poetLastUpdate(int id)
{
    return p->poets[id]["lastUpdate"].toDateTime();
}

bool MeikadeDatabase::containsPoet(int id)
{
    return p->poets_set.contains(id);
}

QString MeikadeDatabase::verseText(int pid, int vid)
{
    fetchPoem(pid);
    return p->fetchedPoemData[vid]["text"].toString();
}

int MeikadeDatabase::versePosition(int pid, int vid)
{
    fetchPoem(pid);
    return p->fetchedPoemData[vid]["position"].toInt();
}

QVariant MeikadeDatabase::value(const QString &key, const QVariant &defaultValue) const
{
    return p->values.value(key, defaultValue);
}

bool MeikadeDatabase::setValue(const QString &key, const QVariant &value)
{
    if(MeikadeDatabase::value(key) == value)
        return true;

    QSqlQuery query(p->db);
    query.prepare("INSERT OR REPLACE INTO General (key,value) "
                  "VALUES (:key, :value)");
    query.bindValue(":key", key);
    query.bindValue(":value", value);
    if(!query.exec())
    {
        qDebug() << __PRETTY_FUNCTION__ << query.lastError().text();
        return false;
    }

    p->values[key] = value;
    return true;
}

void MeikadeDatabase::init_buffer()
{
    p->childs.clear();
    p->cats.clear();
    p->parents.clear();
    p->poets_cats.clear();
    p->poets.clear();
    p->cat_poets.clear();
    p->poets_set.clear();
    p->values.clear();

    do {
        QSqlQuery generalQuery(p->db);
        generalQuery.prepare("SELECT * FROM General");
        if(!generalQuery.exec())
            qDebug() << __PRETTY_FUNCTION__ << generalQuery.lastError().text();
        else
        while(generalQuery.next())
        {
            QSqlRecord record = generalQuery.record();
            p->values[record.value("key").toString()] = record.value("value");
        }
    } while(checkUpdate());

    QSqlQuery cats_query( p->db );
    cats_query.prepare("SELECT id, parent_id, poet_id, text, url FROM cat");
    cats_query.exec();

    while( cats_query.next() )
    {
        QSqlRecord record = cats_query.record();

        int id = record.value(0).toInt();
        p->childs.insertMulti( record.value(1).toInt(), id );
        p->parents.insert( id, record.value(1).toInt() );

        for( int i=0; i<record.count(); i++ )
            p->cats[id].insert( record.fieldName(i), record.value(i) );
    }

    QSqlQuery poets_query( p->db );
    poets_query.prepare("SELECT id, name, cat_id, description, lastUpdate FROM poet");
    poets_query.exec();

    while( poets_query.next() )
    {
        QSqlRecord record = poets_query.record();

        int id = record.value(0).toInt();
        int cat = record.value(2).toInt();
        const QString & name = record.value(1).toString();

        p->cat_poets[cat] = id;
        p->poets_cats.insertMulti(name, cat);
        p->poets_set.insert(id);

        for( int i=0; i<record.count(); i++ )
            p->poets[cat][record.fieldName(i)] = record.value(i);
    }

    p->sorted_poets.clear();
    QStringList sort_tmp = p->poets_cats.keys();
    qStableSort( sort_tmp.begin(), sort_tmp.end(), sortPersianString );
    foreach( const QString & name, sort_tmp )
        p->sorted_poets << p->poets_cats.value(name);

    Q_EMIT countChanged();
}

void MeikadeDatabase::fetchPoem(int pid)
{
    if(p->fetchedPoem == pid)
        return;

    p->fetchedPoem = pid;
    p->fetchedPoemData.clear();

    QSqlQuery query(p->db);
    query.prepare("SELECT vorder, text, position FROM verse WHERE poem_id=:pid");
    query.bindValue(":pid",pid);
    query.exec();

    while( query.next() )
    {
        QSqlRecord record = query.record();
        int vorder = record.value("vorder").toInt();
        p->fetchedPoemData[vorder]["text"] = record.value("text").toString();
        p->fetchedPoemData[vorder]["position"] = record.value("position").toInt();
    }
}

bool MeikadeDatabase::checkUpdate()
{
    const int version = value("Database/version", 0).toString().toInt();
    int dyn_version = version;
    if(dyn_version == 0)
    {
        QStringList queries = QStringList()
                << "PRAGMA foreign_keys = 0"
                << "CREATE TABLE General (\"key\" TEXT PRIMARY KEY, value TEXT)"
                << "CREATE TABLE sqlitestudio_temp_table AS SELECT * FROM poet"
                << "DROP TABLE poet"
                << "CREATE TABLE poet (id INTEGER PRIMARY KEY NOT NULL, name NVARCHAR (20), cat_id INTEGER, description TEXT, lastUpdate DATETIME DEFAULT NULL)"
                << "INSERT INTO poet (id, name, cat_id, description) SELECT id, name, cat_id, description FROM sqlitestudio_temp_table"
                << "DROP TABLE sqlitestudio_temp_table"
                << "PRAGMA foreign_keys = 1";

        foreach(const QString &q, queries)
        {
            QSqlQuery query(p->db);
            query.prepare(q);
            if(!query.exec())
                qDebug() << __PRETTY_FUNCTION__ << query.lastError().text();
        }
        dyn_version = 1;
        qDebug() << QString("Database updated to the %1 version.").arg(dyn_version);
    }

    if(dyn_version != version)
    {
        setValue("Database/version", QString::number(dyn_version));
        return true;
    }
    else
        return false;
}

MeikadeDatabase::~MeikadeDatabase()
{
    delete p;
}
