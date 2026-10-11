--SQL Retail Sales Analysis - P1

-- Create Table
DROP TABLE IF EXISTS Retail_sales;
Create Table Retail_sales (
    transactions_id	INT Primary Key,
	sale_date	DATE,
	sale_time	TIME,
	customer_id	INT,
	gender	VARCHAR(15),
	age	INT,
	category VARCHAR(15),
	quantity	INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

SELECT * FROM Retail_sales;

SELECT Count(*) FROM Retail_sales;

--DATA Cleaning
SELECT * FROM Retail_sales
WHERE 
transactions_id IS NULL
OR 
sale_date IS NULL
OR sale_time IS NULL
OR Customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

Delete From Retail_sales
WHERE 
transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR Customer_id IS NULL
OR gender IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

--Data Exploration

SELECT * FROM Retail_sales;

--How many sales we have?

SELECT Count(*) AS Total_sale FROM Retail_sales;

--How much total sales?
SELECT Sum(Total_sale) FROM Retail_sales;

--How many uniques customer do we have?

SELECT Count(Distinct Customer_id) FROM Retail_sales;

--How many categories he have?
SELECT Count(Distinct Category) FROM Retail_sales;

--Data Analysis and Business key Problems and Solutions:

--Write a SQL query to retrieve all columns for sales made on '2022-11-05'.

Select * 
From Retail_sales
Where sale_date = '2022-11-05';


--Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is equal to or more than 4 in the month of Nov-2022.

Select Transactions_id, Category, quantity, sale_date
FROM retail_sales
Where Quantity>=4
and Category='Clothing'
AND To_Char(Sale_date, 'YYYY-MM') = '2022-11';

--Write a SQL query to calculate the total sales (total_sale) for each category.

Select Distinct Category, Sum(total_sale), Count(*) AS Total_orders From Retail_sales
Group By Category;

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select 
Category, 
ROUND(AVG(Age),2)
From Retail_sales
Where Category = 'Beauty'
Group By Category
;

--Write a SQL query to find all transactions where the total_sale is greater than 1000.

Select *
From Retail_sales
Where Total_sale>1000;

--Write a SQL query to find the total number of transactions made by each gender in each category.

Select
  Category,
  Gender,
  Count(*) AS total_sales
from Retail_sales
Group By Category, Gender
;

--Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year.

Select
  Year,
  Month,
  avg_sale
From
(
Select
  Extract(Year from sale_date) AS Year,
  extract(Month From sale_date) AS Month,
  Avg(total_sale) AS Avg_sale,
  Rank() Over(Partition by Extract (Year from sale_date) order by Avg(total_sale) Desc) as Rank
From Retail_sales
Group by 1,2
) as T1
Where Rank = 1;


--Write a SQL query to find the top 5 customers based on the highest total sales.

Select 
  customer_id,
  Sum(total_sale) as total_sales
From Retail_sales
group by customer_id
order by total_sales desc
limit 5
; 


--Write a SQL query to find the number of unique customers who purchased items from each category.

Select 
Count(Distinct customer_id) as Uniques_customers,
category
From Retail_sales
Group by category
; 

--Write a SQL query to create each shift and number of orders (Example: Morning 17).

With hourly_sale
as
(
Select *,
 Case
  When Extract (Hour From sale_time) <12 Then 'Morning'
  When Extract (Hour From sale_time) Between 12 and 17 Then 'Afternoon'
  Else 'Night'
 End as shift
From Retail_sales
)
Select 
 shift,
 Count(*) as total_orders
From hourly_sale
Group By shift
;













