# dbt Gold Layer - Star Schema

## Overview
Transforms Silver layer data into analytics-ready star schema using dbt.

## Models

### Dimensions
- **dim_customer** - Customer attributes (847 rows)
- **dim_product** - Product catalog with categories (295 rows)  
- **dim_date** - Date dimension 2008-2010 (1,096 rows)

### Facts
- **fact_sales** - Sales transactions at line-item grain (542 rows)

## Star Schema Design
```
                 dim_date
                    |
                    |
dim_customer --- fact_sales --- dim_product
```

## Setup

### Prerequisites
- Python 3.13+
- dbt-databricks installed
- Databricks cluster running
- Silver layer data available

### Configuration
1. Update `~/.dbt/profiles.yml` with your Databricks connection
2. Create Gold schema: `CREATE SCHEMA gold LOCATION 'wasbs://gold@adlsmedalliondev.blob.core.windows.net/'`

### Run Models
```bash
# Run all models
dbt run

# Run specific model
dbt run --select dim_customer

# Test data quality
dbt test

# Generate docs
dbt docs generate
dbt docs serve
```

## Data Quality Tests
- Unique keys enforced on all dimensions and fact
- Not null constraints on critical columns
- Referential integrity between fact and dimensions

## Tech Stack
- dbt Core 1.11
- Databricks Runtime
- Delta Lake format
- ADLS Gen2 storage