# 🔧 Troubleshooting & Instalasi Windows

## ❌ Error: spawn EINVAL

Error ini terjadi karena bug Caliper di Windows. Berikut solusinya:

## ✅ Solusi: Install Manual (Windows-Compatible)

### Step 1: Clean Install
```powershell
cd C:\Blockchain\reservasihotel\caliper-benchmarks

# Hapus node_modules lama (jika ada)
Remove-Item -Recurse -Force node_modules -ErrorAction SilentlyContinue
Remove-Item package-lock.json -ErrorAction SilentlyContinue

# Install fresh
npm install
```

### Step 2: Bind Fabric SDK (Cara Manual)
```powershell
# Gunakan cara manual yang lebih reliable di Windows
npm run bind
```

Script baru akan install langsung tanpa spawn issue:
```json
"bind": "npm install --no-save fabric-network@2.2.20 fabric-common@2.2.20"
```

### Step 3: Verify Installation
```powershell
npm test
```

Expected output:
```
🔍 Testing Hyperledger Caliper Setup...

1️⃣  Checking Node.js version...
   ✅ Node.js v18.x.x (OK)

2️⃣  Checking @hyperledger/caliper-core...
   ✅ Caliper Core installed

3️⃣  Checking @hyperledger/caliper-fabric...
   ✅ Caliper Fabric installed

4️⃣  Checking fabric-network SDK...
   ✅ Fabric Network SDK installed

5️⃣  Checking fabric-common...
   ✅ Fabric Common installed

6️⃣  Checking configuration files...
   ✅ networks/fabric-network.yaml
   ✅ benchmark-config.yaml
   ✅ workload/create-reservation.js
   ...

✅ ALL TESTS PASSED!
🚀 Ready to run benchmarks: npm run benchmark
```

## 🚀 Cara Menggunakan

### 1. Start Fabric Network
```powershell
cd C:\Blockchain\reservasihotel\network
docker-compose up -d
docker ps  # Verify containers running
```

### 2. Run Small Test First (Recommended)
Edit [benchmark-config.yaml](benchmark-config.yaml) untuk test kecil dulu:

```yaml
rounds:
  # Test kecil untuk verifikasi
  - label: quick-test
    description: Quick verification test
    txNumber: 10          # Cuma 10 transaksi
    rateControl:
      type: fixed-rate
      opts:
        tps: 5            # 5 TPS
    workload:
      module: workload/create-reservation.js
```

### 3. Run Benchmark
```powershell
cd C:\Blockchain\reservasihotel\caliper-benchmarks
npm run benchmark
```

### 4. Check Results
Buka file `report.html` di browser.

## 🧪 Testing Setup (Membuktikan Sudah Terpasang)

### Test 1: Verify Node Modules
```powershell
cd C:\Blockchain\reservasihotel\caliper-benchmarks
npm test
```

### Test 2: Check Installed Packages
```powershell
npm list @hyperledger/caliper-core
npm list fabric-network
```

Expected:
```
@hyperledger/caliper-core@0.6.0
fabric-network@2.2.20
```

### Test 3: Dry Run (Without Actual Network)
```powershell
# Just check if Caliper can load configs
npx caliper launch manager --help
```

### Test 4: Check Network Connectivity
```powershell
# Test jika bisa connect ke Docker containers
docker exec peer0.org1.example.com peer version

# Expected: Version: 2.x.x
```

## 📊 Bukti Berhasil Install

✅ **Checklist:**
- [ ] `npm test` menunjukkan "ALL TESTS PASSED"
- [ ] `npm list fabric-network` menunjukkan versi 2.2.20
- [ ] File `report.html` berhasil di-generate setelah run benchmark
- [ ] Docker containers (peer, orderer, couchdb) running

## 🎯 Quick Test Scenario

Buat file test sederhana:

```powershell
# Create simple-test.yaml
```

```yaml
test:
  name: simple-test
  workers:
    number: 1
  rounds:
    - label: create-test
      txNumber: 5
      rateControl:
        type: fixed-rate
        opts:
          tps: 1
      workload:
        module: workload/create-reservation.js
```

Run:
```powershell
npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/fabric-network.yaml --caliper-benchconfig simple-test.yaml --caliper-flow-only-test
```

## 🐛 Common Issues

### Issue 1: npm install stuck
**Solution:**
```powershell
npm cache clean --force
npm install --legacy-peer-deps
```

### Issue 2: fabric-network not found setelah bind
**Solution:**
```powershell
npm install fabric-network@2.2.20 fabric-common@2.2.20
```

### Issue 3: Permission denied di Windows
**Solution:**
```powershell
# Run PowerShell as Administrator
# Or disable Windows Defender temporarily
```

### Issue 4: Cannot read crypto materials
**Solution:**
Check path di `networks/fabric-network.yaml`:
```yaml
clientPrivateKey:
  path: '../../network/organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/priv_sk'
```

Verify file exists:
```powershell
Test-Path "C:\Blockchain\reservasihotel\network\organizations\peerOrganizations\org1.example.com\users\User1@org1.example.com\msp\keystore\priv_sk"
```

### Issue 5: Docker containers not accessible
**Solution:**
```powershell
docker network inspect reservasihotel_default
# Check if containers are in same network
```

## 📈 Progressive Testing

1. **Phase 1: Setup Verification**
   ```powershell
   npm test  # Should all pass
   ```

2. **Phase 2: Mini Test (10 transactions)**
   ```powershell
   npm run benchmark  # Edit config to 10 tx first
   ```

3. **Phase 3: Small Test (100 transactions)**
   ```powershell
   npm run benchmark  # 100 tx @ 10 TPS
   ```

4. **Phase 4: Full Test (1000+ transactions)**
   ```powershell
   npm run benchmark  # Full benchmark suite
   ```

## 🎉 Success Indicators

Kalau berhasil, Anda akan lihat:

```
2026.01.16-XX:XX:XX.XXX info [caliper] [caliper-engine]      Starting round 1 (create-reservation)
2026.01.16-XX:XX:XX.XXX info [caliper] [report-builder]      ######## Submitting  50 TXs ########
2026.01.16-XX:XX:XX.XXX info [caliper] [report-builder]      ######## Submitting 100 TXs ########
...
2026.01.16-XX:XX:XX.XXX info [caliper] [report-builder]      Created report at: report.html
```

Dan file `report.html` berisi tabel seperti:
```
┌─────────────────────┬─────────┬──────────┐
│ Test Round          │ Succ    │ Throughput│
├─────────────────────┼─────────┼──────────┤
│ create-reservation  │ 100     │ 9.8 tps  │
└─────────────────────┴─────────┴──────────┘
```

## 💡 Tips

- Gunakan `npm test` untuk quick verification
- Start dengan test kecil (10-50 tx) dulu
- Monitor Docker resources: `docker stats`
- Jika lambat, kurangi TPS di config
- Backup report.html setelah setiap run

## 📚 Next Steps

Setelah setup berhasil:
1. ✅ Run baseline benchmark (10 TPS)
2. ✅ Increase load gradually (20, 50, 100 TPS)
3. ✅ Analyze report.html results
4. ✅ Tune Fabric config based on bottlenecks
5. ✅ Re-run benchmarks to verify improvements
