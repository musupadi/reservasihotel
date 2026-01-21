# 🎯 STEP-BY-STEP SETUP NETWORK UNTUK CALIPER

## 📊 Status Saat Ini

✅ Yang Sudah Ada:
- Peer containers running (hotelorg, guestorg)
- CouchDB running
- CLI container running
- Caliper sudah installed

❌ Yang Belum Ada:
- Orderer tidak berjalan (crypto materials hilang)
- Channel belum dibuat
- Chaincode belum deployed

---

## 🚀 SOLUSI: Setup Step-by-Step

### **Opsi A: Testing Caliper dengan Network Sederhana (RECOMMENDED)**

Karena network Anda kompleks dan crypto materials hilang, saya sarankan test Caliper dulu dengan:

#### **Alternatif 1: Gunakan Fabric Test Network (Official)**

```powershell
# 1. Download Fabric Samples
cd C:\Blockchain
git clone https://github.com/hyperledger/fabric-samples.git
cd fabric-samples\test-network

# 2. Start test network
.\network.sh up createChannel -c mychannel -ca

# 3. Deploy chaincode (gunakan asset-transfer-basic)
.\network.sh deployCC -ccn basic -ccp ../asset-transfer-basic/chaincode-go -ccl go

# 4. Update Caliper config untuk test network ini
# Edit: caliper-benchmarks/networks/fabric-network.yaml
# Sesuaikan path ke fabric-samples/test-network
```

#### **Alternatif 2: Mock Test (Tanpa Network)**

Caliper bisa run dalam mode testing tanpa actual network untuk verify setup:

```powershell
cd C:\Blockchain\reservasihotel\caliper-benchmarks

# Create mock test config
# Akan saya buatkan file config untuk mock test
```

### **Opsi B: Fix Network Anda (Lebih Lama)**

Jika Anda ingin fix network reservation hotel:

#### Step 1: Generate Crypto Materials

Buat script generate crypto:

```powershell
# File: generate-crypto.ps1
cd C:\Blockchain\reservasihotel\network

# Install cryptogen tool
# Download dari: https://github.com/hyperledger/fabric/releases

# Generate orderer crypto
cryptogen generate --config=./crypto-config-orderer.yaml --output="organizations"

# Generate peer crypto  
cryptogen generate --config=./crypto-config-peer.yaml --output="organizations"
```

#### Step 2: Create Channel

```powershell
# Jalankan script deploy
cd C:\Blockchain\reservasihotel\network\scripts
.\deploy-chaincode.ps1
```

#### Step 3: Deploy Chaincode

```powershell
# After channel created, deploy chaincode
# Script sudah ada di deploy-chaincode.ps1
```

---

## 💡 REKOMENDASI SAYA

**Untuk SEKARANG**, saya sarankan:

### **Quick Win: Test Caliper dengan Mock/Sample Data**

Saya akan buatkan:
1. ✅ Mock network config yang bisa test Caliper functionality
2. ✅ Sample workload untuk verify Caliper works
3. ✅ Script untuk test tanpa actual Fabric network

Ini untuk **MEMBUKTIKAN Caliper sudah siap**, tanpa harus fix network dulu.

### **Nanti (Untuk Production):**
- Fix network reservation hotel dengan benar
- Generate crypto materials lengkap
- Deploy ke production

---

## ❓ Mau Lanjut Kemana?

**Pilih opsi:**

1. **[CEPAT] Mock Test Caliper** 
   - Saya buatkan config mock test
   - Verify Caliper functionality works
   - Dapat report hasil test
   - **Waktu: 5 menit**

2. **[SEDANG] Pakai Fabric Test Network Official**
   - Download fabric-samples
   - Start test network
   - Run Caliper dengan test network
   - **Waktu: 30 menit**

3. **[LAMA] Fix Network Reservation Hotel**
   - Generate crypto materials
   - Create channel
   - Deploy chaincode reservation
   - Run Caliper
   - **Waktu: 2-3 jam**

---

## 🎯 Mana yang Anda pilih?

Ketik:
- "1" untuk Mock Test (paling cepat)
- "2" untuk Test Network Official (recommended untuk belajar)
- "3" untuk Fix network reservation hotel lengkap

Atau saya bisa langsung kerjakan opsi 1 (Mock Test) untuk show Caliper works! 🚀
