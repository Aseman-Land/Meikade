CREATE TABLE IF NOT EXISTS general (
  _key TEXT NOT NULL,
  _value TEXT NOT NULL,
  PRIMARY KEY (_key)
);

CREATE INDEX IF NOT EXISTS keys_index
ON general (
  _key COLLATE BINARY ASC
);
