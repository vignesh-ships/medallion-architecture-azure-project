# Key Vault Setup

## Purpose
Centralized secret management for:
- Storage account access keys
- Databricks tokens
- Connection strings

## Setup Steps

### 1. Create Key Vault
```
1. Search "Key Vault" → Create
2. Name: kv-medallion-dev-<initials> (globally unique)
3. Region: <YOUR_REGION>
4. Pricing tier: Standard
5. Access configuration: Azure RBAC
6. Networking: Enable public access (all networks)
7. Create
```

### 2. Grant Access to Yourself
```
Key Vault → Access control (IAM) → Add role assignment:
- Role: Key Vault Secrets Officer
- Assign to: Your Azure AD account
```

### 3. Grant Access to ADF
```
Key Vault → Access control (IAM) → Add role assignment:
- Role: Key Vault Secrets User
- Assign to: adf-medallion-dev (Managed Identity)
```

### 4. Store Secrets

**ADLS Access Key:**
```
1. Get: Storage Account → Access keys → key1 → Copy
2. Store: KV → Secrets → Generate/Import
   - Name: adls-access-key
   - Value: <paste key>
```

**Databricks Token:**
```
1. Get: Databricks → User Settings → Access tokens → Generate
2. Store: KV → Secrets → Generate/Import
   - Name: databricks-token
   - Value: <paste token>
```

## Secret Naming Convention
- `adls-access-key` - Storage account key
- `databricks-token` - Databricks PAT
- `<service>-connection-string` - Future connection strings

## Security Best Practices
- ✅ Use RBAC instead of access policies
- ✅ Grant least privilege (Secrets User for read-only)
- ✅ Rotate secrets every 90 days
- ✅ Enable soft-delete (default)
- ✅ Monitor access logs

## Usage in ADF
```
Linked Service creation:
1. Select "Azure Key Vault" as credential source
2. Choose kv-medallion-dev
3. Select secret name (e.g., adls-access-key)
ADF automatically retrieves secret value
```

## Verification
- [x] Key Vault created
- [x] RBAC permissions granted (self + ADF)
- [x] ADLS access key stored
- [x] Databricks token stored