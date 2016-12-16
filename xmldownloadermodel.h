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

#ifndef XMLDOWNLOADERMODEL_H
#define XMLDOWNLOADERMODEL_H

#include <QAbstractListModel>
#include <QStringList>

class XmlDownloaderModelUnit;
class XmlDownloaderModelPrivate;
class XmlDownloaderModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QStringList errors READ errors NOTIFY errorsChanged)
    Q_PROPERTY(bool refreshing READ refreshing NOTIFY refreshingChanged)
    Q_PROPERTY(bool processing READ processing NOTIFY processingChanged)

public:
    enum DataRoles {
        DataRolePoetId = Qt::UserRole,
        DataRolePoetName,
        DataRolePoetType,
        DataRoleFileDownloadUrl,
        DataRoleFileMimeType,
        DataRoleFileThumbUrl,
        DataRoleFileSize,
        DataRoleFileThumbSize,
        DataRoleFilePublicDate,
        DataRoleFileGuid,
        DataRoleFileCompressMethod,
        DataRoleRemovingState,
        DataRoleDownloadedStatus,
        DataRoleDownloadingState,
        DataRoleDownloadError,
        DataRoleDownloadedBytes,
        DataRoleInstalled,
        DataRoleUpdateAvailable,
        DataRoleInstalling
    };

    XmlDownloaderModel(QObject *parent = 0);
    ~XmlDownloaderModel();

    XmlDownloaderModelUnit &itemOf( const QModelIndex &index ) const;
    bool contains(int poetId) const;
    int indexOf(const QString &guid) const;

    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::DisplayRole);

    QHash<qint32,QByteArray> roleNames() const;
    int count() const;

    QStringList errors() const;
    bool refreshing() const;
    bool processing() const;

public slots:
    void refresh();
    void loadInstalleds();

signals:
    void countChanged();
    void errorsChanged();
    void refreshingChanged();
    void processingChanged();
    void listChanged();

private slots:
    void error( const QStringList & error );
    void finished( const QByteArray & data );
    void fileError( const QStringList & error );
    void fileFinished( const QByteArray & data );
    void fileRecievedBytesChanged();

    void installerError(const QString &file, const QString &guid);
    void installerFinished(const QString &file, const QString &guid);
    void removeError(const QString &guid);
    void removeFinished(const QString &guid);

private:
    void startDownload(const QModelIndex &index);
    void stopDownload(const QModelIndex &index);
    void startRemoving(const QModelIndex &index);

    void changed(const QList<XmlDownloaderModelUnit> &list);

private:
    XmlDownloaderModelPrivate *p;
};

#endif // XMLDOWNLOADERMODEL_H
