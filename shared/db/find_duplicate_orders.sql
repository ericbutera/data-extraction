CREATE TABLE Orders (
 OrderId int,
 OrderStatus varchar(30),
 LastUpdated timestamp
);
INSERT INTO Orders
 VALUES(1,'Backordered', '2020-06-01');
INSERT INTO Orders
 VALUES(1,'Shipped', '2020-06-09');
INSERT INTO Orders
 VALUES(2,'Shipped', '2020-07-11');
INSERT INTO Orders
 VALUES(1,'Shipped', '2020-06-09');
INSERT INTO Orders
 VALUES(3,'Shipped', '2020-07-12');

-- find duplicates p.108
SELECT 
  OrderId,
  OrderStatus,
  LastUpdated,
  COUNT(*) AS dup_count
FROM Orders
GROUP BY OrderId, OrderStatus, LastUpdated
HAVING COUNT(*) > 1;

-- find duplicates using a _window function_
-- also, how to "de-duplicate" during load p.111
-- CREATE TABLE all_orders AS
SELECT 
  OrderId,
  OrderStatus,
  LastUpdated,
  ROW_NUMBER() OVER(PARTITION BY OrderId, OrderStatus, LastUpdated) AS dup_count
FROM Orders;
-- TRUNCATE TABLE Orders;
-- INSERT INTO Orders(OrderId, OrderStatus, LastUpdated)
--   SELECT OrderId, OrderStatus, LastUpdated FROM all_orders WHERE dup_count = 1