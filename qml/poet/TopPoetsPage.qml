import QtQuick 2.12
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import models 1.0
import queries 1.0 as Query
import globals 1.0
import "views"

Viewport {
    id: dis

    mainItem: PoetTypesView {
        width: dis.width
        closeBtn.onClicked: dis.ViewportType.open = false
        clip: true

        listView.model: PoetCategoriesModel {
            cachePath: ""
        }

        onClicked: function (typeId) {
            Viewport.viewport.append(select_poet_component, {"currentTypeId": typeId}, "stack")
        }
    }

    Component {
        id: select_poet_component

        TopPoetsView {
            id: poetsView
            width: Constants.width
            height: Constants.height
            clip: true

            property alias currentTypeId: topModel.typeId

            onChecked: {
                if (active)
                    topModel.append(poetId, properties);
                else
                    topModel.remove(poetId);
            }

            menuBtn.onClicked: ViewportType.open = false
            closeBtn.onClicked: dis.ViewportType.open = false

            listView.model: TopPoetsModel {
                id: topModel
                keyword: poetsView.keyword
            }
        }
    }
}



