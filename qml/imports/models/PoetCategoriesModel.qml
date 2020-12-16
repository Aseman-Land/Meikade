import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    id: lmodel
    cachePath: AsemanGlobals.cachePath + "/types.cache"

    property alias refreshing: typesReq.refreshing

    PoetsTypeRequest {
        id: typesReq
        onSuccessfull: {
            lmodel.clear();

            var count = 0;
            response.result.forEach(function(v){
                if (count > 1 && !Bootstrap.initialized)
                    return;

                lmodel.append(v);
                count++;
            })
        }
    }
}
