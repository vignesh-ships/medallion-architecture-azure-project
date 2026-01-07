{{ config(
    materialized='table',
    file_format='delta',
    location_root='wasbs://gold@adlsmedalliondev.blob.core.windows.net/'
) }}

WITH silver_customer AS (
    SELECT *
    FROM delta.`wasbs://silver@adlsmedalliondev.blob.core.windows.net/customer/`
)

SELECT
    ROW_NUMBER() OVER (ORDER BY CustomerID) AS customer_key,
    CustomerID AS customer_id,
    FirstName AS first_name,
    LastName AS last_name,
    EmailAddress AS email_address,
    COALESCE(CompanyName, 'Individual') AS company_name,
    Phone AS phone,
    CURRENT_TIMESTAMP() AS effective_date,
    TRUE AS is_current
FROM silver_customer