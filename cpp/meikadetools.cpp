#include "meikadetools.h"
#include <QTimer>

#ifdef Q_OS_MACX
#include "objective-c/macmanager.h"
#endif

MeikadeTools::MeikadeTools(QObject *parent) :
    QObject(parent)
{

}

void MeikadeTools::setupWindowColor(QColor color)
{
#ifdef Q_OS_MACX
    QTimer::singleShot(100, [color](){
        MacManager::removeTitlebarFromWindow(color.redF(), color.greenF(), color.blueF());
    });
#endif
}
