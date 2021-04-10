import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.MaterialIcons 2.0
import AsemanQml.Models 2.0
import globals 1.0
import requests 1.0

AsemanListModel {
    data: {
        if (Devices.isAndroid)
            return [
                {
                    "image": "themes/auto-red.png",
                    "configTheme": 0,
                    "configColorToolbar": true
                }, {
                    "image": "themes/light-color.png",
                    "configTheme": 1,
                    "configColorToolbar": true
                }, {
                    "image": "themes/dark-color.png",
                    "configTheme": 2,
                    "configColorToolbar": true
                }, {
                    "image": "themes/light-light.png",
                    "configTheme": 1,
                    "configColorToolbar": false
                }
            ];
        else
            return [
                {
                    "image": "themes/auto.png",
                    "configTheme": 0,
                    "configColorToolbar": false
                }, {
                    "image": "themes/light-light.png",
                    "configTheme": 1,
                    "configColorToolbar": false
                }, {
                    "image": "themes/light-color.png",
                    "configTheme": 1,
                    "configColorToolbar": true
                }, {
                    "image": "themes/dark-color.png",
                    "configTheme": 2,
                    "configColorToolbar": true
                }
            ];
    }
}
