pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0
import globals 1.0

AsemanObject {

    onPremiumDaysChanged: AsemanGlobals.lastPremiumDays = premiumDays

    readonly property int notesLimits: activeSubscription && Bootstrap.subscription? currentPackage.package.extra.notes_limits : -1
    readonly property int listsLimits: activeSubscription && Bootstrap.subscription? currentPackage.package.extra.lists_limits : -1
    readonly property int offlineLimits: activeSubscription && Bootstrap.subscription? currentPackage.package.extra.offline_limits : -1
    readonly property int mypoemsLimits: activeSubscription && Bootstrap.subscription? currentPackage.package.extra.mypoems_limits : -1

    readonly property int premium:  premiumDays > 0
    readonly property int premiumDays: {
        if (!activeSubscription || !Bootstrap.subscription || Bootstrap.fullyUnlocked)
            return 1000;

        try {
            var expire = Math.floor(Date.parse(currentPackage.expires_at) / 1000);
            var current = Tools.dateToSec(new Date);
            return Math.round( (expire - current) / (24 * 3600) );
        } catch (e) {
            return -1;
        }
    }


    readonly property string title: currentPackage.package.title
    readonly property color packageColor: currentPackage.package.extra.color

    readonly property variant currentPackage: {
        var sbc = MyUserRequest._subscription;
        try {
            if (sbc.package.id === 0)
                return null;

            return sbc;
        } catch (e) {
            return {
                package_id: 2,
                package: {
                    id: 2,
                    title: qsTr("Free Account") + Translations.refresher,
                    description: null,
                    price: 0,
                    expire_in_days: -1,
                    extra: {
                        color: "#008fdc",
                        lists_limits: 3,
                        notes_limits: 5,
                        offline_limits: -1,
                        mypoems_limits: 3
                    }
                },
                starts_at: "1990-11-21T16:40:59+03:30",
                expires_at: "1990-12-21T16:40:59+03:30",
                total_days: 30,
                remained_days: 29
            };
        }
    }

    readonly property color premiumColor: "#fa4"

    function refresh() {
    }

    function init() {
        AsemanGlobals.lastPremiumDays = premiumDays;
        refresh()
    }
}
