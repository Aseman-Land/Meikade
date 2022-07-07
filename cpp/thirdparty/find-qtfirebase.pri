
QTFIREBASE_SDK_PATH = $$getenv(FIREBASE_CPP_SDK_DIR)

ios {
    QTFIREBASE_FRAMEWORKS_ROOT = $$getenv(FIREBASE_FRAMEWORKS_ROOT)
    isEmpty(QTFIREBASE_SDK_PATH)|isEmpty(QTFIREBASE_FRAMEWORKS_ROOT) {
        message(Firebase is disabled. To enable it please set and point FIREBASE_CPP_SDK_DIR)
        message(and FIREBASE_FRAMEWORKS_ROOT environment variables to firebase c++ sdk and )
        message(firebase ios sdk paths.)
        message(Download firebase c++ sdk from: https://firebase.google.com/download/cpp)
        message(Download firebase ios sdk from: https://github.com/firebase/firebase-ios-sdk/releases/download/v8.15.0/Firebase.zip)
    } else {
        DEFINES += QTFIREBASE_SUPPORT
        QTFIREBASE_CONFIG += messaging

        LIBS += \
            -F$$QTFIREBASE_FRAMEWORKS_ROOT/FirebaseAnalytics/FirebaseCore.xcframework/ios-arm64_armv7 \
            -F$$QTFIREBASE_FRAMEWORKS_ROOT/FirebaseAnalytics/GoogleUtilities.xcframework/ios-arm64_armv7 \
            -F$$QTFIREBASE_FRAMEWORKS_ROOT/FirebaseAnalytics/nanopb.xcframework/ios-arm64_armv7 \
            -F$$QTFIREBASE_FRAMEWORKS_ROOT/FirebaseAnalytics/PromisesObjC.xcframework/ios-arm64_armv7 \
            -F$$QTFIREBASE_FRAMEWORKS_ROOT/FirebaseAnalytics/FirebaseInstallations.xcframework/ios-arm64_armv7 \
            -F$$QTFIREBASE_FRAMEWORKS_ROOT/FirebaseAnalytics/GoogleDataTransport.xcframework/ios-arm64_armv7 \
            -framework FirebaseCore \
            -framework GoogleDataTransport \
            -framework GoogleUtilities \
            -framework nanopb \
            -framework PromisesObjC \
            -framework FirebaseInstallations \
            -lobjc \
            \

        include(qtfirebase/qtfirebase.pri)
    }
}

android {
    isEmpty(QTFIREBASE_SDK_PATH) {
        message(Firebase is disabled. To enable it please set and point FIREBASE_CPP_SDK_DIR)
        message(environment variable to the firebase sdk path)
        message(Download firebase c++ sdk from: https://firebase.google.com/download/cpp)
    } else {
        DEFINES += QTFIREBASE_SUPPORT
        QTFIREBASE_CONFIG += messaging
        include(qtfirebase/qtfirebase.pri)
    }
}
