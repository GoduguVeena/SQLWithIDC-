## Phase 1: Foundation & Inspection
-- 1. Install IDC_Pizza.dump as IDC_Pizza server

-- 2. List all unique pizza categories (`DISTINCT`).

SELECT DISTINCT category FROM pizza_types;

-- 3. Display `pizza_type_id`, `name`, and ingredients, replacing NULL ingredients with `"Missing Data"`. Show first 5 rows.

SELECT pizza_type_id, name, COALESCE(ingredients,'Missing Data') AS missing FROM pizza_types LIMIT 5;

-- 4. Check for pizzas missing a price (`IS NULL`).

SELECT * FROM pizzas WHERE price IS NULL;

## Phase 2: Filtering & Exploration

-- 1. Orders placed on '2015-01-01' (SELECT + WHERE).

SELECT * FROM orders WHERE date='2015-01-01';

-- 2. List pizzas with price descending.

SELECT * FROM pizzas ORDER BY price DESC;


--3. Pizzas sold in sizes 'L' or 'XL'.

SELECT ps.size ,COUNT(*) AS order_pizza_count 
FROM order_details od 
LEFT JOIN pizzas ps ON od.pizza_id=ps.pizza_id 
WHERE ps.size IN('L', 'XL') GROUP BY ps.size;


--4. Pizzas priced between $15.00 and $17.00.
SELECT * FROM pizzas 
WHERE price BETWEEN 15 and 17;


--5. Pizzas with "Chicken" in the name.

SELECT * FROM pizza_types
WHERE NAME LIKE '%Chicken%';

--6. Orders on '2015-02-15' or placed after 8 PM.

SELECT * FROM orders
WHERE date= '2015-02-15' OR time >'20:00:00';


## Phase 3: Sales Performance

--1. Total quantity of pizzas sold (SUM).

SELECT SUM(quantity) AS total_quantity
FROM order_details;

-- 2. Average pizza price (AVG).

SELECT round(AVG(price),2) AS avg_price
FROM pizzas;

-- 3. Total order value per order (JOIN, SUM, GROUP BY).

SELECT od.order_id, SUM(ps.price * od.quantity) AS order_total
FROM order_details od LEFT JOIN pizzas ps ON od.pizza_id=ps.pizza_id
GROUP BY od.order_id;

--4. Total quantity sold per pizza category (JOIN, GROUP BY).

SELECT pt.category,SUM(quantity) AS total_quantity 
FROM order_details od LEFT JOIN pizzas ps ON od.pizza_id=ps.pizza_id 
LEFT JOIN pizza_types pt ON ps.pizza_type_id=pt.pizza_type_id
GROUP BY pt.category; 

--5. Categories with more than 5,000 pizzas sold (HAVING).

select pt.category,sum(quantity) as total_quantity 
from order_details od left join pizzas ps on od.pizza_id=ps.pizza_id
left join pizza_types pt on ps.pizza_type_id=pt.pizza_type_id
group by pt.category
having sum(quantity)>5000; 

--6. Pizzas never ordered (LEFT/RIGHT JOIN).
SELECT ps.pizza_id,ps.pizza_type_id, ps.size,ps.price,od.order_id,od.quantity 
FROM pizzas ps LEFT JOIN order_details od ON ps.pizza_id=od.pizza_id RIGHT JOIN pizza_types pt 
ON pt.pizza_type_id= ps.pizza_type_id WHERE od.pizza_id IS NULL;

SELECT ps.pizza_id, ps.pizza_type_id, ps.size, ps.price,od.order_id,od.quantity
FROM pizzas ps
LEFT JOIN order_details od ON ps.pizza_id = od.pizza_id
WHERE od.pizza_id IS NULL;


--7. Price differences between different sizes of the same pizza (SELF JOIN).

SELECT p1.pizza_id,p1.size AS size_1,p2.size AS size_2,
p1.price AS price_1, p2.price AS price_p2,
p2.price-p1.price AS price_difference 
FROM pizzas p1 INNER JOIN pizzas p2 
ON p1.pizza_type_id=p2.pizza_type_id AND p1.size<p2.size
ORDER BY p1.pizza_id;





