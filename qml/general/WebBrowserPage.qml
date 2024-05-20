import QtQuick 2.12
import QtWebView 1.1
import AsemanQml.Viewport 2.0
import globals 1.0
import "views"

WebBrowserView {
    id: webPage
    width: Constants.width
    height: Constants.height

    webTitle.text: title.length? title : webView.title

    busyIndicator.running: Colors.androidStyle? false : webView.loading
    progressBar.visible: Colors.androidStyle? webView.loading : false

    closeBtn.onClicked: ViewportType.open = false

    property string link

    Timer {
        id: visibleTimer
        running: true
        interval: 400
        repeat: false
    }

    WebView {
        id: webView
        parent: webPage.scene
        url: webPage.link
        anchors.fill: parent
        visible: !visibleTimer.running && webPage.link.length && !loading
    }
}



