--Interrogate the data

--What do the column names and first few rows look like?
SELECT *
FROM superstore_raw
LIMIT 10;

-- Are there any missing values?
SELECT 
    COUNT(*) - COUNT(row_id)  AS missing_row_id,
    COUNT(*) - COUNT(order_id) AS missing_order_id,
    COUNT (*) - COUNT(customer_name) AS missing_customer_name,
    COUNT(*) - COUNT(sales) AS missing_sales,
    COUNT(*) - COUNT(region) AS missing_region,
    COUNT(*) - COUNT(profit) AS missing_profit
FROM superstore_raw;

--Are There any messy decimals?
SELECT sales, profit
FROM superstore_raw
LIMIT 30; 

--How many losses (negative profit) are there?
SELECT COUNT(*)
FROM superstore_raw
WHERE profit <0;


--Does date make logical sense?
-- Are there any orders with ship date before the order date?
SELECT COUNT(*) as impossible_dates
FROM superstore_raw
WHERE ship_Date < order_date;

--Are the category columns consistent?
SELECT DISTINCT ship_mode FROM superstore_raw;

SELECT DISTINCT segment FROM superstore_raw;

SELECT DISTINCT region FROM superstore_raw;

SELECT DISTINCT category FROM superstore_raw;

SELECT DISTINCT payment_mode FROM  superstore_raw;


--Are there any duplicate rows?

--Expected repeats: One order_id to multiple products
SELECT order_id, COUNT(*) AS occurences
FROM superstore_raw
GROUP BY order_id
HAVING COUNT (*) > 1
LIMIT 10;

--Sort from highest to lowest
SELECT order_id, COUNT (*) AS occurences
FROM superstore_raw
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY occurences DESC

--True Duplicates: Exact row appearing twice or more.
SELECT order_id, customer_id, product_id,ship_date, COUNT (*) AS occurences
FROM superstore_raw
GROUP BY order_id, customer_id, product_id, ship_date 
HAVING COUNT(*) > 1
ORDER BY occurences DESC;

-- Show us the complete duplicate rows side by side
-- We need to see ALL columns to confirm they're truly identical
SELECT *
FROM superstore_raw
WHERE (order_id, product_id, customer_id, order_date)
IN (
    SELECT order_id, product_id, customer_id, order_date
    FROM superstore_raw
    GROUP BY order_id, product_id, customer_id, order_date
    HAVING COUNT(*) > 1
)
ORDER BY order_id;


--Are names cased consistently?
--Finds all unique customer name where word starts with a lower case  

SELECT DISTINCT customer_name, INITCAP(customer_name) AS what_initcap_suggests
FROM superstore_raw
WHERE customer_name != INITCAP(customer_name);