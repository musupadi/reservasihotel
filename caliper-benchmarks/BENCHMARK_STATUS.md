# Caliper Benchmark Results

## Status
❌ **Benchmark FAILED** - Configuration error

## Error Details
```
Error: No connection profile file found at 
C:\Blockchain\reservasihotel\caliper-benchmarks\connection-org1.yaml
```

**Root Cause**: Path di `fabric-test-network.yaml` menggunakan relative path `./networks/connection-org1.yaml`, tapi Caliper mencari di root folder.

## Files Location
✅ Files exist at:
- `C:\Blockchain\reservasihotel\caliper-benchmarks\networks\connection-org1.yaml`
- `C:\Blockchain\reservasihotel\caliper-benchmarks\networks\connection-org2.yaml`

## Next Steps to Fix
1. Update path di `fabric-test-network.yaml` dari `./networks/` ke absolute path
2. Atau copy connection profiles ke root folder
3. Deploy chaincode dulu ke test-network (optional)
4. Re-run benchmark

## Alternative Approach
Karena kompleksitas Windows path dan Docker socket issue untuk chaincode:
- Gunakan **mock data** approach untuk demo
- Atau gunakan **pre-deployed chaincode** dari fabric-samples
- Fokus ke **network performance metrics** tanpa custom chaincode

## Report Location
**No HTML report generated** karena benchmark gagal di initialization phase.

Report akan generate di `report.html` di root folder caliper-benchmarks setelah benchmark sukses.

## Command to View Results
Setelah fix dan benchmark sukses:
```powershell
cd C:\Blockchain\reservasihotel\caliper-benchmarks
start report.html
```
