#ifndef POETIMAGEPROVIDER_H
#define POETIMAGEPROVIDER_H

#include <QObject>
#include <QUrl>

class PoetImageProviderPrivate;
class PoetImageProvider : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int poet READ poet WRITE setPoet NOTIFY poetChanged)
    Q_PROPERTY(QUrl path READ path NOTIFY pathChanged)

public:
    PoetImageProvider(QObject *parent = 0);
    ~PoetImageProvider();

    void setPoet(int poet);
    int poet() const;

    QUrl path() const;

public slots:
    void refresh();

signals:
    void poetChanged();
    void pathChanged();

private slots:
    void finished( const QByteArray & data );

private:
    PoetImageProviderPrivate *p;
};

#endif // POETIMAGEPROVIDER_H
