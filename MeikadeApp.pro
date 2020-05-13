QT += quick qml quickcontrols2 webview
CONFIG += c++11

SOURCES += \
    main.cpp

include(objectivec/ios.pri)

ios {
    QMAKE_INFO_PLIST = iOS/info.plist

    app_launch_images.files = $$PWD/iOS/Launch.xib $$files($$PWD/iOS/splash/LaunchImage*.png)
    QMAKE_BUNDLE_DATA += app_launch_images

    ios_icon.files = $$files($$PWD/iOS/icons/*.png)
    QMAKE_BUNDLE_DATA += ios_icon
}

INCLUDED_RESOURCE_FILES += \
    $$files($$PWD/qml/*.qml, true) \
    $$files($$PWD/qml/*.png, true) \
    $$files($$PWD/qml/*.jpg, true) \
    $$files($$PWD/qml/*.ttf, true) \
    $$files($$PWD/qml/*.sql, true) \
    $$files($$PWD/qml/qmldir, true)

meikadeQml.files = $$INCLUDED_RESOURCE_FILES
meikadeQml.prefix = /

TRANSLATIONS += \
    $$files($$PWD/translations/*.ts)

qtPrepareTool(LRELEASE, lrelease)
for(tsfile, TRANSLATIONS) {
    qmfile = $$PWD/qml/imports/globals/translations/$$basename(tsfile)
    qmfile ~= s,.ts$,.qm,
    qmdir = $$dirname(qmfile)
    !exists($$qmdir) {
        mkpath($$qmdir)|error("Aborting.")
    }
    command = $$LRELEASE -removeidentical $$tsfile -qm $$qmfile
    system($$command)|error("Failed to run: $$command")
    TRANSLATIONS_FILES += $$qmfile
}

translations.files = $$TRANSLATIONS_FILES
translations.prefix = /

RESOURCES += \
    qml/qml.qrc \
    translations \
    meikadeQml

QML_IMPORT_PATH += \
    $$PWD/qml/imports
