VERSION = 3.9.58
DEFINES += MEIKADE_VERSION='\\"$${VERSION}\\"'

include(configurations/configurations.pri)
include(translations/translations.pri)
include(qml/qml.pri)
include(cpp/cpp.pri)
