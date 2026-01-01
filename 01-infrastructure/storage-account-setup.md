# Azure Data Lake Storage Gen2 Setup

## Prerequisites
- Resource Group created
- Contributor access to subscription

## Setup Steps

### 1. Create Storage Account
```bash
# Azure Portal Steps:
1. Search "Storage accounts" → Create
2. Resource Group: <YOUR_RG>
3. Storage account name: adlsmedalliondev
4. Region: <YOUR_REGION>
5. Performance: Standard
6. Redundancy: LRS (Locally Redundant Storage)
7. Advanced Tab:
   - Enable hierarchical namespace: ✅ YES (this makes it Data Lake Gen2)
   - Enable Blob public access: ❌ NO
8. Review + Create
```

### 2. Create Containers
After storage account created:
```
1. Go to Storage Account → Containers
2. Create three containers:
   - bronze (Private access)
   - silver (Private access)
   - gold (Private access)
```

### 3. Folder Structure (Create later via ADF/Databricks)
```
bronze/
├── sales/
├── customer/
└── product/

silver/
├── sales_cleaned/
├── customer_enriched/
└── product_standardized/

gold/
├── dim_date/
├── dim_product/
├── dim_customer/
└── fact_sales/
```

### 4. Access Keys (For ADF Connection)
```
Storage Account → Access keys → Copy key1
Store securely - needed for ADF linked service
```

### 5. Security Notes
- Never commit access keys to Git
- Use ADF Managed Identity for production (optional for learning)
- Monitor access logs regularly

## Verification
- [ ] Storage account created with ADLS Gen2 enabled
- [ ] Three containers (bronze, silver, gold) created
- [ ] Access key copied and stored securely