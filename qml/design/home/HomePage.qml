import QtQuick 2.12
import AsemanQml.Base 2.0
import design 1.0

HomeForm {
    width: Constants.width
    height: Constants.height

    list.model: AsemanListModel {
        data: [
            {
                type: "recents",
                section: "Recents",
                color: "transparent",
                background: false,
                modelData: [
                    {
                        title: "Title 0",
                        description: "Description 0",
                        color: "#18f",
                        background: "",
                        type: "normal"
                    },
                    {
                        title: "Title 1",
                        description: "Description 1",
                        color: "#18f",
                        background: "",
                        type: "normal"
                    }
                ]
            },
            {
                type: "static",
                section: "Static",
                color: "white",
                background: true,
                modelData: [
                    {
                        title: "Title 0",
                        description: "Description 0",
                        color: "#18f",
                        background: "",
                        type: "fullback"
                    },
                    {
                        title: "Title 1",
                        description: "Description 1",
                        color: "#18f",
                        background: "",
                        type: "fullback"
                    }
                ]
            },
        ]
    }
}
