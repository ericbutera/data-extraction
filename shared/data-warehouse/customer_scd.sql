-- Type II SCD with customer data p. 125 
CREATE TABLE Customers_scd
(
 CustomerId int,
 CustomerName varchar(20),
 CustomerCountry varchar(10),
 ValidFrom timestamp,
 Expired timestamp
);
INSERT INTO Customers_scd VALUES(100,'Jane','USA','2019-05-01 7:01:10', '2020-06-20 8:15:34');
INSERT INTO Customers_scd VALUES(100,'Jane','UK','2020-06-20 8:15:34', '2199-12-31 00:00:00');

SELECT
 o.OrderId,
 o.OrderDate,
 c.CustomerName,
 c.CustomerCountry
FROM Orders o
INNER JOIN Customers_scd c
 ON o.CustomerId = c.CustomerId
 AND o.OrderDate BETWEEN c.ValidFrom AND
c.Expired
ORDER BY o.OrderDate;

-- orderid | orderdate | customer | customer name country
---------+--------------------+--------+---------
-- 1 | 2020-06-09 00:00:00 | Jane | USA
-- 4 | 2020-07-12 00:00:00 | Jane | UK