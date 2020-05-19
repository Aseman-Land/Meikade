BEGIN;

CREATE TABLE IF NOT EXISTS General (
  "key" TEXT,
  "value" TEXT,
  PRIMARY KEY ("key")
);

CREATE TABLE IF NOT EXISTS cat (
  id INTEGER NOT NULL,
  poet_id INTEGER,
  text NVARCHAR(100),
  parent_id INTEGER,
  url NVARCHAR(255),
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS poem (
  id INTEGER,
  cat_id INTEGER,
  title NVARCHAR(255),
  url NVARCHAR(255),
  phrase TEXT DEFAULT ('null')
);

CREATE TABLE IF NOT EXISTS poet (
  id INTEGER NOT NULL,
  name NVARCHAR (20),
  cat_id INTEGER,
  description TEXT,
  lastUpdate DATETIME DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS verse (
  poem_id INTEGER,
  vorder INTEGER,
  position INTEGER,
  text TEXT,
  poet INTEGER
);

CREATE INDEX cat_pid
ON cat (
  parent_id ASC
);

CREATE INDEX poem_cid
ON poem (
  cat_id ASC
);

CREATE INDEX verse_pid
ON verse (
  poem_id ASC
);

COMMIT;
