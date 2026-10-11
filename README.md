# Retail Sales Analysis (SQL)

An end-to-end SQL project that cleans, explores and analyzes a retail sales dataset to answer common business questions about revenue, customer behavior, category performance and sales trends.

## Project Overview

| | |
|---|---|
| **Project** | Retail Sales Analysis - P1 |
| **Tool** | SQL (PostgreSQL syntax) |
| **Dataset** | 2,000 retail transactions (`SQL - Retail Sales Analysis_utf .csv`) |
| **Skills shown** | Data cleaning, EDA, aggregation, CTEs, window functions, conditional logic, date/time functions |

## Objectives

1. Set up a retail sales database and load the data.
2. Clean the data by finding and removing records with null values.
3. Explore the data to understand volume, revenue, customers and categories.
4. Answer business questions with SQL to support decision-making.

## Repository Structure

```
.
├── sql_querry_p1.sql                       # All SQL: table setup, cleaning, exploration, analysis
├── SQL - Retail Sales Analysis_utf .csv    # Raw dataset
└── README.md
```

## Dataset Schema

| Column | Type | Description |
|---|---|---|
| `transactions_id` | INT (PK) | Unique transaction ID |
| `sale_date` | DATE | Date of sale |
| `sale_time` | TIME | Time of sale |
| `customer_id` | INT | Customer identifier |
| `gender` | VARCHAR(15) | Customer gender |
| `age` | INT | Customer age |
| `category` | VARCHAR(15) | Product category |
| `quantity` | INT | Units sold |
| `price_per_unit` | FLOAT | Price per unit |
| `cogs` | FLOAT | Cost of goods sold |
| `total_sale` | FLOAT | Total sale value |

## Project Workflow

### 1. Database Setup

```sql
DROP TABLE IF EXISTS Retail_sales;
CREATE TABLE Retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date       DATE,
    sale_time       TIME,
    customer_id     INT,
    gender          VARCHAR(15),
    age             INT,
    category        VARCHAR(15),
    quantity        INT,
    price_per_unit  FLOAT,
    cogs            FLOAT,
    total_sale      FLOAT
);
```

Import the CSV into `Retail_sales` (e.g. pgAdmin Import/Export or `COPY`).

### 2. Data Cleaning

Check for null values, then remove incomplete records.

```sql
SELECT * FROM Retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

DELETE FROM Retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
```

> **Note:** `age` is intentionally excluded from the null check. Many customers choose not to disclose their age, so rows with a missing age are kept. Age-based queries (e.g. Q4) automatically ignore nulls because `AVG()` skips them.

### 3. Data Exploration

```sql
-- Total number of sales
SELECT COUNT(*) AS total_sale FROM Retail_sales;

-- Total revenue
SELECT SUM(total_sale) FROM Retail_sales;

-- Unique customers
SELECT COUNT(DISTINCT customer_id) FROM Retail_sales;

-- Number of categories
SELECT COUNT(DISTINCT category) FROM Retail_sales;
```

## Key Findings

Each section below is a business question answered with SQL.

### Q1. Retrieve all sales made on 2022-11-05

```sql
SELECT *
FROM Retail_sales
WHERE sale_date = '2022-11-05';
```

### Q2. Clothing transactions with quantity of more than 4 in Nov-2022

```sql
SELECT transactions_id, category, quantity, sale_date
FROM Retail_sales
WHERE quantity > 4
  AND category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';
```

### Q3. Total sales and order count for each category

```sql
SELECT category,
       SUM(total_sale) AS net_sales,
       COUNT(*)        AS total_orders
FROM Retail_sales
GROUP BY category;
```

### Q4. Average age of customers who bought from the Beauty category

```sql
SELECT category,
       ROUND(AVG(age), 2) AS avg_age
FROM Retail_sales
WHERE category = 'Beauty'
GROUP BY category;
```

### Q5. High-value transactions (total sale greater than 1000)

```sql
SELECT *
FROM Retail_sales
WHERE total_sale > 1000;
```

### Q6. Number of transactions by gender in each category

```sql
SELECT category,
       gender,
       COUNT(*) AS total_transactions
FROM Retail_sales
GROUP BY category, gender;
```

### Q7. Average sale per month and the best-selling month in each year

```sql
SELECT year, month, avg_sale
FROM (
    SELECT EXTRACT(YEAR FROM sale_date)  AS year,
           EXTRACT(MONTH FROM sale_date) AS month,
           AVG(total_sale)               AS avg_sale,
           RANK() OVER (
               PARTITION BY EXTRACT(YEAR FROM sale_date)
               ORDER BY AVG(total_sale) DESC
           ) AS rank
    FROM Retail_sales
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;
```

### Q8. Top 5 customers by total sales

```sql
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM Retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### Q9. Unique customers per category

```sql
SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM Retail_sales
GROUP BY category;
```

### Q10. Orders by shift (Morning < 12, Afternoon 12-17, Evening/Night > 17)

```sql
WITH hourly_sale AS (
    SELECT *,
           CASE
               WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
               WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
               ELSE 'Night'
           END AS shift
    FROM Retail_sales
)
SELECT shift,
       COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

## Business Insights You Can Draw

- **Category performance:** Q3 and Q9 show which categories drive revenue and reach the most customers.
- **Customer value:** Q8 identifies top spenders for loyalty and retention programs.
- **Demographics:** Q4 and Q6 reveal who buys what, by age and gender.
- **Seasonality:** Q7 surfaces the strongest month in each year for campaign and inventory planning.
- **Peak hours:** Q10 shows which shift gets the most orders, useful for staffing and promotions.
- **High-ticket sales:** Q5 isolates large transactions for upsell analysis.

## How to Run

1. Clone the repo:
   ```bash
   git clone <your-repo-url>
   cd <your-repo-name>
   ```
2. Create a PostgreSQL database and run the table setup from `sql_querry_p1.sql`.
3. Import `SQL - Retail Sales Analysis_utf .csv` into `Retail_sales`.
4. Run the cleaning, exploration and analysis queries in order.

## Tech Stack

- PostgreSQL
- pgAdmin / any SQL client
- CSV dataset

## Author

**Doyen Deb**
Business & Data Analyst | Bengaluru, India

Connect: [LinkedIn](https://www.linkedin.com/) · [GitHub](https://github.com/)
