CREATE TABLE IF NOT EXISTS [cat] ([id] INTEGER  PRIMARY KEY NOT NULL,[poet_id] INTEGER  NULL,[text] NVARCHAR(100)  NULL,[parent_id] INTEGER  NULL,[url] NVARCHAR(255)  NULL);
CREATE TABLE IF NOT EXISTS poem (
    "id" INTEGER,
    "cat_id" INTEGER,
    "title" NVARCHAR(255),
    "url" NVARCHAR(255)
, "phrase" TEXT   DEFAULT ('null'));
CREATE TABLE IF NOT EXISTS verse (
    "poem_id" INTEGER,
    "vorder" INTEGER,
    "position" INTEGER,
    "text" TEXT
, "poet" INTEGER);
CREATE INDEX IF NOT EXISTS cat_pid ON cat(parent_id ASC);
CREATE INDEX IF NOT EXISTS poem_cid ON poem(cat_id ASC);
CREATE INDEX IF NOT EXISTS verse_pid ON verse(poem_id ASC);
CREATE TABLE IF NOT EXISTS General ("key" TEXT PRIMARY KEY, value TEXT);
CREATE TABLE IF NOT EXISTS poet (id INTEGER PRIMARY KEY NOT NULL, name NVARCHAR (20), cat_id INTEGER, description TEXT, lastUpdate DATETIME DEFAULT NULL);
INSERT OR IGNORE INTO General (key,value) VALUES ("Database/version", 1);
