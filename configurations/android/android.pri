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

contains(ANDROID_TARGET_ARCH,x86_64) {
    ANDROID_ABIS = x86_64
}
