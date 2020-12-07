/*
    Copyright (C) 2020 Aseman Team
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

#include "old/stickermodel.h"
#include "old/stickerwriter.h"

#ifdef Q_OS_MACX
#include "../objective-c/macmanager.h"
#endif

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QTimer>
#ifdef QT_WEBVIEW_LIB
#include <QtWebView>
#endif

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

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);

    qmlRegisterType<MeikadeOfflineItem>("Meikade", 1, 0, "MeikadeOfflineItem");
    qmlRegisterType<MeikadeOfflineItemGlobal>("Meikade", 1, 0, "MeikadeOfflineItemGlobal");
    qmlRegisterType<StickerModel>("Meikade", 1, 0, "StickerModel");
    qmlRegisterType<StickerWriter>("Meikade", 1, 0, "StickerWriter");

#ifdef QT_WEBVIEW_LIB
    QtWebView::initialize();
#endif
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath(":/qml/imports/");
    engine.rootContext()->setContextProperty("isAndroidStyle", androidStyle);
    engine.rootContext()->setContextProperty("appVersion", MEIKADE_VERSION);
    engine.rootContext()->setContextProperty("qVersion", qVersion());
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

#ifdef Q_OS_MACX
    QTimer::singleShot(100, [](){
        MacManager::removeTitlebarFromWindow();
    });
#endif

    return app.exec();
}
