VERSION = 5.1.0
TARGET = Meikade

QMAKE_TARGET_BUNDLE_PREFIX = com.meikade
QMAKE_BUNDLE = Meikade

DEFINES += DISABLE_SUBSCRIPTION

include(configurations/configurations.pri)
include(translations/translations.pri)
include(qml/qml.pri)
include(cpp/cpp.pri)
include(thirdparty/thirdparty.pri)
include(objective-c/objective-c.pri)
