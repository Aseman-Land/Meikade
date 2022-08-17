import QtQuick 2.12

Rectangle {
    color: "transparent"

    property ListView listView

    signal clicked(string link, variant properties)
    signal moreRequest()
    signal editRequest(bool mode)
}
