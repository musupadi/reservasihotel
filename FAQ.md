# ❓ FAQ - Hotel Reservation Blockchain System

## 📚 Daftar Isi
- [Tentang Sistem](#tentang-sistem)
- [Cara Kerja Sistem](#cara-kerja-sistem)
- [Pertanyaan Umum](#pertanyaan-umum)
- [Technical Questions](#technical-questions)
- [Troubleshooting](#troubleshooting)

---

## 🏗️ Tentang Sistem

### Apa itu sistem ini?
Sistem reservasi hotel berbasis **blockchain Hyperledger Fabric** yang menggunakan teknologi distributed ledger untuk mencatat dan mengelola reservasi hotel secara transparan, aman, dan tidak dapat diubah (immutable).

### Teknologi yang digunakan?
- **Backend**: Go (Golang) dengan Gin Framework
- **Frontend**: React dengan Vite
- **Database**: MySQL (untuk data off-chain)
- **Blockchain**: Hyperledger Fabric (untuk data on-chain)
- **Storage**: CouchDB (state database untuk Fabric)
- **Container**: Docker & Docker Compose

---

## ⚙️ Cara Kerja Sistem

### Arsitektur Sistem

```
┌─────────────┐
│   User      │
│  (Browser)  │
└──────┬──────┘
       │ HTTP Request (Port 3000)
       ▼
┌─────────────────┐
│ React Frontend  │
│  (Vite + TW)    │
└──────┬──────────┘
       │ API Call (Port 8080)
       ▼
┌──────────────────────────────┐
│   Go Backend (API Gateway)   │
│  - REST API (Gin)            │
│  - Business Logic            │
│  - Fabric SDK Client         │
└─────┬──────────────────┬─────┘
      │                  │
      │ SQL              │ Invoke/Query Chaincode
      ▼                  ▼
┌──────────┐    ┌───────────────────────┐
│  MySQL   │    │ Hyperledger Fabric    │
│ Database │    │ - Orderer (7050)      │
│          │    │ - Peer0 (7051)        │
│          │    │ - Peer1 (8051)        │
│          │    │ - CouchDB (5984,6984) │
└──────────┘    └───────────────────────┘
```

### Alur Proses Reservasi

#### 1. **Pembuatan Reservasi (Create)**
```
User → Frontend → Backend API → MySQL (simpan data) 
                             → Fabric Chaincode (CreateReservation)
                             → Blockchain (data tersimpan immutable)
```

**Detail:**
- User mengisi form reservasi (hotel, tanggal, jumlah tamu, dll)
- Frontend mengirim POST request ke `/api/reservations`
- Backend menyimpan data ke MySQL (off-chain storage)
- Backend invoke chaincode `CreateReservation` ke Fabric
- Chaincode menyimpan hash/data penting ke blockchain ledger
- Transaksi tercatat permanent dengan timestamp & MSP ID

#### 2. **Konfirmasi Reservasi (Confirm)**
```
User → Frontend → Backend API → Fabric Chaincode (ConfirmReservation)
                             → Status berubah: PENDING → CONFIRMED
                             → MySQL updated
                             → History tercatat di blockchain
```

#### 3. **Check-in / Check-out**
```
User → Frontend → Backend API → Fabric Chaincode (CheckIn/CheckOut)
                             → Status berubah: CONFIRMED → CHECKED_IN → CHECKED_OUT
                             → Setiap perubahan tercatat sebagai transaksi baru
```

#### 4. **Melihat History Blockchain**
```
User → Frontend → Backend API → Fabric Chaincode (GetReservationHistory)
                             → Menampilkan semua perubahan yang pernah terjadi
                             → Siapa yang melakukan, kapan, status apa
```

---

## 💡 Pertanyaan Umum

### 1. **Kenapa pakai blockchain untuk reservasi hotel?**

**Keuntungan menggunakan blockchain:**
- ✅ **Immutability**: Data tidak dapat diubah/dihapus, cocok untuk audit
- ✅ **Transparency**: Semua pihak dapat melihat history transaksi
- ✅ **Security**: Enkripsi dan distributed ledger mencegah fraud
- ✅ **Decentralization**: Tidak ada single point of failure
- ✅ **Trust**: Tidak perlu pihak ketiga untuk verifikasi data
- ✅ **Audit Trail**: History lengkap setiap perubahan status reservasi

**Use Case Ideal:**
- Multi-partner hotel networks (chain hotels)
- Corporate booking dengan multiple approvals
- Event/meeting packages dengan compliance requirements
- Sistem yang butuh audit trail ketat (legal, finance)

### 2. **Apa bedanya data di MySQL vs Blockchain?**

| MySQL (Off-chain) | Blockchain (On-chain) |
|-------------------|----------------------|
| Data detail lengkap (hotel, user, dll) | Hash/data kritikal saja |
| Bisa di-update/delete | **Immutable** (tidak bisa diubah) |
| Performa cepat untuk query | Performa lebih lambat |
| Biaya storage rendah | Biaya consensus overhead |
| Single point of truth | Distributed ledger |

**Strategi Hybrid:**
- MySQL: Data user, hotel, room types, pricing
- Blockchain: Reservation ID, status changes, transaction hash, audit trail

### 3. **Apa itu Chaincode?**

**Chaincode** = Smart Contract di Hyperledger Fabric

Fungsi chaincode di sistem ini:
- `InitLedger()`: Inisialisasi ledger dengan data sample
- `CreateReservation()`: Buat reservasi baru
- `GetReservation()`: Ambil data reservasi
- `UpdateReservationStatus()`: Update status
- `ConfirmReservation()`: Konfirmasi reservasi
- `CancelReservation()`: Batalkan reservasi
- `CheckIn()` / `CheckOut()`: Proses check-in/out
- `GetAllReservations()`: List semua reservasi
- `GetReservationHistory()`: Audit trail lengkap

### 4. **Apa itu MSP (Membership Service Provider)?**

MSP adalah identitas organisasi dalam Fabric network.

Di sistem ini:
- **HotelOrgMSP**: Organisasi hotel (peer0, peer1)
- **OrdererOrgMSP**: Organisasi orderer

Setiap transaksi tercatat dengan MSP ID untuk tracking siapa yang melakukan action.

### 5. **Bagaimana cara kerja consensus di sistem ini?**

Sistem menggunakan **Solo Orderer** (single orderer):
- Cocok untuk development/testing
- Satu orderer node yang mengurutkan transaksi
- Production sebaiknya pakai **Raft** atau **Kafka** (multiple orderers)

**Alur Consensus:**
1. User submit transaksi via API
2. Backend invoke chaincode ke peer
3. Peer execute chaincode (simulation)
4. Peer send proposal response ke backend
5. Backend kirim transaction ke orderer
6. Orderer create block dan distribute ke peers
7. Peers validate dan commit block ke ledger

### 6. **Apa itu CouchDB dan fungsinya?**

**CouchDB** adalah state database untuk Hyperledger Fabric.

- **Peer0 (HotelOrg)**: Port 5984
- **Peer1 (HotelOrg)**: Port 6984

**Fungsi:**
- Menyimpan world state (current state) dari blockchain
- Mendukung rich queries (JSON queries)
- Indexing untuk performa query lebih baik

**Cara akses:**
- http://localhost:5984/_utils (CouchDB GUI)
- Username/password: admin/adminpw

### 7. **Berapa lama data disimpan di blockchain?**

**Permanent!** Data di blockchain:
- Tidak pernah dihapus
- Tersimpan selama network hidup
- Bisa di-backup dan restore
- History tercatat selamanya

Ini berbeda dengan MySQL yang bisa di-delete/truncate.

---

## 🔧 Technical Questions

### 8. **Bagaimana cara menambah peer baru?**

Edit [docker-compose.yaml](network/docker-compose.yaml):
```yaml
peer2.hotelorg.reservation.com:
  container_name: peer2.hotelorg.reservation.com
  image: hyperledger/fabric-peer:latest
  environment:
    - CORE_PEER_ID=peer2.hotelorg.reservation.com
    - CORE_PEER_ADDRESS=peer2.hotelorg.reservation.com:9051
    # ... (konfigurasi lainnya)
  ports:
    - 9051:9051
```

Kemudian generate crypto material dan join channel.

### 9. **Bagaimana cara upgrade chaincode?**

```powershell
# 1. Update chaincode version di code
# 2. Package chaincode baru
peer lifecycle chaincode package reservation_v2.tar.gz

# 3. Install ke semua peers
peer lifecycle chaincode install reservation_v2.tar.gz

# 4. Approve & commit
peer lifecycle chaincode approveformyorg --version 2.0
peer lifecycle chaincode commit --version 2.0
```

### 10. **Bagaimana cara backup blockchain data?**

**Option 1: Backup CouchDB**
```powershell
# Backup CouchDB state
curl -X GET http://admin:adminpw@localhost:5984/_all_dbs
curl -X GET http://admin:adminpw@localhost:5984/hotelorg_reservationchannel
```

**Option 2: Backup Ledger Files**
```powershell
# Backup volume ledger dari peer
docker cp peer0.hotelorg.reservation.com:/var/hyperledger/production ./backup/
```

**Option 3: Export Transaksi**
- Query all reservations via API
- Export ke JSON/CSV
- Simpan sebagai backup off-chain

### 11. **Bagaimana monitoring performance?**

**Tools yang bisa digunakan:**
- **Prometheus + Grafana**: Metrics dari Fabric
- **Docker stats**: Resource usage containers
- **Fabric Explorer**: GUI untuk explore blockchain
- **Custom API**: Endpoint `/api/health` untuk health check

### 12. **Bagaimana cara scale sistem ini?**

**Horizontal Scaling:**
1. Tambah peer nodes (peer2, peer3, etc)
2. Gunakan Raft orderer (multiple orderers)
3. Load balancer untuk API Gateway
4. Database replication untuk MySQL

**Vertical Scaling:**
- Increase CPU/RAM untuk containers
- SSD storage untuk faster I/O
- Optimize chaincode (batch operations)

---

## 🐛 Troubleshooting

### 13. **Docker container tidak mau start?**

**Solusi:**
```powershell
# 1. Cek Docker Desktop running
docker --version

# 2. Stop semua containers
docker-compose down -v

# 3. Clean unused resources
docker system prune -a --volumes

# 4. Start ulang
docker-compose up -d
```

### 14. **Backend error "Failed to connect to Fabric"?**

**Kemungkinan penyebab:**
- ❌ Fabric network belum start
- ❌ Crypto material tidak ada
- ❌ Connection profile salah
- ❌ Chaincode belum di-install

**Solusi:**
```powershell
# 1. Pastikan fabric running
docker ps | findstr peer

# 2. Cek crypto material
ls network/organizations/peerOrganizations

# 3. Reinstall chaincode jika perlu
```

### 15. **Frontend tidak bisa connect ke backend?**

**Cek:**
```powershell
# 1. Backend running?
curl http://localhost:8080/api/health

# 2. CORS enabled?
# Cek di main.go ada:
# router.Use(cors.Default())

# 3. Port conflict?
netstat -ano | findstr 8080
```

### 16. **MySQL connection refused?**

**Solusi:**
```powershell
# 1. XAMPP MySQL running?
# Buka XAMPP Control Panel → Start MySQL

# 2. Database sudah dibuat?
mysql -u root -p
CREATE DATABASE reservation;

# 3. Import schema
mysql -u root -p reservation < database/reservation.sql
```

### 17. **Chaincode invoke gagal?**

**Debug steps:**
```powershell
# 1. Cek chaincode installed
docker exec peer0.hotelorg.reservation.com peer lifecycle chaincode queryinstalled

# 2. Cek chaincode committed
docker exec peer0.hotelorg.reservation.com peer lifecycle chaincode querycommitted -C reservationchannel

# 3. Cek logs
docker logs peer0.hotelorg.reservation.com -f

# 4. Test invoke manual
docker exec peer0.hotelorg.reservation.com peer chaincode invoke ...
```

### 18. **CouchDB tidak bisa diakses?**

**Solusi:**
```powershell
# 1. Cek container running
docker ps | findstr couchdb

# 2. Cek port
curl http://localhost:5984

# 3. Default credentials
# Username: admin
# Password: adminpw
```

### 19. **Bagaimana cara register hotel baru?**

**Endpoint:** `POST /api/v1/auth/register-hotel`

**Request Body:**
```json
{
  "email": "owner@hotel.com",
  "password": "password123",
  "full_name": "Hotel Owner Name",
  "phone": "081234567890",
  "hotel_name": "My New Hotel",
  "hotel_city": "Bandung",
  "hotel_address": "Jl. Example No.123",
  "hotel_description": "Hotel description here"
}
```

**Response:**
```json
{
  "message": "Hotel registered successfully",
  "token": "eyJhbGciOiJIUzI1...",
  "user": {
    "id": 10,
    "email": "owner@hotel.com",
    "role": "hotel_super_admin",
    "hotel_id": 15
  },
  "hotel": {
    "id": 15,
    "name": "My New Hotel",
    "status": "active"
  }
}
```

**Yang terjadi di backend:**
1. Validate email belum terdaftar
2. Hash password
3. **Transaction Start**
4. Create hotel baru di database
5. Create user dengan role `hotel_super_admin`
6. Create entry di `hotel_admins` table
7. Update hotel dengan owner info
8. **Transaction Commit**
9. Generate JWT token
10. Return data hotel + user

**Catatan:**
- User yang register otomatis jadi **Super Admin** hotel tersebut
- Mendapat full permissions untuk manage hotel
- Bisa menambah admin/staff lain nanti

---

## 📞 Support

**Need Help?**
- 📖 Documentation: README.md, QUICKSTART.md
- 🔍 Logs: `docker logs <container_name>`
- 💬 Issues: Check common errors above
- 🌐 Resources: 
  - [Hyperledger Fabric Docs](https://hyperledger-fabric.readthedocs.io/)
  - [Go Gin Framework](https://gin-gonic.com/)
  - [React Documentation](https://react.dev/)

---

**Last Updated:** January 2026  
**Version:** 1.0.0
