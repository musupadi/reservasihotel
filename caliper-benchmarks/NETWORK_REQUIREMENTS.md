# ⚠️ PENTING: Network Configuration

## Network Structure Anda

Berdasarkan `docker ps`, network Anda memiliki:

```
✅ peer0.hotelorg.reservation.com  (Port 7051)
✅ peer0.guestorg.reservation.com  (Port 8051/9051)  
✅ couchdb0 & couchdb1
❌ NO ORDERER RUNNING
```

## 🚨 Problem: Orderer Tidak Running

Hyperledger Caliper **MEMBUTUHKAN orderer** untuk mengirim transaksi.

### Solusi 1: Start Orderer (Recommended)

```powershell
cd C:\Blockchain\reservasihotel\network

# Check docker-compose config
docker-compose config | findstr orderer

# Start orderer
docker-compose up -d orderer.reservation.com

# Verify
docker ps | findstr orderer
```

Expected output:
```
orderer.reservation.com   Up x minutes
```

### Solusi 2: Gunakan Network Lain

Jika orderer memang tidak ada di setup ini, Anda perlu network lengkap dengan orderer.

## 📋 Checklist Network Requirements untuk Caliper

Untuk Caliper bekerja, diperlukan:
- [x] Peer nodes running
- [x] CouchDB running
- [ ] **Orderer running** ⚠️ MISSING
- [ ] Channel created
- [ ] Chaincode deployed

## 🔍 Verify Network Setup

```powershell
# 1. Check all containers
docker ps

# 2. Check if channel exists
docker exec peer0.hotelorg.reservation.com-1 peer channel list

# 3. Check if chaincode deployed
docker exec peer0.hotelorg.reservation.com-1 peer lifecycle chaincode queryinstalled
```

## 🚀 Alternative: Use Existing Network Test

Jika network Anda sudah complete (dengan orderer), tapi orderer tidak muncul di `docker ps`, mungkin:

1. **Orderer di compose file berbeda**
   ```powershell
   cd C:\Blockchain\reservasihotel\network
   docker-compose -f docker-compose-simple.yaml ps
   ```

2. **Orderer dengan nama lain**
   ```powershell
   docker ps -a | findstr -i order
   ```

3. **Network belum fully setup**
   - Perlu run setup scripts dulu
   - Create channel
   - Deploy chaincode

## 💡 Recommendation

Sebelum lanjut dengan Caliper benchmark, pastikan:

1. ✅ Network lengkap (peer + orderer + couch)
2. ✅ Channel sudah dibuat
3. ✅ Chaincode sudah deployed dan ready
4. ✅ Bisa invoke chaincode manual (via API gateway)

## 🎯 Next Steps

**Option A: Jika orderer memang tidak perlu di setup Anda**
- Caliper tidak bisa dipakai
- Network ini mungkin untuk testing lokal saja

**Option B: Setup orderer dulu**
```powershell
# Check if orderer config exists
cat C:\Blockchain\reservasihotel\network\docker-compose.yaml | Select-String "orderer"

# Start orderer if exists
docker-compose up -d orderer.reservation.com
```

**Option C: Test dengan API Gateway dulu**
Pastikan sistem reservasi berjalan normal lewat API Gateway sebelum benchmark dengan Caliper.

## ❓ Questions?

Cek dokumentasi network Anda:
- [README.md](../../README.md)
- [QUICKSTART.md](../../QUICKSTART.md)

Atau tanyakan:
- Apakah network ini sudah pernah bisa create reservation?
- Bagaimana cara normal start network ini?
- Apakah ada script setup.sh atau deploy.sh?
