pragma Singleton

import QtQuick 2.10
import AsemanQml.Base 2.0
import queries 1.0
import globals 1.0

AsemanObject {

    property real daily
    property real weekly
    property int faves
    property int monthly
    property int weeklyDays

    UserActions {
        id: diaryQuery
        declined: 0
        synced: 0
    }

    HashObject {
        id: activityHash
    }

    function reload() {
        var monthList = diaryQuery.getDiaries(Tools.dateFromSec(Tools.dateToSec(new Date) - (30 * 24 * 3600)));

        activityHash.clear();
        var sum = 0;
        var currentDate = Tools.dateToString(new Date, "yyyy-MM-dd");
        monthList.forEach(function(m){
            var date = Tools.dateFromSec(m.updatedAt);
            if (Tools.dateToString(date, "yyyy-MM-dd") == currentDate)
                return;

            var day = date.getDay();
            var value = 1;
            if (activityHash.contains(day))
                value = (activityHash.value(day) * 1) + 1;

            activityHash.remove(day);
            activityHash.insert(day, value);
            sum += (m.value * 1)
        })

        var hours = (sum / 3600);

        monthly = monthList.length;
        weeklyDays = activityHash.count;
        daily = (Math.floor(monthList.length / 3) / 10);
        weekly = (Math.floor(sum / 7 / (100 * hours)) / 100);
        faves = diaryQuery.getFavedPoets().length;

        if (!Devices.isIOS)
            AsemanGlobals.trusted = true;
        else
        if (daily > 1 && weeklyDays >= 3 && hours >= 6 && Bootstrap.initialized && Bootstrap.subscription && Bootstrap.payment)
            AsemanGlobals.trusted = true;
    }
}
