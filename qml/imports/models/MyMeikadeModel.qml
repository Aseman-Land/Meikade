import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Models 2.0

AsemanListModel {
    data: [
//        {
//            "title": qsTr("Lists") + Translations.refresher,
//            "icon": "mdi_heart",
//            "link": "float:/lists",
//            "underco": false
//        },
        {
            "title": qsTr("Favorites") + Translations.refresher,
            "icon": "mdi_heart",
            "link": "float:/lists?favoritesOnly=true",
            "underco": false
        },
        {
            "title": qsTr("Notes") + Translations.refresher,
            "icon": "mdi_note",
            "link": "popup:/test",
            "underco": true
        },
        {
            "title": qsTr("Manage Offlines") + Translations.refresher,
            "icon": "mdi_view_dashboard",
            "link": "float:/offline/manage",
            "underco": false
        },
        {
            "title": qsTr("Sync") + Translations.refresher,
            "icon": "mdi_cloud_sync",
            "link": "popup:/test",
            "underco": false
        },
        {
            "title": qsTr("Contact US") + Translations.refresher,
            "icon": "mdi_email",
            "link": "float:/contactus",
            "underco": false
        },
        {
            "title": qsTr("Settings") + Translations.refresher,
            "icon": "mdi_settings",
            "link": "page:/settings",
            "underco": false
        }
    ]
}
