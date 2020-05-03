import QtQuick 2.0
import AsemanQml.Base 2.0

QtObject {

    property string input
    property string delimiter
    property int count
    property bool arrayOutput

    readonly property variant output: {
        var res = "";
        for (var i=0; i<input.length; i++) {
            if (i && i % count == 0)
                res = delimiter + res;

            res = input[input.length - i - 1] + res;
        }
        return arrayOutput? res.split(delimiter) : res;
    }
}
