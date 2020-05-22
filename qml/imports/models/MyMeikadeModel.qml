import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Models 2.0

AsemanListModel {
    data: [
        {
            "title": qsTr("Lists") + Translations.refresher,
            "icon": "mdi_heart",
            "link": "popup:/test"
        },
        {
            "title": qsTr("Notes") + Translations.refresher,
            "icon": "mdi_note",
            "link": "popup:/test"
        },
        {
            "title": qsTr("Manage Offlines") + Translations.refresher,
            "icon": "mdi_view_dashboard",
            "link": "popup:/poets/manage"
        },
        {
            "title": qsTr("Sync") + Translations.refresher,
            "icon": "mdi_cloud_sync",
            "link": "popup:/test"
        },
        {
            "title": qsTr("Contact US") + Translations.refresher,
            "icon": "mdi_email",
            "link": "popup:/auth/float"
        }
    ]
}
