android {
    QT += androidextras
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD

    DISTFILES += \
        $$PWD/AndroidManifest.xml \
        $$PWD/gradle.properties

    ANDROID_EXTRA_LIBS = $$PWD/libs/libcrypto_1_1.so $$PWD/libs/libssl_1_1.so
}
