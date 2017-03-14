#-------------------------------------------------
#
# Project created by QtCreator 2016-12-14T16:23:08
#
#-------------------------------------------------

DESTDIR = ../build/lib
QT += network gui qml

TARGET = asemanclient
TEMPLATE = lib

include(../AsemanGlobals/AsemanGlobals.pri)
include(AsemanClientLib.pri)

DEFINES += ASEMANCLIENTLIB_LIBRARY

unix {
    target.path = /usr/lib
    INSTALLS += target
}
