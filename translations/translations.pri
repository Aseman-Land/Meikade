greaterThan(QT_MINOR_VERSION, 14) {
    include(15/translations.pri)
} else {
    include(13/translations.pri)
}
