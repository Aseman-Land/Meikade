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

import QtQuick 2.3
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import AsemanTools 1.0

Rectangle {
    id: view
    color: Meikade.nightTheme? "#222222" : "#ffffff"

    property int poemId: -1
    property variant poemsArray: new Array

    property bool onEdit: view_list.selectedIndex != -1
    property bool allowEditMode: false

    property alias header: view_list.header
    property alias count: view_list.count

    property color highlightColor: "#11000000"
    property color textColor: Meikade.nightTheme? "#ffffff" : "#333333"
    property color highlightTextColor: Meikade.nightTheme? "#ffffff" : "#333333"

    property real fontScale: Meikade.fontPointScale(Meikade.poemsFont)
    property bool editable: true
    property bool headerVisible: true

    property bool rememberBar: false
    property bool selectMode: false

    property variant stickerDialog

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
    }

    onSelectModeChanged: {
        selectionHash.clear()
        if(selectMode)
            BackHandler.pushHandler(selectionHash, function(){selectMode = false})
        else
            BackHandler.removeHandler(selectionHash)
    }

    signal itemSelected( int pid, int vid )

    Connections {
        target: Meikade
        onPoemsFontChanged: view.fontScale = Meikade.fontPointScale(Meikade.poemsFont)
    }

    HashObject {
        id: selectionHash
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
        color: "#444444"
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
        property int highlightedVid: -1
        property int selectedIndex: -1

        footer: Rectangle {
            width: view_list.width
            height: phrase_txt.text.length==0? 1 : phrase_column.height + 40*Devices.density
            color: phrase_txt.text.length==0? (Meikade.nightTheme? "#222222" : "#ffffff")
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
                color: Meikade.nightTheme? "#222222" : "#ffffff"
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
            height: editMode? pitem.height + edit_frame.height + extraHeight : pitem.height + extraHeight
            color: Meikade.nightTheme? "#222222" : "#ffffff"
//            clip: true

            property real extraHeight: single? txt_frame.height : 0
            property alias press: marea.pressed
            property bool editMode: allowEditMode? view_list.selectedIndex == index : 0
            property bool anim: false

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
                color: Meikade.nightTheme? "#222222" : "#ffffff"
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
                color: press? view.highlightColor : "#00000000"
                textColor: item.press? view.highlightTextColor : view.textColor
                vid: verseId
                pid: poemId
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
                    color: "#EC4334"
                    visible: item.press || item.height != pitem.height + item.extraHeight

                    Text {
                        anchors.centerIn: parent
                        text: Meikade.currentLanguage != "Persian"? index+1 : Meikade.numberToArabicString(index+1)
                        color: Meikade.nightTheme? "#111111" : "#ffffff"
                        font.pixelSize: 9*fontScale*globalFontDensity*Devices.fontDensity
                        font.family: AsemanApp.globalFont.family
                    }
                }
            }

            MouseArea{
                id: marea
                anchors.fill: parent
                z: 10
                onClicked: {
                    if(checkItem) {
                        checkItem.checked = !checkItem.checked
                        if(checkItem.checked)
                            selectionHash.insert(model.verseId, pitem.text)
                        else
                            selectionHash.remove(model.verseId)
                        return
                    }

                    if( view.editable ) {
                        var itemObj = showBottomPanel(share_component, true)
                        itemObj.poemId = pitem.pid
                        itemObj.vid = pitem.vid
                        itemObj.text = pitem.text
                    }

                    view.itemSelected(pitem.pid,pitem.vid)
                }
            }

            Rectangle {
                id: txt_frame
                height: poet.height
                width: parent.width
                anchors.top: pitem.bottom
                color: "#EC4334"
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

            Item {
                id: edit_frame
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: pitem.bottom
                height: 80*Devices.density

                property bool editMode: item.editMode
                property variant itemObj

                onEditModeChanged: {
                    if( editMode ) {
                        if( itemObj )
                            return

                        var component = Qt.createComponent("PoemEdit.qml")
                        itemObj = component.createObject(edit_frame)
                        itemObj.poemId = pitem.pid
                        itemObj.vid = pitem.vid
                        itemObj.text = pitem.text
                        itemObj.anchors.fill = edit_frame
                        itemObj.pressChanged.connect(edit_frame.pressChanged)
                    } else {
                        if( !itemObj )
                            return

                        itemObj.hidePicker()
                        Meikade.timer(400,itemObj,"deleteLater")
                    }
                }

                function pressChanged() {
                    view_list.interactive = !itemObj.press
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
            onHeightChanged: {
                header_back.headerHeight = height+view_list.y
                view_list.positionViewAtBeginning()
            }
            onNextRequest: {
                var idx = poemsArray.indexOf(poemId)+1
                if(idx < poemsArray.length)
                    view.poemId = poemsArray[idx]
            }
            onPreviousRequest: {
                var idx = poemsArray.indexOf(poemId)-1
                if(idx >= 0)
                    view.poemId = poemsArray[idx]
            }
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

    Item {
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

    ScrollBar {
        scrollArea: view_list; height: view_list.height-View.navigationBarHeight
        anchors.right: view_list.right; anchors.top: view_list.top
        color: Meikade.nightTheme? "#ffffff" : "#881010"
        LayoutMirroring.enabled: View.layoutDirection == Qt.RightToLeft
    }

    MouseArea {
        anchors.fill: parent
        onClicked: AsemanApp.back()
        visible: bottomPanel.item? true : false
    }

    Component {
        id: share_component
        Column {
            id: poem_edit
            width: parent.width

            property int poemId
            property int vid
            property bool favorited: false
            property bool signalBlocker: false
            property string text

            onVidChanged: {
                if( vid == -1 )
                    return
                signalBlocker = true
                favorited = UserData.isFavorited(poemId,vid)
                signalBlocker = false
            }
            onFavoritedChanged: {
                if( signalBlocker )
                    return

                if( favorited ) {
                    UserData.favorite(poemId,vid)
                    showTooltip( qsTr("Favorited") )
                    networkFeatures.pushAction( ("Poem Favorited: %1").arg(poemId) )
                } else {
                    UserData.unfavorite(poemId,vid)
                    showTooltip( qsTr("Unfavorited") )
                }
            }

            Button {
                width: parent.width
                height: 40*Devices.density
                text:   qsTr("Copy")
                textColor: "#333333"
                textFont.bold: false
                textFont.pixelSize: 9*globalFontDensity*Devices.fontDensity
                onClicked: {
                    var subject = Database.poemName(poem_edit.poemId)
                    var poet
                    var catId = Database.poemCat(poem_edit.poemId)
                    while( catId ) {
                        poet = Database.catName(catId)
                        subject = Database.catName(catId) + ", " + subject
                        catId = Database.parentOf(catId)
                    }

                    var message = poem_edit.text + "\n\n" + poet

                    networkFeatures.pushAction( ("Copy Verse: %1:%2").arg(poem_edit.poemId).arg(poem_edit.vid) )
                    Devices.clipboard = message
                    hideBottomPanel()
                }
            }
            Button {
                width: parent.width
                height: 40*Devices.density
                text:   qsTr("Share")
                textColor: "#333333"
                textFont.bold: false
                textFont.pixelSize: 9*globalFontDensity*Devices.fontDensity
                onClicked: {
                    var subject = Database.poemName(poem_edit.poemId)
                    var poet
                    var catId = Database.poemCat(poem_edit.poemId)
                    while( catId ) {
                        poet = Database.catName(catId)
                        subject = Database.catName(catId) + ", " + subject
                        catId = Database.parentOf(catId)
                    }

                    networkFeatures.pushAction( ("Share Verse: %1:%2").arg(poem_edit.poemId).arg(poem_edit.vid) )
                    var message = poem_edit.text + "\n\n" + poet
                    Devices.share(subject,message)
                    hideBottomPanel()
                }
            }
            Button {
                width: parent.width
                height: 40*Devices.density
                text:   qsTr("Share Image")
                textColor: "#333333"
                textFont.bold: false
                textFont.pixelSize: 9*globalFontDensity*Devices.fontDensity
                onClicked: {
                    var poet
                    var catId = Database.poemCat(poem_edit.poemId)
                    while( catId ) {
                        poet = Database.catName(catId)
                        catId = Database.parentOf(catId)
                    }

                    networkFeatures.pushAction( ("Share Image: %1:%2").arg(poem_edit.poemId).arg(poem_edit.vid) )
                    stickerDialog = sticker_dialog_component.createObject(view)
                    stickerDialog.text = poem_edit.text
                    stickerDialog.poet = poet
                    hideBottomPanel()
                }
            }
            Button {
                width: parent.width
                height: 40*Devices.density
                text: poem_edit.favorited? qsTr("Unfavorite") : qsTr("Favorite")
                textColor: "#333333"
                textFont.bold: false
                textFont.pixelSize: 9*globalFontDensity*Devices.fontDensity
                onClicked: {
                    poem_edit.favorited = !poem_edit.favorited
                    if(poem_edit.favorited)
                        networkFeatures.pushAction( ("Verse Favorited: %1:%2").arg(poem_edit.poemId).arg(poem_edit.vid) )
                    hideBottomPanel()
                }
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
            }

            Component.onCompleted: {
                x = 0
                BackHandler.pushHandler(sdlg, sdlg.close)
            }
            Component.onDestruction: {
                BackHandler.removeHandler(sdlg)
            }
        }
    }

    ActivityAnalizer { id: analizer; object: view; comment: view.poemId }
}
