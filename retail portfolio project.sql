USE retail;

CREATE TABLE retail_lagging LIKE online_retail;

INSERT INTO retail_lagging
SELECT *
FROM online_retail;

SELECT *
FROM retail_lagging;

-- creating row number column to check for duplicates
SELECT *,
ROW_NUMBER() OVER (PARTITION BY invoice_no, stock_code, description, 
quantity, invoice_date, unit_price, customer_id, country) AS row_num
FROM retail_lagging;

-- checking for duplicates using cte
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY invoice_no, stock_code, description, 
quantity, invoice_date, unit_price, customer_id, country) AS row_num
FROM retail_lagging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;
-- there are duplicates in the dataset

-- create another table
CREATE TABLE `retail_lagging2` (
  `invoice_no` int DEFAULT NULL,
  `stock_code` text,
  `description` text,
  `quantity` int DEFAULT NULL,
  `invoice_date` text,
  `unit_price` double DEFAULT NULL,
  `customer_id` double DEFAULT NULL,
  `country` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- insert data into the 2nd table
INSERT INTO retail_lagging2
SELECT *,
ROW_NUMBER() OVER (PARTITION BY invoice_no, stock_code, description, 
quantity, invoice_date, unit_price, customer_id, country) AS row_num
FROM retail_lagging;

-- removing duplicates
DELETE
FROM retail_lagging2
WHERE row_num > 1;

SELECT *
FROM retail_lagging2;

-- checking for blank rows
SELECT unit_price
FROM retail_lagging2
WHERE unit_price = '';

SELECT country
FROM retail_lagging2
WHERE country = '';

-- replacing the blanks with null
UPDATE retail_lagging2
SET unit_price = NULL
WHERE unit_price = '';

-- fixing the null rows
SELECT *
FROM retail_lagging2 a1
JOIN retail_lagging2 a2
USING(country)
WHERE (a1.unit_price IS NULL) AND a2.unit_price IS NOT NULL;

UPDATE retail_lagging2 a1
JOIN retail_lagging2 a2
USING(country)
SET a1.unit_price = a2.unit_price
WHERE (a1.unit_price IS NULL) AND a2.unit_price IS NOT NULL;

-- checking to see if the null rows were fixed
SELECT unit_price
FROM retail_lagging2
WHERE unit_price IS NULL;
-- it worked! the null rows has been fixed

SELECT *
FROM retail_lagging2;

-- invoice_date column is a combination of 2 columns 
ALTER TABLE retail_lagging2
ADD created_date DATE,
ADD created_time TIME;

-- updating the two new columns with data from invoice_date
UPDATE retail_lagging2
SET 
   created_date = STR_TO_DATE(TRIM(SUBSTRING(invoice_date, 1, 10)), '%Y-%m-%d'),
   created_time = STR_TO_DATE(TRIM(SUBSTRING(invoice_date, 12, 8)), '%H:%i:%s');

-- deleting the invoice_date column
ALTER TABLE retail_lagging2
DROP COLUMN invoice_date;

-- since the blanks/nulls have been fixed, delete row_num column
ALTER TABLE retail_lagging2
DROP COLUMN row_num;

SELECT *
FROM retail_lagging2;

-- checked for distinct characters for elimination
SELECT DISTINCT(unit_price)
FROM retail_lagging2;

-- changing the unit price column to 2 decimal places
ALTER TABLE retail_lagging2
MODIFY unit_price DECIMAL(10,2);

-- checked for distinct characters for elimination or replacement
SELECT DISTINCT(country)
FROM retail_lagging2;

UPDATE retail_lagging2
SET country = 'Ireland'
WHERE country = 'EIRE';

DELETE
FROM retail_lagging2
WHERE country = 'Unspecified';

DELETE
FROM retail_lagging2
WHERE country = 'European Community';

SELECT *
FROM retail_lagging2;

-- fixing the lettercase of the description column
SELECT description, CONCAT(UPPER(LEFT(description, 1)),
LOWER(SUBSTRING(description, 2))) AS description2
FROM retail_lagging2;

UPDATE retail_lagging2
SET description = CONCAT(UPPER(LEFT(description, 1)),
LOWER(SUBSTRING(description, 2)));

SELECT *
FROM retail_lagging2;

CREATE VIEW retail_cleaned AS
SELECT invoice_no,
stock_code,
description,
quantity,
unit_price,
customer_id,
country,
invoice_date,
invoice_time
FROM retail_lagging2;

