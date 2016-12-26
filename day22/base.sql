
CREATE TABLE IF NOT EXISTS advent_cluster (
  x INTEGER NOT NULL,
  y INTEGER NOT NULL,
  total_space INTEGER NOT NULL,
  used INTEGER NOT NULL,
  available INTEGER NOT NULL
);

TRUNCATE advent_cluster;
