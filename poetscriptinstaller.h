#ifndef POETSCRIPTINSTALLER_H
#define POETSCRIPTINSTALLER_H

#include <QDateTime>
#include <QObject>

class PoetScriptInstallerPrivate;
class PoetScriptInstaller : public QObject
{
    Q_OBJECT
public:
    PoetScriptInstaller(QObject *parent = 0);
    ~PoetScriptInstaller();

public slots:
    void installFile(const QString &path, int poetId, const QDateTime &date, bool removeFile = true);
    void install(const QString &script, int poetId, const QDateTime &date);

signals:
    void finished(bool error);

private:
    PoetScriptInstallerPrivate *p;
};

#endif // POETSCRIPTINSTALLER_H
