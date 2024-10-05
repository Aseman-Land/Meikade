android {
    # QT += androidextras
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD

    DISTFILES += \
        $$PWD/AndroidManifest.xml \
        $$PWD/gradle.properties
}

ANDROID_ABIS = arm64-v8a

android: include(/opt/develop/android/openssl3/openssl.pri)
