# data pipelines pocket reference
- this project contains
  - minio as "fake s3"
  - postgres8 as "redshift"
  - mysql as database

## workflow
1. OLTP db contains real-time production data
2. run extract_mysql_*.py to create *.csv
   1. possibly use replica to not crash prod
   2. utilize binlog optimization
3. place csv into cloud storage 
   - cloud storage is _data lake_
4. load OLAP (data warehouse)
   - [columnar db](https://en.wikipedia.org/wiki/List_of_column-oriented_DBMSes)
   - read from _data lake_ into _data warehouse_
   - the book mentioned using amazon redshift which can load CSV from cloud storage into a Postgres database. this can be 'replicated' like so:
     - manually copy output of a specific python extract csv result into ~/shared/data-warehouse
     - run import_order_csv.sh
     - TODO: automate process (or use another tool like stitch?)
       - minio csv -> ~/shared/data-warehouse
       - run import_order_csv on ~/shared/data-warehouse


## how to run
```bash
sh setup.sh # create persistent storage on host machine
docker-compose up 
docker-compose run --rm app # hop into app container to run scripts
python extract_rest.py
```

## minio cloud storage
- [Service](http://localhost:9001/)
- Remember to create 
  - bucket
  - service account


## seed "production" database 
```bash
# TODO there are multiple iterations of tables as the book progresses. use the command in seed.sh to use the correct one
docker-compose exec db sh
cd /usr/src/shared/db
sh seed.sh
```

## postgres notes
```bash
docker-compose exec data-warehouse sh
cd /usr/src/shared/db
sh seed.sh
```
- [docker image](https://hub.docker.com/_/postgres)
- [cheat sheet](https://gist.github.com/Kartones/dd3ff5ec5ea238d4c546)
- `psql --user=postgres`
- `\l` list databases
- `\c postgres` connect to postgres db
- `\d orders` shows orders
- `select * from orders;`
- import csv
  - https://www.postgresqltutorial.com/import-csv-file-into-posgresql-table/
  - `copy orders(orderid, orderstatus, lastupdated) FROM '/usr/src/shared/data-warehouse/order_extract.csv' DELIMITER '|';`
  - `select max(lastupdated) from orders;`


## sql clients
- beekeeper studio
- vscode extension: SQL Tools 
  - mysql
  - postgres