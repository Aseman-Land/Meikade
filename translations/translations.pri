greaterThan(QT_MAJOR_VERSION, 5) {
    include(15/translations.pri)
} else {
    greaterThan(QT_MINOR_VERSION, 14) {
        include(15/translations.pri)
    } else {
        include(13/translations.pri)
    }
}
