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
                    link: "page:/poet"
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
                    link: "page:/poet"
                },
                {
                    title: "Title 1",
                    description: "Description 1",
                    color: "#18f",
                    image: "",
                    type: "normal",
                    link: "page:/poet"
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
                    link: "page:/poet"
                },
                {
                    title: "Title 1",
                    description: "Description 1",
                    color: "#18f",
                    image: "",
                    type: "fullback",
                    link: "page:/poet"
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
                    link: "page:/poet"
                },
                {
                    title: "Title 1",
                    description: "Description 1",
                    color: "#18f",
                    image: "",
                    type: "fullback",
                    link: "page:/poet"
                },
                {
                    title: "Title 2",
                    description: "Description 1",
                    color: "#18f",
                    image: "",
                    type: "fullback",
                    link: "page:/poet"
                },
                {
                    title: "Title 3",
                    description: "Description 1",
                    color: "#18f",
                    image: "",
                    type: "fullback",
                    link: "page:/poet"
                }
            ]
        },
    ]
}
