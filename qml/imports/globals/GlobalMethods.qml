pragma Singleton

import QtQuick 2.10
import AsemanQml.Base 2.0

QtObject {
    function textToColor(text) {
        var md5 = Tools.md5(text);
        var colors = new Array;
        for (var i = 0; i < md5.length; i++) {
            var clr = Math.floor(i / 10);
            var code = parseInt(md5[i], 36) + 1;
            if (clr < colors.length)
                colors[clr] = code * colors[clr];
            else
                colors[clr] = code;
        }

        return Qt.hsla((colors[0] % 255) / 255,
                       (20 + (colors[1] % 55)) / 255,
                       (100 + (colors[1] % 55)) / 255,
                       1);
    }
}
