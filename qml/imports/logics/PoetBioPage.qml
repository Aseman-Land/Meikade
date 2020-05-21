import QtQuick 2.12
import QtWebView 1.1
import AsemanQml.Viewport 2.0
import views 1.0
import globals 1.0

PoetBioView {
    id: bioPage
    width: Constants.width
    height: Constants.height

    busyIndicator.running: Colors.androidStyle? false : webView.loading
    progressBar.visible: Colors.androidStyle? webView.loading : false
    flickable.visible: link.length == 0

    bioText.text: text

    closeBtn.onClicked: ViewportType.open = false

    property string text
    property string link

    Timer {
        id: visibleTimer
        running: true
        interval: 400
        repeat: false
    }

    WebView {
        id: webView
        parent: bioPage.scene
        url: bioPage.link
        anchors.fill: parent
        visible: !visibleTimer.running && !loading && bioPage.link.length
    }
}
