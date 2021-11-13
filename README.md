# data pipelines pocket reference

## aws
an aws account is required.
- [IAM](https://console.aws.amazon.com/iamv2/home?#/home)
- [S3](https://s3.console.aws.amazon.com/s3/buckets)

# deps
- [mini io "fake s3"](https://hub.docker.com/r/minio/minio/#test-using-minio-client-mc)
- [redshift]()
  

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
# docker
docker-compose up -d
```

## seed db
```bash
docker-compose exec db sh

# seed database 
mysql --password=$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/src/db/seed/orders.sql 
```

# run commands on app
```bash
docker-compose run --rm app
pip install boto3
pip install pymysql
```