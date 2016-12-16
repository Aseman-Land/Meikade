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

#include "p7zipextractor.h"

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#else
#include <QProcess>
#include <QCoreApplication>
#include <QDir>
#endif

#ifndef Q_OS_ANDROID
#ifdef Q_OS_WIN
#define COMMAND_NAME "7z.exe"
#else
#define COMMAND_NAME "7z"
#endif
#define COMMAND (QDir(QCoreApplication::applicationDirPath()).entryList(QDir::Files).contains(COMMAND_NAME)? QCoreApplication::applicationDirPath() + "/" + COMMAND_NAME : COMMAND_NAME)
#endif

class P7ZipExtractorPrivate
{
public:
#ifdef Q_OS_ANDROID
    QAndroidJniObject object;
    QAndroidJniEnvironment env;
#endif
};

P7ZipExtractor::P7ZipExtractor(QObject *parent) :
    QObject(parent)
{
    p = new P7ZipExtractorPrivate;
#ifdef Q_OS_ANDROID
    p->object = QAndroidJniObject("SevenZip/J7zip");
#endif
}

void P7ZipExtractor::extract(const QString &path, const QString & dest)
{
#ifdef Q_OS_ANDROID
    jstring jpath = p->env->NewString(reinterpret_cast<const jchar*>(path.constData()), path.length());
    jstring jdest = p->env->NewString(reinterpret_cast<const jchar*>(dest.constData()), dest.length());
    p->object.callMethod<jboolean>("extract", "(Ljava/lang/String;Ljava/lang/String;)Z", jpath, jdest );
#else
    QStringList args;
    args << "x";
    args << "-y";
    args << path;
    args << "-o" + dest;

    QProcess prc;
    prc.start(COMMAND, args);
    prc.waitForReadyRead();
    prc.waitForFinished();
#endif
}

P7ZipExtractor::~P7ZipExtractor()
{
    delete p;
}
