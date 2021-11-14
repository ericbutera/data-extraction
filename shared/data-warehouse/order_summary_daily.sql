-- p. 122
CREATE TABLE IF NOT EXISTS order_summary_daily (
order_date date,
order_country varchar(10),
total_revenue numeric,
order_count int
);
INSERT INTO order_summary_daily
  (order_date, order_country,
  total_revenue, order_count)
SELECT
  o.OrderDate AS order_date,
  c.CustomerCountry AS order_country,
  SUM(o.OrderTotal) as total_revenue,
  COUNT(o.OrderId) AS order_count
FROM Orders o
INNER JOIN Customers c on
  c.CustomerId = o.CustomerId
GROUP BY o.OrderDate, c.CustomerCountry;

-- How much revenue was generated from orders placed from a given country in a given month?
SELECT
  DATE_PART('month', order_date) as order_month,
  order_country,
  SUM(total_revenue) as order_revenue
FROM order_summary_daily
GROUP BY
 DATE_PART('month', order_date),
 order_country
ORDER BY
 DATE_PART('month', order_date),
 order_country;

-- order_month | order_country | order_revenue
-- ------------+---------------+--------------
--           6 | USA           |         50.05
--           7 | UK            |        193.44
--           7 | USA           |         43.00

-- How many orders were placed on a given day?
SELECT
  order_date,
  SUM(order_count) as total_orders
FROM order_summary_daily
GROUP BY order_date
ORDER BY order_date;
-- order_date | total_orders
-- -----------+--------------
-- 2020-06-09 | 1
-- 2020-07-11 | 1
-- 2020-07-12 | 2
-- (3 rows)