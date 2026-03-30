--  RETAILS_SALES_ANALYSIS_PROJECT SQL
CREATE DATABASE RETAILS_SALES_ANALYSIS_PROJECT;

-- Create a Table. transactions_id, sale_date, sale_time, customer_id,
-- gender, age, category, quantiy, price_per_unit, cogs, total_sale

Drop Table if Exists retail_sales_tb;
CREATE TABLE retail_sales_tb
			(transactions_id Int PRIMARY KEY,
			sale_date Date,
			sale_time Time,
			customer_id Int,
			gender Varchar(15),
			age Int,
			category Varchar(15),
			quantiy Int,
			price_per_unit Float, 
			cogs Float,
			total_sale Float);

Select * from retail_sales_tb;

Select count(*) from retail_sales_tb;

Select * from retail_sales_tb
Where transactions_id IS Null;

Select * from retail_sales_tb
Where sale_date IS Null;

Select * from retail_sales_tb
Where customer_id IS Null;

Select * from retail_sales_tb
Where gender IS Null;

Select * from retail_sales_tb
Where transactions_id IS Null 
	  or sale_date IS Null
	  or customer_id IS Null 
      or gender IS Null
	  or age IS Null
	  or category IS Null
	  or quantiy Is Null
	  or price_per_unit IS NULL
	  or cogs IS NULL
	  or total_sale IS NULL;

Delete from retail_sales_tb
Where age IS Null
	  or 
	  category IS Null
	  or 
	  quantiy Is Null
	  or 
	  price_per_unit IS NULL
	  or 
	  cogs IS NULL
	  or 
	  total_sale IS NULL;

-- Data Exploration

--How Many Sales do we have? 
Select count(*) as total_sales from retail_sales_tb;

--How Many Customers do we have?
Select count(*) as customer_id from retail_sales_tb;

--How Many Unique Customers do we have?
Select count(Distinct customer_id) as customer_id from retail_sales_tb;

--How Many Unique Category do we have?
Select count(Distinct category) as customer_id from retail_sales_tb;

Select Distinct category from retail_sales_tb;

--Data Analysis and Business Key Problems and Solutions

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
Select * from retail_sales_tb
where sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
--and the quantity sold is more than 4 in the month of Nov-2022
Select category, SUM(quantiy) from retail_sales_tb
where category = 'Clothing'
Group by 1

Select * from retail_sales_tb
where category = 'Clothing'
	  And TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	  And quantiy >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
Select category, SUM(total_sale) from retail_sales_tb
Group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
Select Category, Round(AVG(age),2) as Avg_Age from retail_sales_tb
where category = 'Beauty'
Group by category
		

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
Select transactions_id, total_sale from retail_sales_tb
Where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
Select category, gender,  COUNT(transactions_id) as total_tansactions
		from retail_sales_tb
Group by Category, gender
order by 1
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

Select * from
(	
	Select 
			Extract (year from  sale_date) as year,
			Extract (month from sale_date) as month,
			AVG(total_sale) ,
			Rank() over(partition by Extract (year from  sale_date) order by AVG(total_sale) DESC) as rank
			from retail_sales_tb
	Group by 1,2
	--Order by 1,3 Desc
) as t1
Where rank = 1



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
Select customer_id, SUM(total_sale) from retail_sales_tb
Group by 1
Order by 2 DESC
Limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
Select Count(Distinct(customer_id)), category 
	from retail_sales_tb
Group by 2

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

With Hourly_sales as 
(
	Select *,
		Case
			When Extract (Hour from sale_time) < 12 Then 'Morning'
			When Extract (Hour from sale_time) Between 12 And 17 Then 'Afternoon'
			Else 'Evening'
		End as shift
	from retail_sales_tb
)
Select shift, Count(*)
from Hourly_sales
Group by shift

