SELECT COUNT(*) AS num_viable FROM (
  SELECT
    t1.x AS x1,
    t1.y AS y1,
    t1.used AS used1,
    t2.x AS x2,
    t2.y AS y2,
    t2.available AS avail2
  FROM
    advent_cluster AS t1,
    advent_cluster AS t2
  WHERE
    NOT (t1.x = t2.x AND t1.y = t2.y)
    AND t1.used != 0
    AND t1.used < t2.available) AS viables;
