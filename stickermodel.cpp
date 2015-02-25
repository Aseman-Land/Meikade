#include "stickermodel.h"

#include <QUrl>
#include <QColor>

class StickerModelItem
{
public:
    int type;
    QVariant command1;
    QVariant command2;
    QString title;
    QUrl image;
};

class StickerModelPrivate
{
public:
    QList<StickerModelItem> list;
    int state;
};

StickerModel::StickerModel(QObject *parent) :
    QAbstractListModel(parent)
{
    p = new StickerModelPrivate;
    p->state = Category;

    refresh();
}

StickerModelItem StickerModel::itemOf(const QModelIndex &index) const
{
    const int row = index.row();
    return p->list.value(row);
}

int StickerModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return p->list.count();
}

QVariant StickerModel::data(const QModelIndex &index, int role) const
{
    QVariant result;

    const StickerModelItem & item = itemOf(index);
    switch(role)
    {
    case Qt::DisplayRole:
    case NameRole:
        result = item.title;
        break;

    case StateRole:
        result = item.type;
        break;

    case StateCommandRole:
        result = item.command1;
        break;

    case StateCommand2Role:
        result = item.command2;
        break;

    case ItemImageRole:
        result = item.image;
        break;
    }

    return result;
}

QHash<qint32, QByteArray> StickerModel::roleNames() const
{
    QHash<qint32, QByteArray> *res = 0;
    if( res )
        return *res;

    res = new QHash<qint32, QByteArray>();
    res->insert( NameRole, "name");
    res->insert( StateRole, "state");
    res->insert( StateCommandRole, "stateCommand");
    res->insert( StateCommand2Role, "stateCommand2");
    res->insert( ItemImageRole, "itemImage");

    return *res;
}

int StickerModel::count() const
{
    return p->list.count();
}

void StickerModel::setState(int state)
{
    if(p->state == state)
        return;

    p->state = state;
    emit stateChanged();

    refresh();
}

int StickerModel::state() const
{
    return p->state;
}

void StickerModel::refresh()
{
    beginResetModel();
    p->list.clear();

    switch(p->state)
    {
    case Category:
    {
        StickerModelItem size;
        size.title = tr("Size");
        size.command1 = Size;
        size.type = Category;
        size.image = QUrl::fromLocalFile(":/qml/Meikade/stickers/icons/size.png");

        StickerModelItem color;
        color.title = tr("Color");
        color.command1 = Color;
        color.type = Category;
        color.image = QUrl::fromLocalFile(":/qml/Meikade/stickers/icons/color.png");

        StickerModelItem sticker;
        sticker.title = tr("Sticker");
        sticker.command1 = Sticker;
        sticker.type = Category;
        sticker.image = QUrl::fromLocalFile(":/qml/Meikade/stickers/icons/image.png");

        StickerModelItem font;
        font.title = tr("Font");
        font.command1 = Font;
        font.type = Category;
        font.image = QUrl::fromLocalFile(":/qml/Meikade/stickers/icons/font.png");

        StickerModelItem logo;
        logo.title = tr("Logo");
        logo.command1 = Logo;
        logo.type = Category;
        logo.image = QUrl::fromLocalFile(":/qml/Meikade/stickers/icons/logo.png");

        p->list << size;
        p->list << color;
        p->list << sticker;
        p->list << font;
        p->list << logo;
    }
        break;

    case Size:
    {
        StickerModelItem size_1_1;
        size_1_1.title = tr("1:1");
        size_1_1.type = Size;
        size_1_1.command1 = 1;

        StickerModelItem size_4_3;
        size_4_3.title = tr("4:3");
        size_4_3.type = Size;
        size_4_3.command1 = 4.0/3;

        StickerModelItem size_3_4;
        size_3_4.title = tr("3:4");
        size_3_4.type = Size;
        size_3_4.command1 = 3.0/4;

        StickerModelItem size_16_9;
        size_16_9.title = tr("16:9");
        size_16_9.type = Size;
        size_16_9.command1 = 16.0/9;

        StickerModelItem size_16_6;
        size_16_6.title = tr("16:6");
        size_16_6.type = Size;
        size_16_6.command1 = 16.0/6;

        p->list << size_1_1;
        p->list << size_4_3;
        p->list << size_3_4;
        p->list << size_16_9;
        p->list << size_16_6;
    }
        break;

    case Color:
    {
        QStringList backgrounds;
        backgrounds << "#f3f3f3";
        backgrounds << "#435d97";
        backgrounds << "#ebc220";
        backgrounds << "#a13636";
        backgrounds << "#1b1b1b";
        backgrounds << "#3f8529";
        backgrounds << "#3d93aa";

        QStringList foregrounds;
        foregrounds << "#1b1b1b";
        foregrounds << "#f3f3f3";
        foregrounds << "#ebc220";

        foreach(const QString &b, backgrounds)
            foreach(const QString &f, foregrounds)
            {
                if(b == f)
                    continue;

                StickerModelItem color;
                color.type = Color;
                color.command1 = b;
                color.command2 = f;

                p->list << color;
            }
    }
        break;

    case Sticker:
    {
        for(int i=0; i<5; i++)
        {
            StickerModelItem sticker;
            sticker.type = Sticker;
            sticker.image = QUrl::fromLocalFile(QString(":/qml/Meikade/stickers/images/s%1.png").arg(i));
            sticker.command1 = sticker.image;

            p->list << sticker;
        }
    }
        break;

    case Font:
    {
        StickerModelItem font2;
        font2.type = Font;
        font2.title = "B Yekan";
        font2.command1 = "B Yekan";
        font2.command2 = 25;

        StickerModelItem font3;
        font3.type = Font;
        font3.title = "Droid Sans";
        font3.command1 = "Droid Arabic Naskh";
        font3.command2 = 20;

        p->list << font2;
        p->list << font3;
    }
        break;

    case Logo:
    {
        StickerModelItem meikade;
        meikade.type = Logo;
        meikade.title = tr("Meikade Logo");
        meikade.image = QUrl::fromLocalFile(":/qml/Meikade/icons/logo.png");
        meikade.command1 = static_cast<int>(StickerModel::MeikadeLogo);

        StickerModelItem poet;
        poet.type = Logo;
        poet.title = tr("Poet Name");
        poet.image = QUrl::fromLocalFile(":/qml/Meikade/icons/poet.png");
        poet.command1 = static_cast<int>(StickerModel::PoetLogo);

        p->list << meikade;
        p->list << poet;
    }
        break;
    }

    endResetModel();
}

StickerModel::~StickerModel()
{
    delete p;
}

