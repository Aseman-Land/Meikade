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

#ifndef MEIKADE_MACROS_H
#define MEIKADE_MACROS_H

#include <QtGlobal>
#include <QDir>
#include <QStandardPaths>

#include <asemanapplication.h>

#define DATA_DB_CONNECTION "data_sqlite"
#define THREADED_DATA_DB_CONNECTION "threaded_data_sqlite"
#define USERDATAS_DB_CONNECTION "userdata_sqlite"

#ifdef Q_OS_ANDROID
#define HOME_PATH AsemanApplication::homePath()
#define ANDROID_SDCARD1_DB_PATH "/storage/sdcard1/NileGroup/Meikade/"
#define BACKUP_PATH "/sdcard/NileGroup/Meikade/backups"
#define TEMP_PATH HOME_PATH + "/temp"
#define TRANSLATIONS_PATH QString("assets:/files/translations")
#else
#ifdef Q_OS_IOS
#define HOME_PATH QString(AsemanApplication::homePath() + "/configs/")
#define BACKUP_PATH QString(AsemanApplication::homePath() + "/backups/")
#define TEMP_PATH   QString(AsemanApplication::homePath() + "/tmp/")
#define TRANSLATIONS_PATH QString(QCoreApplication::applicationDirPath() + "/files/translations/")
#else
#ifdef Q_OS_WIN
#define HOME_PATH AsemanApplication::homePath()
#define BACKUP_PATH AsemanApplication::homePath()
#define TEMP_PATH   QDir::tempPath()
#define TRANSLATIONS_PATH QString(QCoreApplication::applicationDirPath() + "/files/translations/")
#else
#define HOME_PATH AsemanApplication::homePath()
#define BACKUP_PATH AsemanApplication::homePath()
#define TEMP_PATH   QDir::tempPath()
#define TRANSLATIONS_PATH QString(QCoreApplication::applicationDirPath() + "/files/translations/")
#endif
#endif
#endif

#define LOG_PATH QString(HOME_PATH+"/log")

#endif // MEIKADE_MACROS_H
