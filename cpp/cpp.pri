QT += quick qml quickcontrols2  network widgets
CONFIG += c++11
QTPLUGIN -= qsqlmysql

qtHaveModule(asemancore): {
    QT += asemancore asemangui
}

qtHaveModule(sql): QT += sql
qtHaveModule(webview): QT += webview

DEFINES += \
    MEIKADE_VERSION='\\"$${VERSION}\\"' \
    UNLOCK_PASSWORD='\\"$${UNLOCK_PASSWORD}\\"' \
    LOGGER_PATH='\\"$${LOGGER_PATH}\\"'

test-mode: DEFINES += TEST_MODE
disable-subscription: DEFINES += DISABLE_SUBSCRIPTION

include(thirdparty/thirdparty.pri)

SOURCES += \
    $$PWD/old/stickermodel.cpp \
    $$PWD/old/stickerwriter.cpp \
    $$PWD/main.cpp \
    $$PWD/meikadeofflinemanager.cpp \
    $$PWD/meikadetools.cpp \
    $$PWD/delegatedataanalizer.cpp

HEADERS += \
    $$PWD/old/stickermodel.h \
    $$PWD/old/stickerwriter.h \
    $$PWD/meikadeofflinemanager.h \ \
    $$PWD/meikadetools.h \
    $$PWD/delegatedataanalizer.h
