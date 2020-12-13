android {
    QT += androidextras
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD

    DISTFILES += \
        $$PWD/AndroidManifest.xml \
        $$PWD/gradle.properties

    ANDROID_EXTRA_LIBS = \
        $$PWD/libs/armv7/libcrypto_1_1.so \
        $$PWD/libs/armv7/libssl_1_1.so \
        $$PWD/libs/arm64/libcrypto_1_1.so \
        $$PWD/libs/arm64/libssl_1_1.so \
        $$PWD/libs/x86_64/libcrypto_1_1.so \
        $$PWD/libs/x86_64/libssl_1_1.so
}
