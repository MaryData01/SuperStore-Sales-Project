# Superstore Sales Performance Analysis

## Project Overview
This project involved cleaning and analysing a Superstore sales dataset 
containing 5,901 transactions across 4 years (2019–2022). 
The goal was to uncover insights about sales performance, 
profitability and regional trends.

## Tools Used
- PostgreSQL — data cleaning and transformation
- Power BI — dashboard and visualizations
- VSCode — writing and running SQL queries
- GitHub — project documentation

## The Analytical Questions
1. Which region generates the most sales and profit?
2. Which product category drives the most revenue?
3. How do sales trend over time — is the business growing?
4. How many transactions are losses and how significant are they?

## Data Cleaning Steps
- Identified and fixed 8 incorrectly cased or encoding-corrupted customer names
- Rounded Sales and Profit columns to 2 decimal places
- Flagged 1,098 loss-making transactions instead of deleting them
- Flagged 1 impossible profit row (Brian Moss) for business review
- Confirmed zero null values and zero date logic errors
- Preserved original raw data in superstore_raw table

## Key Insights from the Dashboard
- **West region** leads with $520K in total sales
- **Office Supplies** is the top category driving 41% of all sales.
- **Sales grew consistently** from 2019 to 2022 showing healthy business growth
- **18.6% of transactions** resulted in a loss — nearly 1 in 5 orders lost money

## Files in This Repository
| File | Description |
|---|---|
| profiling.sql | SQL queries used to explore and diagnose data issues |
| cleaning.sql | SQL queries used to clean and transform the data |
| superstore_clean.csv | Final cleaned dataset ready for analysis |
| Superstore_Dashboard.pbix | Power BI dashboard file |
| Superstore_Dashboard.pdf | Exported dashboard for quick viewing |

## Takeaways
Data doesn't lie, but it does hide things.
This project was about digging through 5,901 rows,
finding what was hidden, and letting the numbers tell their story.
