import QtQuick 2.0
import AsemanQml.Base 2.0

ListModel {
    id: model

    property int catId

    onCatIdChanged: refresh()
    Component.onCompleted: if(!catId) refresh()

    function refresh() {
        model.clear()

        var list = catId==0? Database.poets() : Database.childsOf(catId)
        for( var i=0; i<list.length; i++ ) {
            model.append({"identifier":list[i]})
        }

        var poems = Database.catPoems(catId)
        if(poems.length != 0)
            model.append({"identifier": -1})
    }
}
