VERSION = 3.9.57
DEFINES += MEIKADE_VERSION='\\"$${VERSION}\\"'

include(configurations/configurations.pri)
include(translations/translations.pri)
include(qml/qml.pri)
include(cpp/cpp.pri)
