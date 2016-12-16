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
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
import AsemanTools 1.1 as AT
import AsemanTools.Awesome 1.0
import Meikade 1.0
import "."

MeikadeWindowBase {
    id: main
    color: "#000000"

    property string globalPoemFontFamily: poem_texts_font.name
    property real globalZoomAnimDurations: animations? 500 : 0
    property real globalFontDensity: 0.9

    readonly property real headerHeight: AT.Devices.standardTitleBarHeight
    property bool backButton: !AT.Devices.isAndroid
    property bool flatDesign: true

    property alias pageManager: page_manager
    readonly property variant catPage: page_manager.mainItem? page_manager.mainItem.catPage : 0

    property bool blockBack: false
    property bool fontsLoaded: false

    property bool animations: Meikade.animations
    property alias networkFeatures: network_features

    readonly property variant areaFrame: page_manager.mainItem? page_manager.mainItem.areaFrame : 0
    property variant mainDialog

    property variant init_wait
    property string meikadeTitle: qsTr("Meikade")

    readonly property bool localPortrait: catPage? (catPage.width<catPage.height || AT.Devices.isMobile) : portrait

    Connections{
        target: Meikade
        onCurrentLanguageChanged: initTranslations()
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
        initTranslations()
        if( !Database.initialized() ) {
            var initWaitComponent = Qt.createComponent("InitializeWait.qml")
            init_wait = initWaitComponent.createObject(main)
        }

        Meikade.runCount++
        switch(Meikade.runCount)
        {
        case 1:
            showLanguageSetup()
            break
        case 2:
            showFavoriteMessage()
            break
        }
    }

    Timer {
        interval: 4000
        onTriggered: loadFonts()
        Component.onCompleted: start()
    }

    XmlDownloaderModel {
        id: xml_model
    }

    NetworkFeatures {
        id: network_features
        activePush: Meikade.activePush
        onShowMessage: messageDialog.show(network_message_component, {"message":message, "destUrl":url})
    }

    Connections {
        target: Database
        onCopyError: showCopyErrorMessage()
        onInitializeFinished: {
            if( init_wait ) {
                init_wait.visible = false
                init_wait.destroy()
            }

            if(AT.AsemanApp.applicationVersion == "3.1.1" && Meikade.runCount > 1)
                showNews(1)
            else
                Meikade.setMeikadeNews(1, true)
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

    FontLoader {
        id: poem_texts_font
        source: Meikade.resourcePath + "/fonts/" + Meikade.poemsFont + ".ttf"
        onStatusChanged: if(status == FontLoader.Ready) AT.AsemanApp.globalFont.family = name
    }

    AT.SlidePageManager {
        id: page_manager
        anchors.fill: parent
        direction: Qt.Vertical
        mainComponent: Item {
            id: frame
            anchors.fill: parent
            clip: true

            property bool anim: false
            property alias catPage: cat_page
            property alias areaFrame: area_frame

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
                    }
                }
            }
        }
    }

    FastBlur {
        anchors.fill: page_manager
        source: page_manager
        radius: 32*AT.Devices.density
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

    AT.SideMenu {
        id: sidebar
        anchors.fill: parent
        delegate: MouseArea {
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: "#f0f0f0"
            }

            MainMenu {
                anchors.fill: parent
                anchors.bottomMargin: AT.View.navigationBarHeight
                onSelected: {
                    if( fileName.length == 0 ) {
                        catPage.home()
                        pageManager.closeLast()
                    } else {
                        var ocomponent = Qt.createComponent(fileName)
                        if(ocomponent.status == Component.Ready)
                            pageManager.append(ocomponent)
                        else if(ocomponent.status == Component.Error) {
                            console.error(ocomponent.errorString())
                        }
                    }

                    sidebar.discard()
                }
            }
        }
    }

    Item {
        id: menu_button
        height: AT.Devices.standardTitleBarHeight
        width: row.width + 26*AT.Devices.density
        x: AT.View.defaultLayout? 0 : parent.width - width
        y: AT.View.statusBarHeight

        Row {
            id: row
            anchors.centerIn: parent
            layoutDirection: AT.View.layoutDirection
            spacing: 10*AT.Devices.density

            AT.MenuIcon {
                id: menuIcon
                anchors.verticalCenter: parent.verticalCenter
                height: 20*AT.Devices.density
                width: height
                ratio: {
                    if(catPage && catPage.count>1)
                        return fakeRatio
                    else
                    if(pageManager.count)
                        return fakeRatio
                    else
                    if(sidebar.percent == 0)
                        return fakeRatio
                    return sidebar.percent
                }

                property real fakeRatio: {
                    if(catPage && catPage.count>1)
                        return 1
                    else
                    if(pageManager.count)
                        return 1
                    else
                        return 0
                }

                Behavior on fakeRatio {
                    NumberAnimation{easing.type: Easing.OutCubic; duration: 300}
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                font.family: AT.AsemanApp.globalFont.family
                font.pixelSize: 11*globalFontDensity*AT.Devices.fontDensity
                text: pageManager.currentItem && pageManager.currentItem.title? pageManager.currentItem.title : meikadeTitle
                verticalAlignment: Text.AlignVCenter
                color: "#ffffff"
                opacity: 1-sidebar.percent
                visible: opacity != 0
            }
        }

        Rectangle {
            anchors.fill: row
            anchors.margins: -8*AT.Devices.density
            radius: 3*AT.Devices.density
            color: "#33ffffff"
            visible: menu_area.pressed
        }

        MouseArea {
            id: menu_area
            anchors.fill: parent
            onClicked: {
                if(menuIcon.ratio == 1)
                    AT.BackHandler.back()
                else
                if(sidebar.showed)
                    sidebar.discard()
                else
                    sidebar.show()
            }
        }
    }

    Timer {
        id: start_report_timer
        interval: 2000
        repeat: false
        onTriggered: networkFeatures.pushDeviceModel(AT.Devices.deviceName, AT.Devices.lcdPhysicalSize, AT.Devices.density)
        Component.onCompleted: start()
    }

    function hideMenuItem() {
        if(!main.menuItem)
            return

        main.menuItem.close()
        main.menuItem = 0
    }

    function setCurrentChapter( id ){
        quran_frame.chapterAT.Viewer.chapter = id
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

    function showLanguageSetup() {
        var component = Qt.createComponent("LanguageInitializer.qml")
        var popup = component.createObject(main)
        popup.open()
    }

    function showFavoriteMessage() {
        var component = Qt.createComponent("FavoriteMessage.qml")
        messageDialog.show(component)
    }

    function showNews(num) {
        if(Meikade.meikadeNews(num))
            return

        var component = Qt.createComponent("MeikadeNews" + num + ".qml")
        messageDialog.show(component)
        Meikade.setMeikadeNews(num, true)
    }

    function showCopyErrorMessage() {
        var component = Qt.createComponent("CopyErrorMessage.qml")
        messageDialog.show(component)
    }

    function back(){
        return AT.AsemanApp.back()
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

    function initTranslations(){
        meikadeTitle = qsTr("Meikade")
    }

    Component {
        id: font_loader_component
        FontLoader{
            source: Meikade.resourcePath + "/fonts/" + fontName + ".ttf"
            property string fontName
        }
    }

    Component {
        id: network_message_component
        AT.MessageDialogOkCancelWarning {
            property string destUrl
            onOk: {
                Qt.openUrlExternally(destUrl)
                AT.AsemanApp.back()
            }
        }
    }

    Component {
        id: main_menu_item_component
        MainMenuItem {}
    }
}
