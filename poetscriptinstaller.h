#ifndef POETSCRIPTINSTALLER_H
#define POETSCRIPTINSTALLER_H

#include <QObject>

class PoetScriptInstallerPrivate;
class PoetScriptInstaller : public QObject
{
    Q_OBJECT
public:
    PoetScriptInstaller(QObject *parent = 0);
    ~PoetScriptInstaller();

public slots:
    void installFile(const QString &path, bool removeFile = true);
    void install(const QString &script);
    void removePoet(int poet_id);

signals:
    void finished(bool error);

private:
    void removePoem(int poet_id);
    void removeCatChild(int parent_id);

private:
    PoetScriptInstallerPrivate *p;
};

#endif // POETSCRIPTINSTALLER_H
