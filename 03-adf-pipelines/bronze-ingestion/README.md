# Bronze Layer Ingestion Pipeline

## Overview
Copies raw data from Azure SQL Database (AdventureWorksLT) to ADLS Gen2 Bronze layer in parallel.

## Pipeline: PL_Bronze_Ingestion_All_Tables

### Architecture
```
Azure SQL DB (AdventureWorksLT)
    ↓ (ADF Copy Activity)
ADLS Gen2 → bronze/ container
    ├── customer/
    ├── product/
    ├── product_category/
    ├── sales_order_header/
    └── sales_order_detail/
```

### Components

**Linked Services:**
- `LS_AzureSQL_AdventureWorks` - Source database connection (SQL auth via Key Vault)
- `LS_ADLS_MedallionDev` - Data Lake storage (account key via Key Vault)
- `LS_KeyVault` - Centralized secret management

**Datasets:**
- `DS_SQL_Generic` - Parameterized SQL source
  - Parameters: SchemaName, TableName
- `DS_ADLS_Bronze_Generic` - Parameterized ADLS sink
  - Parameters: FolderName
  - Format: Parquet (Snappy compression)

**Pipeline Activities:**
1. **ForEach Loop** - Iterates through TableList parameter
   - Parallel execution (batch count: 5)
   - Dynamic table processing
2. **Copy Activity** - Copies each table to Bronze
   - Source: SQL table (dynamic)
   - Sink: ADLS parquet files (dynamic)
   - Auto-schema mapping

### Pipeline Parameters
```json
{
  "TableList": [
    {
      "schemaName": "SalesLT",
      "tableName": "Customer",
      "folderName": "customer"
    },
    {
      "schemaName": "SalesLT",
      "tableName": "Product",
      "folderName": "product"
    },
    {
      "schemaName": "SalesLT",
      "tableName": "ProductCategory",
      "folderName": "product_category"
    },
    {
      "schemaName": "SalesLT",
      "tableName": "SalesOrderHeader",
      "folderName": "sales_order_header"
    },
    {
      "schemaName": "SalesLT",
      "tableName": "SalesOrderDetail",
      "folderName": "sales_order_detail"
    }
  ]
}
```

### Execution

**Manual Trigger:**
```
ADF UI → PL_Bronze_Ingestion_All_Tables → Debug (or Add trigger → Trigger now)
```

**Expected Output:**
- 5 folders created in bronze container
- Parquet files with raw data (no transformations)
- ~1,750 total rows copied

### Design Decisions

1. **Parameterization:** Single pipeline handles multiple tables (scalable, maintainable)
2. **Parallel Execution:** All 5 tables copy simultaneously (faster)
3. **Parquet Format:** Columnar storage for analytics (Delta conversion in Databricks)
4. **No Transformations:** Bronze = exact replica of source (raw zone)
5. **Key Vault Integration:** Credentials secured (production-ready pattern)

### Monitoring

**Check pipeline runs:**
```
ADF → Monitor → Pipeline runs
- View execution duration
- Check activity-level details
- Identify failures
```

**Data validation:**
```
Storage Account → bronze container
- Verify all 5 folders exist
- Check file sizes reasonable
- Validate parquet file structure
```

### Error Handling

**Common Issues:**
- **Firewall:** Ensure Azure services can access SQL Server
- **Permissions:** ADF managed identity needs Storage Blob Data Contributor role
- **Schema drift:** If source columns change, pipeline auto-adapts

**Recovery:**
- Re-run failed tables only (modify TableList parameter)
- Check ADF activity logs for detailed errors
- Validate linked service connections

### Next Steps
- Silver layer transformation in Databricks (convert to Delta, apply business rules)
- Add incremental load logic (track ModifiedDate column)
- Implement pipeline scheduling via triggers