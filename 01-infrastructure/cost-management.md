# Cost Management & Monitoring

## Budget Tracking

### Monthly Budget Allocation
- **Total Budget:** $50/month
- **Storage (ADLS):** $2-6/month
- **Databricks:** $12-25/month
- **Data Factory:** $6-12/month
- **Buffer:** $7-20/month

### Cost by Phase
- **Setup Phase (Week 1-2):** $10-15 (one-time cluster setup/testing)
- **Development Phase (Week 3-6):** $30-40 (active development)
- **Maintenance Phase:** $5-10/month (scheduled runs only)

## Monitoring Strategy

### Azure Cost Management
```
1. Portal → Cost Management + Billing
2. Set up Budget Alert:
   - Budget: $50/month
   - Alert at: 80% ($40), 100% ($50)
   - Email notifications enabled
```

### Daily Cost Checks
- Check Azure Cost Analysis daily during development
- Track spending by resource
- Identify cost spikes immediately

### Resource-Specific Monitoring

**Databricks:**
- Check cluster usage: Workspace → Compute → Usage
- Verify auto-termination working
- Monitor DBU (Databricks Unit) consumption

**Storage:**
- Monitor transaction costs (List/Read operations)
- Check data volume growth
- Review access patterns

**Data Factory:**
- Pipeline run history and frequency
- Activity run costs
- Integration runtime hours

## Cost Optimization Checklist

### Daily
- [ x ] Stop Databricks cluster after work
- [ x ] Verify no orphaned resources running

### Weekly
- [ x ] Review cost analysis dashboard
- [ x ] Check budget alerts
- [ x ] Validate auto-termination settings

### End of Project
- [  ] Delete all resources
- [  ] Keep documentation, delete compute resources
- [ x ] Export pipeline JSON/notebooks before cleanup

## Emergency Cost Controls

If costs exceed budget:
1. **Immediate:** Stop all Databricks clusters
2. **Review:** Check cost analysis for spike cause
3. **Pause:** ADF pipeline triggers
4. **Optimize:** Reduce cluster size or switch to smaller node types

## Cost Saving Tips
- Run pipelines only when testing (not scheduled initially)
- Use notebook workflows instead of jobs (free)
- Compress data in Bronze layer
- Delete test datasets after validation
- Use Databricks Community Edition for practice (free, limited features)

## Actual Cost Tracking

| Week | Resource | Actual Cost | Notes |
|------|----------|-------------|-------|
| 1    | All      | $0.88         | Setup |
| 2    | All      | $4.21        | Dev/Testing |