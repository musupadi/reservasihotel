# 📊 Implementasi Hyperledger Caliper untuk Sistem Reservasi Hotel

## 🎯 Tujuan

Dokumen ini menjelaskan cara mengimplementasikan **Hyperledger Caliper** untuk melakukan benchmarking performa sistem reservasi hotel berbasis Hyperledger Fabric.

## ❓ Apa itu Hyperledger Caliper?

Hyperledger Caliper adalah framework open-source untuk mengukur performa blockchain dengan metrics:
- **TPS (Transactions Per Second)** - Throughput jaringan
- **Latency** - Waktu respons transaksi
- **Resource Utilization** - Penggunaan CPU, Memory, Network
- **Success Rate** - Tingkat keberhasilan transaksi

## 🏗️ Struktur Implementasi

```
caliper-benchmarks/
├── networks/                          # Konfigurasi koneksi ke Fabric network
│   ├── fabric-network.yaml           # Config utama Caliper
│   ├── connection-profile-org1.yaml  # Koneksi Org1
│   └── connection-profile-org2.yaml  # Koneksi Org2
├── workload/                         # Modul test scenarios
│   ├── create-reservation.js         # Test create reservation
│   ├── query-reservation.js          # Test query by ID
│   ├── query-all.js                  # Test query semua data
│   ├── update-reservation.js         # Test update status
│   └── mixed-workload.js             # Test skenario campuran
├── benchmark-config.yaml             # Konfigurasi benchmark
├── package.json                      # Dependencies
└── README.md                         # Dokumentasi lengkap
```

## 📦 Instalasi

### 1. Pastikan Network Fabric Berjalan

```powershell
# Masuk ke directory network
cd C:\Blockchain\reservasihotel\network

# Start network dan chaincode
docker-compose up -d

# Verify containers running
docker ps
```

### 2. Install Caliper

```powershell
# Masuk ke directory caliper-benchmarks
cd C:\Blockchain\reservasihotel\caliper-benchmarks

# Install dependencies
npm install

# Bind Caliper dengan Fabric 2.2
npm run bind
```

## 🚀 Menjalankan Benchmark

### Run Semua Test

```powershell
npm run benchmark
```

### Hasil yang Diharapkan

Caliper akan menjalankan 6 rounds:
1. ✅ **Create Reservation** - 100 transaksi @ 10 TPS
2. ✅ **Query Reservation** - 200 transaksi @ 20 TPS
3. ✅ **Query All** - 50 transaksi @ 5 TPS
4. ✅ **Update Reservation** - 100 transaksi @ 10 TPS
5. ✅ **Mixed Workload** - 150 transaksi @ 15 TPS
6. ✅ **Stress Test** - 500 transaksi @ 50 TPS

## 📈 Memahami Hasil Benchmark

Setelah selesai, Caliper akan generate file `report.html` dengan informasi:

### 1. **Performance Metrics**
```
┌─────────────────────┬─────────┬──────────┬──────────┬──────────┐
│ Test Round          │ Succ    │ Fail     │ Send Rate│ Throughput│
├─────────────────────┼─────────┼──────────┼──────────┼──────────┤
│ create-reservation  │ 100     │ 0        │ 10 tps   │ 9.8 tps  │
│ query-reservation   │ 200     │ 0        │ 20 tps   │ 19.5 tps │
│ mixed-workload      │ 150     │ 0        │ 15 tps   │ 14.7 tps │
└─────────────────────┴─────────┴──────────┴──────────┴──────────┘
```

### 2. **Latency Distribution**
- **Min**: Waktu transaksi tercepat
- **Max**: Waktu transaksi terlambat
- **Avg**: Rata-rata waktu transaksi
- **p50**: 50% transaksi selesai dalam waktu ini
- **p95**: 95% transaksi selesai dalam waktu ini

### 3. **Resource Utilization**
- CPU usage per container
- Memory usage per container
- Network I/O

## 🎨 Kustomisasi Test

### Mengubah Transaction Rate

Edit [benchmark-config.yaml](caliper-benchmarks/benchmark-config.yaml):

```yaml
rounds:
  - label: create-reservation
    txNumber: 200        # Ubah jumlah transaksi
    rateControl:
      type: fixed-rate
      opts:
        tps: 20          # Ubah TPS
```

### Menambah Test Scenario Baru

1. **Buat file workload baru**:

```javascript
// workload/custom-test.js
'use strict';
const { WorkloadModuleBase } = require('@hyperledger/caliper-core');

class CustomWorkload extends WorkloadModuleBase {
    async submitTransaction() {
        const request = {
            contractId: 'reservation',
            contractFunction: 'YourFunction',
            invokerIdentity: 'User1',
            contractArguments: ['arg1', 'arg2'],
            readOnly: false
        };
        await this.sutAdapter.sendRequests(request);
    }
}

function createWorkloadModule() {
    return new CustomWorkload();
}

module.exports.createWorkloadModule = createWorkloadModule;
```

2. **Tambahkan di benchmark-config.yaml**:

```yaml
rounds:
  - label: custom-test
    description: Test kustom saya
    txNumber: 100
    rateControl:
      type: fixed-rate
      opts:
        tps: 10
    workload:
      module: workload/custom-test.js
```

## 📊 Skenario Benchmark yang Tersedia

### 1. Create Reservation
- **Fungsi**: `CreateReservation`
- **Tujuan**: Mengukur performa write operation
- **Workload**: 100 transaksi @ 10 TPS

### 2. Query Reservation
- **Fungsi**: `ReadReservation`
- **Tujuan**: Mengukur performa read single record
- **Workload**: 200 transaksi @ 20 TPS

### 3. Query All Reservations
- **Fungsi**: `GetAllReservations`
- **Tujuan**: Mengukur performa query kompleks
- **Workload**: 50 transaksi @ 5 TPS

### 4. Update Reservation
- **Fungsi**: `UpdateReservationStatus`
- **Tujuan**: Mengukur performa update operation
- **Workload**: 100 transaksi @ 10 TPS

### 5. Mixed Workload
- **Operasi**: 40% Create, 40% Read, 20% Update
- **Tujuan**: Simulasi penggunaan real-world
- **Workload**: 150 transaksi @ 15 TPS

### 6. Stress Test
- **Fungsi**: `CreateReservation`
- **Tujuan**: Test performa di high load
- **Workload**: 500 transaksi @ 50 TPS

## 🔧 Troubleshooting

### Problem: Caliper tidak terhubung ke network

**Solusi**: Cek path crypto materials di `fabric-network.yaml`:

```yaml
clientPrivateKey:
  path: '../../network/organizations/peerOrganizations/org1.example.com/...'
```

Pastikan path sesuai dengan struktur folder Anda.

### Problem: Low TPS / High Latency

**Solusi**:
1. Cek resource Docker containers: `docker stats`
2. Increase block timeout di Fabric config
3. Reduce concurrent workers di benchmark config
4. Gunakan dedicated machine untuk Caliper

### Problem: Transaksi gagal (Fail > 0)

**Solusi**:
1. Cek chaincode logs: `docker logs peer0.org1.example.com`
2. Cek endorsement policy
3. Verify chaincode deployed correctly
4. Increase timeout di connection profile

## 📈 Best Practices

### 1. **Prepare Environment**
- Gunakan network bersih (clean state)
- Stop aplikasi lain yang berat
- Ensure Docker memiliki resource cukup

### 2. **Run Multiple Iterations**
- Jalankan benchmark 3-5 kali
- Ambil rata-rata hasil
- Buang hasil outlier

### 3. **Progressive Load Testing**
```
Round 1: 10 TPS  → Baseline
Round 2: 20 TPS  → 2x load
Round 3: 50 TPS  → 5x load
Round 4: 100 TPS → 10x load (find breaking point)
```

### 4. **Monitor Resources**
```powershell
# Monitor Docker containers
docker stats

# Monitor system resources
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10
```

## 📊 Interpretasi Hasil

### Good Performance
```
✅ TPS: > 80% dari target rate
✅ Success Rate: 100%
✅ Avg Latency: < 1 second
✅ CPU Usage: < 70%
```

### Need Optimization
```
⚠️ TPS: < 50% dari target rate
⚠️ Success Rate: < 95%
⚠️ Avg Latency: > 3 seconds
⚠️ CPU Usage: > 90%
```

## 🎯 Use Cases

### 1. **Development**
- Verify chaincode performance
- Compare different implementations
- Find bottlenecks

### 2. **Testing**
- Load testing before deployment
- Capacity planning
- SLA verification

### 3. **Production Monitoring**
- Baseline performance metrics
- Detect performance degradation
- Validate infrastructure changes

## 📚 Resources

- [Hyperledger Caliper Docs](https://hyperledger.github.io/caliper/)
- [Fabric Performance Guide](https://hyperledger-fabric.readthedocs.io/en/latest/performance.html)
- [Caliper GitHub](https://github.com/hyperledger/caliper)

## 🎉 Kesimpulan

Dengan Hyperledger Caliper, Anda dapat:
- ✅ Mengukur performa blockchain secara objektif
- ✅ Membandingkan berbagai skenario
- ✅ Menemukan bottleneck sistem
- ✅ Validasi performa sebelum production
- ✅ Generate report profesional untuk stakeholder

Selamat benchmarking! 🚀
