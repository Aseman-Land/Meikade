import QtQuick 2.12
import globals 1.0
import "views"

SearchSmartAboutView {
    width: Constants.width
    height: Constants.height

    property string text: qsTr("Meikade online search is a smart search that uses AI alghorithms to give you better results.\n" +
                               "It removes all extra spaces you may entered or search between other positive spelling or meanings.\n" +
                               "It's experimental currently and Meikade technical team working on it. But if it fail to find true result, You can disable it " +
                               "Using accurate search checkbox.")

    textLabel.text: text
}


