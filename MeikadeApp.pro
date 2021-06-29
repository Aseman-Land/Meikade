VERSION = 4.4.0
TARGET = Meikade

QMAKE_TARGET_BUNDLE_PREFIX = com.meikade
QMAKE_BUNDLE = Meikade

include(configurations/configurations.pri)
include(translations/translations.pri)
include(qml/qml.pri)
include(cpp/cpp.pri)
include(objective-c/objective-c.pri)

#exists(QtFirebase/qtfirebase.pri): {
#    QTFIREBASE_CONFIG += analytics messaging
#    include(QtFirebase/qtfirebase.pri)
#}

ANDROID_ABIS = armeabi-v7a arm64-v8a x86 x86_64

contains(ANDROID_TARGET_ARCH,) {
    ANDROID_ABIS = \
        armeabi-v7a \
        arm64-v8a \
        x86_64
}
