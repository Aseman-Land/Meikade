import QtQuick 2.0
import QtQuick.Controls 2.0
import "../design"
import "../globals"

MainForm {
    id: form

    Home {
        parent: form.homePage
        anchors.fill: parent
    }

    Search {
        parent: form.searchPage
        anchors.fill: parent
    }

    MyMeikade {
        parent: form.myMeikadePage
        anchors.fill: parent
    }
}
