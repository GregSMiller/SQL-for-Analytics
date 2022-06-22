CREATE EXTERNAL TABLE IF NOT EXISTS `formula1`.`races` (
  `raceid` int,
  `year` int,
  `round` int,
  `circuitid` int,
  `name` string,
  `date` date,
  `time` timestamp,
  `url` string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' 
WITH SERDEPROPERTIES (
  'serialization.format' = ',',
  'field.delim' = ','
) LOCATION 's3://formula1-gmiller/races/'
TBLPROPERTIES ('has_encrypted_data'='false');
