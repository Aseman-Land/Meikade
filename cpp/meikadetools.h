#ifndef MEIKADETOOLS_H
#define MEIKADETOOLS_H

#include <QObject>
#include <QColor>

class MeikadeTools : public QObject
{
    Q_OBJECT
public:
    MeikadeTools(QObject *parent = Q_NULLPTR);

public Q_SLOTS:
    void setupWindowColor(QColor color);

};

#endif // MEIKADETOOLS_H
