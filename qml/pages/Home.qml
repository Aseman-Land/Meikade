import QtQuick 2.0
import AsemanQml.Base 2.0
import "../models" as Models
import "../design/home"

HomePage {
    id: home

    onLinkRequest: console.debug(link)

    list.model: Models.HomeDemoModel {}
}
