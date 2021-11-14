# data pipelines pocket reference

## workflow
1. db contains real-time production data
2. run extract_mysql_*.py to create *.csv
   1. possibly use replica to not crash prod
   2. utilize binlog optimization
3. place csv into cloud storage
4. read from cloud storage into data lake
   - the book mentioned using amazon redshift which can load CSV from cloud storage into a Postgres database
   - this project contains
     - minio as "fake s3"
     - postgres8 as "redshift"
     - manually copy output of csv extract into ~/shared/data-warehouse
     - run import_order_csv.sh
     - TODO: automate process (or use another tool like stitch?)
       - minio csv -> ~/shared/data-warehouse
       - run import_order_csv on ~/shared/data-warehouse

## setup devcontainer using python
```bash
python -m venv env
source env/bin/activate
which python
pip install configparser
touch pipeline.conf
python -m pip install --upgrade pip
```

## container
```bash
docker-compose up 
docker-compose run --rm app
```

## seed "production" database 
```bash
docker-compose exec db sh
cd /usr/src/shared/db
sh seed.sh
```

## minio cloud storage
- [Service](http://localhost:9001/)
- Remember to create 
  - bucket
  - service account


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