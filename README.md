# Medallion Architecture on Azure - Production-Grade Data Pipeline

[![Azure](https://img.shields.io/badge/Azure-0078D4?style=flat&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com)
[![Databricks](https://img.shields.io/badge/Databricks-FF3621?style=flat&logo=databricks&logoColor=white)](https://databricks.com)
[![dbt](https://img.shields.io/badge/dbt-FF694B?style=flat&logo=dbt&logoColor=white)](https://www.getdbt.com)

End-to-end data pipeline implementing Bronze → Silver → Gold medallion architecture on Azure, transforming OLTP data into analytics-ready star schema.

## 🏗️ Architecture
```
AdventureWorksLT (Azure SQL)
         ↓ (ADF Copy)
    Bronze Layer (Raw Parquet)
         ↓ (Databricks PySpark)
    Silver Layer (Cleaned Delta)
         ↓ (dbt)
    Gold Layer (Star Schema)
```

## 🛠️ Tech Stack

- **Orchestration:** Azure Data Factory (parameterized pipelines)
- **Processing:** Azure Databricks (PySpark, Delta Lake)
- **Transformation:** dbt Core (SQL-based modeling)
- **Storage:** ADLS Gen2 (Bronze, Silver, Gold containers)
- **Security:** Azure Key Vault (credentials management)
- **Source:** Azure SQL Database (AdventureWorksLT sample)

## 📊 Data Model

**Bronze Layer:** 5 raw tables (~1,750 rows)
- Customer, Product, ProductCategory, SalesOrderHeader, SalesOrderDetail

**Silver Layer:** Cleaned and validated Delta tables
- Data quality checks, standardized formats, audit columns

**Gold Layer:** Star schema (3 dimensions + 1 fact)
- `dim_customer` (847 rows)
- `dim_product` (295 rows)
- `dim_date` (1,096 days, 2008-2010)
- `fact_sales` (542 transactions)

## 🚀 Key Features

✅ **Parameterized Pipelines** - Single ADF pipeline handles multiple tables via ForEach loops  
✅ **Delta Lake Format** - ACID transactions, time travel, schema evolution  
✅ **Databricks Jobs** - Production-grade orchestration with parameter passing  
✅ **dbt Tests** - 15+ data quality tests (unique keys, not null, referential integrity)  
✅ **Cost Optimized** - Spot instances, auto-termination, minimal resources (~$30/month)  
✅ **Security** - Key Vault integration, no hardcoded credentials  

## 📁 Project Structure
```
medallion-architecture-azure-project/
├── 01-infrastructure/          # Azure resource documentation
├── 02-data-source/             # Source profiling & mapping
├── 03-adf-pipelines/           # ADF pipeline definitions (JSON)
│   ├── bronze-ingestion/       # SQL → Bronze (5 tables in parallel)
│   ├── silver-transformation/  # Bronze → Silver (Databricks Job)
│   └── linked-services/        # Connection configs
├── 04-bronze-layer/            # Raw data layer (Parquet)
├── 05-silver-layer/            # Cleaned data layer (Delta)
│   └── databricks-notebooks/   # PySpark transformation notebooks
├── 06-gold-layer/              # Star schema (Delta tables)
│   └── dbt_project/            # dbt models, tests, docs
├── 07-orchestration/           # Master pipeline (Bronze→Silver→Gold)
└── 08-monitoring/              # Cost tracking & observability
```

## 🎯 Learning Outcomes

- Implemented medallion architecture from scratch
- Built parameterized, reusable data pipelines
- Mastered PySpark for data transformations
- Applied dbt for analytics engineering
- Configured Azure cloud infrastructure
- Managed secrets with Key Vault
- Optimized cloud costs for PoC workloads

## 💰 Cost Management

**Monthly Budget:** $50  
**Actual Cost:** ~$30/month
- ADLS Gen2: $3-5
- Databricks (spot instances): $15-20
- Azure SQL: $5-8
- Data Factory: $2-3

**Optimization Strategies:**
- Single-node Databricks cluster with auto-termination (30 min)
- Spot instances (70% cost savings)
- Serverless Azure SQL (auto-pause)
- Manual trigger pipelines (no scheduled runs during development)

## 🏃 Quick Start

### Prerequisites
- Azure subscription with resource group
- Python 3.13+
- dbt-databricks installed
- Azure CLI (optional)

### Setup
1. **Infrastructure:** Create resources per `01-infrastructure/` docs
2. **ADF Pipelines:** Import JSON from `03-adf-pipelines/`
3. **Databricks:** Upload notebooks from `05-silver-layer/databricks-notebooks/`
4. **dbt:** Configure `~/.dbt/profiles.yml` and run `dbt run`

### Run Pipeline
```bash
# Trigger master pipeline in ADF
# Or run individual layers:
dbt run --select dim_customer  # Gold layer only
```

## 📈 Results

- **Pipeline Execution:** Bronze (2 min) → Silver (4 min) → Gold (1 min) = **~7 min end-to-end**
- **Data Quality:** 100% test pass rate (15 tests)
- **Documentation:** Auto-generated dbt docs with lineage graphs
- **Scalability:** Parameterized design supports 50+ tables with no code changes