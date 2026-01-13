-- View: Line-level sales calculations
CREATE OR REPLACE VIEW retail_sales AS
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price,
    country,
    invoice_date,
    invoice_time,
    (quantity * unit_price) AS total_price
FROM retail_cleaned
WHERE quantity > 0
  AND unit_price > 0;
