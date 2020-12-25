greaterThan(QT_MINOR_VERSION, 14) {
    test-mode {
        include(15_test/qt_15_test.pri)
    } else {
        include(15/qt_15.pri)
    }
} else {
    include(13/qt_13.pri)
}

ANDROID_ABIS = armeabi-v7a arm64-v8a

ANDROID_EXTRA_LIBS = \
    $$PWD/libs/armv7/libcrypto_1_1.so \
    $$PWD/libs/armv7/libssl_1_1.so \
    $$PWD/libs/arm64/libcrypto_1_1.so \
    $$PWD/libs/arm64/libssl_1_1.so \
    $$PWD/libs/x86_64/libcrypto_1_1.so \
    $$PWD/libs/x86_64/libssl_1_1.so \
    $$PWD/libs/x86/libcrypto_1_1.so \
    $$PWD/libs/x86/libssl_1_1.so
