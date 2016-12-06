#include "poetscriptinstaller.h"
#include "p7zipextractor.h"
#include "asemantools/asemanapplication.h"
#include "meikade_macros.h"
#include "poetremover.h"

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

void PoetScriptInstaller::installFile(const QString &path, int poetId, const QDateTime &date, bool removeFile)
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

    install(file.readAll(), poetId, date);
    file.close();
    file.remove();

    QDir().rmdir(tmpDir);
    emit finished(false);
}

void PoetScriptInstaller::install(const QString &scr, int poetId, const QDateTime &date)
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

    PoetRemover::removePoetCat(p->db, poetId);

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

    QSqlQuery query(p->db);
    query.prepare("UPDATE poet SET lastUpdate=:date WHERE id=:id");
    query.bindValue(":id", poetId);
    query.bindValue(":date", date);
    int res = query.exec();
    if(!res)
        qDebug() << __PRETTY_FUNCTION__ << query.lastError().text();

    PoetRemover::vacuum(p->db);
}

PoetScriptInstaller::~PoetScriptInstaller()
{
    delete p;
}

