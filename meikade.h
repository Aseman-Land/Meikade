/*
    Copyright (C) 2015 Nile Group
    http://nilegroup.org

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

#ifndef MEIKADE_H
#define MEIKADE_H

#include <QObject>
#include <QSettings>
#include <QStringList>

class QQuickItem;
class QSettings;
class MeikadeDatabase;
class MeikadePrivate;
class Meikade : public QObject
{
    Q_PROPERTY(QString poemsFont READ poemsFont WRITE setPoemsFont NOTIFY poemsFontChanged)
    Q_PROPERTY(bool animations READ animations WRITE setAnimations NOTIFY animationsChanged)
    Q_PROPERTY(QString resourcePath READ resourcePath NOTIFY resourcePathChanged)
    Q_PROPERTY(QString currentLanguage READ currentLanguage WRITE setCurrentLanguage NOTIFY currentLanguageChanged)
    Q_PROPERTY(int runCount READ runCount WRITE setRunCount NOTIFY runCountChanged)
    Q_PROPERTY( int  languageDirection  READ languageDirection NOTIFY languageDirectionChanged )
    Q_PROPERTY(bool nightTheme READ nightTheme WRITE setNightTheme NOTIFY nightThemeChanged)
    Q_PROPERTY(bool keepScreenOn READ keepScreenOn WRITE setKeepScreenOn NOTIFY keepScreenOnChanged)
    Q_PROPERTY(bool phrase READ phrase WRITE setPhrase NOTIFY phraseChanged)
    Q_PROPERTY(bool activePush READ activePush WRITE setActivePush NOTIFY activePushChanged)
    Q_OBJECT

public:
    Meikade(QObject *parent = 0);
    ~Meikade();

    Q_INVOKABLE bool fileExists( const QString & file );

    Q_INVOKABLE QChar convertChar( const QChar & ch );
    Q_INVOKABLE QString numberToArabicString( int number );
    Q_INVOKABLE bool endUsingNumber(const QString &str);

    Q_INVOKABLE QStringList findBackups();
    Q_INVOKABLE QString fileName( const QString & path );
    Q_INVOKABLE QString fileSuffix( const QString & path );

    Q_INVOKABLE QStringList availableFonts();
    Q_INVOKABLE qreal fontPointScale( const QString & fontName );

    Q_INVOKABLE QStringList languages();
    Q_INVOKABLE void setCurrentLanguage( const QString & lang );
    Q_INVOKABLE QString currentLanguage() const;

    Q_INVOKABLE QQuickItem *createObject(const QString &code);

    MeikadeDatabase *database() const;

    static QString resourcePathAbs();
    static QString resourcePath();
    static Meikade *instance();

    Q_INVOKABLE int languageDirection();

    Q_INVOKABLE qint64 mSecsSinceEpoch() const;

    Q_INVOKABLE void removeFile( const QString & path );

    Q_INVOKABLE void setProperty( QObject *obj, const QString & property, const QVariant & v );
    Q_INVOKABLE QVariant property( QObject *obj, const QString & property );

    Q_INVOKABLE void setAnimations( bool stt );
    Q_INVOKABLE bool animations() const;

    void setNightTheme( bool stt );
    bool nightTheme() const;

    Q_INVOKABLE void setMeikadeNews(int i, bool stt);
    Q_INVOKABLE bool meikadeNews(int i) const;

    void setKeepScreenOn(bool stt, bool force = false);
    bool keepScreenOn() const;

    void setPhrase(bool stt);
    bool phrase() const;

    void setActivePush(bool stt);
    bool activePush() const;

    Q_INVOKABLE QString aboutHafezOmen() const;

    void setPoemsFont( const QString & name );
    QString poemsFont() const;

    int runCount() const;
    void setRunCount( int cnt );

    static QSettings *settings();

public slots:
    void start();
    void close();

    void timer( int interval, QObject *obj, const QString & member );

signals:
    void closeRequest();
    void poemsFontChanged();
    void animationsChanged();
    void nightThemeChanged();
    void keepScreenOnChanged();
    void phraseChanged();
    void activePushChanged();

    void currentLanguageChanged();
    void languageDirectionChanged();
    void resourcePathChanged();

    void runCountChanged();

protected:
    bool eventFilter(QObject *o, QEvent *e);

private:
    void init_languages();

private:
    MeikadePrivate *p;
};

#endif // MEIKADE_H
