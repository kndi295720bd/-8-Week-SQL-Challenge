use [Danny's dinner]

--Create tabel sales
CREATE TABLE Sales 
	(
	Customer_id VARCHAR(1),
	Order_id DATE,
	Product_id INTEGER);

INSERT INTO Sales
	(Customer_id, Order_id, Product_id)
VALUES
	('A', '2021-01-01', '1'),
	('A', '2021-01-01', '2'),
	('A', '2021-01-07', '2'),
	('A', '2021-01-10', '3'),
	('A', '2021-01-11', '3'),
	('A', '2021-01-11', '3'),
	('B', '2021-01-01', '2'),
	('B', '2021-01-02', '2'),
	('B', '2021-01-04', '1'),
	('B', '2021-01-11', '1'),
	('B', '2021-01-16', '3'),
	('B', '2021-02-01', '3'),
	('C', '2021-01-01', '3'),
	('C', '2021-01-01', '3'),
	('C', '2021-01-07', '3');

--Create table Menu
CREATE TABLE Menu
	(
	Product_id INTEGER,
	Product_name VARCHAR(5),
	Price INTEGER);

INSERT INTO Menu
	(Product_id, Product_name,Price)
VALUES
	('1', 'Sushi', '10'),
	('2', 'Curry', '15'),
	('3', 'Ramen', '12');

--CREATE TABLE Member
CREATE TABLE Members
	(
	Customer_id VARCHAR(1),
	Join_date DATE);

INSERT INTO Members
	(Customer_id, Join_date)
VALUES
	('A', '2021-01-07'),
	('B', '2021-01-09');
-- Rename columns in the table
EXEC sp_rename 'Sales.Order_id', 'Order_date', 'COLUMN';


