QT += quick qml quickcontrols2 webview sql asemancore network
CONFIG += c++11
VERSION = 3.9.54

include(android/android.pri)
include(ios/ios.pri)

DEFINES += MEIKADE_VERSION='\\"$${VERSION}\\"'

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

SOURCES += \
    main.cpp \
    meikadeofflinemanager.cpp

HEADERS += \
    meikadeofflinemanager.h

RESOURCES += \
    qml/qml.qrc \
    translations \
    meikadeQml

QML_IMPORT_PATH += \
    $$PWD/qml/imports

DISTFILES += \
    translations/lang-en.ts \
    translations/lang-fa.ts
