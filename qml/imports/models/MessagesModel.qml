pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Models 2.0
import requests 1.0
import globals 1.0

AsemanListModel {
    id: model

    signal newMessageArrived()

    GetMessagesRequest {
        id: req
        onSuccessfull: {
            model.clear();
            var lastMsgId = 0;
            let current_date = new Date;
            response.result.forEach(function(m){
                lastMsgId = Math.max(lastMsgId, m.id);

                m.created_at = Tools.dateFromSec( Math.floor(Date.parse(m.created_at) / 1000) );
                m.expires_at = Tools.dateFromSec( Math.floor(Date.parse(m.expires_at) / 1000) );
                if (m.created_at > current_date || m.expires_at < current_date)
                    return;

                m.title = Tools.jsonToVariant(m.title);
                m.body = Tools.jsonToVariant(m.body);
                model.insert(0, m);
            });

            if (lastMsgId > AsemanGlobals.lastMessageId && AsemanGlobals.lastMessageId != -1)
                newMessageArrived();

            AsemanGlobals.lastMessageId = lastMsgId;
        }
    }

    function init() {
        req.doRequest();
    }
}
