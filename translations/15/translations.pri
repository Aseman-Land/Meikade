
TRANSLATIONS += \
    $$files($$PWD/*.ts)

qtPrepareTool(LRELEASE, lrelease)
for(tsfile, TRANSLATIONS) {
    qmfile = $$_PRO_FILE_PWD_/qml/imports/globals/translations/$$basename(tsfile)
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
    translations

DISTFILES += \
    lang-en.ts \
    lang-fa.ts

