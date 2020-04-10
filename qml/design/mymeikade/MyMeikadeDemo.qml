import QtQuick 2.0
import AsemanQml.Base 2.0

MyMeikadePage {
    gridView.model: AsemanListModel {
        data: [
            {
                "title": "Item Title",
                "icon": "mdi_account",
                "link": "popup:/test"
            },
            {
                "title": "Item Title",
                "icon": "mdi_account",
                "link": "popup:/test"
            },
            {
                "title": "Item Title",
                "icon": "mdi_account",
                "link": "popup:/test"
            },
            {
                "title": "Item Title",
                "icon": "mdi_account",
                "link": "popup:/test"
            },
            {
                "title": "Item Title",
                "icon": "mdi_account",
                "link": "popup:/test"
            }
        ]
    }
}
