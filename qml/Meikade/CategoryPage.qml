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
import AsemanTools.Awesome 1.0
import QtQuick.Controls 2.0 as QtControls
import QtQuick.Controls.Material 2.1
import "globals"
import "auth" as Auth

Rectangle {
    id: page
    anchors.fill: parent
    color: MeikadeGlobals.backgroundColor

    property alias count: list.count
    property alias catId: catItem.catId

    property variant randomPoetObject
    property variant poemsListObject
    property variant sidePoemsListObject

    readonly property real sideMargin: sidePoemsListObject? parent.width/2 : 0
    readonly property bool titleBarHide: !forceTitleBarShow && title_bar.hide && (localPortrait || Devices.isMobile)
    property bool forceTitleBarShow: false

    ListObject {
        id: list
        onCountChanged: {
            if( count <= 1 ) {
                BackHandler.removeHandler(page)
            } else
            if( count == 2 ) {
                BackHandler.pushHandler(page, page.back)
            }
        }
    }

    Connections {
        target: Database
        onInitializeFinished: finished()
        Component.onCompleted: finished()

        function finished() {
            if(!Database.initialized)
                return
            catItem.catId = 0
            catItem.startInit = true
        }
    }

    Item {
        anchors.top: base_frame.top
        anchors.bottom: base_frame.bottom
        width: sideMargin
        clip: true

        Item {
            id: sideFrame
            width: page.width/2
            height: parent.height
        }
    }

    Rectangle {
        id: base_frame
        color: parent.color
        anchors.top: title_bar.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: View.defaultLayout? 0 : sideMargin
        anchors.rightMargin: View.defaultLayout? sideMargin : 0
        clip: true

        CategoryPageItem {
            id: catItem
            startY: 0
            startHeight: parent.height
            onCategorySelected: base_frame.appendCategory(cid, rect, catId == 0)
            onPoemSelected: base_frame.appendPoem(pid, rect)
            Component.onCompleted: list.append(catItem)

            MaterialDesignButton {
                id: md_button
                anchors.fill: parent
                flickable: catItem.list
                color: MeikadeGlobals.masterColor
            }
        }

        function appendCategory(cid, rect, root) {
            var item = category_component.createObject(base_frame, {"catId": cid, "startY": rect.y, "startHeight": rect.height, "root": root} )
            item.start()

            if( list.count != 0 )
                list.last().outside = true

            list.append(item)
        }

        function appendPoem(pid, rect) {
            var item
            if( pid < 10000 ) {
                item = poems_component.createObject(base_frame, {"catId": pid})
                item.inited = true
            } else {
                item = hafez_omen_component.createObject(base_frame, {"catId": pid} )
                item.inited = true
            }

            if( list.count != 0 )
                list.last().outside = true

            list.append(item)
        }
    }

    Header {
        id: title_bar
        width: parent.width
        color: MeikadeGlobals.masterColor
        shadow: true
        y: titleBarHide? -Devices.standardTitleBarHeight : 0

        property bool hide: false

        Behavior on y {
            NumberAnimation { easing.type: Easing.OutCubic; duration: 300 }
        }

        Row {
            y: View.statusBarHeight
            x: View.reverseLayout? 10*Devices.density : parent.width - width - 10*Devices.density
            height: Devices.standardTitleBarHeight
            spacing: 2*Devices.density
            layoutDirection: View.layoutDirection

            Button {
                anchors.verticalCenter: parent.verticalCenter
                height: Devices.standardTitleBarHeight - 2*xMargin
                width: height
                text: AsemanServices.loggining? "" : Awesome.fa_user
                fontSize: 13*Devices.fontDensity
                textFont.family: Awesome.family
                textColor: "#ffffff"
                highlightColor: "#44ffffff"
                radius: 4*Devices.density
                onClicked: {
                    if(AsemanServices.loggining)
                        return
                    if(AsemanServices.sessionActivated)
                        return
                    else
                        userAccount.open()
                }

                property real xMargin: 10*Devices.density

                QtControls.BusyIndicator {
                    anchors.centerIn: parent
                    height: 46*Devices.density
                    width: height
                    running: AsemanServices.loggining
                    transformOrigin: Item.Center
                    scale: 0.5
                    Material.accent: "#ffffff"
                }
            }

            Button {
                anchors.verticalCenter: parent.verticalCenter
                y: View.statusBarHeight
                height: Devices.standardTitleBarHeight - 2*xMargin
                width: height
                text: Awesome.fa_search
                fontSize: 12*Devices.fontDensity
                textFont.family: Awesome.family
                textColor: "#ffffff"
                highlightColor: "#44ffffff"
                radius: 4*Devices.density
                onClicked: {
                    AsemanServices.meikade.pushAction("Search (from header)", null)
                    showSearch()
                }
                property real xMargin: 10*Devices.density
            }
        }
    }

    Rectangle {
        width: parent.width
        height: Devices.statusBarHeight
        color: title_bar.color
    }

    Component {
        id: category_component

        CategoryPageItem {
            onCategorySelected: base_frame.appendCategory(cid, rect, catId == 0)
            onPoemSelected: base_frame.appendPoem(pid, rect)
        }
    }

    Component {
        id: hafez_omen_component
        HafezOmen {
            id: homen
            width: parent.width
            height: parent.height
            x: inited? 0 : (View.defaultLayout? width : -width )

            property bool inited: false
            property bool outside: false

            Behavior on x {
                NumberAnimation{ easing.type: Easing.OutCubic; duration: 400 }
            }

            Timer {
                id: destroy_timer
                interval: 400
                onTriggered: homen.destroy()
            }

            function end() {
                inited = false
                destroy_timer.restart()
            }
        }
    }

    Component {
        id: poems_component

        PoemsPage {
            id: ppage
            width: parent.width
            height: parent.height
            x: inited? 0 : (View.defaultLayout? width : -width )
            onForceTitleBarShowRequest: forceTitleBarShow = stt

            property bool inited: false
            property bool outside: false

            Behavior on x {
                NumberAnimation{ easing.type: Easing.OutCubic; duration: 400 }
            }

            Timer {
                id: destroy_timer
                interval: 400
                onTriggered: ppage.destroy()
            }

            function end() {
                inited = false
                destroy_timer.restart()
            }
        }
    }

    Component {
        id: poemsHeader_component
        Rectangle {
            anchors.fill: parent

            property alias catId: poems.catId
            property alias poemId: poems.poemId

            PoemsPage {
                id: poems
                width: parent.width
                anchors.top: header.bottom
                anchors.bottom: parent.bottom
            }

            Header {
                id: header
                width: parent.width
                color: title_bar.color
                shadow: true

                Button {
                    x: View.reverseLayout? 0 : parent.width - width
                    y: View.statusBarHeight
                    height: Devices.standardTitleBarHeight
                    width: height
                    radius: 0
                    highlightColor: "#88666666"
                    onClicked: {
                        AsemanServices.meikade.pushAction("Search (from header)", null)
                        showSearch()
                    }

                    Text {
                        anchors.centerIn: parent
                        font.pixelSize: 15*globalFontDensity*Devices.fontDensity
                        font.family: Awesome.family
                        color: "white"
                        text: Awesome.fa_search
                    }
                }
            }
        }
    }

    Auth.UserAccountDialogs {
        id: userAccount
        anchors.fill: parent
    }

    function back() {
        if( list.count == 1 )
            return

        var item = list.takeLast()
        item.end()
        if( list.count != 0 )
            list.last().outside = false

        if( list.count == 1 )
            BackHandler.removeHandler(page)
        else
            return false
    }

    function backToPoet(pid) {
        pageManager.append( Qt.createComponent("CategoryPage.qml") ).catId = pid
    }

    function backToCats(cid, pid) {
        var poems = Database.catPoems(cid)
        if( poems.length != 0 )
            pageManager.append(poemsHeader_component).catId = cid
        else
            pageManager.append( Qt.createComponent("CategoryPage.qml") ).catId = cid
    }

    function home() {
        if( list.count == 1 )
            return

        var item = list.takeLast()
        item.end()

        while(list.count > 1) {
            item = list.takeLast()
            item.destroy()
        }

        list.last().outside = false
        BackHandler.removeHandler(page)
    }

    function showHafezOmen() {
        var item = hafez_omen_component.createObject( base_frame, {"catId": 10001} )
        item.inited = true

        if( list.count != 0 )
            list.last().outside = true

        list.append(item)
    }

    function showRandomCatPoem(id) {
        id = id || 0
        var cats = Database.childsOf(id)
        var poem = -1
        while(cats.length != 0)
        {
            var cat_id_rnd = Math.floor(Math.random()*cats.length)
            if(cat_id_rnd == cats.length)
                cat_id_rnd--

            var cat = cats[cat_id_rnd]
            var poems = Database.catPoems(cat)
            if(poems.length != 0)
            {
                var poem_id_rnd = Math.floor(Math.random()*poems.length)
                if(poem_id_rnd == poems.length)
                    poem_id_rnd--

                poem = poems[poem_id_rnd]
                break;
            }

            cats = Database.childsOf(cat)
        }

        if(poem == -1 || !poem)
            return false

        if(!poemsListObject)
            poemsListObject = poems_component.createObject( base_frame, {"poemId": poem} )
        else
            poemsListObject.poemId = poem

        var item = poemsListObject
        var animationsRecovery = animations
        animations = false
        item.viewMode = true
        BackHandler.removeHandler(item)
        animations = animationsRecovery
        item.inited = true

        if( list.count != 0 )
            list.last().outside = true

        list.append(item)
        return true
    }

    function showSidePoem(poem) {
        if(!sidePoemsListObject)
            sidePoemsListObject = poems_component.createObject( sideFrame, {"poemId": poem} )
        else
            sidePoemsListObject.poemId = poem

        var item = sidePoemsListObject
        var animationsRecovery = animations
        animations = false
        item.viewMode = true
        BackHandler.removeHandler(item)
        animations = animationsRecovery
        item.inited = true
    }

    function showStore() {
        var ocomponent = Qt.createComponent("XmlDownloaderPage.qml")
        if(ocomponent.status == Component.Ready)
            pageManager.append(ocomponent)
        else if(ocomponent.status == Component.Error) {
            console.error(ocomponent.errorString())
        }
    }

    Connections{
        target: Meikade
        onCurrentLanguageChanged: initTranslations()
    }

    Connections {
        target: Database
        onCountChanged: initTranslations()
    }

    function initTranslations(){
        if(Database.count) {
            if(Database.containsHafez)
                md_button.list = [
                            {"name": qsTr("Add Poet"), "iconText": Awesome.fa_shopping_cart, "method": showStore},
                            {"name": qsTr("Random Poem"), "iconText": Awesome.fa_random, "method": showRandomCatPoem},
                            {"name": qsTr("Hafez Omen") , "iconText": Awesome.fa_book, "method": showHafezOmen }
                        ]
            else
                md_button.list = [
                            {"name": qsTr("Add Poet"), "iconText": Awesome.fa_shopping_cart, "method": showStore},
                            {"name": qsTr("Random Poem"), "iconText": Awesome.fa_random, "method": showRandomCatPoem}
                        ]
        } else {
            md_button.list = [
                        {"name": qsTr("Add Poet"), "iconText": Awesome.fa_shopping_cart, "method": showStore}
                    ]
        }

    }

    function hideHeader() {
        title_bar.hide = true
    }

    function showHeader() {
        title_bar.hide = false
    }

    Component.onCompleted: {
        initTranslations()
        MeikadeGlobals.categoriesList.append(this)
    }
    Component.onDestruction: MeikadeGlobals.categoriesList.removeAll(this)
}
