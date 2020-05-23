
ios {
    HEADERS += \
        $$PWD/osxviewcontroller.h
    SOURCES += \
        $$PWD/osxviewcontroller.mm

    QMAKE_INFO_PLIST = $$PWD/ios/info.plist

    app_launch_images.files = $$PWD/ios/Launch.xib $$files($$PWD/ios/splash/LaunchImage*.png)
    QMAKE_BUNDLE_DATA += app_launch_images

    ios_icon.files = $$files($$PWD/ios/icons/*.png)
    QMAKE_BUNDLE_DATA += ios_icon
}
