/*
    Copyright (C) 2017 Aseman Team
    http://aseman.co

    Meikade is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Meikade is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <QGuiApplication>
#include <QFont>

#include "meikade.h"

#ifdef Q_OS_MACX
#include "mac/macmanager.h"
#include <QTimer>
#endif

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QGuiApplication::setFont(QFont("IRAN-sans"));

    Meikade meikade;
    meikade.start();

#ifdef Q_OS_MACX
        QTimer::singleShot(1000, [](){
            MacManager::removeTitlebarFromWindow();
        });
#endif

    return app.exec();
}
