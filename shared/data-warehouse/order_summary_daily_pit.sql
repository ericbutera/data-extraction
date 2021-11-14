-- Incremental refresh using Point-In-Time p.130
CREATE TABLE order_summary_daily_pit
(
 order_date date,
 order_country varchar(10),
 total_revenue numeric,
 order_count int
);
INSERT INTO order_summary_daily_pit (order_date, order_country, total_revenue, order_count)
WITH customer_pit AS
(
  SELECT
    cs.CustomerId,
    o.OrderId,
    MAX(cs.LastUpdated) AS max_update_date
  FROM Orders o
  INNER JOIN Customers_staging cs ON cs.CustomerId = o.CustomerId AND cs.LastUpdated <= o.OrderDate
  GROUP BY cs.CustomerId, o.OrderId
)
SELECT
  o.OrderDate AS order_date,
  cs.CustomerCountry AS order_country,
  SUM(o.OrderTotal) AS total_revenue,
  COUNT(o.OrderId) AS order_count
FROM Orders o
INNER JOIN customer_pit cp ON cp.CustomerId = o.CustomerId AND cp.OrderId = o.OrderId
INNER JOIN Customers_staging cs ON cs.CustomerId = cp.CustomerId AND cs.LastUpdated = cp.max_update_date
GROUP BY o.OrderDate, cs.CustomerCountry;

SELECT
 DATE_PART('month', order_date) AS order_month,
 order_country,
 SUM(total_revenue) AS order_revenue
FROM order_summary_daily_pit
GROUP BY
 DATE_PART('month', order_date),
 order_country
ORDER BY
 DATE_PART('month', order_date),
 order_country;

-- order_month | order_country | order_revenue
-- -------------+---------------+---------------
--  6 | USA | 50.05
--  7 | UK | 236.44