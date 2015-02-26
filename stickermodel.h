#ifndef STICKERMODEL_H
#define STICKERMODEL_H

#include <QAbstractListModel>

class StickerModelItem;
class StickerModelPrivate;
class StickerModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(int state READ state WRITE setState NOTIFY stateChanged)

    Q_ENUMS(State)
    Q_ENUMS(LogoTypes)
    Q_ENUMS(StickerType)

public:
    enum ColorfullListModelRoles {
        NameRole = Qt::UserRole,
        StateRole,
        StateCommandRole,
        StateCommand2Role,
        ItemImageRole
    };

    enum State {
        Category,
        Sticker,
        Color,
        Size,
        Font,
        Logo
    };

    enum LogoTypes {
        PoetLogo,
        MeikadeLogo
    };

    enum StickerType {
        StickerDouble = 0,
        StickerTopRight = 1,
        StickerBottomLeft
    };

    StickerModel(QObject *parent = 0);
    ~StickerModel();

    StickerModelItem itemOf( const QModelIndex &index ) const;

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;

    QHash<qint32,QByteArray> roleNames() const;
    int count() const;

    void setState(int state);
    int state() const;

    void setFontSize(int sz);
    int fontSize() const;

    void setFontFamily(const QString &f);
    QString fontFamily() const;

public slots:
    void refresh();

signals:
    void countChanged();
    void stateChanged();

private:
    StickerModelPrivate *p;
};

#endif // STICKERMODEL_H
