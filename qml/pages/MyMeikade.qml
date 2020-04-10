import QtQuick 2.0
import QtQuick.Controls 2.0
import "../models" as Models
import "../globals"
import "../design/mymeikade"

MyMeikadePage {

    gridView.model: Models.MyMeikadeDemoModel {}

    onClicked: ViewController.trigger(link, {})
}