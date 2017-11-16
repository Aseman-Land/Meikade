
HEADERS += \
    $$PWD/asemanabstractlistmodel.h \
    $$PWD/asemandownloader.h

SOURCES += \
    $$PWD/asemanabstractlistmodel.cpp \
    $$PWD/asemandownloader.cpp

ios {
    HEADERS += \
        $$PWD/osxviewcontroller.h
    SOURCES += \
        $$PWD/osxviewcontroller.mm
}
