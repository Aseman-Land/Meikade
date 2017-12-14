BEGIN TRANSACTION;

CREATE TABLE poem_tmp ("id" INTEGER, "cat_id" INTEGER, "title" NVARCHAR(255), "url" NVARCHAR(255), "phrase" TEXT DEFAULT (0));
INSERT INTO poem_tmp SELECT *, null FROM poem;
DROP TABLE poem;
CREATE TABLE poem ("id" INTEGER, "cat_id" INTEGER, "title" NVARCHAR(255), "url" NVARCHAR(255), "phrase" TEXT DEFAULT (0));
INSERT INTO poem SELECT * FROM poem_tmp;
DROP TABLE poem_tmp;

CREATE TABLE poet_tmp (id INTEGER PRIMARY KEY NOT NULL, name NVARCHAR (20), cat_id INTEGER, description TEXT, lastUpdate DATETIME DEFAULT NULL);
INSERT INTO poet_tmp SELECT *, null FROM poet;
DROP TABLE poet;
CREATE TABLE poet (id INTEGER PRIMARY KEY NOT NULL, name NVARCHAR (20), cat_id INTEGER, description TEXT, lastUpdate DATETIME DEFAULT NULL);
INSERT INTO poet SELECT * FROM poet_tmp;
DROP TABLE poet_tmp;

CREATE TABLE verse_tmp ( "poem_id" INTEGER, "vorder" INTEGER, "position" INTEGER, "text" TEXT, "poet" INTEGER DEFAULT (0));
INSERT INTO verse_tmp SELECT *, null FROM verse;
DROP TABLE verse;
CREATE TABLE verse ( "poem_id" INTEGER, "vorder" INTEGER, "position" INTEGER, "text" TEXT, "poet" INTEGER DEFAULT (0));
INSERT INTO verse SELECT * FROM verse_tmp;
DROP TABLE verse_tmp;
UPDATE verse SET poet=(SELECT id FROM poet LIMIT 1);

COMMIT;
