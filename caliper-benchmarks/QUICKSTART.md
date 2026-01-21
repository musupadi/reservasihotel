# Quick Start Guide - Hyperledger Caliper

## 🚀 Langkah Cepat (5 Menit)

### 1. Install Dependencies
```powershell
cd C:\Blockchain\reservasihotel\caliper-benchmarks
npm install
```

### 2. Bind Caliper ke Fabric
```powershell
npm run bind
```

### 3. Pastikan Network Running
```powershell
cd C:\Blockchain\reservasihotel\network
docker ps
# Pastikan peer0.org1, peer0.org2, orderer, couchdb running
```

### 4. Run Benchmark
```powershell
cd C:\Blockchain\reservasihotel\caliper-benchmarks
npm run benchmark
```

### 5. Lihat Hasil
Buka file `report.html` di browser setelah selesai.

## 📊 Yang Akan Diukur

- ✅ Create Reservation Performance (Write)
- ✅ Query Reservation Performance (Read)
- ✅ Update Reservation Performance (Update)
- ✅ Mixed Workload (Real-world scenario)
- ✅ Stress Test (High load)

## ⏱️ Estimasi Waktu

Total waktu benchmark: **~5-10 menit** (tergantung hardware)

## 🎯 Hasil yang Diharapkan

```
Name: hotel-reservation-benchmark
Succ / Fail : 1100 / 0
Send Rate   : 18.5 TPS
Throughput  : 18.2 TPS
Avg Latency : 0.8 seconds
```

## 📁 File Penting

- [benchmark-config.yaml](benchmark-config.yaml) - Konfigurasi test
- [networks/fabric-network.yaml](networks/fabric-network.yaml) - Konfigurasi network
- [workload/](workload/) - Test scenarios

## ❓ Troubleshooting Cepat

**Error: Cannot find module**
```powershell
npm install
npm run bind
```

**Error: Connection refused**
```powershell
# Pastikan network running
cd ..\network
docker-compose up -d
```

**Low performance**
- Restart Docker Desktop
- Close aplikasi berat lainnya
- Reduce TPS di benchmark-config.yaml

Untuk dokumentasi lengkap, lihat [README.md](README.md) atau [CALIPER_IMPLEMENTATION.md](../CALIPER_IMPLEMENTATION.md)
