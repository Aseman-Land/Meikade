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

#include "stickermodel.h"

#include <QUrl>
#include <QColor>
#include <QDir>

typedef QPair<QString,QString> PairString;

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

        StickerModelItem image;
        image.title = tr("Image");
        image.command1 = OpenImage;
        image.type = Category;
        image.image = QUrl::fromLocalFile(":/qml/Meikade/stickers/icons/open.png");

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
        p->list << image;
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
        QList<PairString> colors;
        colors << PairString("#f3f3f3", "#1b1b1b");
        colors << PairString("#f3f3f3", "#ebc220");
        colors << PairString("#f3f3f3", "#0d80ec");
        colors << PairString("#f3f3f3", "#a13636");

        colors << PairString("#435d97", "#1b1b1b");
        colors << PairString("#435d97", "#fbfbfb");
        colors << PairString("#435d97", "#ebc220");

        colors << PairString("#ebc220", "#1b1b1b");
        colors << PairString("#ebc220", "#fbfbfb");

        colors << PairString("#a13636", "#1b1b1b");
        colors << PairString("#a13636", "#fbfbfb");
        colors << PairString("#a13636", "#ebc220");

        colors << PairString("#1b1b1b", "#fbfbfb");
        colors << PairString("#1b1b1b", "#ebc220");

        colors << PairString("#3f8529", "#1b1b1b");
        colors << PairString("#3f8529", "#fbfbfb");
        colors << PairString("#3f8529", "#ebc220");

        colors << PairString("#3d93aa", "#1b1b1b");
        colors << PairString("#3d93aa", "#fbfbfb");
        colors << PairString("#3d93aa", "#ebc220");

        colors << PairString("#bcd014", "#1b1b1b");
        colors << PairString("#bcd014", "#fbfbfb");

        colors << PairString("#a43f95", "#1b1b1b");
        colors << PairString("#a43f95", "#fbfbfb");
        colors << PairString("#a43f95", "#ebc220");

        colors << PairString("#f8c4c4", "#1b1b1b");
        colors << PairString("#f8c4c4", "#fbfbfb");

        colors << PairString("#ba9850", "#1b1b1b");
        colors << PairString("#ba9850", "#fbfbfb");

        colors << PairString("#0d80ec", "#1b1b1b");
        colors << PairString("#0d80ec", "#fbfbfb");
        colors << PairString("#0d80ec", "#ebc220");

        for(const PairString &c: colors)
        {
            StickerModelItem color;
            color.type = Color;
            color.command1 = c.first;
            color.command2 = c.second;

            p->list << color;
        }
    }
        break;

    case Sticker:
    {
        const QStringList & files = QDir(":/qml/Meikade/stickers/images/").entryList(QDir::Files, QDir::Name);
        for(const QString &f: files)
        {
            QString path = ":/qml/Meikade/stickers/images/"+f;
            QFileInfo file(path);
            const QStringList &parts = file.baseName().split("_",QString::SkipEmptyParts);
            if(parts.count() != 2)
                continue;

            StickerModelItem sticker;
            sticker.type = Sticker;
            sticker.image = QUrl::fromLocalFile(path);
            sticker.command1 = sticker.image;
            sticker.command2 = parts.first().toInt();

            p->list << sticker;
        }
    }
        break;

    case Font:
    {
        StickerModelItem font1;
        font1.type = Font;
        font1.title = "Iran Sans";
        font1.command1 = "IRAN-Sans";
        font1.command2 = 18;

        StickerModelItem font2;
        font2.type = Font;
        font2.title = "B Yekan";
        font2.command1 = "B Yekan";
        font2.command2 = 23;

        StickerModelItem font3;
        font3.type = Font;
        font3.title = "Droid Sans";
        font3.command1 = "Droid Arabic Naskh";
        font3.command2 = 20;

        p->list << font2;
        p->list << font1;
//        p->list << font3;
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
