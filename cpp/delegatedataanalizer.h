#ifndef DELEGATEDATAANALIZER_H
#define DELEGATEDATAANALIZER_H

#include <QColor>
#include <QObject>
#include <QUrl>
#include <QTimer>
#include <QImage>
#include <QMutex>
#include <QThreadPool>

#include <QAsemanImageColorAnalizor>

class QGraphicsEffect;
class DelegateDataAnalizer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString cachePath READ cachePath WRITE setCachePath NOTIFY cachePathChanged)
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(qreal blur READ blur WRITE setBlur NOTIFY blurChanged)
    Q_PROPERTY(qreal radius READ radius WRITE setRadius NOTIFY radiusChanged)
    Q_PROPERTY(QSize size READ size WRITE setSize NOTIFY sizeChanged)
    Q_PROPERTY(QColor defaultColor READ defaultColor WRITE setDefaultColor NOTIFY defaultColorChanged)
    Q_PROPERTY(bool colorAnalizer READ colorAnalizer WRITE setColorAnalizer NOTIFY colorAnalizerChanged)
    Q_PROPERTY(QUrl imageResult READ imageResult NOTIFY imageResultChanged)
    Q_PROPERTY(QColor color READ color NOTIFY colorChanged)
    Q_PROPERTY(QColor textColor READ textColor NOTIFY colorChanged)

public:
    DelegateDataAnalizer(QObject *parent = Q_NULLPTR);
    virtual ~DelegateDataAnalizer();

    QUrl source() const;
    void setSource(const QUrl &source);

    QUrl imageResult() const;
    QColor color() const;
    QColor textColor() const;

    qreal radius() const;
    void setRadius(const qreal &radius);

    qreal blur() const;
    void setBlur(const qreal &blur);

    QString cachePath() const;
    void setCachePath(const QString &cachePath);

    bool colorAnalizer() const;
    void setColorAnalizer(bool colorAnalizer);

    QColor defaultColor() const;
    void setDefaultColor(const QColor &defaultColor);

    QSize size() const;
    void setSize(const QSize &size);

public Q_SLOTS:
    void reload();

Q_SIGNALS:
    void sourceChanged();
    void imageResultChanged();
    void colorChanged();
    void radiusChanged();
    void blurChanged();
    void radiusedImageChanged();
    void cachePathChanged();
    void colorAnalizerChanged();
    void defaultColorChanged();
    void sizeChanged();

protected:
    void setImageResult(const QUrl &result);
    void setColor(const QColor &color);

private:
    void reload_image();
    void reload_color();
    void color_updated();

    template<typename T>
    QString getKey(const QUrl &source, T value);
    static QImage applyEffectToImage(const QImage &src, QGraphicsEffect *effect, int extent);
    static QImage blurred(const QImage& image, const QRect& rect, int radius, bool alphaOnly = false);
    static QImage rounded(const QImage& image, int radius);

private:
    QString mCachePath;
    QUrl mSource;
    qreal mRadius;
    qreal mBlur;
    QSize mSize;
    QColor mDefaultColor;
    bool mColorAnalizer;

    static QMutex mImageResultMutex;
    static QThreadPool *mThreadPool;

    QUrl mImageResult;
    QColor mColor;

    QTimer *mReloadImageTimer;
    QTimer *mReloadColorTimer;
    QAsemanImageColorAnalizor *mColorAnalizerObj;
};

#endif // DELEGATEDATAANALIZER_H
