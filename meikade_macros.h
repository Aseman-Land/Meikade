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

#define DATA_DB_CONNECTION "data_sqlite"
#define THREADED_DATA_DB_CONNECTION "threaded_data_sqlite"
#define USERDATAS_DB_CONNECTION "userdata_sqlite"

#ifdef Q_OS_ANDROID
#define HOME_PATH QDir::homePath()
#define ANDROID_OLD_DB_PATH "/sdcard/NileGroup/Meikade/"
#define ANDROID_SDCARD1_DB_PATH "/storage/sdcard1/NileGroup/Meikade/"
#define BACKUP_PATH ANDROID_OLD_DB_PATH "/backups"
#define TEMP_PATH   HOME_PATH "/temp"
#define TRANSLATIONS_PATH QString("assets:/files/translations")
#else
#ifdef Q_OS_IOS
#define HOME_PATH QString(QStandardPaths::standardLocations(QStandardPaths::QStandardPaths::AppDataLocation).first() + "/configs/")
#define BACKUP_PATH QString(QStandardPaths::standardLocations(QStandardPaths::QStandardPaths::AppDataLocation).first() + "/backups/")
#define TEMP_PATH   QString(QStandardPaths::standardLocations(QStandardPaths::QStandardPaths::AppDataLocation).first() + "/tmp/")
#define TRANSLATIONS_PATH QString(QCoreApplication::applicationDirPath() + "/files/translations/")
#else
#ifdef Q_OS_WIN
#define HOME_PATH QString(QDir::homePath() + "/AppData/Local/NileGroup/meikade")
#define BACKUP_PATH QDir::homePath()
#define TEMP_PATH   QDir::tempPath()
#define TRANSLATIONS_PATH QString(QCoreApplication::applicationDirPath() + "/files/translations/")
#else
#define HOME_PATH QString(QDir::homePath() + "/.config/nilegroup/meikade")
#define BACKUP_PATH QDir::homePath()
#define TEMP_PATH   QDir::tempPath()
#define TRANSLATIONS_PATH QString(QCoreApplication::applicationDirPath() + "/files/translations/")
#endif
#endif
#endif

#define LOG_PATH QString(HOME_PATH+"/log")

#endif // MEIKADE_MACROS_H
