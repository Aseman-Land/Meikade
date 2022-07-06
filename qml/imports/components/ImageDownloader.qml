/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    AsemanQtTools is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    AsemanQtTools is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.9
import AsemanQml.Base 2.0
import AsemanQml.Network 2.0
import globals 1.0

AsemanObject {
    id: cimage

    property alias source: queueItem.source
    property alias header: queueItem.header
    property alias percent: queueItem.percent
    property alias ignoreSslErrors: queueItem.ignoreSslErrors
    readonly property string cachedSource: queueItem.result

    property string fileName: {
        if (source.length == 0)
            return "";
        var name = Tools.md5(source) + "." + Tools.fileSuffix(source)
        var dir = AsemanGlobals.cachePath
        Tools.mkDir(dir)
        return dir + name
    }

    FileDownloaderQueueItem {
        id: queueItem
        downloaderQueue: DownloaderQueue
        ignoreSslErrors: true
        fileName: {
            if(source.length == 0)
                return ""

            return cimage.fileName
        }
    }
}
