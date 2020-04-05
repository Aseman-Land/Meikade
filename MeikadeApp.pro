QT += quick
CONFIG += c++11

SOURCES += \
    main.cpp

INCLUDED_RESOURCE_FILES += \
    $$files($$PWD/qml/design/*.qml, true) \
    $$files($$PWD/qml/design/*.png, true) \
    $$files($$PWD/qml/design/qmldir, true)

meikadeQml.files = $$INCLUDED_RESOURCE_FILES
meikadeQml.prefix = /

RESOURCES += \
    qml/qml.qrc \
    meikadeQml
