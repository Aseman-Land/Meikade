include(android/android.pri)
include(ios/ios.pri)
include(osx/osx.pri)
include(windows/windows.pri)
include(wasm/wasm.pri)

greaterThan(QT_MAJOR_VERSION, 5) {
    include(android/android.pri)
} else {
    include(android-qt5/android.pri)
}
