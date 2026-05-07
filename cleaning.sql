-- =============================================
-- SUPERSTORE DATA CLEANING
-- Database: superstore_db
-- =============================================
-- ISSUES WE ARE FIXING:
-- 1. Messy decimals in Sales and Profit
-- 2. 8 customer names with wrong casing or encoding
-- 3. 1 corrupted product name (Imation)
-- 4. 1,098 negative profit rows - flagging them
-- 5. Brian Moss impossible profit - flagging it
-- =============================================

-- We are creating a brand new clean table
-- Instead of editing the raw data, we copy it
-- and fix everything during the copy
-- Think of it like making a clean photocopy
-- of a messy document

CREATE TABLE superstore_clean AS
SELECT
    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,

    -- Fix customer names
    -- We only fix the 8 specific broken names
    -- Everyone else stays exactly as they are
    CASE
        WHEN customer_name = 'Dorris liebe'       THEN 'Dorris Liebe'
        WHEN customer_name = 'Dean percer'         THEN 'Dean Percer'
        WHEN customer_name LIKE '%Franz%sisch%'    THEN REPLACE(customer_name, 'Franz♦sisch', 'Französisch')
        WHEN customer_name LIKE '%B%hler%'         THEN REPLACE(customer_name, 'B♦hler', 'Bühler')
        WHEN customer_name LIKE '%H%berlin%'       THEN REPLACE(customer_name, 'H♦berlin', 'Häberlin')
        WHEN customer_name LIKE '%P%lking%'        THEN REPLACE(customer_name, 'P♦lking', 'Pölking')
        ELSE customer_name
    END AS customer_name,

    segment,
    country,
    city,
    state,
    region,
    product_id,
    category,
    sub_category,

    -- Fix corrupted product name
    REPLACE(product_name, 'Imation♦Secure+', 'Imation Secure+') AS product_name,

    -- Round Sales and Profit to 2 decimal places
    -- Example: 28.2668000003 becomes 28.27
    ROUND(sales::NUMERIC, 2)  AS sales,

    quantity,

    ROUND(profit::NUMERIC, 2) AS profit,

    returns,
    payment_mode

FROM superstore_raw;


-- We are adding a brand new column called profit_flag
-- This labels every row as Profitable, Loss, or Break Even
-- We never delete negative profit rows
-- We just label them so we can analyse them separately

ALTER TABLE superstore_clean
ADD COLUMN profit_flag TEXT;


-- CASE WHEN is just like Excel's IF formula
-- IF profit < 0 → Loss
-- IF profit = 0 → Break Even
-- Everything else → Profitable

UPDATE superstore_clean
SET profit_flag = CASE
    WHEN profit < 0  THEN 'Loss'
    WHEN profit = 0  THEN 'Break Even'
    ELSE                  'Profitable'
END;


-- This row has profit higher than sales
-- That is physically impossible in retail
-- We add a note so anyone using this data knows

ALTER TABLE superstore_clean
ADD COLUMN data_quality_note TEXT;

UPDATE superstore_clean
SET data_quality_note = 'Impossible profit - exceeds sales value, flag for review'
WHERE order_id = 'CA-2020-152912'
AND   customer_id = 'BM-11650'
AND   sales < profit;


-- Check 1: Do we still have all 5901 rows?
SELECT COUNT(*) FROM superstore_clean;

-- Check 2: Are decimals now clean?
SELECT sales, profit
FROM superstore_clean
LIMIT 20;

-- Check 3: Are the broken names fixed?
SELECT DISTINCT customer_name
FROM superstore_clean
WHERE customer_name IN (
    'Dorris Liebe', 'Dean Percer',
    'Neil Französisch', 'Barry Französisch',
    'Roy Französisch', 'Peter Bühler',
    'Anna Häberlin', 'Resi Pölking'
);

-- Check 4: How many losses, profitable and break even?
SELECT profit_flag, COUNT(*) AS total
FROM superstore_clean
GROUP BY profit_flag
ORDER BY total DESC;

-- Check 5: Is Brian Moss flagged?
SELECT customer_name, sales, profit, data_quality_note
FROM superstore_clean
WHERE data_quality_note IS NOT NULL;