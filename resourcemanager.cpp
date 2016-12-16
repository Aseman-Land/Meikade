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

#include "resourcemanager.h"
#include "SimpleQtCryptor/simpleqtcryptor.h"

#include <QFile>
#include <QDataStream>
#include <QFileInfo>
#include <QUuid>
#include <QDebug>

class ResourceManagerPrivate
{
public:
    QFile file;
    QDataStream stream;
};

ResourceManager::ResourceManager(const QString &path, bool writeMode)
{
    p = new ResourceManagerPrivate;
    p->file.setFileName( path );
    p->file.open( writeMode? QFile::WriteOnly : QFile::ReadOnly );
    p->stream.setDevice( &(p->file) );
    p->stream.setVersion( QDataStream::Qt_5_0 );
}

void ResourceManager::addFile(const QString &filePath, const QString & password)
{
    QFile src( filePath );
    QFileInfo src_info( filePath );
    if( !src.open(QFile::ReadOnly) )
        return;

    QSharedPointer<SimpleQtCryptor::Key> gKey = QSharedPointer<SimpleQtCryptor::Key>(new SimpleQtCryptor::Key(password));
    SimpleQtCryptor::Encryptor enc( gKey, SimpleQtCryptor::SERPENT_32, SimpleQtCryptor::ModeCFB, SimpleQtCryptor::NoChecksum );

    p->stream << src.size();
    p->stream << src_info.fileName();

    QByteArray ar;
    QByteArray tmp;

    do {
        tmp = src.read(1024*1024);
        enc.encrypt( tmp, ar, tmp.isEmpty() ) ;

        p->stream << ar;
        ar.clear();
    } while( !tmp.isEmpty() );
}

QString ResourceManager::extractFile(const QString &filePath, const QString & password)
{
    QFile dest( filePath );
    if( !dest.open(QFile::WriteOnly) )
        return QString();

    QSharedPointer<SimpleQtCryptor::Key> gKey = QSharedPointer<SimpleQtCryptor::Key>(new SimpleQtCryptor::Key(password));
    SimpleQtCryptor::Decryptor dec( gKey, SimpleQtCryptor::SERPENT_32, SimpleQtCryptor::ModeCFB );

    qint64 size;
    p->stream >> size;
    if( !size )
    {
        dest.close();
        QFile::remove(filePath);
        return QString();
    }

    QString fileName;
    p->stream >> fileName;

    forever
    {
        qint64 rsize = (size >= 1024*1024)? 1024*1024 : size;

        QByteArray ar;
        QByteArray tmp;

        p->stream >> tmp;
        dec.decrypt( tmp, ar, size == 0 );

        dest.write( ar );

        if( size == 0 )
            break;
        else
            size -= rsize;
    }

    return fileName;
}

void ResourceManager::writeHead(const QString &password)
{
    p->file.reset();

    QSharedPointer<SimpleQtCryptor::Key> gKey = QSharedPointer<SimpleQtCryptor::Key>(new SimpleQtCryptor::Key(password));
    SimpleQtCryptor::Encryptor enc( gKey, SimpleQtCryptor::SERPENT_32, SimpleQtCryptor::ModeCFB, SimpleQtCryptor::NoChecksum );

    QByteArray enc_header_code;
    enc.encrypt( QUuid::createUuid().toByteArray(), enc_header_code, true );

    p->stream << enc_header_code;
}

bool ResourceManager::checkHead(const QString &password)
{
    p->file.reset();

    QSharedPointer<SimpleQtCryptor::Key> gKey = QSharedPointer<SimpleQtCryptor::Key>(new SimpleQtCryptor::Key(password));
    SimpleQtCryptor::Decryptor dec( gKey, SimpleQtCryptor::SERPENT_32, SimpleQtCryptor::ModeCFB );

    QByteArray enc_header_code;
    QByteArray enc_header_code_dec;
    p->stream >> enc_header_code;
    if( dec.decrypt(enc_header_code,enc_header_code_dec,true) == SimpleQtCryptor::ErrorInvalidKey )
        return false;
    else
        return true;
}

void ResourceManager::close()
{
    p->file.close();
}

qint64 ResourceManager::size()
{
    return p->file.size();
}

qint64 ResourceManager::currentPosition()
{
    return p->file.pos();
}

ResourceManager::~ResourceManager()
{
    delete p;
}
