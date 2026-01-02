# Azure Databricks Workspace Setup

## Prerequisites
- Resource Group and Storage Account created
- Databricks quota available in subscription

## Setup Steps

### 1. Create Databricks Workspace
```bash
# Azure Portal Steps:
1. Search "Azure Databricks" → Create
2. Resource Group: <YOUR_RG>
3. Workspace name: dbw-medallion-dev
4. Region: <YOUR_REGION> (same as Storage Account)
5. Pricing Tier: Standard (NOT Premium - cost saving)
6. Review + Create
```

### 2. Launch Workspace
```
1. Go to Databricks resource → Launch Workspace
2. Opens Databricks UI in new tab
```

### 3. Create Cluster
```
Compute → Create Cluster:
- Cluster name: bronze-silver-cluster
- Cluster mode: Single Node (for learning/cost saving)
- Databricks Runtime: 13.3 LTS or latest LTS
- Node type: Standard_DS3_v2 (4 cores, 14GB RAM)
- Auto-termination: 30 minutes (IMPORTANT for cost)
- Advanced Options:
  - Spot instances: Enable (50-80% cost savings)
```

### 4. Mount ADLS to Databricks
```python
# Create notebook: setup/mount-adls.py
# We'll add this code later when setting up Bronze layer
```

### 5. Install Required Libraries (Cluster level)
```
Cluster → Libraries → Install New:
- delta-spark (if not pre-installed)
- pandas
- pyarrow
```

## Cost Optimization
- ✅ Single-node cluster (not multi-node)
- ✅ Auto-terminate after 30 min
- ✅ Use Spot instances
- ✅ Stop cluster when not in use
- ⚠️ Estimated: $0.40-0.60/hour when running

## Security Notes
- Use Service Principal for ADLS access (production)
- For learning: Access Key authentication acceptable
- Never hardcode credentials in notebooks

## Verification
- [ ] Workspace created and accessible
- [ ] Cluster created with auto-termination enabled
- [ ] Cluster starts successfully
- [ ] Photon acceleration enabled