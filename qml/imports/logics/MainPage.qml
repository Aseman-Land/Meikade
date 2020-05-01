import QtQuick 2.0
import QtQuick.Controls 2.0
import views 1.0
import globals 1.0

MainView {
    id: form

    HomePage {
        parent: form.homePage
        anchors.fill: parent
    }

    SearchPage {
        parent: form.searchPage
        anchors.fill: parent
    }

    MyMeikadePage {
        parent: form.myMeikadePage
        anchors.fill: parent
    }
}
