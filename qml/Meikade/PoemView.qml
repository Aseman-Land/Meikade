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

import QtQuick 2.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import AsemanQml.Base 2.0
import "globals"

Rectangle {
    id: view
    color: MeikadeGlobals.backgroundColor

    property int poemId: -1
    property variant poemsArray: new Array

    property alias header: view_list.header
    property alias count: view_list.count

    property color highlightColor: "#11000000"
    property color textColor: MeikadeGlobals.foregroundColor
    property color highlightTextColor: MeikadeGlobals.foregroundColor

    property real fontScale: Meikade.fontPointScale(Meikade.poemsFont)
    property bool editable: true
    property bool headerVisible: true

    property bool rememberBar: false
    property bool selectMode: false

    property bool allowHideHeader: false

    property variant stickerDialog
    readonly property bool loggedIn: AsemanServices.loggedIn

    onPoemIdChanged: {
        view_list.refresh()

        if(poemId!=-1) {
            analizer.end()
            analizer.begin()
        }

        var cat = Database.poemCat(poemId)
        poemsArray = Database.catPoems(cat)

        var fileName = cat
        var filePath = "banners/" + fileName + ".jpg"
        while( !Meikade.fileExists(filePath) ) {
            fileName = Database.parentOf(fileName)
            filePath = "banners/" + fileName + ".jpg"
        }

        img.source = filePath
        reloadOnlines()
    }
    onLoggedInChanged: reloadOnlines()

    onSelectModeChanged: {
        selectionHash.clear()
        if(selectMode)
            BackHandler.pushHandler(selectionHash, function(){selectMode = false})
        else
            BackHandler.removeHandler(selectionHash)
    }

    signal itemSelected( int pid, int vid )
    signal forceTitleBarShowRequest(bool stt)

    Connections {
        target: Meikade
        onPoemsFontChanged: view.fontScale = Meikade.fontPointScale(Meikade.poemsFont)
    }

    HashObject {
        id: selectionHash
        onCountChanged: if(count == 0) selectMode = false
    }

    HashObject {
        id: notesHash
    }

    Timer {
        id: highlight_disabler
        interval: 2500
        repeat: false
        onTriggered: view_list.highlightedVid = -1
    }

    Timer {
        id: highlight_enabler
        interval: 500
        repeat: false
        onTriggered: view_list.highlightedVid = vid

        property int vid
    }

    Item {
        id: header_back
        anchors.left: parent.left
        anchors.right: parent.right
        height: img.height
        visible: catTop>=-height && headerVisible
        clip: true

        property real catTop: -contentY<0? view_list.y : -contentY+view_list.y
        property real headerHeight: 0
        property real contentY: contentAbsY - (headerHeight+view_list.y)
        property real contentAbsY: (view_list.height/view_list.visibleArea.heightRatio)*view_list.visibleArea.yPosition

        Image {
            id: img
            anchors.left: parent.left
            anchors.right: parent.right
            y: 0
            height: width
            fillMode: Image.PreserveAspectCrop
            visible: false
        }

        FastBlur {
            id: blur
            anchors.fill: img
            source: img
            radius: fakeRadius<0? 0 : (fakeRadius>blurSize? blurSize : fakeRadius)
            Component.onDestruction: radius = 0

            property real fakeRadius: -header_back.contentAbsY<=0? blurSize :
                                      (-header_back.contentAbsY>header_back.headerHeight? 0 : blurSize*(header_back.headerHeight+header_back.contentAbsY)/(header_back.headerHeight))
            property real blurSize: 64
        }

        Rectangle {
            anchors.fill: blur
            color: "#000000"
            opacity: fakeOpacity<0? 0 : (fakeOpacity>1? 1 : fakeOpacity)

            property real fakeOpacity: (blur.radius/blur.blurSize)/2
        }

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: blur.bottom
            height: 100*Devices.density
            anchors.margins: -1*Devices.density
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 1.0; color: view.color }
            }
        }
    }

    Rectangle {
        id: phrase_frame
        width: parent.width
        height: parent.height - header_back.headerHeight
        anchors.bottom: parent.bottom
        color: "#222222"
        visible: phrase_txt.text.length!=0

        Column {
            id: phrase_column
            width: parent.width - 40*Devices.density
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20*Devices.density + View.navigationBarHeight
            visible: phrase_txt.text.length != 0

            Text {
                id: phrase_title
                width: parent.width
                color: "#ffffff"
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 19*Devices.density
                text: qsTr("Phrase")
            }

            Text {
                id: phrase_txt
                width: parent.width
                text: Meikade.phrase? Database.poemPhrase(view.poemId) : ""
                color: "#ffffff"
                font.family: AsemanApp.globalFont.family
                font.pixelSize: 12*Devices.density
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }
    }

    AsemanListView {
        id: view_list
        anchors.fill: parent
        clip: true
        highlightMoveDuration: 250
        displayMarginBeginning: 512*Devices.density
        displayMarginEnd: 512*Devices.density
        cacheBuffer: 512*Devices.density
        bottomMargin: View.navigationBarHeight
        highlightRangeMode: ListView.ApplyRange
        preferredHighlightBegin: height/2
        preferredHighlightEnd: height/2
        currentIndex: 0

        onContentYChanged: {
            if(!allowHideHeader)
                return

            if(contentY < 100*Devices.density)
                showHeader()
            else
            if(contentY > 200*Devices.density) {
                var delta = (contentY-lastContentY)
                if(delta < -100*Devices.density)
                    showHeader()
                else
                if(delta > 50*Devices.density)
                    hideHeader()
            }
        }
        onDraggingVerticallyChanged: if(draggingVertically) lastContentY = contentY

        property int highlightedVid: -1
        property int selectedIndex: -1
        property real lastContentY

        footer: Rectangle {
            width: view_list.width
            height: phrase_txt.text.length==0? 1 : phrase_column.height + 40*Devices.density
            color: phrase_txt.text.length==0? MeikadeGlobals.backgroundAlternativeColor
                                            : "#00000000"

            Rectangle {
                anchors.top: parent.bottom
                width: parent.width
                height: view.height
                color: parent.color
            }

            Rectangle {
                x: phrase_title.horizontalAlignment==Text.AlignLeft? 10*Devices.density : parent.width - width - 10*Devices.density
                width: 20*Devices.density
                height: width
                rotation: 45
                transformOrigin: Item.Center
                anchors.verticalCenter: parent.top
                visible: phrase_txt.text.length!=0
                color: MeikadeGlobals.backgroundAlternativeColor
            }
        }

        onSelectedIndexChanged: {
            if( selectedIndex != -1 )
                BackHandler.pushHandler(view, view.closeEdit)
            else
                BackHandler.removeHandler(view)
        }

        model: ListModel {}
        delegate: Rectangle {
            id: item
            width: view_list.width
            height: pitem.height + (noteRect.visible?noteRect.height:0) + extraHeight
            color: MeikadeGlobals.backgroundAlternativeColor
//            clip: true

            property real extraHeight: single? txt_frame.height : 0
            property alias press: marea.pressed
            property bool anim: false

            property PoemEdit editItem
            property variant checkItem

            Behavior on height {
                NumberAnimation{ easing.type: Easing.OutCubic; duration: item.anim? 400 : 0 }
            }

            Connections {
                target: view
                onSelectModeChanged: item.createSelectCheckBox()
            }

            Timer {
                interval: 400
                repeat: false
                onTriggered: item.anim = true
                Component.onCompleted: start()
            }

            Rectangle {
                anchors.fill: parent
                anchors.bottomMargin: -2*Devices.density
                color: MeikadeGlobals.backgroundAlternativeColor
            }

            Rectangle {
                anchors.top: pitem.top
                anchors.bottom: pitem.bottom
                anchors.left: parent.left
                anchors.right: pitem.left
                color: pitem.color
            }

            PoemItem {
                id: pitem
                anchors.top: parent.top
                anchors.right: parent.right
                width: checkItem? parent.width - checkItem.width : parent.width
                color: "#00000000"
                textColor: item.press? view.highlightTextColor : view.textColor
                vid: verseId
                pid: poemId
                visible: !item.editItem
                highlight: view_list.highlightedVid == vid
                font.pixelSize: Devices.isMobile? 9*fontScale*globalFontDensity*Devices.fontDensity : 10*fontScale*globalFontDensity*Devices.fontDensity
                font.family: globalPoemFontFamily

                Behavior on width {
                    NumberAnimation {easing.type: Easing.OutCubic; duration: 300}
                }

                Rectangle {
                    x: View.defaultLayout? 0 : parent.width-width
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 25*Devices.density
                    color: Qt.lighter(MeikadeGlobals.masterColor)
                    visible: item.press

                    Text {
                        anchors.centerIn: parent
                        text: MeikadeGlobals.localeName != "fa"? index+1 : Meikade.numberToArabicString(index+1)
                        color: "#ffffff"
                        font.pixelSize: 9*fontScale*globalFontDensity*Devices.fontDensity
                        font.family: AsemanApp.globalFont.family
                    }
                }
            }

            Item {
                id: noteRect
                anchors.top: pitem.bottom
                anchors.left: pitem.left
                anchors.right: pitem.right
                height: noteText.height + 10*Devices.density
                visible: noteText.text.length

                Rectangle {
                    y: -10*Devices.density
                    height: noteText.height + 10*Devices.density
                    width: 2*Devices.density
                    color: "#FFC107"
                    x: View.defaultLayout? 40*Devices.density : parent.width - width - 40*Devices.density
                }

                Text {
                    id: noteText
                    width: parent.width - 100*Devices.density
                    anchors.horizontalCenter: parent.horizontalCenter
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    maximumLineCount: 3
                    elide: Text.ElideRight
                    font.pixelSize: 8*Devices.fontDensity
                    color: MeikadeGlobals.foregroundColor
                    opacity: 0.6
                    text: {
                        if(notesHash.count == 0)
                            return ""
                        else
                        if(notesHash.contains(verseId))
                            return notesHash.value(verseId)
                        else
                            return ""
                    }
                }
            }

            ItemDelegate {
                id: marea
                anchors.fill: parent
                z: 10
                onPressAndHold: {
                    if( view.editable ) {
                        selectMode = true
                        checkItem.checked = true
                        selectionHash.insert(model.verseId, pitem.text)
                        if(fake_header.visible)
                            fake_header.showMenu()
                        else
                        if(view_list.headerItem)
                            view_list.headerItem.showMenu()
                    }
                }
                onClicked: {
                    if(!AsemanServices.loggedIn)
                        selectMode = true

                    if( view.editable ) {
                        if(selectMode) {
                            selectMode = true
                            checkItem.checked = !checkItem.checked
                            if(checkItem.checked)
                                selectionHash.insert(model.verseId, pitem.text)
                            else
                                selectionHash.remove(model.verseId)
                        } else {
                            var point = view.mapFromItem(pitem, 0, 0)
                            item.editItem = poemEdit_component.createObject(view, {"vid": verseId, "pid": poemId})
                            item.editItem.start(point.y)
                        }
                    }

                    view.itemSelected(pitem.pid,pitem.vid)
                }
            }

            Rectangle {
                id: txt_frame
                height: poet.height
                width: parent.width
                anchors.top: pitem.bottom
                color: Qt.lighter(MeikadeGlobals.masterColor)
                visible: single

                Text {
                    id: poet
                    anchors.left: parent.left
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 8*Devices.density
                    font.pixelSize: Devices.isMobile? 8*globalFontDensity*Devices.fontDensity : 9*globalFontDensity*Devices.fontDensity
                    font.family: AsemanApp.globalFont.family
                    color: "#ffffff"

                    Component.onCompleted: {
                        if( !single )
                            return

                        var cat = Database.poemCat(pitem.pid)
                        var str
                        str = Database.catName(cat) + ", "
                        str += Database.poemName(pitem.pid)

                        var poet
                        var book
                        while( cat ) {
                            book = poet
                            poet = cat
                            cat = Database.parentOf(cat)
                        }

                        str = Database.catName(poet) + ", " + Database.catName(book) + ", " + str
                        text = str
                    }
                }
            }

            function createSelectCheckBox() {
                if(selectMode && !checkItem)
                    checkItem = selectCBox_component.createObject(item)
                else
                if(!selectMode && checkItem)
                    checkItem.destroy()
            }

            Component {
                id: selectCBox_component
                CheckBox {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.margins: 10*Devices.density
                    checked: selectionHash.contains(model.verseId)
                }
            }

            Component.onCompleted: createSelectCheckBox()
        }

        focus: true
        header: PoemHeader {
            id: header
            width: view_list.width
            poemId: view.poemId
            font.pixelSize: Devices.isMobile? 11*globalFontDensity*Devices.fontDensity : 13*globalFontDensity*Devices.fontDensity
            font.family: globalPoemFontFamily
            z: 100
            busy: fake_header.busy
            onHeightChanged: {
                header_back.headerHeight = height+view_list.y
                view_list.positionViewAtBeginning()
            }
            onNextRequest: nextPoem()
            onPreviousRequest: previousPoem()
        }

        function refresh(){
            model.clear()
            selectMode = false
            selectedIndex = -1

            refresh_timer.idx = 0
            refresh_timer.moveToVerse = -1
            refresh_timer.verses = Database.poemVerses(poemId)
            refresh_timer.restart()
            focus = true
        }

        Timer {
            id: refresh_timer
            interval: 1
            repeat: false
            onTriggered: {
                for( var i=0; i<10; i++ ) {
                    if( idx < verses.length ) {
                        var vid = verses[idx]
                        view_list.add(view.poemId,vid,false)
                        if( Database.versePosition(poemId,vid)===0 && Database.versePosition(poemId,vid+1)===1 ) {
                            i++
                            idx++
                        }
                        idx++
                        refresh_timer.restart()
                    } else {
                        if( moveToVerse != -1 )
                            view_list.goTo(moveToVerse, true)

                        moveToVerse = -1
                        idx = 0
                        refresh_timer.stop()
                        break
                    }
                }
            }

            property int idx: 0
            property variant verses: new Array
            property int moveToVerse: -1
        }

        function add( poem_id, verse_id, single ) {
            model.append({"poemId": poem_id, "verseId": verse_id,"single":single})
        }

        function clear() {
            model.clear()
        }

        function goTo( vid, force ){
            if( refresh_timer.running && !force ) {
                refresh_timer.moveToVerse = vid
                return
            }
            var index = vidIndex(vid)
            if( index === -1 )
                return

            view_list.currentIndex = index
        }

        function vidIndex( vid ) {
            for( var i=0;i<model.count; i++ )
                if( model.get(i).verseId === vid )
                    return i

            return -1
        }
    }

    ScrollBar {
        scrollArea: view_list; height: view_list.height-View.navigationBarHeight
        anchors.right: view_list.right; anchors.top: view_list.top
        color: Meikade.nightTheme? "#ffffff" : MeikadeGlobals.masterColor
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }

    GoUpButton { list: view_list; visible: false }

    Item {
        id: headerFrame
        width: view_list.width
        height: 32*Devices.density
        clip: true
        visible: header_back.contentY >= -height && rememberBar

        PoemHeader{
            id: fake_header
            width: parent.width
            anchors.bottom: parent.bottom
            poemId: view.poemId
            font.pixelSize: Devices.isMobile? 11*globalFontDensity*Devices.fontDensity : 13*globalFontDensity*Devices.fontDensity
            font.family: globalPoemFontFamily
        }
    }

    PoemFooter {
        width: view_list.width
        anchors.top: headerFrame.bottom
        visible: headerFrame.visible
        onNextRequest: nextPoem()
        onPreviousRequest: previousPoem()

        Rectangle {
            height: 3*Devices.density
            width: parent.width
            anchors.top: parent.bottom
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#55000000" }
                GradientStop { position: 1.0; color: "#00000000" }
            }
        }
    }

    function goTo(vid){
        view_list.goTo(vid)
    }

    function goToBegin(){
        view_list.positionViewAtBeginning()
    }

    function closeEdit(){
        view_list.currentIndex = -1
    }

    function add( poem_id, verse_id ) {
        view_list.add(poem_id,verse_id,true)
    }

    function clear() {
        view_list.clear()
    }

    function highlightItem( vid ){
        highlight_enabler.vid = vid
        highlight_enabler.restart()
        highlight_disabler.restart()

    }

    function nextPoem() {
        var idx = poemsArray.indexOf(poemId)+1
        if(idx < poemsArray.length)
            view.poemId = poemsArray[idx]
    }

    function previousPoem() {
        var idx = poemsArray.indexOf(poemId)-1
        if(idx >= 0)
            view.poemId = poemsArray[idx]
    }

    function reloadOnlines() {
        notesHash.clear()
        if(!loggedIn) return
        fake_header.busy = true
        AsemanServices.meikade.getPoemNotes(poemId, 0, 100, function(res, error){
            fake_header.busy = false
            for(var i in res)
                notesHash.insert(i, res[i])
            if(!error.null || !res) {
                showTooltip(error.value)
            }
        })
    }

    Component {
        id: poemEdit_component
        PoemEdit {
            anchors.fill: parent
            textColor: view.textColor
            onForceTitleBarShowRequest: view.forceTitleBarShowRequest(stt)
            onNoteChanged: {
                notesHash.remove(vid)
                notesHash.insert(vid, text)
            }
        }
    }

    Component {
        id: sticker_dialog_component
        StickerDialog {
            id: sdlg
            width: view.width
            height: view.height
            x: View.defaultLayout? parent.width : -width

            Behavior on x {
                NumberAnimation{easing.type: Easing.OutCubic; duration: 400}
            }

            Timer {
                id: destroy_timer
                interval: 400
                onTriggered: sdlg.destroy()
            }

            function close() {
                x = View.defaultLayout? parent.width : -width
                view.forceTitleBarShowRequest(false)
            }

            Component.onCompleted: {
                x = 0
                view.forceTitleBarShowRequest(true)
                BackHandler.pushHandler(sdlg, sdlg.close)
            }
            Component.onDestruction: {
                BackHandler.removeHandler(sdlg)
            }
        }
    }

    ActivityAnalizer { id: analizer; object: view; comment: view.poemId }
}
