USE retail;
SELECT *
FROM retail_cleaned;

-- quantity in stock
SELECT stock_code,
description,
COUNT(quantity) AS total_quantity
FROM retail_cleaned
GROUP BY stock_code,description 
ORDER BY total_quantity DESC;

SELECT *
FROM retail_cleaned;

-- sales by country
SELECT country,
SUM(quantity * unit_price) AS total_revenue
FROM retail_cleaned
WHERE quantity > 0 AND unit_price > 0
GROUP BY country
ORDER BY total_revenue DESC;
-- from this it can be observed that UK, Netherlands, & Ireland are the top 3 countries with the most sales

SELECT *
FROM retail_cleaned;

-- total prices of goods available
SELECT stock_code,
description,
quantity,
unit_price,
(quantity * unit_price) AS total_price
FROM retail_cleaned;

SELECT *
FROM retail_cleaned;

-- total price of good purchased by invoice
SELECT invoice_no,
description,
quantity,
unit_price,
(quantity * unit_price) AS total_price
FROM retail_cleaned
GROUP BY invoice_no, description, quantity, unit_price
ORDER BY total_price DESC;
-- this shows the customers that purchased the most goods, and the total price of 
-- the goods they purchased

SELECT *
FROM retail_cleaned;

-- customer count by country
SELECT country,
COUNT(invoice_no) AS customer_count
FROM retail_cleaned
GROUP BY country
ORDER BY customer_count DESC;
-- this shows the total number of customers in each country purchasing goods from the retailers

SELECT *
FROM retail_cleaned;

-- yearly sales by country
SELECT country,
SUM(quantity * unit_price) total_sales,
YEAR(invoice_date) AS year
FROM retail_cleaned
WHERE quantity > 0 AND unit_price > 0
GROUP BY country, year(invoice_date)
ORDER BY country, year;

SELECT *
FROM retail_cleaned;

-- total quantity purchased by invoice
SELECT invoice_no,
SUM(quantity) total_quantity
FROM retail_cleaned
GROUP BY invoice_no
ORDER BY total_quantity DESC;
-- it shows the customers that purchased the most quantity of products