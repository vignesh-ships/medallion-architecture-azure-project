# Azure Resources List

## Resources to Create

### 1. Azure Data Lake Storage Gen2 (ADLS)
- **Purpose:** Store Bronze, Silver, Gold layer data
- **SKU:** Standard LRS (Locally Redundant Storage)
- **Hierarchical Namespace:** Enabled
- **Containers:**
  - `bronze` - Raw ingested data
  - `silver` - Cleaned/validated data
  - `gold` - Star schema (dimensional model)
- **Estimated Cost:** $2-6/month (based on data volume)

### 2. Azure Databricks Workspace
- **Purpose:** Process Bronze & Silver layers (PySpark)
- **Tier:** Standard (not Premium for cost saving)
- **Cluster Type:** Single-node (for learning)
- **Runtime:** Latest LTS version
- **Estimated Cost:** $12-25/month (with auto-termination)

### 3. Azure Data Factory (ADF)
- **Purpose:** Orchestrate end-to-end pipeline
- **Pipelines:**
  - Bronze ingestion
  - Silver transformation
  - Gold aggregation
  - Master orchestration pipeline
- **Estimated Cost:** $6-12/month (based on runs)

### 4. Key Vault
- **Purpose:** Store connection strings & secrets (ADLS key, Databricks token)
- **SKU:** Standard
- **Access Model:** Azure RBAC
- **Secrets Stored:**
  - `adls-access-key` - Storage account access key
  - `databricks-token` - Databricks personal access token
- **Estimated Cost:** $1-2/month

## Total Estimated Monthly Cost
**$20 - $45/month** (well within budget)

## Cost Optimization Strategies
- Auto-terminate Databricks clusters after 30 min idle
- Use single-node clusters for development
- Schedule pipelines (avoid continuous runs)
- Delete test data regularly
- Monitor with Azure Cost Management

## Resource Naming Convention
- Storage: `adlsmedalliondev`
- Databricks: `dbw-medallion-dev`
- ADF: `adf-medallion-dev`