QT += quick qml quickcontrols2 asemancore network widgets asemangui
CONFIG += c++11
QTPLUGIN -= qsqlmysql

qtHaveModule(sql): QT += sql
qtHaveModule(webview): QT += webview

DEFINES += \
    MEIKADE_VERSION='\\"$${VERSION}\\"' \
    UNLOCK_PASSWORD='\\"$${UNLOCK_PASSWORD}\\"' \
    LOGGER_PATH='\\"$${LOGGER_PATH}\\"'

test-mode: DEFINES += TEST_MODE
disable-subscription: DEFINES += DISABLE_SUBSCRIPTION

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
