import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Models 2.0
import globals 1.0
import requests 1.0

AsemanListModel {
    data: {
        var res = [
            {
                "title": qsTr("Lists") + Translations.refresher,
                "icon": "mdi_heart",
                "link": "float:/lists",
                "underco": false
            },
            {
                "title": qsTr("Notes") + Translations.refresher,
                "icon": "mdi_note",
                "link": "float:/notes",
                "underco": false
            },
            {
                "title": qsTr("My Poems") + Translations.refresher,
                "icon": "mdi_notebook",
                "link": "float:/mypoems",
                "underco": false
            },
//            {
//                "title": qsTr("Manage Offlines") + Translations.refresher,
//                "icon": "mdi_view_dashboard",
//                "link": "float:/offline/manage",
//                "underco": false
//            },
            {
                "title": qsTr("Settings") + Translations.refresher,
                "icon": "mdi_settings",
                "link": "page:/settings",
                "underco": false
            },{
                "title": qsTr("Sync") + Translations.refresher,
                "icon": "mdi_cloud_sync",
                "link": "float:/syncs",
                "underco": false
            }
        ]

        if (Bootstrap.initialized) {
            res[res.length] = {
                "title": qsTr("Contact US") + Translations.refresher,
                "icon": "mdi_email",
                "link": "float:/contactus",
                "underco": false
            };
            res[res.length] = {
                "title": qsTr("about") + Translations.refresher,
                "icon": "mdi_information",
                "link": "page:/abouts",
                "underco": false
            };
        }

        res[res.length] = {
            "title": qsTr("Privacy Policy") + Translations.refresher,
            "icon": "mdi_information",
            "link": "float:/web?link=https://meikade.com/privacy&title=" + qsTr("Privacy Policy"),
            "underco": false
        };

        return res;
    }
}
