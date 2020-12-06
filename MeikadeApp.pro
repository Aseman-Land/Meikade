VERSION = 4.2.0
TARGET = Meikade

QMAKE_TARGET_BUNDLE_PREFIX = com.meikade
QMAKE_BUNDLE = app

include(configurations/configurations.pri)
include(translations/translations.pri)
include(qml/qml.pri)
include(cpp/cpp.pri)
include(objective-c/objective-c.pri)

ANDROID_ABIS = armeabi-v7a

contains(ANDROID_TARGET_ARCH,x86_64) {
    ANDROID_ABIS = \
        armeabi-v7a
}
