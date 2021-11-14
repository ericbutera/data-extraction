-- https://drill.apache.org/docs/text-files-csv-tsv-psv/
-- https://stackoverflow.com/a/45803449/261272

ALTER SESSION SET `exec.errors.verbose` = true

EXPLAIN PLAN FOR
SELECT 
  CAST(COLUMNS[0] AS DOUBLE) AS LATITUDE,
  CAST(COLUMNS[1] AS DOUBLE) AS LONGITUDE,
  CAST(COLUMNS[2] AS INT) AS DURATION,
  -- i cannot get this to cast as TIMESTAMP
  -- 
  COLUMNS[3] AS RISE_TIME 
FROM TABLE(dfs.`/usr/src/shared/extracts/extract_rest.csv`(type => 'text', fieldDelimiter => '|'));
 
-- TO_TIMESTAMP(CAST(COLUMNS[3] AS INT)) AS RISE_TIME
-- CAST(COLUMNS[3] AS TIMESTAMP) AS RISE_TIME
-- select TO_DATE('1636852087');
-- select TO_TIMESTAMP(1636852087);