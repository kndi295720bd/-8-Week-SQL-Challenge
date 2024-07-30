--A. PIZZA METRICS
--1. How many pizzas were ordered
SELECT COUNT(pizza_id) AS total_order
FROM customer_orders;

--2. How many unique customer orders were made?
SELECT 
	customer_id,
	COUNT(DISTINCT order_id) AS unique_customer_order
FROM customer_orders
GROUP BY customer_id;

-- 3. How many successful orders were delivered by each runner?
SELECT 
	runner_id,
	COUNT(order_id) AS Delivered_order
FROM runner_orders
WHERE 
	pickup_time IS NOT NULL
	AND distance IS NOT NULL
	AND duration IS NOT NULL
GROUP BY runner_id
ORDER BY runner_id;

-- 4 How many of each type of pizza was delivered?
SELECT 
    p.pizza_name,
    COUNT(c.order_id) AS Delivered_order
FROM 
    customer_orders c
JOIN 
    pizza_names p ON p.pizza_id = c.pizza_id
JOIN 
    runner_orders r ON c.order_id = r.order_id
WHERE
    r.pickup_time IS NOT NULL
    AND r.distance IS NOT NULL
    AND r.duration IS NOT NULL
GROUP BY 
    p.pizza_name
ORDER BY 
    p.pizza_name;

-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
    CAST(p.pizza_name AS varchar(max)) AS pizza_name,
    COUNT(c.order_id) AS Delivered_order
FROM 
    customer_orders c
JOIN 
    pizza_names p ON p.pizza_id = c.pizza_id
JOIN 
    runner_orders r ON c.order_id = r.order_id
WHERE
    r.pickup_time IS NOT NULL
    AND r.distance IS NOT NULL
    AND r.duration IS NOT NULL
GROUP BY 
    CAST(p.pizza_name AS varchar(max))
ORDER BY 
    CAST(p.pizza_name AS varchar(max));

--6. What was the maximum number of pizzas delivered in a single order?
WITH cte AS (
	SELECT	
		c.order_id,
		c.customer_id,
		COUNT(c.order_id) AS ITEM_ordered,
		DENSE_RANK() OVER(
			ORDER BY
				COUNT(c.order_id) DESC) AS RANK_order
	FROM customer_orders c
	JOIN runner_orders r ON c.order_id = r.order_id
	WHERE
		r.pickup_time IS NOT NULL
		AND r.distance IS NOT NULL
		AND r.duration IS NOT NULL
	GROUP BY
		c.order_id,
		c.customer_id
)
SELECT 
	order_id,
	customer_id,
	ITEM_ordered
FROM cte
WHERE RANK_order = 1;


--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- cte change
WITH changes AS (
	SELECT
		c.order_id,
		c.customer_id,
		CASE
			WHEN c.exclusions LIKE '%[^0-9, ]%'
			OR c.extras LIKE '%[^0-9, ]%' THEN 'Change'
			ELSE 'Not change'
			END AS status_change
	FROM customer_orders c
	JOIN runner_orders r ON c.order_id = r.order_id
	WHERE
		r.pickup_time IS NOT NULL
		AND r.distance IS NOT NULL
		AND r.duration IS NOT NULL
	GROUP BY
		c.exclusions,
		c.extras,
		c.customer_id,
		c.order_id
)
SELECT
	customer_id,
	status_change,
	COUNT(status_change) as Total_of_pizza
FROM changes
GROUP BY
	status_change,
	customer_id
ORDER BY
	customer_id;

--8. How many pizzas were delivered that had both exclusions and extras?
WITH cte AS (	
	SELECT
		CASE	
			WHEN c.exclusions LIKE '%[^0-9, ]%'
			OR c.extras LIKE '%[^0-9, ]%' THEN 'Have exclusion and extras'
			END AS Both_using
	FROM customer_orders c
	JOIN runner_orders r ON c.order_id = r.order_id
	WHERE
		r.pickup_time IS NOT NULL
		AND r.distance IS NOT NULL
		AND r.duration IS NOT NULL
	GROUP BY
		c.exclusions,
		c.extras
)
SELECT 
	COUNT(Both_using) AS total_pizza
FROM cte;

-- 9.

