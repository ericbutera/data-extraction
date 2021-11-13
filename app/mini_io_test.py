import configparser

parser = configparser.ConfigParser()
parser.read("pipeline.conf")

hostname = parser.get("storage", "hostname")
access_key = parser.get("storage", "access_key")
secret_key = parser.get("storage", "secret_key")
bucket_name = parser.get("storage", "bucket_name")

from minio import Minio
from minio.error import S3Error
client = Minio(
    hostname,
    access_key=access_key,
    secret_key=secret_key,
    secure=False
)

found = client.bucket_exists(bucket_name)
if not found:
    client.make_bucket(bucket_name)
    print("Creating bucket")

local_filename = "mini_io_test.py"
s3_file = "bucket-s3.py"
client.fput_object(bucket_name, s3_file, local_filename)
