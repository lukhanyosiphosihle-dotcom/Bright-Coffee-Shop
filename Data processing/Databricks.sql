USE CATALOG brightcoffeeshop.sales.coffee_shop

SELECT  -- WHEN WAS DATA WAS COLLECTED AND HOW LONG HAVE THEY BEEN CLOSNG IT
MIN(transaction_date) AS first_transaction, 
MAX(transaction_date) AS last_transaction
FROM brightcoffeeshop.sales.coffee_shop;

SELECT -- opening time and closing time of the 3 stores
MIN(transaction_time) AS opening_time,
MAX(Transaction_time) AS closing_time
FROM brightcoffeeshop.sales.coffee_shop;

SELECT COUNT(DISTINCT product_category) AS number_of_products -- number of unique products 
FROM brightcoffeeshop.sales.coffee_shop;

SELECT COUNT(*) FROM brightcoffeeshop.sales.coffee_shop;

-- processing data 
SELECT -- Total revenue for store_location
store_location,
ROUND(SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)),2) AS Revenue
FROM brightcoffeeshop.sales.coffee_shop AS coffee_shop
GROUP BY store_location
ORDER BY Revenue ASC;

SELECT -- total revenue and number of products sold per month by product category and month 
COUNT(transaction_qty) AS number_of_products_sold,
ROUND(SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)),2) AS total_revenue,
MONTHNAME(transaction_date) AS Month,
product_category
FROM brightcoffeeshop.sales.coffee_shop
GROUP BY  Month, product_category;
HAVING Month IN (Feb)


SELECT -- total revenue by product_category
product_category, 
ROUND(SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)),2) AS total_revenue
FROM brightcoffeeshop.sales.coffee_shop AS coffee_shop 
GROUP BY product_category;

SELECT -- total amount for 6 months 
ROUND(SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)),2) AS total_revenue
FROM brightcoffeeshop.sales.coffee_shop;

SELECT -- processed table 
transaction_id,
product_category,
product_type,
store_location,
CASE
WHEN transaction_time BETWEEN '06:00:00' AND '08:59:59' THEN 'Peak hour morning'
WHEN transaction_time BETWEEN '09:00:00' AND '11:59:59' THEN 'Mid-morning'
WHEN transaction_time BETWEEN '12:00:00' AND '17:59:59' THEN 'Afternoon'
WHEN transaction_time BETWEEN '18:00:00' AND '21:59:59' THEN 'Evening'  
END AS `Time_of_the_day`,
MONTHNAME(transaction_date) AS Month,
DAYNAME(transaction_date) AS Day_of_the_week,
SUM(transaction_qty) AS number_of_products_sold,
COUNT(transaction_id) as Total_transactions,
ROUND(SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)),2) AS total_amount 
FROM brightcoffeeshop.sales.coffee_shop AS coffee_shop
GROUP BY Day_of_the_week, transaction_time, product_type, product_category, store_location, Month, transaction_id
