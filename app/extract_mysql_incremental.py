# p. 45
import pymysql
import boto3
import csv
import configparser
import psycopg2


# redshift
parser = configparser.ConfigParser()
parser.read("pipeline.conf")
dbname = parser.get("datawarehouse","database")
user = parser.get("datawarehouse","user")
password = parser.get("datawarehouse","password")
host = parser.get("datawarehouse","host")
port = parser.get("datawarehouse","port")

rs_conn = psycopg2.connect(
  "dbname=" + dbname
  + " user=" + user
  + " password=" + password
  + " host=" + host
  + " port=" + port)

# fetch last updated or default to 1900
rs_sql = """SELECT COALESCE(MAX(LastUpdated), '1900-01-01') FROM Orders"""
rs_cursor = rs_conn.cursor()
rs_cursor.execute(rs_sql)
result = rs_cursor.fetchone()
last_updated_warehouse = result[0]
rs_cursor.close()
rs_conn.commit()

# mysql
parser = configparser.ConfigParser()
parser.read("pipeline.conf")
hostname = parser.get("db", "hostname")
port = parser.get("db", "port")
username = parser.get("db", "username")
dbname = parser.get("db", "database")
password = parser.get("db", "password")

conn = pymysql.connect(host=hostname, user=username, password=password, db=dbname, port=int(port))

if conn is None:
  print("Error connecting to the database")
else:
  print("db connection established")

m_query = """SELECT * FROM Orders WHERE LastUpdated > %s"""
local_filename = "/usr/src/shared/extracts/order_extract_incremental.csv"

m_cursor = conn.cursor()
m_cursor.execute(m_query, (last_updated_warehouse,))
results = m_cursor.fetchall()

with open(local_filename, 'w') as fp:
  csv_w = csv.writer(fp, delimiter='|')
  csv_w.writerows(results)

fp.close()
m_cursor.close()
conn.close()


# load aws_boto_creds
endpoint = parser.get("storage", "endpoint")
access_key = parser.get("storage", "access_key")
secret_key = parser.get("storage", "secret_key")
bucket_name = parser.get("storage", "bucket_name")

s3 = boto3.client('s3', 
endpoint_url=endpoint,
aws_access_key_id=access_key,
aws_secret_access_key=secret_key)

s3_file = local_filename
s3.upload_file(local_filename, bucket_name, s3_file)
