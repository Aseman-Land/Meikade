import QtQuick 2.14
import AsemanQml.Base 2.0
import QtQuick.Controls 2.3
import globals 1.0

TextField {
    id: dis
    implicitHeight: 34 * Devices.density
    horizontalAlignment: Text.AlignLeft
    topInset: 0
    topPadding: 4 * Devices.density
    rightPadding: LayoutMirroring.enabled? 16 * Devices.density : unit.width + 16 * Devices.density
    leftPadding: LayoutMirroring.enabled? unit.width + 16 * Devices.density : 16 * Devices.density
    inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
    validator: RegularExpressionValidator { regularExpression: /[\,\d]+/ }
    font.pixelSize: 9 * Devices.fontDensity
    text: "0"

    function getValue() {
        return Tools.stringRemove(text, ",") * 1;
    }

    property alias unit: unit
    property string customValue

    onCustomValueChanged: setValue(customValue)

    onTextEdited: {
        if (formater.signalBlocker)
            return;

        formater.input = "" + (getValue() * 1);

        formater.signalBlocker = true;
        text = formater.output;
        formater.signalBlocker = false;
    }

    function setValue(value) {
        formater.input = Qt.binding( function(){ return "" + value; });
        text = Qt.binding( function(){ return formater.output; });
    }

    TextFormater {
        id: formater
        delimiter: ","
        count: 3

        property bool signalBlocker: false
    }

    Label {
        id: unit
        anchors.rightMargin: 8 * Devices.density
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 8 * Devices.fontDensity
        color: Colors.accent
    }
}
