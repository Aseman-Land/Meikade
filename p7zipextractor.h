/*
    Copyright (C) 2014 Aseman Labs
    http://labs.aseman.org

    This project is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This project is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef P7ZIPEXTRACTOR_H
#define P7ZIPEXTRACTOR_H

#include <QObject>

class P7ZipExtractorPrivate;
class P7ZipExtractor : public QObject
{
    Q_OBJECT
public:
    P7ZipExtractor(QObject *parent = 0);
    ~P7ZipExtractor();

public slots:
    void extract(const QString & path, const QString &dest);

private:
    P7ZipExtractorPrivate *p;
};

#endif // P7ZIPEXTRACTOR_H
