-- Incremental data refresh example
--  p.127
CREATE TABLE Customers_staging (
 CustomerId int,
 CustomerName varchar(20),
 CustomerCountry varchar(10),
 LastUpdated timestamp
);
INSERT INTO Customers_staging VALUES(100,'Jane','USA','2019-05-01 7:01:10');
INSERT INTO Customers_staging VALUES(101,'Bob','UK','2020-01-15 13:05:31');
INSERT INTO Customers_staging VALUES(102,'Miles','UK','2020-01-29 9:12:00');
INSERT INTO Customers_staging VALUES(100,'Jane','UK','2020-06-20 8:15:34');

CREATE TABLE order_summary_daily_current
(
 order_date date,
 order_country varchar(10),
 total_revenue numeric,
 order_count int
);
INSERT INTO order_summary_daily_current (order_date, order_country, total_revenue, order_count)
WITH customers_current AS
(
 SELECT CustomerId,
 MAX(LastUpdated) AS latest_update
 FROM Customers_staging
 GROUP BY CustomerId
)
SELECT
  o.OrderDate AS order_date,
  cs.CustomerCountry AS order_country,
  SUM(o.OrderTotal) AS total_revenue,
  COUNT(o.OrderId) AS order_count
FROM Orders o
INNER JOIN customers_current cc ON cc.CustomerId = o.CustomerId
INNER JOIN Customers_staging cs ON cs.CustomerId = cc.CustomerId AND cs.LastUpdated = cc.latest_update
GROUP BY o.OrderDate, cs.CustomerCountry;

-- how much revenue was generated from orders placed in a given country in a given month p.129
SELECT
 DATE_PART('month', order_date) AS order_month,
 order_country,
 SUM(total_revenue) AS order_revenue
FROM order_summary_daily_current
GROUP BY
 DATE_PART('month', order_date),
 order_country
ORDER BY
 DATE_PART('month', order_date),
 order_country;

-- order_month | order_country | order_revenue
-- -------------+---------------+---------------
--  6 | UK | 50.05
--  7 | UK | 236.44
