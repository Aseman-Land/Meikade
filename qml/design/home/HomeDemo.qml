import QtQuick 2.12
import AsemanQml.Base 2.0
import MeikadeDesign 1.0

HomePage {
    width: Constants.width
    height: Constants.height

    list.model: AsemanListModel {
        data: [
            {
                type: "flexible",
                section: "Flexible",
                color: "white",
                background: true,
                modelData: [
                    {
                        title: "Title 0",
                        description: "Description 0",
                        color: "#18f",
                        image: "",
                        type: "fullback"
                    }
                ]
            },
            {
                type: "dynamic",
                section: "Dynamic",
                color: "transparent",
                background: false,
                modelData: [
                    {
                        title: "Title 0",
                        description: "Description 0",
                        color: "#18f",
                        image: "",
                        type: "normal"
                    },
                    {
                        title: "Title 1",
                        description: "Description 1",
                        color: "#18f",
                        image: "",
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
                        image: "",
                        type: "fullback"
                    },
                    {
                        title: "Title 1",
                        description: "Description 1",
                        color: "#18f",
                        image: "",
                        type: "fullback"
                    }
                ]
            },
            {
                type: "flexible",
                section: "Flexible",
                color: "transparent",
                background: false,
                modelData: [
                    {
                        title: "Title 0",
                        description: "Description 0",
                        color: "#18f",
                        image: "",
                        type: "fullback"
                    },
                    {
                        title: "Title 1",
                        description: "Description 1",
                        color: "#18f",
                        image: "",
                        type: "fullback"
                    },
                    {
                        title: "Title 2",
                        description: "Description 1",
                        color: "#18f",
                        image: "",
                        type: "fullback"
                    },
                    {
                        title: "Title 3",
                        description: "Description 1",
                        color: "#18f",
                        image: "",
                        type: "fullback"
                    }
                ]
            },
        ]
    }
}
