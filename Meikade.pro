folder_01.source = fonts
folder_01.target = .
folder_02.source = database
folder_02.target = .
folder_03.source = translations
folder_03.target = files
DEPLOYMENTFOLDERS += folder_01 folder_02 folder_03

QT += widgets

ios {
    QTPLUGIN += qsqlite
    QMAKE_INFO_PLIST = iOS/info.plist

    folder_04.source = iOS/splash/Default-568h@2x.png
    folder_04.target = .
    DEPLOYMENTFOLDERS += folder_04

    ios_icon.files = $$files($$PWD/iOS/icons/*.png)
    QMAKE_BUNDLE_DATA += ios_icon
}
android {
    QT += androidextras
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}

DEFINES += DISABLE_KEYCHAIN
include(aseman/aseman.pri)
include(qmake/qtcAddDeployment.pri)
qtcAddDeployment()

LIBS += -lasemanclient
INCLUDEPATH += \
    $$[QT_INSTALL_HEADERS]/aseman/client/

QT += sql qml quick asemancore asemangui asemanqml

SOURCES += main.cpp \
    userdata.cpp \
    threadeddatabase.cpp \
    threadedfilesystem.cpp \
    meikade.cpp \
    meikadedatabase.cpp \
    stickermodel.cpp \
    stickerwriter.cpp \
    threadedsearchmodel.cpp \
    poetscriptinstaller.cpp \
    poetimageprovider.cpp \
    poetinstaller.cpp

HEADERS += \
    userdata.h \
    threadeddatabase.h \
    threadedfilesystem.h \
    meikade.h \
    meikade_macros.h \
    meikadedatabase.h \
    stickermodel.h \
    stickerwriter.h \
    threadedsearchmodel.h \
    poetscriptinstaller.h \
    poetimageprovider.h \
    poetremover.h \
    services/meikade2.h \
    poetinstaller.h

OTHER_FILES += \
    android/AndroidManifest.xml \
    iOS/Info.plist \
    iOS/splash/Default-568h@2x.png

RESOURCES += \
    resource.qrc

DISTFILES += \
    translations_sources/lang-fa.ts \
    translations_sources/lang-en.ts \
    qmldir \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS = \
        $$PWD/libs/libcrypto.so \
        $$PWD/libs/libssl.so
}
