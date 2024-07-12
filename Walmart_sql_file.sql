CREATE DATABASE IF NOT EXISTS salesdatawalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
);


-- Feature Engineering --
SELECT 
    time,
    (CASE
        WHEN 'time' BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN 'time' BETWEEN '12:01:00' AND '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_date
FROM
    sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR (20);

UPDATE sales
set time_of_day=(
CASE
WHEN 'time' BETWEEN '00:00:00' AND '12:00:00' THEN "Morning"
WHEN 'time' BETWEEN '12:01:00' AND '16:00:00' THEN "Afternoon"
ELSE "Evening"
END);
--------------------------------------------------------------------------------------------------------------------------
-- day_name

SELECT 
    date, DAYNAME(date) as day_name
FROM
    sales;
    
ALTER table sales add column day_name VARCHAR(20);

update sales
set day_name= dayname(date);
-------------------------------------------------------------------------------------------------
-- month name
SELECT 
    date, MONTHNAME(date)
FROM
    sales;
    
ALTER TABLE sales ADD COLUMN month_name varchar (20);

UPDATE sales 
SET 
    month_name = MONTHNAME(date);
-------------------------------------Generic----------------------------------------------------
-- How many unique cities does the data have?--
SELECT DISTINCT
    (city)
FROM
    sales;
    
-- In which city is each branch? --
SELECT DISTINCT
    branch
FROM
    sales;

-- 1.How many unique product lines does the data have?--

SELECT DISTINCT
    (product_line)
FROM
    sales;
-- 2.What is the most common payment method?--

SELECT 
    payment, COUNT(payment) AS most_common_payment
FROM
    sales
GROUP BY payment
ORDER BY most_common_payment DESC;

-- 3.What is the most selling product line?--
SELECT 
    product_line, COUNT(product_line) AS most_selling_product
FROM
    sales
GROUP BY product_line
ORDER BY most_selling_product DESC;

-- 4.What is the total revenue by month?--
SELECT month_name, sum(total) as total_revenue
FROM sales
Group BY month_name 
ORDER BY total_revenue DESC;

-- 5.What month had the largest COGS?--
SELECT month_name,SUM(COGS) AS total_cogs
FROM sales
GROUP BY month_name
ORDER BY total_cogs DESC;

-- 6.What product line had the largest revenue?--
SELECT 
    product_line, SUM(total) AS largest_revenue
FROM
    sales
GROUP BY product_line
ORDER BY largest_revenue DESC;

-- 7.What is the city with the largest revenue?--
SELECT 
    branch,city, SUM(total) AS largest_revenue
FROM
    sales
GROUP BY city,branch
ORDER BY largest_revenue DESC;

-- 

-- 8.What product line had the largest VAT?-
SELECT 
     product_line, avg(VAT) AS largest_VAT
FROM
    sales
GROUP BY  product_line
ORDER BY largest_VAT DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales--


-- Which branch sold more products than average product sold?--
SELECT branch, sum(quantity) as total_quantity from sales
group by branch
having total_quantity > (select avg(quantity) from sales);

-- What is the most common product line by gender?--
select gender, product_line, count(gender) as gnd from sales
group by gender,product_line
order by gnd desc;


-- What is the average rating of each product line?--
SELECT 
    product_line, round(avg(rating),2) AS avg_rating
FROM
    sales
GROUP BY product_line
ORDER BY avg_rating DESC;
-- ---------------------------------------------------------------------Sales-----------------------------------------------------------------------------------------------------------------
-- Number of sales made in each time of the day per weekday--
SELECT 
    time_of_day, COUNT(*) AS sales_made
FROM
    sales
WHERE
    day_name = 'Monday'
GROUP BY time_of_day
ORDER BY sales_made DESC;

-- Which of the customer types brings the most revenue?--
SELECT 
    customer_type, SUM(total) AS revenue
FROM
    sales
GROUP BY customer_type
ORDER BY revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?--
SELECT 
    city, SUM(VAT) AS total_vat
FROM
    sales
GROUP BY city
ORDER BY total_vat DESC;

-- Which customer type pays the most in VAT?--
SELECT 
    customer_type, SUM(VAT) AS total_vat
FROM
    sales
GROUP BY customer_type
ORDER BY total_vat DESC;

-- ---------------------------------------------------------------------Customer------------------------------------------------------------------------------------------------------------
-- How many unique customer types does the data have?--
SELECT 
    
    DISTINCT (customer_type) AS unique_customer
FROM
    sales;

-- How many unique payment methods does the data have?--
SELECT 
   
    DISTINCT (payment) AS payment_method
FROM
    sales;

-- What is the most common customer type?--
SELECT customer_type, count(customer_type) as most_common_type
from sales
group by customer_type
order by most_common_type DESC;

-- Which customer type buys the most?--
SELECT  customer_type, product_line,sum(quantity) as most_buys
FROM sales
group by customer_type, product_line
order by most_buys DESC;

-- What is the gender of most of the customers?--
SELECT gender,COUNT(gender) as most_common_gender
FROM sales
GROUP BY gender
ORDER  BY most_common_gender DESC;

-- What is the gender distribution per branch?--
SELECT branch,city,gender,count(gender) as most_common_gender 
FROM sales 
GROUP BY branch,city,gender
ORDER BY most_common_gender DESC;

-- Which time of the day do customers give most ratings?--
SELECT time_of_day,avg(rating) as avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating;

-- Which time of the day do customers give most ratings per branch?--
SELECT time_of_day, branch,avg(rating) AS avg_rating
FROM sales
GROUP BY time_of_day, branch
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?--
SELECT day_name, avg(rating) as avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?--
SELECT day_name, avg(rating) as avg_rating
FROM sales
WHERE branch="B"
GROUP BY day_name
ORDER BY avg_rating DESC;
