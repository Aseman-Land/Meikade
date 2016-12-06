#ifndef POETSCRIPTINSTALLERQUEUE_H
#define POETSCRIPTINSTALLERQUEUE_H

#include <QObject>
#include <QDateTime>

class PoetScriptInstallerQueuePrivate;
class PoetScriptInstallerQueue : public QObject
{
    Q_OBJECT
public:
    PoetScriptInstallerQueue(QObject *parent = 0);
    ~PoetScriptInstallerQueue();

    bool isActive();

public slots:
    void append(const QString &file, const QString &guid, int poetId, const QDateTime &date);

signals:
    void error(const QString &file, const QString &guid);
    void finished(const QString &file, const QString &guid);

private slots:
    void finished(bool error);

private:
    void next();
    void init_core();

private:
    PoetScriptInstallerQueuePrivate *p;
};

#endif // POETSCRIPTINSTALLERQUEUE_H
