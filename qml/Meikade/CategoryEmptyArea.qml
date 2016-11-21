import QtQuick 2.0
import AsemanTools 1.0

Item {

    Text {
        id: txt
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        font.family: AsemanApp.globalFont.family
        font.pixelSize: 12*Devices.fontDensity
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        horizontalAlignment: Text.AlignHCenter
        color: "#666666"
    }

    Canvas {
        anchors.fill: parent
        transform: Scale { origin.x: width/2; origin.y: height; xScale: View.layoutDirection==Qt.LeftToRight?1:-1}

        property color strokeColor: "#aaaaaa"
        property real strokeWidth: 2

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0,0,width,height)

            var startX = parent.width - 80*Devices.density
            var startY = parent.height - 38*Devices.density
            var endX = width/2
            var endY = txt.y + txt.height

            ctx.strokeStyle = strokeColor
            ctx.lineWidth = strokeWidth*Devices.density

            ctx.beginPath()
            ctx.moveTo(startX , startY)
            ctx.bezierCurveTo(startX, startY ,
                              endX, startY,
                              endX, endY);
            ctx.stroke()
        }

        Component.onCompleted: requestPaint()
    }

    Connections{
        target: Meikade
        onCurrentLanguageChanged: initTranslations()
    }

    function initTranslations(){
        txt.text = qsTr("To Start, Download new poet")
    }

    Component.onCompleted: {
        initTranslations()
    }
}
