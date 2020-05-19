BEGIN;

CREATE TABLE IF NOT EXISTS offline (
  poet_id INTEGER,
  cat_id INTEGER,
  state INTEGER NOT NULL,
  PRIMARY KEY (poet_id, cat_id)
);

CREATE INDEX cat_poetId
ON cat (
  poet_id COLLATE BINARY ASC
);
CREATE INDEX cat_text
ON cat (
  text COLLATE BINARY ASC
);
CREATE INDEX offline_state
ON offline (
  state COLLATE BINARY ASC
);

INSERT INTO offline (poet_id, cat_id, state) SELECT id, 0, 1 FROM poet;

COMMIT;
