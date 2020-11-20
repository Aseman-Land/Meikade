pragma Singleton

import QtQuick 2.0
import AsemanQml.Base 2.0

AsemanObject {

    readonly property int notesLimits: currentPackage.extra.notes_limits
    readonly property int listsLimits: currentPackage.extra.lists_limits
    readonly property int offlineLimits: currentPackage.extra.offline_limits

    readonly property int premiumDays: currentPackage.expire_in_days
    readonly property int premium: currentPackage.expire_in_days > 0

    readonly property string title: currentPackage.title

    readonly property variant currentPackage: {
        var sbc = MyUserRequest._subscription;
        try {
            if (sbc.package.id === 0)
                return null;

            return sbc.package;
        } catch (e) {
            return {
                id: 2,
                title: qsTr("Free Account") + Translations.refresher,
                description: null,
                price: 0,
                expire_in_days: -1,
                extra: {
                    color: "#008fdc",
                    lists_limits: 3,
                    notes_limits: 5,
                    offline_limits: -1
                }
            };
        }
    }

    readonly property color premiumColor: "#fa4"

    function refresh() {
    }

    function init() {
        refresh()
    }
}
