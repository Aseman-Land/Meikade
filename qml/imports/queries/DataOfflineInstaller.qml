import QtQuick 2.12
import AsemanQml.Base 2.0
import Meikade 1.0
import globals 1.0

MeikadeOfflineItem {
    sourceUrl: Constants.offlinesUrl
    databasePath: AsemanApp.homePath + "/database.sqlite"
}
