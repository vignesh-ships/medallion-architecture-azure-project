{{ config(
    materialized='table',
    file_format='delta',
    location_root='wasbs://gold@adlsmedalliondev.blob.core.windows.net/'
) }}

WITH silver_sales_header AS (
    SELECT *
    FROM delta.`wasbs://silver@adlsmedalliondev.blob.core.windows.net/sales_order_header/`
),

silver_sales_detail AS (
    SELECT *
    FROM delta.`wasbs://silver@adlsmedalliondev.blob.core.windows.net/sales_order_detail/`
),

dim_customer AS (
    SELECT * FROM {{ ref('dim_customer') }}
),

dim_product AS (
    SELECT * FROM {{ ref('dim_product') }}
),

dim_date AS (
    SELECT * FROM {{ ref('dim_date') }}
)

SELECT
    ROW_NUMBER() OVER (ORDER BY d.SalesOrderID, d.SalesOrderDetailID) AS sales_key,
    CAST(DATE_FORMAT(h.OrderDate, 'yyyyMMdd') AS INT) AS date_key,
    c.customer_key,
    p.product_key,
    d.SalesOrderID AS sales_order_id,
    d.SalesOrderDetailID AS sales_order_detail_id,
    d.OrderQty AS order_qty,
    d.UnitPrice AS unit_price,
    d.LineTotal AS line_total,
    h.TaxAmt AS tax_amt,
    h.Freight AS freight,
    h.TotalDue AS total_due
FROM silver_sales_detail d
INNER JOIN silver_sales_header h ON d.SalesOrderID = h.SalesOrderID
LEFT JOIN dim_customer c ON h.CustomerID = c.customer_id
LEFT JOIN dim_product p ON d.ProductID = p.product_id
LEFT JOIN dim_date dt ON CAST(DATE_FORMAT(h.OrderDate, 'yyyyMMdd') AS INT) = dt.date_key