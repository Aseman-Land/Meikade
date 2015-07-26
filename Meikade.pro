folder_01.source = fonts
folder_01.target = .
folder_02.source = database
folder_02.target = .
folder_03.source = translations
folder_03.target = files
DEPLOYMENTFOLDERS = folder_01 folder_02 folder_03

ios {
    QTPLUGIN += qsqlite
    QMAKE_INFO_PLIST = iOS/info.plist

    folder_04.source = iOS/splash/Default-568h@2x.png
    folder_04.target = .
    DEPLOYMENTFOLDERS += folder_04
}
android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}

include(qmake/qtcAddDeployment.pri)
include(asemantools/asemantools.pri)
qtcAddDeployment()

QT += sql qml quick xml

SOURCES += main.cpp \
    listobject.cpp \
    userdata.cpp \
    threadeddatabase.cpp \
    threadedfilesystem.cpp \
    backuper.cpp \
    resourcemanager.cpp \
    hashobject.cpp \
    systeminfo.cpp \
    meikade.cpp \
    meikadedatabase.cpp \
    SimpleQtCryptor/simpleqtcryptor.cpp \
    p7zipextractor.cpp \
    stickermodel.cpp \
    stickerwriter.cpp \
    threadedsearchmodel.cpp \
    xmldownloadermodel.cpp \
    poetscriptinstaller.cpp \
    poetscriptinstallerqueue.cpp \
    poetimageprovider.cpp

HEADERS += \
    listobject.h \
    userdata.h \
    threadeddatabase.h \
    threadedfilesystem.h \
    backuper.h \
    resourcemanager.h \
    hashobject.h \
    systeminfo.h \
    meikade.h \
    meikade_macros.h \
    meikadedatabase.h \
    SimpleQtCryptor/serpent_sbox.h \
    SimpleQtCryptor/simpleqtcryptor.h \
    p7zipextractor.h \
    stickermodel.h \
    stickerwriter.h \
    threadedsearchmodel.h \
    xmldownloadermodel.h \
    poetscriptinstaller.h \
    poetscriptinstallerqueue.h \
    poetimageprovider.h

OTHER_FILES += \
    android/AndroidManifest.xml \
    iOS/Info.plist \
    iOS/splash/Default-568h@2x.png

RESOURCES += \
    resource.qrc

DISTFILES += \
    translations_sources/lang-fa.ts \
    translations_sources/lang-en.ts
