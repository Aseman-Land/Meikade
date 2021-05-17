#include "delegatedataanalizer.h"

#include <QBuffer>
#include <QDataStream>
#include <QCryptographicHash>
#include <QFileInfo>
#include <QDir>
#include <QGraphicsEffect>
#include <QGraphicsScene>
#include <QGraphicsPixmapItem>
#include <QPainter>
#include <QRunnable>
#include <QThreadPool>
#include <QPointer>
#include <QImageWriter>
#include <QGuiApplication>

QMutex DelegateDataAnalizer::mImageResultMutex;
QThreadPool *DelegateDataAnalizer::mThreadPool = Q_NULLPTR;

DelegateDataAnalizer::DelegateDataAnalizer(QObject *parent)
    : QObject(parent)
    , mRadius(0)
    , mBlur(0)
    , mColorAnalizer(false)
{
    mColorAnalizerObj = Q_NULLPTR;

    mReloadImageTimer = new QTimer(this);
    mReloadImageTimer->setInterval(10);
    mReloadImageTimer->setSingleShot(true);

    mReloadColorTimer = new QTimer(this);
    mReloadColorTimer->setInterval(10);
    mReloadColorTimer->setSingleShot(true);

    connect(mReloadImageTimer, &QTimer::timeout, this, &DelegateDataAnalizer::reload_image);
    connect(mReloadColorTimer, &QTimer::timeout, this, &DelegateDataAnalizer::reload_color);
}

DelegateDataAnalizer::~DelegateDataAnalizer()
{
    QMutexLocker locker(&mImageResultMutex);
}

QUrl DelegateDataAnalizer::source() const
{
    return mSource;
}

void DelegateDataAnalizer::setSource(const QUrl &source)
{
    if (source == mSource)
        return;

    mSource = source;
    reload();
    Q_EMIT sourceChanged();
}

QString DelegateDataAnalizer::cachePath() const
{
    return mCachePath;
}

void DelegateDataAnalizer::setCachePath(const QString &cachePath)
{
    if (mCachePath == cachePath)
        return;

    mCachePath = cachePath;
    reload();
    Q_EMIT cachePathChanged();
}

qreal DelegateDataAnalizer::blur() const
{
    return mBlur;
}

void DelegateDataAnalizer::setBlur(const qreal &blur)
{
    if (mBlur == blur)
        return;

    mBlur = blur;
    reload();
    Q_EMIT blurChanged();
}

bool DelegateDataAnalizer::colorAnalizer() const
{
    return mColorAnalizer;
}

void DelegateDataAnalizer::setColorAnalizer(bool colorAnalizer)
{
    if (mColorAnalizer == colorAnalizer)
        return;

    mColorAnalizer = colorAnalizer;
    reload();
    Q_EMIT colorAnalizerChanged();
}

qreal DelegateDataAnalizer::radius() const
{
    return mRadius;
}

void DelegateDataAnalizer::setRadius(const qreal &radius)
{
    if (mRadius == radius)
        return;

    mRadius = radius;
    reload();
    Q_EMIT radiusChanged();
}

QSize DelegateDataAnalizer::size() const
{
    return mSize;
}

void DelegateDataAnalizer::setSize(const QSize &size)
{
    if (mSize == size)
        return;

    mSize = size;
    reload();
    Q_EMIT sizeChanged();
}

QUrl DelegateDataAnalizer::imageResult() const
{
    QMutexLocker locker(&mImageResultMutex);
    return mImageResult;
}

void DelegateDataAnalizer::setImageResult(const QUrl &result)
{
    if (mImageResult == result)
        return;

    mImageResult = result;
    Q_EMIT QMetaObject::invokeMethod(this, "imageResultChanged", Qt::QueuedConnection);
}

QColor DelegateDataAnalizer::color() const
{
    return mColor.isValid()? mColor : mDefaultColor;
}

QColor DelegateDataAnalizer::textColor() const
{
    auto c = color();
    if ((c.red() + c.green() + c.blue()) / 3 < 192)
        return QColor("#ffffff");
    else
        return QColor("#333333");
}

void DelegateDataAnalizer::setColor(const QColor &color)
{
    if (mColor == color)
        return;

    mColor = color;
    Q_EMIT colorChanged();
}

void DelegateDataAnalizer::reload()
{
    if (mSource.isEmpty())
        return;

    if (mBlur || mRadius)
    {
        mReloadImageTimer->stop();
        mReloadImageTimer->start();
    }

    if (mColorAnalizer)
    {
        mReloadColorTimer->stop();
        mReloadColorTimer->start();
    }
}

void DelegateDataAnalizer::reload_image()
{
    const auto image_key = getKey(mSource, QList<qint32>() << mRadius*(100) << mBlur*(100));
    const auto image_path = mCachePath + "/" + image_key + ".png";
    if (QFileInfo::exists(image_path))
    {
        setImageResult(QUrl::fromLocalFile(image_path));
        return;
    }

    class AnalizerRunnable: public QRunnable
    {
    public:
        QSize size;
        qreal blur;
        qreal radius;
        QString image_path;
        QString path;
        QPointer<DelegateDataAnalizer> dis;

        void run() {
            if (!dis)
                return;

            QImage img(path);

            if (!size.isNull()) img = img.scaled(size);
            if (blur) img = DelegateDataAnalizer::blurred(img, img.rect(), blur);
            if (radius) img = DelegateDataAnalizer::rounded(img, radius);

            QImageWriter writer(image_path);
            writer.write(img);

            mImageResultMutex.lock();
            if (dis)
                dis->setImageResult(QUrl::fromLocalFile(image_path));
            mImageResultMutex.unlock();
        };
    };

    auto runnable = new AnalizerRunnable;
    runnable->size = mSize * qGuiApp->devicePixelRatio();
    runnable->blur = mBlur;
    runnable->radius = mRadius * qGuiApp->devicePixelRatio();
    runnable->image_path = image_path;
    runnable->path = mSource.toLocalFile();
    runnable->dis = this;
    runnable->setAutoDelete(true);

    if (!mThreadPool)
        mThreadPool = new QThreadPool();
    
    mThreadPool->start(runnable);
}

void DelegateDataAnalizer::reload_color()
{
    const auto color_key = getKey(mSource, QString("color"));
    const auto color_path = mCachePath + "/" + color_key + ".color";
    if (QFileInfo::exists(color_path))
    {
        QFile f(color_path);
        if (f.open(QFile::ReadOnly))
        {
            QColor color = QString::fromUtf8( f.readAll().trimmed() );
            if (color.isValid())
            {
                setColor(color);
                return;
            }
        }
    }
    
     if (!mColorAnalizerObj)
     {
         mColorAnalizerObj = new QAsemanImageColorAnalizor(this);
         connect(mColorAnalizerObj, &QAsemanImageColorAnalizor::colorChanged, this, &DelegateDataAnalizer::color_updated);
     }
    
    mColorAnalizerObj->setSource(mSource);
}

void DelegateDataAnalizer::color_updated()
{
    auto color = mColorAnalizerObj->color();

    const auto color_key = getKey(mSource, QString("color"));
    const auto color_path = mCachePath + "/" + color_key + ".color";

    QFile f(color_path);
    if (f.open(QFile::WriteOnly))
    {
        f.write(color.name().toUtf8());
        f.close();
    }

    setColor(color);
}

QColor DelegateDataAnalizer::defaultColor() const
{
    return mDefaultColor;
}

void DelegateDataAnalizer::setDefaultColor(const QColor &defaultColor)
{
    if (mDefaultColor == defaultColor)
        return;

    mDefaultColor = defaultColor;
    Q_EMIT defaultColorChanged();
    Q_EMIT colorChanged();
}

template<typename T>
QString DelegateDataAnalizer::getKey(const QUrl &source, T value)
{
    QByteArray res;
    QDataStream stream(&res, QIODevice::WriteOnly);
    stream << QFileInfo(source.toString()).fileName();
    stream << value;

    return "analizer_cache_" + QCryptographicHash::hash(res, QCryptographicHash::Md5).toHex();
}

QImage DelegateDataAnalizer::applyEffectToImage(const QImage &src, QGraphicsEffect *effect, int extent)
{
    if(src.isNull() || !effect)
        return src;

    QImage res(src.size() + QSize(extent*2, extent*2), QImage::Format_ARGB32);
    res.fill(Qt::transparent);

    QPainter ptr(&res);

    QGraphicsPixmapItem item;
    item.setPixmap(QPixmap::fromImage(src));
    item.setGraphicsEffect(effect);

    QGraphicsScene scene;
    scene.addItem(&item);
    scene.render(&ptr, QRectF(), QRectF( -extent, -extent, src.width()+extent*2, src.height()+extent*2 ) );

    return res;
}

QImage DelegateDataAnalizer::blurred(const QImage& image, const QRect& rect, int radius, bool alphaOnly)
{
    int tab[] = { 14, 10, 8, 6, 5, 5, 4, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2 };
    int alpha = (radius < 1)  ? 16 : (radius > 17) ? 1 : tab[radius-1];

    QImage result = image.convertToFormat(QImage::Format_ARGB32_Premultiplied);
    int r1 = rect.top();
    int r2 = rect.bottom();
    int c1 = rect.left();
    int c2 = rect.right();

    int bpl = result.bytesPerLine();
    int rgba[4];
    unsigned char* p;

    int i1 = 0;
    int i2 = 3;

    if (alphaOnly)
        i1 = i2 = (QSysInfo::ByteOrder == QSysInfo::BigEndian ? 0 : 3);

    for (int col = c1; col <= c2; col++) {
        p = result.scanLine(r1) + col * 4;
        for (int i = i1; i <= i2; i++)
            rgba[i] = p[i] << 4;

        p += bpl;
        for (int j = r1; j < r2; j++, p += bpl)
            for (int i = i1; i <= i2; i++)
                p[i] = (rgba[i] += ((p[i] << 4) - rgba[i]) * alpha / 16) >> 4;
    }

    for (int row = r1; row <= r2; row++) {
        p = result.scanLine(row) + c1 * 4;
        for (int i = i1; i <= i2; i++)
            rgba[i] = p[i] << 4;

        p += 4;
        for (int j = c1; j < c2; j++, p += 4)
            for (int i = i1; i <= i2; i++)
                p[i] = (rgba[i] += ((p[i] << 4) - rgba[i]) * alpha / 16) >> 4;
    }

    for (int col = c1; col <= c2; col++) {
        p = result.scanLine(r2) + col * 4;
        for (int i = i1; i <= i2; i++)
            rgba[i] = p[i] << 4;

        p -= bpl;
        for (int j = r1; j < r2; j++, p -= bpl)
            for (int i = i1; i <= i2; i++)
                p[i] = (rgba[i] += ((p[i] << 4) - rgba[i]) * alpha / 16) >> 4;
    }

    for (int row = r1; row <= r2; row++) {
        p = result.scanLine(row) + c2 * 4;
        for (int i = i1; i <= i2; i++)
            rgba[i] = p[i] << 4;

        p -= 4;
        for (int j = c1; j < c2; j++, p -= 4)
            for (int i = i1; i <= i2; i++)
                p[i] = (rgba[i] += ((p[i] << 4) - rgba[i]) * alpha / 16) >> 4;
    }

    return result;
}

QImage DelegateDataAnalizer::rounded(const QImage &image, int radius)
{
    QImage result(image.size(), QImage::Format_ARGB32);
    result.fill(QColor(0,0,0,0));

    QPainterPath path;
    path.addRoundedRect(image.rect(), radius, radius);

    QPainter painter(&result);
    painter.setRenderHint(QPainter::SmoothPixmapTransform);
    painter.setClipPath(path);
    painter.drawImage(QPoint(0,0), image);

    return result;
}
