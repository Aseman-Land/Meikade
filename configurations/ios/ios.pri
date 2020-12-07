ios {
    QMAKE_INFO_PLIST = $$PWD/info.plist

    app_launch_images.files = $$PWD/Launch.xib $$files($$PWD/splash/LaunchImage*.png)
    QMAKE_BUNDLE_DATA += app_launch_images

    ios_icon.files = $$files($$PWD/icons/*.png)
    QMAKE_BUNDLE_DATA += ios_icon

    QMAKE_ASSET_CATALOGS += $$PWD/icons.xcassets
}
