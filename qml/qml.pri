INCLUDED_RESOURCE_FILES += \
    $$files($$PWD/*.qml, true) \
    $$files($$PWD/*.png, true) \
    $$files($$PWD/*.jpg, true) \
    $$files($$PWD/*.ttf, true) \
    $$files($$PWD/*.sql, true) \
    $$files($$PWD/qmldir, true)

meikadeQml.files = $$INCLUDED_RESOURCE_FILES
meikadeQml.prefix = /

RESOURCES += \
    $$PWD/qml.qrc \
    meikadeQml
    
QML_IMPORT_PATH += \
    $$PWD/imports
