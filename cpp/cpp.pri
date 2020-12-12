QT += quick qml quickcontrols2 sql asemancore network widgets
CONFIG += c++11

qtHaveModule(webview): QT += webview

DEFINES += MEIKADE_VERSION='\\"$${VERSION}\\"'

disable-subscription: DEFINES += DISABLE_SUBSCRIPTION

SOURCES += \
    $$PWD/old/stickermodel.cpp \
    $$PWD/old/stickerwriter.cpp \
    $$PWD/main.cpp \
    $$PWD/meikadeofflinemanager.cpp

HEADERS += \
    $$PWD/old/stickermodel.h \
    $$PWD/old/stickerwriter.h \
    $$PWD/meikadeofflinemanager.h

