greaterThan(QT_MINOR_VERSION, 14) {
    include(15/qt_15.pri)
} else {
    include(13/qt_13.pri)
}

ANDROID_ABIS = armeabi-v7a arm64-v8a

contains(ANDROID_TARGET_ARCH,x86_64) {
    ANDROID_ABIS = x86_64
}
