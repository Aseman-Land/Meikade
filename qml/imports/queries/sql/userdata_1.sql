BEGIN;

CREATE TABLE IF NOT EXISTS actions (
  poetId INTEGER NOT NULL,
  catId INTEGER NOT NULL,
  poemId INTEGER NOT NULL,
  verseId INTEGER NOT NULL,
  "type" INTEGER NOT NULL,
  declined INTEGER NOT NULL DEFAULT 0,
  value TEXT,
  extra TEXT NOT NULL DEFAULT '',
  updatedAt INTEGER NOT NULL,
  synced INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (poetId, catId, poemId, verseId, type)
);

CREATE INDEX IF NOT EXISTS declined_idx
ON actions (
  declined COLLATE BINARY ASC
);

CREATE INDEX IF NOT EXISTS synced_idx
ON actions (
  synced COLLATE BINARY ASC
);

CREATE INDEX IF NOT EXISTS updated_idx
ON actions (
  updatedAt COLLATE BINARY ASC
);

CREATE INDEX IF NOT EXISTS value_idx
ON actions (
  value COLLATE BINARY ASC
);

INSERT INTO actions (poetId, catId, poemId, verseId, type, declined, value, updatedAt, synced) SELECT 0, 0, poem_id, vorder, 1, 0, 1, date, 0 FROM favorites;
INSERT INTO actions (poetId, catId, poemId, verseId, type, declined, value, updatedAt, synced) SELECT 0, 0, poem_id, vorder, 2, 0, text, date, 0 FROM notes;

COMMIT;
