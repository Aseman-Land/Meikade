VERSION = 5.0.0
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

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    android/res/xml/qtprovider_paths.xml \
    configurations/android/build.gradle \
    configurations/android/res/values/libs.xml \
    configurations/android/res/xml/qtprovider_paths.xml

