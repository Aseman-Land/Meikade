greaterThan(QT_MINOR_VERSION, 14) {
    include(15/qt_15.pri)
} else {
    include(13/qt_13.pri)
}
