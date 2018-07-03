#ifndef MACMANAGER_H
#define MACMANAGER_H


#include <QGuiApplication>
#include <QWindow>

class MacManager
{
    public:
        static void removeTitlebarFromWindow(long winId = -1);
};
#endif // MACMANAGER_H
