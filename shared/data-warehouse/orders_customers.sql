-- p. 120 Data Modeling

-- Questions to answer:
-- How much revenue was generated from orders placed from a given country in a given month?
-- How many orders were placed on a given day?

CREATE TABLE Orders (
  OrderId int,
  OrderStatus varchar(30),
  OrderDate timestamp,
  CustomerId int,
  OrderTotal numeric
);

INSERT INTO Orders VALUES(1, 'Shipped', '2020-06-09', 100, 50.05);
INSERT INTO Orders VALUES(2, 'Shipped', '2020-07-11', 101, 57.45);
INSERT INTO Orders VALUES(3, 'Shipped', '2020-07-12', 102, 135.99);
INSERT INTO Orders VALUES(4, 'Shipped', '2020-07-12', 100, 43.00);

CREATE TABLE Customers (
  CustomerId int,
  CustomerName varchar(20),
  CustomerCountry varchar(10)
);

INSERT INTO Customers VALUES(100, 'Jane', 'USA');
INSERT INTO Customers VALUES(101, 'Bob', 'UK');
INSERT INTO Customers VALUES(102, 'Miles', 'UK');