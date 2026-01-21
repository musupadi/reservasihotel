# 🎯 Quick Test Commands

## Test 1: Quick Verification (Recommended First)
Hanya 15 transaksi untuk verifikasi cepat:

```powershell
cd C:\Blockchain\reservasihotel\caliper-benchmarks
npx caliper launch manager --caliper-workspace ./ --caliper-networkconfig networks/fabric-network.yaml --caliper-benchconfig quick-test.yaml --caliper-flow-only-test
```

**Waktu:** ~1-2 menit

---

## Test 2: Small Benchmark
100 transaksi untuk test performa:

```powershell
npm run benchmark
```

**Waktu:** ~5-10 menit

---

## 📊 Cara Baca Hasil

Setelah selesai, buka `report.html` di browser.

Yang perlu dilihat:
- **Succ**: Jumlah transaksi sukses (harus = txNumber)
- **TPS**: Transactions Per Second (throughput)
- **Latency**: Waktu respons (semakin kecil semakin baik)

Contoh hasil bagus:
```
┌──────────────────────┬──────┬──────┬──────────┬───────────┐
│ Name                 │ Succ │ Fail │ Send Rate│ Throughput│
├──────────────────────┼──────┼──────┼──────────┼───────────┤
│ quick-create-test    │  10  │  0   │  5 tps   │  4.8 tps │
│ quick-query-test     │   5  │  0   │  3 tps   │  2.9 tps │
└──────────────────────┴──────┴──────┴──────────┴───────────┘
```

---

## 🐛 Jika Ada Error

### Error: Cannot connect to peer
```powershell
# Check network
cd ..\network
docker-compose ps

# Restart if needed
docker-compose restart
```

### Error: Transaction timeout
Edit [quick-test.yaml](quick-test.yaml), kurangi TPS:
```yaml
opts:
  tps: 2  # Lebih lambat
```

### Error: Crypto materials not found
```powershell
# Check if network setup correctly
Test-Path "..\network\organizations\peerOrganizations\org1.example.com"
```

---

## 📂 Output Files

- `report.html` - HTML report dengan grafik
- `caliper.log` - Detailed logs (jika error)

---

## ✅ Success Checklist

Anda berhasil jika:
- [ ] Command berjalan tanpa error
- [ ] Semua transaksi "Succ" (tidak ada Fail)
- [ ] File `report.html` ter-generate
- [ ] TPS mendekati target rate
- [ ] Bisa buka dan lihat grafik di report.html

---

## 🎉 Next Steps

Setelah quick test berhasil:
1. Run full benchmark: `npm run benchmark`
2. Experiment dengan TPS lebih tinggi
3. Analyze bottlenecks dari report
4. Optimize Fabric configuration
