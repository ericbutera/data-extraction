# TODO: this only works for `orders.sql`
# the book contains multiple updates to tables as it expands understanding around concepts
mysql --password=$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/src/shared/db/orders.sql 
