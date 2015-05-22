/*
    Copyright (C) 2015 Nile Group
    http://nilegroup.org

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
import QtGraphicalEffects 1.0
import AsemanTools 1.0

AsemanMain {
    id: main
    width: 500
    height: 680
    color: "#333333"
    mainFrame: main_scene

    property string globalPoemFontFamily: Devices.isIOS? "Droid Arabic Naskh" : poem_texts_font.name
    property real globalZoomAnimDurations: animations? 500 : 0

    property alias headerHeight: header.height
    property bool backButton: !Devices.isAndroid
    property bool flatDesign: true

    property alias catPage: cat_page
    property alias materialDesignButton: md_button

    property bool blockBack: false
    property bool fontsLoaded: false

    property bool animations: Meikade.animations

    property variant areaFrame: area_frame
    property variant mainDialog

    property variant menuItem
    property variant init_wait

    onMenuItemChanged: {
        if( menuItem )
            BackHandler.pushHandler( main, main.hideMenuItem )
        else
            BackHandler.removeHandler(main)
    }

    QtObject {
        id: privates
        property bool animations: true
    }

    Timer {
        id: main_dialog_destroyer
        interval: 400
        repeat: false
        onTriggered: if(item) item.destroy()
        property variant item
    }

    Component.onCompleted: {
        if( !Database.initialized() ) {
            var initWaitComponent = Qt.createComponent("InitializeWait.qml")
            init_wait = initWaitComponent.createObject(main)
        }

        Meikade.runCount++
        if( Meikade.runCount == 2 )
            showFavoriteMessage()
    }

    Connections{
        target: Meikade
        onCloseRequest: AsemanApp.back()
    }

    Connections {
        target: AsemanApp
        onBackRequest: {
            if(timer_delayer.running)
                return

            timer_delayer.start()
            var res = BackHandler.back()
            if( !res && !Devices.isDesktop )
                Meikade.close()
        }
    }

    Timer {
        id: timer_delayer
        interval: 300
        repeat: false
    }

    Keys.onEscapePressed: AsemanApp.back()

    Connections {
        target: Database
        onCopyError: showCopyErrorMessage()
        onInitializeFinished: {
            if( init_wait ) {
                init_wait.visible = false
                init_wait.destroy()
            }
        }
    }

    Connections {
        target: Backuper
        onActiveChanged: {
            if( Backuper.active ) {
                showWaitDialog()
                UserData.disconnect()
                main.blockBack = true
            } else {
                hideMainDialog()
                UserData.reconnect()
                main.blockBack = false
            }
        }
    }

    FontLoader{
        id: poem_texts_font
        source: Meikade.resourcePath + "/fonts/" + Meikade.poemsFont + ".ttf"
        onStatusChanged: if(status == FontLoader.Ready) AsemanApp.globalFont.family = name
    }

    SearchBar {
        id: search_bar
        anchors.left: main_scene.left
        anchors.right: main_scene.right
        onHideChanged: {
            if( !hide ) {
                if( main.menuItem )
                    main.menuItem.close()
            }
            if( !hide )
                BackHandler.pushHandler( search_bar_back, search_bar_back.hide )
            else
                BackHandler.removeHandler(search_bar_back)
        }

        QtObject {
            id: search_bar_back
            function hide(){
                search_bar.hide = true
            }
        }
    }

    Item {
        id: main_scene
        anchors.top: search_bar.bottom
        width: parent.width
        height: parent.height
        clip: true
        transformOrigin: Item.Center

        Item {
            id: frame
            y: 0
            x: 0
            width: main.width
            height: main.height
            clip: true

            property bool anim: false

            Behavior on y {
                NumberAnimation { easing.type: Easing.OutCubic; duration: frame.anim?animations*400:0 }
            }

            Item {
                id: area_item
                y: padY
                height: parent.height
                anchors.left: parent.left
                anchors.right: parent.right

                property real padY: 0

                Behavior on padY {
                    NumberAnimation { easing.type: Easing.OutCubic; duration: animations*400 }
                }

                Item {
                    id: area_frame
                    width: parent.width
                    height: parent.height

                    Behavior on scale {
                        NumberAnimation { easing.type: Easing.InOutCubic; duration: animations*globalZoomAnimDurations }
                    }
                    Behavior on x {
                        NumberAnimation { easing.type: Easing.InOutCubic; duration: animations*globalZoomAnimDurations }
                    }
                    Behavior on y {
                        NumberAnimation { easing.type: Easing.InOutCubic; duration: animations*globalZoomAnimDurations }
                    }

                    CategoryPage {
                        id: cat_page
                        anchors.fill: parent

                        MaterialDesignButton {
                            id: md_button
                            anchors.fill: parent
                            layoutDirection: Qt.RightToLeft
                            onHafezOmenRequest: cat_page.showHafezOmen()
                            onRandomPoemRequest: cat_page.showRandom()
                            onSearchRequest: search_bar.show()
                        }
                    }
                }
            }

            Item {
                id: header_frame
                y: 0
                anchors.left: parent.left
                anchors.right: parent.right
                height: Devices.standardTitleBarHeight+View.statusBarHeight

                Behavior on y {
                    NumberAnimation { easing.type: Easing.OutCubic; duration: animations*400 }
                }

                Item {
                    id: header
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: Devices.standardTitleBarHeight

                    Button{
                        id: back_btn
                        anchors.left: parent.left
                        anchors.top: parent.top
                        height: parent.height
                        radius: 0
                        normalColor: "#00000000"
                        highlightColor: "#88666666"
                        textColor: "#ffffff"
                        icon: "icons/back_light_64.png"
                        iconHeight: 16*Devices.density
                        fontSize: 11*Devices.fontDensity
                        textFont.bold: false
                        visible: backButton && cat_page.count != 1
                        onClicked: {
                            AsemanApp.back()
                            Devices.hideKeyboard()
                        }
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            visible: !search_bar.hide
            z: 10000
            onClicked: {
                AsemanApp.back()
                Devices.hideKeyboard()
            }
        }
    }

    FastBlur {
        anchors.fill: main_scene
        source: main_scene
        radius: 32*Devices.density
        opacity: main_dialog_frame.opacity
        visible: main_dialog_frame.visible
    }

    Rectangle {
        id: main_dialog_frame
        anchors.fill: parent
        transformOrigin: Item.Center
        opacity: main.mainDialog? 1 : 0
        visible: opacity != 0
        color: "#aa000000"

        MouseArea {
            anchors.fill: parent
        }

        Behavior on opacity {
            NumberAnimation { easing.type: Easing.OutCubic; duration: animations*400 }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: sidebar.top
        anchors.bottom: sidebar.bottom
        color: "#000000"
        opacity: sidebar.percent*0.7
    }

    SideMenu {
        id: sidebar
        anchors.fill: parent
        menuWidth: Devices.isMobile? parent.width-50*Devices.density : parent.width/2 + 50*Devices.density
        layoutDirection: Qt.RightToLeft
        delegate: MouseArea {
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: "#f0f0f0"
            }

            MainMenu {
                anchors.fill: parent
                anchors.bottomMargin: View.navigationBarHeight
                onSelected: {
                    if( main.menuItem )
                        main.menuItem.close()
                    if( !search_bar.hide ) {
                        if( search_bar.viewMode )
                            if( BackHandler )
                                AsemanApp.back()

                        search_bar.hide = true
                    }

                    if( fileName.length == 0 )
                        ;
                    else
                    if( fileName.slice(0,4) == "cmd:" ) {
                        var cmd = fileName.slice(4)
                        if( cmd == "search" )
                            Meikade.timer(400,search_bar,"show")
                    }
                    else {
                        var component = Qt.createComponent("MainMenuItem.qml")
                        var item = component.createObject(frame)
                        item.anchors.fill = frame
                        item.z = 1000

                        var ocomponent = Qt.createComponent(fileName)
                        var object = ocomponent.createObject(item)
                        item.item = object

                        menuItem = item
                    }

                    sidebar.discard()
                }
            }
        }
    }

    Item {
        id: menu_button
        height: Devices.standardTitleBarHeight
        width: 100*Devices.density
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: View.statusBarHeight + main_scene.y
        opacity: 1-sidebar.percent

        Image {
            id: menu_img
            height: 24*Devices.density
            width: height
            anchors.horizontalCenter: parent.right
            anchors.verticalCenter: parent.verticalCenter
            sourceSize: Qt.size(width,height)
            source: "icons/menu.png"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: menu_img.left
            anchors.rightMargin: 8*Devices.density
            font.family: AsemanApp.globalFont.family
            font.pixelSize: 11*Devices.fontDensity
            text: qsTr("Meikade")
            color: "#ffffff"
        }

        Rectangle {
            anchors.fill: parent
            color: "#33ffffff"
            visible: menu_area.pressed
        }

        MouseArea {
            id: menu_area
            anchors.fill: parent
            onClicked: sidebar.show()
        }
    }

    function hideMenuItem() {
        main.menuItem.close()
    }

    function setCurrentChapter( id ){
        quran_frame.chapterViewer.chapter = id
    }

    function showMainDialog( item ){
        hideMainDialog()
        item.parent = main_dialog_frame
        mainDialog = item
    }

    function hideMainDialog(){
        if( !mainDialog )
            return
        if( main_dialog_destroyer.item )
            main_dialog_destroyer.item.destroy()

        main_dialog_destroyer.item = mainDialog
        main_dialog_destroyer.restart()
        mainDialog = 0
    }

    function showWaitDialog(){
        var component = Qt.createComponent("WaitDialog.qml")
        var item = component.createObject(main_dialog_frame)
        showMainDialog(item)
        return item
    }

    function showFavoriteMessage() {
        var component = Qt.createComponent("FavoriteMessage.qml")
        messageDialog.show(component)
    }

    function showCopyErrorMessage() {
        var component = Qt.createComponent("CopyErrorMessage.qml")
        messageDialog.show(component)
    }

    function back(){
        return AsemanApp.back()
    }

    function loadFonts() {
        if(fontsLoaded)
            return

        var fonts = Meikade.availableFonts()
        for(var i=0; i<fonts.length; i++)
            if(fonts[i] != "DroidNaskh-Regular")
                font_loader_component.createObject(main, {"fontName": fonts[i]})

        fontsLoaded = true
    }

    Component {
        id: font_loader_component
        FontLoader{
            source: Meikade.resourcePath + "/fonts/" + fontName + ".ttf"
            property string fontName
        }
    }
}
