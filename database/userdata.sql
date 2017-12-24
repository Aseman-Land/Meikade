CREATE TABLE IF NOT EXISTS notes (
    "poem_id" INT NOT NULL,
    "vorder" INT NOT NULL,
    "text" TEXT,
    "date" TEXT NOT NULL,
  PRIMARY KEY (`poem_id`, `vorder`) 
);
CREATE TABLE IF NOT EXISTS favorites (
    "poem_id" INT NOT NULL,
    "vorder" INT NOT NULL,
    "date" TEXT NOT NULL,
  PRIMARY KEY (`poem_id`, `vorder`) 
);
