BEGIN;

ALTER TABLE poet RENAME TO _poet_old_20200526;

CREATE TABLE poet (
  id INTEGER NOT NULL,
  name NVARCHAR (20),
  cat_id INTEGER,
  description TEXT,
  wikipedia TEXT,
  image TEXT,
  color TEXT,
  lastUpdate DATETIME DEFAULT NULL,
  PRIMARY KEY (id)
);

INSERT INTO poet (id, name, cat_id, description, lastUpdate) SELECT id, name, cat_id, description, lastUpdate FROM _poet_old_20200526;
DROP TABLE _poet_old_20200526;

COMMIT;
