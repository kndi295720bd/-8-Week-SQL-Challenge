--1. What is the total amount each customer spent at the restaurant?
SELECT S.Customer_id, SUM(M.Price) as Tota_amt
FROM Sales S
JOIN Menu M ON S.Product_id = M.Product_id
GROUP BY S.Customer_id;
-- 2. How many days has each customer visited the restaurant?
SELECT Customer_id, COUNT(DISTINCT Order_date) as Visited_day
FROM Sales
GROUP BY Customer_id
-- 3. What was the first item from the menu purchased by each customer?
WITH CTE AS
(SELECT S.Customer_id, S.Order_date, DENSE_RANK() OVER (PARTITION BY S.Customer_id order by S.Order_date, M.Product_name) as rank, M.Product_name
FROM Sales S
JOIN Menu M ON S.Product_id = M.Product_id)
SELECT Customer_id, Product_name, Order_date
From CTE
WHERE CTE.rank =1;

-- What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT M.Product_name, COUNT(S.Product_id) as Most_ordered
FROM Sales S
JOIN Menu M on S.Product_id = M.Product_id
GROUP BY M.Product_name
ORDER BY Most_ordered DESC
LIMIT 1;

--WHICH ITEM WAS THE MOST POPULAR FOR EACH CUSTOMER
WITH CTE AS
(SELECT S.Customer_id, M.Product_name, COUNT(S.Product_id) AS Order_count, DENSE_RANK() OVER(PARTITION BY S.Customer_id ORDER BY COUNT(S.Product_id) DESC) AS RANK
FROM Sales S
JOIN Menu M ON S.Product_id = M.Product_id
GROUP BY S.Customer_id, M.Product_name)
SELECT Customer_id, Product_name, Order_count
From CTE
WHERE rank= 1;
-- WHICH ITEM WAS PURCHASED FIRST BY THE CUSTOMER AFTER THEY BECAME A MEMBER?
WITH Join_members AS
(SELECT 
	S.Customer_id, 
	S.Order_date,
	S.Product_id,
	ROW_NUMBER() OVER(PARTITION BY S.Customer_id ORDER BY S.Order_date) as RANK
 FROM Sales S
 JOIN Members MB ON S.Customer_id = MB.Customer_id AND S.Order_date > MB.Join_date)
 SELECT JM.Customer_id, M.Product_name
 FROM Join_members JM
 JOIN Menu M ON JM.Product_id = M.Product_id
 WHERE RANK = 1
 ORDER BY JM.Customer_id ASC;

-- WHICH ITEM WAS PURCHASED JUST BEFORE THE CUSTOMER BECAME A MEMBER
WITH Join_Member AS
(SELECT 
	S.Customer_id, 
	S.Order_date, 
	S.Product_id,
	ROW_NUMBER() OVER(PARTITION BY MB.Customer_id ORDER BY S.Order_date) AS RANK
FROM Sales S
JOIN Members MB ON S.Customer_id = MB.Customer_id AND S.Order_date < MB.Join_date)
SELECT JM.Customer_id, M.Product_name
FROM Join_Member JM
JOIN Menu M ON JM.Product_id = M.Product_id
WHERE RANK = 1;

-- WHAT IS THE TOTAL ITEMS AND AMOUNT SPENT FOR EACH MEMBER BEFORE THEY BECAME A MEMBER
SELECT 
	S.Customer_id,
	COUNT(S.Product_id) AS Total_item,
	SUM (M.Price) as Total_amount
FROM Sales S
JOIN Menu M ON S.Product_id = M.Product_id
JOIN Members MB ON S.Customer_id = MB.Customer_id
WHERE S.Order_date < MB.Join_date
GROUP BY S.Customer_id
ORDER BY S.Customer_id;

-- IF EACH $1 SPENT EQUATES TO 10 POINTS AND SUSHI HAS A 2X POINTS, HOW MANY POINTS WOULD EACH CUSTOMER HAVE
SELECT 
	S.Customer_id,
	SUM( CASE
			WHEN m.Product_name = 'Sushi' THEN price*2
			ELSE price
		END) *10 AS Total_points
FROM Sales S
JOIN Menu M ON S.Product_id = M.Product_id
GROUP BY S.Customer_id
ORDER BY S.Customer_id;

--BONUS QUESTION
-- JOIN ALL THE TABLE



 
