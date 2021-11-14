# example of how to load a specific csv data set into the Data Warehouse
# optimally this should happen by utilizing cloud storage files as "external tables"
# since i'm not into paying amazon to learn, i set up a workaround system using minio & postgres to "mimic redshift"
psql --user=postgres data_warehouse < /usr/src/shared/data-warehouse/import_order_csv.sql