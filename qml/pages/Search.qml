import QtQuick 2.0
import AsemanQml.Base 2.0
import "../models" as Models
import "../design/search"
import "../globals"

SearchPage {
    id: home

    onClicked: console.debug(link)

    gridView.model: Models.SearchDemoModel {}

    domainBtn.onClicked: ViewController.trigger("popup:/search/domains", {})
}
