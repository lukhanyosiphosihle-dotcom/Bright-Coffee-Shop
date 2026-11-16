---- EXPLORING THE DATA ---
SELECT  -- When was data collected and how long have they been collecting it 
MIN(transaction_date) AS first_transaction, 
MAX(transaction_date) AS last_transaction
FROM brightcoffeeshop.sales.coffee_shop;

SELECT -- Opening time and closing time of the 3 stores
MIN(transaction_time) AS opening_time,
MAX(Transaction_time) AS closing_time
FROM brightcoffeeshop.sales.coffee_shop;

SELECT COUNT(DISTINCT product_category) AS number_of_products -- Number of unique products 
FROM brightcoffeeshop.sales.coffee_shop;

SELECT COUNT(*) FROM brightcoffeeshop.sales.coffee_shop;

WITH cleaned_sales AS (
-- STEP 1: Clean and prepare the data    
SELECT transaction_id, 
transaction_date,
transaction_time, 
transaction_qty, 
CAST(REPLACE(unit_price, ',', '.') AS DOUBLE) AS unit_price,
product_category, 
product_type,
store_location
FROM brightcoffeeshop.sales.coffee_shop),

calculated_sales AS (
-- STEP 2: Calculate transaction revenue  
SELECT*,transaction_qty * unit_price AS total_amount FROM cleaned_sales),

classified_sales AS (
-- STEP 3: Classify transactions    
SELECT *,
MONTH(transaction_date) AS Month_number,
DATE_FORMAT(transaction_date, 'MMMM') AS Month, 
DATE_FORMAT(transaction_date, 'EEEE') AS Day_of_the_week,
CASE 
WHEN HOUR(transaction_time) BETWEEN 6 AND 8 THEN 'Peak hour morning'
WHEN HOUR(transaction_time) BETWEEN 9 AND 11 THEN 'Mid-morning'
WHEN HOUR(transaction_time) BETWEEN 12 AND 17 THEN 'Afternoon'
WHEN HOUR(transaction_time) BETWEEN 18 AND 21 THEN 'Evening'
ELSE 'Outside defined hours' END AS Time_of_the_day
FROM calculated_sales)

SELECT -- STEP 4: Retrieve the processed dataset
transaction_id,
transaction_date,
transaction_time,
product_category,
product_type,
store_location,
transaction_qty,
unit_price,
total_amount,
Month_number, 
Month, 
Day_of_the_week,
Time_of_the_day
FROM classified_sales;
