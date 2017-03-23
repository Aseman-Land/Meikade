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

import QtQuick 2.0
import AsemanTools 1.1
import Meikade 1.0
import QtQuick.Controls 2.1 as QtControls
import QtQuick.Controls.Material 2.1
import "globals"
import "."

AsemanWindow {
    width: 1024
    height: 680
    visible: true

    Material.theme: Meikade.nightTheme? Material.Dark : Material.Light

    Connections {
        target: Meikade
        onLanguageDirectionChanged: View.layoutDirection = Meikade.languageDirection
        Component.onCompleted: View.layoutDirection = Meikade.languageDirection
    }

    MeikadeWindow {
        anchors.fill: parent
    }

    Component.onCompleted: {
        DownloaderQueue.destination = AsemanApp.homePath + "/cache"
        AsemanServices.init()
    }
}
