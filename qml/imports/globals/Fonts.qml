pragma Singleton

import QtQuick 2.10
import AsemanQml.Base 2.0

AsemanObject
{
    property alias ubuntuFont: ubuntu_font.name
    property alias iranSansFont: iran_sans.name
    readonly property url resourcePath: "fonts"

    property string globalFont: {
        if (Translations.localeName === "fa")
            return iranSansFont + ", " + ubuntuFont + ", Noto Color Emoji"
        else
            return ubuntuFont + ", " + iranSansFont + ", Noto Color Emoji"
    }

    onGlobalFontChanged: AsemanApp.globalFont.family = globalFont

    FontLoader { id: iran_sans; source: "fonts/IRANSans_Regular.ttf"}
    FontLoader { id: ubuntu_font; source: "fonts/Ubuntu-R.ttf" }

    function init() {
        AsemanApp.globalFont.family = globalFont
    }
}
