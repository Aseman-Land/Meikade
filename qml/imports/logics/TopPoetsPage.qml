import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import views 1.0
import models 1.0
import queries 1.0 as Query
import globals 1.0

TopPoetsView {
    id: dis
    width: Constants.width
    height: Constants.height

    onChecked: {
        if (active)
            topModel.append(poetId, properties);
        else
            topModel.remove(poetId);
    }

    closeBtn.onClicked: ViewportType.open = false

    listView.model: TopPoetsModel {
        id: topModel
    }
}
