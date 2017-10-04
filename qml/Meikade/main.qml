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

import QtQuick 2.7
import AsemanTools 1.0

AsemanApplication {
    id: app
    applicationName: "Meikade"
    applicationAbout: "Persian Poetry App"
    applicationDisplayName: "Meikade"
    applicationVersion: "v3.5.0"
    applicationId: "7e861c79-2b50-427b-93b6-4591b54eb821"
    organizationDomain: "NileGroup"
//    organizationName: "Aseman Team"
    windowIcon: "icons/meikade.png"

    MeikadeMainWindow {
        id: appMain
    }
}
