# p. 45
import pymysql
import boto3
import csv
import configparser

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

m_query = "SELECT * FROM Orders"
local_filename = "order_extract_full.csv"

m_cursor = conn.cursor()
m_cursor.execute(m_query)
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
