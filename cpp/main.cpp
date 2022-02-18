/*
    Copyright (C) 2021 Aseman Team
    http://aseman.io

    This project is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This project is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "meikadeofflinemanager.h"
#include "meikadetools.h"
#include "delegatedataanalizer.h"

#include "old/stickermodel.h"
#include "old/stickerwriter.h"

#ifdef Q_OS_MACX
#include "../objective-c/macmanager.h"
#endif

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QIcon>
#include <QTimer>
#ifdef QT_WEBVIEW_LIB
#include <QtWebView>
#endif

static void register_fcm(QQmlEngine *engine)
{
#ifdef QTFIREBASE_VERSION
    engine->rootContext()->setContextProperty("qtFirebaseVersion", QString(QTFIREBASE_VERSION));
#endif

#ifdef QTFIREBASE_GIT_VERSION
    engine->rootContext()->setContextProperty("qtFirebaseGitVersion", QString(QTFIREBASE_GIT_VERSION));
#endif

#ifdef QTFIREBASE_GIT_BRANCH
    engine->rootContext()->setContextProperty("qtFirebaseGitBranch", QString(QTFIREBASE_GIT_BRANCH));
#endif
}

static QObject *create_meikadetoole_singleton(QQmlEngine *, QJSEngine *)
{
    return new MeikadeTools;
}

int main(int argc, char *argv[])
{
    qsrand(QTime::currentTime().msec());
    qputenv("QT_ANDROID_ENABLE_WORKAROUND_TO_DISABLE_PREDICTIVE_TEXT", "1");
    qputenv("QT_LOGGING_RULES", "qt.qml.connections=false");

    bool androidStyle;
#ifdef Q_OS_ANDROID
    androidStyle = true;
    QQuickStyle::setStyle("Material");
#else
    androidStyle = false;
    QQuickStyle::setStyle("IOSStyle");
#endif

    bool activeSubscription = true;
#ifdef DISABLE_SUBSCRIPTION
    activeSubscription = false;
#endif

    bool testMode = false;
#ifdef TEST_MODE
    testMode = true;
#endif

#if !defined(Q_OS_LINUX) || defined(Q_OS_ANDROID)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
#if (QT_VERSION >= QT_VERSION_CHECK(5, 14, 0))
#ifdef Q_OS_ANDROID
    QGuiApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::Ceil);
#endif
#endif

    qmlRegisterType<MeikadeOfflineItem>("Meikade", 1, 0, "MeikadeOfflineItem");
    qmlRegisterType<MeikadeOfflineItemGlobal>("Meikade", 1, 0, "MeikadeOfflineItemGlobal");
    qmlRegisterType<StickerModel>("Meikade", 1, 0, "StickerModel");
    qmlRegisterType<StickerWriter>("Meikade", 1, 0, "StickerWriter");
    qmlRegisterType<DelegateDataAnalizer>("Meikade", 1, 0, "DelegateDataAnalizer");
    qmlRegisterSingletonType<MeikadeTools>("Meikade", 1, 0, "MeikadeTools", create_meikadetoole_singleton);

#ifdef QT_WEBVIEW_LIB
    QtWebView::initialize();
#endif
    QApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/qml/imports/views/images/meikade.png"));

    QQmlApplicationEngine engine;
    engine.addImportPath(":/qml/imports/");
    register_fcm(&engine);
    engine.rootContext()->setContextProperty("isAndroidStyle", androidStyle);
    engine.rootContext()->setContextProperty("appVersion", MEIKADE_VERSION);
    engine.rootContext()->setContextProperty("appVersionNumber", QString(MEIKADE_VERSION).remove(QRegExp("\\D")));
    engine.rootContext()->setContextProperty("unlockPassword", UNLOCK_PASSWORD);
    engine.rootContext()->setContextProperty("loggerPath", LOGGER_PATH);
    engine.rootContext()->setContextProperty("qVersion", qVersion());
    engine.rootContext()->setContextProperty("activeSubscription", activeSubscription);
    engine.rootContext()->setContextProperty("testMode", testMode);
    const QUrl url(testMode? QStringLiteral("qrc:/qml/maintest.qml") : QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
