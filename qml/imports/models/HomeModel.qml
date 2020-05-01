import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0

AsemanListModel {
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
                    type: "fullback",
                    link: "popup:/test"
                }
            ]
        },
        {
            type: "dynamic",
            section: "Dynamic:moreLink",
            color: "transparent",
            background: false,
            modelData: [
                {
                    title: "Title 0",
                    description: "Description 0",
                    color: "#18f",
                    image: "",
                    type: "normal",
                    link: "popup:/test"
                },
                {
                    title: "Title 1",
                    description: "Description 1",
                    color: "#18f",
                    image: "",
                    type: "normal",
                    link: "popup:/test"
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
                    type: "fullback",
                    link: "popup:/test"
                },
                {
                    title: "Title 1",
                    description: "Description 1",
                    color: "#18f",
                    image: "",
                    type: "fullback",
                    link: "popup:/test"
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
                    type: "fullback",
                    link: "popup:/test"
                },
                {
                    title: "Title 1",
                    description: "Description 1",
                    color: "#18f",
                    image: "",
                    type: "fullback",
                    link: "popup:/test"
                },
                {
                    title: "Title 2",
                    description: "Description 1",
                    color: "#18f",
                    image: "",
                    type: "fullback",
                    link: "popup:/test"
                },
                {
                    title: "Title 3",
                    description: "Description 1",
                    color: "#18f",
                    image: "",
                    type: "fullback",
                    link: "popup:/test"
                }
            ]
        },
    ]
}
