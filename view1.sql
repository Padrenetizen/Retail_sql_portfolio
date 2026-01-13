-- View: Cleaned retail data
CREATE OR REPLACE VIEW retail_cleaned AS
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price,
    customer_id,
    country,
    invoice_date,
    invoice_time
FROM retail_lagging2
WHERE quantity IS NOT NULL
  AND unit_price IS NOT NULL;