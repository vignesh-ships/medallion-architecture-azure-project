# Source-to-Target Mapping

## Overview
Maps AdventureWorksLT OLTP tables to Medallion layers and final star schema.

---

## Bronze Layer (Raw Ingestion)

### bronze_customer
- **Source:** SalesLT.Customer
- **Load Type:** Full
- **Format:** Delta
- **Schema:** As-is from source (no transformations)
- **Partition:** None (small dataset)

### bronze_product
- **Source:** SalesLT.Product
- **Load Type:** Full
- **Format:** Delta
- **Schema:** As-is from source

### bronze_product_category
- **Source:** SalesLT.ProductCategory
- **Load Type:** Full
- **Format:** Delta
- **Schema:** As-is from source

### bronze_sales_order_header
- **Source:** SalesLT.SalesOrderHeader
- **Load Type:** Full
- **Format:** Delta
- **Schema:** As-is from source

### bronze_sales_order_detail
- **Source:** SalesLT.SalesOrderDetail
- **Load Type:** Full
- **Format:** Delta
- **Schema:** As-is from source

---

## Silver Layer (Cleaned & Enriched)

### silver_customer_enriched
- **Source:** bronze_customer
- **Transformations:**
  - Standardize names (trim whitespace, proper case)
  - Validate email format
  - Handle NULL CompanyName (default to 'Individual')
  - Add audit columns: load_timestamp, source_system
- **Quality Checks:** No duplicate CustomerID, valid email

### silver_product_standardized
- **Source:** bronze_product + bronze_product_category
- **Transformations:**
  - Join with ProductCategory for hierarchy
  - Standardize NULL Color/Size to 'N/A'
  - Convert ListPrice to decimal(10,2)
  - Add product_category_name
  - Add audit columns
- **Quality Checks:** No duplicate ProductID, ListPrice > 0

### silver_sales_cleaned
- **Source:** bronze_sales_order_header + bronze_sales_order_detail
- **Transformations:**
  - Join header and detail
  - Calculate derived metrics (discount %, margin)
  - Validate dates (OrderDate <= DueDate <= ShipDate)
  - Filter out cancelled orders (if Status column exists)
  - Add audit columns
- **Quality Checks:** No orphan records, valid date logic

---

## Gold Layer (Star Schema)

### dim_customer
- **Source:** silver_customer_enriched
- **Type:** SCD Type 1 (overwrite)
- **Columns:**
  - customer_key (surrogate key)
  - customer_id (business key)
  - first_name
  - last_name
  - email_address
  - company_name
  - effective_date
  - is_current

### dim_product
- **Source:** silver_product_standardized
- **Type:** SCD Type 1
- **Columns:**
  - product_key (surrogate key)
  - product_id (business key)
  - product_name
  - product_number
  - color
  - size
  - list_price
  - category_name
  - effective_date
  - is_current

### dim_date
- **Source:** Generated (not from source tables)
- **Type:** Static dimension
- **Date Range:** 2008-01-01 to 2010-12-31
- **Columns:**
  - date_key (YYYYMMDD format)
  - full_date
  - year, quarter, month, day
  - day_of_week, week_of_year
  - is_weekend, is_holiday

### fact_sales
- **Source:** silver_sales_cleaned
- **Type:** Transaction fact table
- **Grain:** One row per sales order line item
- **Columns:**
  - sales_key (surrogate key)
  - date_key (FK to dim_date)
  - customer_key (FK to dim_customer)
  - product_key (FK to dim_product)
  - sales_order_id (degenerate dimension)
  - order_qty
  - unit_price
  - line_total
  - tax_amt
  - freight
  - total_due

---

## Data Lineage Summary
```
SalesLT.Customer → bronze_customer → silver_customer_enriched → dim_customer
                                                               ↘
SalesLT.Product → bronze_product → silver_product_standardized → dim_product
                                                                ↘
SalesLT.ProductCategory → bronze_product_category ──────────────→ (joined in silver)

SalesLT.SalesOrderHeader ↘
                          → bronze_sales_* → silver_sales_cleaned → fact_sales
SalesLT.SalesOrderDetail ↗

(Generated) → dim_date
```

---

## Key Design Decisions

1. **Bronze:** No transformations - exact copy from source
2. **Silver:** Business rules applied, data quality enforced
3. **Gold:** Star schema optimized for analytics queries
4. **SCD:** Type 1 only (no history tracking due to snapshot data)
5. **Surrogate Keys:** Auto-generated in dbt for dimensions
6. **Date Dimension:** Pre-generated static table