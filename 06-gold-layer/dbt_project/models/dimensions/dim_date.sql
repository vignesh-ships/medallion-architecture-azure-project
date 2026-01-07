{{ config(
    materialized='table',
    file_format='delta',
    location_root='wasbs://gold@adlsmedalliondev.blob.core.windows.net/'
) }}

WITH date_spine AS (
    SELECT EXPLODE(SEQUENCE(
        TO_DATE('2008-01-01'),
        TO_DATE('2010-12-31'),
        INTERVAL 1 DAY
    )) AS date_day
)

SELECT
    CAST(DATE_FORMAT(date_day, 'yyyyMMdd') AS INT) AS date_key,
    date_day AS full_date,
    YEAR(date_day) AS year,
    QUARTER(date_day) AS quarter,
    MONTH(date_day) AS month,
    DAY(date_day) AS day,
    DAYOFWEEK(date_day) AS day_of_week,
    WEEKOFYEAR(date_day) AS week_of_year,
    CASE WHEN DAYOFWEEK(date_day) IN (1, 7) THEN TRUE ELSE FALSE END AS is_weekend,
    FALSE AS is_holiday
FROM date_spine