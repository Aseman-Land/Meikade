VERSION = 3.9.63
DEFINES += MEIKADE_VERSION='\\"$${VERSION}\\"'
TARGET = Meikade

include(configurations/configurations.pri)
include(translations/translations.pri)
include(qml/qml.pri)
include(cpp/cpp.pri)
include(objective-c/objective-c.pri)
