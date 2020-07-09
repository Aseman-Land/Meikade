greaterThan(QT_MINOR_VERSION, 14) {
    include(15/android.pri)
} else {
    include(13/android.pri)
}
