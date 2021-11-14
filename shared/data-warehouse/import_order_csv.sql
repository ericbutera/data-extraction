-- copy csv data into a database table
-- https://www.postgresqltutorial.com/import-csv-file-into-posgresql-table/
COPY orders(orderid, orderstatus, lastupdated) 
FROM '/usr/src/shared/data-warehouse/order_extract.csv' 
DELIMITER '|';