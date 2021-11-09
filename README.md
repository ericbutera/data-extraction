# 

## setup devcontainer using python
```bash
python-m venv env
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

# create database data_pipeline;
mysql -p data_pipeline < /usr/src/db/orders.sql # import orders
```