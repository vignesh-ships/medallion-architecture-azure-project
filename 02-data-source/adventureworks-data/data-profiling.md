# Data Source Profiling - AdventureWorksLT

## Source Database
- **Server:** sqlserver-medallion-dev.database.windows.net
- **Database:** AdventureWorksLT
- **Schema:** SalesLT
- **Connection:** SQL Authentication

## Tables Selected for Pipeline

### 1. SalesLT.Customer
- **Purpose:** Customer dimension data
- **Row Count:** ~847 rows
- **Key Columns:** CustomerID (PK), FirstName, LastName, EmailAddress, CompanyName
- **Business Use:** Customer demographics and contact info

### 2. SalesLT.Product
- **Purpose:** Product dimension data
- **Row Count:** ~295 rows
- **Key Columns:** ProductID (PK), Name, ProductNumber, Color, Size, ListPrice, ProductCategoryID
- **Business Use:** Product catalog and pricing

### 3. SalesLT.ProductCategory
- **Purpose:** Product hierarchy
- **Row Count:** ~41 rows
- **Key Columns:** ProductCategoryID (PK), Name, ParentProductCategoryID
- **Business Use:** Product categorization

### 4. SalesLT.SalesOrderHeader
- **Purpose:** Sales order header (fact table)
- **Row Count:** ~32 rows
- **Key Columns:** SalesOrderID (PK), OrderDate, DueDate, ShipDate, CustomerID, SubTotal, TaxAmt, TotalDue
- **Business Use:** Order-level transactions

### 5. SalesLT.SalesOrderDetail
- **Purpose:** Sales order line items (fact table)
- **Row Count:** ~542 rows
- **Key Columns:** SalesOrderID (FK), SalesOrderDetailID (PK), ProductID, OrderQty, UnitPrice, LineTotal
- **Business Use:** Line-item level sales details

## Data Quality Observations
- ✅ No obvious nulls in key columns
- ✅ Referential integrity maintained (FKs valid)
- ⚠️ Some products have NULL in Color/Size (expected for certain product types)
- ✅ Date ranges: Single day snapshot (2008-06-01) - limited temporal data
- ⚠️ Small dataset volume - suitable for learning, not performance testing

## Refresh Strategy
- **Frequency:** Manual trigger (on-demand for learning)
- **Type:** Full load only (snapshot data - no incremental possible)
- **Volume:** ~1,750 total rows across all tables
- **Note:** Single date snapshot (2008-06-01) - suitable for pipeline development and testing