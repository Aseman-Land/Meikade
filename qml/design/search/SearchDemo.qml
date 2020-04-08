import QtQuick 2.12
import MeikadeDesign 1.0
import AsemanQml.Base 2.0

SearchPage {
    width: Constants.width
    height: Constants.height

    gridView.model: AsemanListModel {
        data: [
            {
                title: "Title 0",
                description: "Description 0",
                color: "#18f",
                image: ""
            },
            {
                title: "Title 1",
                description: "Description 1",
                color: "#18f",
                image: ""
            },
            {
                title: "Title 2",
                description: "Description 1",
                color: "#18f",
                image: ""
            },
            {
                title: "Title 3",
                description: "Description 1",
                color: "#18f",
                image: ""
            }
        ]
    }
}
