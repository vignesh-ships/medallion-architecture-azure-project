{{ config(
    materialized='table',
    file_format='delta',
    location_root='wasbs://gold@adlsmedalliondev.blob.core.windows.net/'
) }}

WITH silver_product AS (
    SELECT *
    FROM delta.`wasbs://silver@adlsmedalliondev.blob.core.windows.net/product/`
),

silver_category AS (
    SELECT *
    FROM delta.`wasbs://silver@adlsmedalliondev.blob.core.windows.net/product_category/`
)

SELECT
    ROW_NUMBER() OVER (ORDER BY p.ProductID) AS product_key,
    p.ProductID AS product_id,
    p.Name AS product_name,
    p.ProductNumber AS product_number,
    COALESCE(p.Color, 'N/A') AS color,
    COALESCE(p.Size, 'N/A') AS size,
    p.ListPrice AS list_price,
    c.Name AS category_name,
    CURRENT_TIMESTAMP() AS effective_date,
    TRUE AS is_current
FROM silver_product p
LEFT JOIN silver_category c ON p.ProductCategoryID = c.ProductCategoryID