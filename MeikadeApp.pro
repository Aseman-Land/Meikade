QT += quick qml quickcontrols2 webview
CONFIG += c++11

SOURCES += \
    main.cpp

include(objectivec/ios.pri)

INCLUDED_RESOURCE_FILES += \
    $$files($$PWD/qml/*.qml, true) \
    $$files($$PWD/qml/*.png, true) \
    $$files($$PWD/qml/*.jpg, true) \
    $$files($$PWD/qml/*.ttf, true) \
    $$files($$PWD/qml/*.sql, true) \
    $$files($$PWD/qml/qmldir, true)

meikadeQml.files = $$INCLUDED_RESOURCE_FILES
meikadeQml.prefix = /

RESOURCES += \
    qml/qml.qrc \
    meikadeQml

QML_IMPORT_PATH += \
    $$PWD/qml/imports
