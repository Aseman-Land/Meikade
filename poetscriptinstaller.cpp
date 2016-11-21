#include "poetscriptinstaller.h"
#include "p7zipextractor.h"
#include "asemantools/asemanapplication.h"
#include "meikade_macros.h"

#include <QDir>
#include <QUuid>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QSqlRecord>
#include <QThread>
#include <QDebug>

class PoetScriptInstallerPrivate
{
public:
    P7ZipExtractor *p7zip;
    QSqlDatabase db;
    QString path;
};

PoetScriptInstaller::PoetScriptInstaller(QObject *parent) :
    QObject(parent)
{
    p = new PoetScriptInstallerPrivate;
    p->p7zip = 0;

#ifdef Q_OS_ANDROID
    p->path = ANDROID_OLD_DB_PATH "/data.sqlite";
    if(!QFileInfo::exists(p->path))
        p->path = HOME_PATH + "/data.sqlite";
#else
    p->path = HOME_PATH + "/data.sqlite";
#endif
}

void PoetScriptInstaller::installFile(const QString &path, bool removeFile)
{
    if(!p->p7zip)
        p->p7zip = new P7ZipExtractor(this);

    const QString &tmp = AsemanApplication::tempPath();
    const QString tmpDir = tmp + "/" + QUuid::createUuid().toString();

    p->p7zip->extract(path, tmpDir);
    if(removeFile)
        QFile::remove(path);

    QFile file(tmpDir + "/script.sql");
    if(!file.open(QFile::ReadOnly))
    {
        emit finished(true);
        file.remove();
        return;
    }

    install(file.readAll());
    file.close();
    file.remove();

    QDir().rmdir(tmpDir);
    emit finished(false);
}

void PoetScriptInstaller::install(const QString &scr)
{
    QString script = QString(scr).replace("\r\n", "\n");
    QFile(p->path).setPermissions(QFileDevice::ReadUser|QFileDevice::WriteUser|
                                  QFileDevice::ReadGroup|QFileDevice::WriteGroup);

    if(!p->db.isOpen())
    {
        p->db = QSqlDatabase::addDatabase("QSQLITE", QUuid::createUuid().toString());
        p->db.setDatabaseName(p->path);
        p->db.open();
    }

    int pos = 0;
    int from = 0;
    while( (pos=script.indexOf(";\n", from)) != -1 )
    {
        const QString &scr = script.mid(from, pos-from);

        QSqlQuery query(p->db);
        query.prepare(scr);
        int res = query.exec();
        if(!res)
            qDebug() << __PRETTY_FUNCTION__ << query.lastError().text();

        from = pos+2;
    }
}

void PoetScriptInstaller::removePoet(int poet_id )
{
    QSqlQuery begin(p->db);
    begin.prepare("BEGIN");
    begin.exec();

    QSqlQuery query(p->db);
    query.prepare("SELECT id FROM cat WHERE poet_id=:pid");
    query.bindValue(":pid", poet_id);
    query.exec();

    while( query.next() )
    {
        int id = query.record().value(0).toInt();
        removeCatChild(id);
    }

    removePoem(poet_id);

    QSqlQuery delete_cat_query(p->db);
    delete_cat_query.prepare("DELETE FROM cat WHERE poet_id=:pid");
    delete_cat_query.bindValue(":pid", poet_id);
    delete_cat_query.exec();

    QSqlQuery delete_poet_query(p->db);
    delete_poet_query.prepare("DELETE FROM poet WHERE id=:id");
    delete_poet_query.bindValue(":id", poet_id);
    delete_poet_query.exec();

    QSqlQuery commit(p->db);
    commit.prepare("COMMIT");
    commit.exec();
}

void PoetScriptInstaller::removePoem(int poet_id)
{
    QSqlQuery delete_verse_query(p->db);
    delete_verse_query.prepare("DELETE FROM verse WHERE poet=:pid");
    delete_verse_query.bindValue(":pid", poet_id);
    delete_verse_query.exec();
}

void PoetScriptInstaller::removeCatChild(int parent_id)
{
    QSqlQuery query(p->db);
    query.prepare("SELECT id FROM cat WHERE parent_id=:pid");
    query.bindValue(":pid", parent_id);
    query.exec();

    while( query.next() )
    {
        int id = query.record().value(0).toInt();
        removeCatChild(id);
    }

    QSqlQuery delete_poem_query(p->db);
    delete_poem_query.prepare("DELETE FROM poem WHERE cat_id=:cid");
    delete_poem_query.bindValue(":cid", parent_id);
    delete_poem_query.exec();

    QSqlQuery delete_cat_query(p->db);
    delete_cat_query.prepare("DELETE FROM cat WHERE parent_id=:pid");
    delete_cat_query.bindValue(":pid", parent_id);
    delete_cat_query.exec();
}

PoetScriptInstaller::~PoetScriptInstaller()
{
    delete p;
}

