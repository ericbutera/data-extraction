# http://api.open-notify.org/iss-pass.json?lat=44.756339&lon=-85.587633
import requests
import json
import configparser
import csv

lat = 44.756339
lon = -85.587633
params = {"lat": lat, "lon": lon}
response = requests.get("http://api.open-notify.org/iss-pass.json", params=params)

print('content:')
print(response.content)

data = json.loads(response.content)
rows = []
for response in data['response']:
  row = []
  print("resp")
  print(response)

  row.append(lat)
  row.append(lon)
  row.append(response['duration'])
  row.append(response['risetime'])

  rows.append(row)

export_file = "extracts/extract_rest.csv"

print("rows:")
print(rows)

with open(export_file, 'w') as fp:
  csvw = csv.writer(fp, delimiter='|')
  csvw.writerows(rows)

fp.close()

# TODO: upload to s3