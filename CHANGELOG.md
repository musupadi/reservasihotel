# 📝 Changelog - Hotel Reservation System

## [2025-10-18] - Project Cleanup & Simplification

### 🗑️ Removed
- ❌ **Folder `builders/`** - CCAAS mode tidak dipakai
- ❌ **Folder `config/`** - Duplikat, config sebenarnya ada di `network/`
- ❌ **Folder `scripts/`** - Tidak perlu wrapper scripts, command langsung lebih jelas

### ✅ Updated
- 📄 **README.md** - Direct commands tanpa scripts
- 📄 **QUICKSTART.md** - Simplified 3-step startup
- 📄 **PANDUAN-LENGKAP.md** - Already clean, no changes needed

### 🎯 Benefits
- ✨ Struktur folder lebih bersih dan sederhana
- ✨ User langsung paham command yang dijalankan
- ✨ Tidak perlu maintain script files terpisah
- ✨ Lebih mudah troubleshoot (langsung lihat command)

### 📁 Current Structure
```
reservasihotel/
├── bin/                    # Fabric CLI tools (PENTING!)
├── chaincode/              # Smart contract (PENTING!)
├── api-gateway/            # Go backend (PENTING!)
├── web-ui/                 # React frontend (PENTING!)
├── network/                # Fabric network config (PENTING!)
├── README.md               # Technical documentation
├── PANDUAN-LENGKAP.md      # Step-by-step guide (Bahasa)
├── QUICKSTART.md           # Quick start guide
└── CHANGELOG.md            # This file
```

### 🚀 Quick Start Commands
```powershell
# 1. Start Fabric
cd network
docker-compose -f docker-compose-simple.yaml up -d

# 2. Start Backend
cd api-gateway
go run main.go blockchain.go fabric_client.go

# 3. Start Frontend
cd web-ui
npm run dev
```

---

## Previous Changes

### [2025-10-17] - Initial System Setup
- ✅ Hyperledger Fabric 2.5 network deployed
- ✅ Go API Gateway with hybrid blockchain
- ✅ React frontend with Vite + Tailwind
- ✅ MySQL database integration
- ✅ Dual storage architecture (MySQL + Fabric)
