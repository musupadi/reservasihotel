# 🏨 Hotel Reservation System with Hyperledger Fabric

Sistem reservasi hotel berbasis blockchain menggunakan **Hyperledger Fabric**, **Go Backend**, **React Frontend**, dan **MySQL Database**.

## � Quick Start - Cara Menjalankan Sistem

### **Prasyarat Sebelum Mulai:**
✅ Docker Desktop sudah terinstall dan **HARUS RUNNING**  
✅ XAMPP sudah terinstall (untuk MySQL)  
✅ Go (Golang) sudah terinstall  
✅ Node.js & npm sudah terinstall  

---

### **🔥 LANGKAH CEPAT - 5 Menit Setup**

#### **1️⃣ Start Docker Desktop**
```powershell
# ⚠️ PENTING: Pastikan Docker Desktop sudah running!
# Buka aplikasi Docker Desktop dan tunggu sampai icon berubah hijau
# Verifikasi:
docker ps
# Jika muncul tabel (meskipun kosong), berarti Docker sudah siap
```

#### **2️⃣ Start MySQL Database**
```powershell
# Buka XAMPP Control Panel
# Klik tombol "Start" untuk MySQL (dan Apache jika perlu)
# Status harus berubah jadi hijau

# Verifikasi MySQL running:
# Buka browser: http://localhost/phpmyadmin
# Pastikan database "reservation" sudah ada
# (Jika belum ada, buat database baru dengan nama "reservation")
```

#### **3️⃣ Start Blockchain Network (Terminal 1)**
```powershell
# Buka PowerShell/Terminal pertama:
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml up -d

# Tunggu ~30 detik, lalu verifikasi (harus ada 5 containers):
docker ps --format "table {{.Names}}\t{{.Status}}"

# Expected output:
# orderer.reservation.com          Up X minutes
# peer0.hotelorg.reservation.com   Up X minutes
# peer0.guestorg.reservation.com   Up X minutes
# couchdb0                         Up X minutes
# couchdb1                         Up X minutes
```

#### **4️⃣ Start Backend API (Terminal 2)**
```powershell
# Buka PowerShell/Terminal kedua:
cd C:\Blockchain\reservasihotel\api-gateway

# Jalankan backend:
go run main.go blockchain.go fabric_client.go

# Expected output:
# [GIN-debug] Listening and serving HTTP on :8080
# Backend running on http://localhost:8080
```

#### **5️⃣ Start Frontend (Terminal 3)**
```powershell
# Buka PowerShell/Terminal ketiga:
cd C:\Blockchain\reservasihotel\web-ui

# Jalankan frontend:
npm run dev

# Expected output:
# VITE v5.x.x ready in xxx ms
# ➜ Local: http://localhost:3000/
```

### **✅ Akses Aplikasi**
- **Website**: http://localhost:3000
- **API Backend**: http://localhost:8080
- **Database**: http://localhost/phpmyadmin
- **CouchDB**: http://localhost:5984/_utils (HotelOrg) | http://localhost:6984/_utils (GuestOrg)

---

### **📊 OPTIONAL: Run Hyperledger Caliper Benchmark (Terminal 4)**

**Caliper** digunakan untuk performance testing blockchain network. Ini **OPTIONAL** - hanya jalankan jika ingin mengukur performa sistem.

```powershell
# Buka PowerShell/Terminal keempat:
cd C:\Blockchain\reservasihotel\caliper-benchmarks

# Jalankan benchmark:
npm run benchmark-test

# Expected output:
# 2 workers connected...
# Started round 1 (query)...
# Benchmark finished...
# Report generated: report.html

# Lihat hasil benchmark:
start report.html
# Atau buka manual: C:\Blockchain\reservasihotel\caliper-benchmarks\report.html
```

**Apa yang di-test Caliper?**
- ✅ Transaction throughput (TPS - Transactions Per Second)
- ✅ Transaction latency (response time)
- ✅ Resource usage (CPU, memory)
- ✅ Success/failure rate
- ✅ Network performance

**Kapan perlu run Caliper?**
- ✅ Untuk skripsi/thesis - data performa blockchain
- ✅ Testing sebelum production deployment
- ✅ Benchmarking setelah perubahan chaincode
- ✅ Membandingkan performa konfigurasi berbeda

**Tidak perlu run Caliper jika:**
- ❌ Hanya development/testing fitur aplikasi
- ❌ Hanya ingin test UI/UX
- ❌ Tidak butuh data performa untuk penulisan

---

### **⏹️ Cara Stop Semua Services**
```powershell
# Stop Backend & Frontend (& Caliper jika sedang running):
# Tekan Ctrl+C di Terminal 2, Terminal 3, dan Terminal 4

# Stop Blockchain Network:
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml down

# Stop MySQL:
# Buka XAMPP Control Panel → Klik "Stop" untuk MySQL
```

---

## 📖 Dokumentasi Lengkap

- 📦 **[INSTALLATION.md](INSTALLATION.md)** - First-time setup guide (npm install, go mod, database setup)
- ⚡ **[QUICKSTART.md](QUICKSTART.md)** - Quick 3-terminal startup
- 📚 **[PANDUAN-LENGKAP.md](PANDUAN-LENGKAP.md)** - Complete step-by-step guide (Bahasa Indonesia)
- 📝 **[CHANGELOG.md](CHANGELOG.md)** - Version history

---

## 🏗️ Arsitektur Sistem

```
┌─────────────────┐
│  React Frontend │ (Port 3000)
│   (Vite + TW)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Go Backend    │ (Port 8080)
│  (Gin + GORM)   │
└────┬───────┬────┘
     │       │
     ▼       ▼
┌─────────┐ ┌──────────────────────┐
│  MySQL  │ │ Hyperledger Fabric   │
│Database │ │ (Docker Containers)  │
│(Port    │ │ - Orderer: 7050      │
│ 3306)   │ │ - Peer0: 7051        │
└─────────┘ │ - Peer1: 8051        │
            │ - CouchDB: 5984,6984 │
            └──────────────────────┘
```

---

## ✅ Prerequisites

Pastikan software berikut sudah terinstall:

### 1. **XAMPP** (untuk MySQL)
- Download: https://www.apachefriends.org/
- Versi: 8.0 atau lebih baru
- Cek: Buka XAMPP Control Panel

### 2. **Docker Desktop**
- Download: https://www.docker.com/products/docker-desktop
- Versi: 20.10+
- Cek: `docker --version` dan `docker-compose --version`
- **PENTING**: Pastikan Docker Desktop sudah running sebelum start Fabric

### 3. **Go (Golang)**
- Download: https://go.dev/dl/
- Versi: 1.19+ (Recommended: 1.21+)
- Cek: `go version`

### 4. **Node.js & npm**
- Download: https://nodejs.org/
- Versi: 16.x+ (Recommended: 18.x atau 20.x LTS)
- Cek: `node --version` dan `npm --version`

### 5. **Git** (Optional, untuk clone repository)
- Download: https://git-scm.com/downloads
- Cek: `git --version`

---

## 📦 Installation & Setup

> **💡 Tip**: Bagian ini untuk setup pertama kali. Jika sudah pernah install dependencies, langsung skip ke [Quick Start](#-quick-start---cara-menjalankan-sistem).

### **Prerequisites - Software yang Harus Terinstall**

Pastikan software berikut sudah terinstall:

#### 1. **Docker Desktop** ⚠️ WAJIB
- Download: https://www.docker.com/products/docker-desktop
- Versi: 20.10+
- **PENTING**: Docker HARUS running sebelum start Fabric network
- Verifikasi: `docker --version` dan `docker-compose --version`

#### 2. **XAMPP** (untuk MySQL)
- Download: https://www.apachefriends.org/
- Versi: 8.0 atau lebih baru
- Verifikasi: Buka XAMPP Control Panel

#### 3. **Go (Golang)**
- Download: https://go.dev/dl/
- Versi: 1.19+ (Recommended: 1.21+)
- Verifikasi: `go version`

#### 4. **Node.js & npm**
- Download: https://nodejs.org/
- Versi: 16.x+ (Recommended: 18.x atau 20.x LTS)
- Verifikasi: `node --version` dan `npm --version`

#### 5. **Git** (Optional)
- Download: https://git-scm.com/downloads
- Verifikasi: `git --version`

---

## � Setup Pertama Kali (First Time Installation)

**⚠️ Jalankan langkah ini HANYA SEKALI saat pertama kali setup project!**

### **STEP 0.1: Install Go Backend Dependencies**

```powershell
cd C:\Blockchain\reservasihotel\api-gateway

# Download semua Go dependencies
go mod download

# Verify dependencies
go mod verify

# Expected: "all modules verified"
```

**Expected modules:**
- `github.com/gin-gonic/gin` - HTTP web framework
- `gorm.io/gorm` - ORM library
- `gorm.io/driver/mysql` - MySQL driver
- `github.com/hyperledger/fabric-sdk-go` - Fabric SDK
- `github.com/joho/godotenv` - Environment variables
- `github.com/gin-contrib/cors` - CORS middleware

### **STEP 0.2: Install React Frontend Dependencies**

```powershell
cd C:\Blockchain\reservasihotel\web-ui

# Install semua npm packages
npm install

# Tunggu ~2-5 menit (tergantung koneksi internet)
```

**Expected packages:**
- `react` & `react-dom` - React framework
- `vite` - Build tool & dev server
- `tailwindcss` - CSS framework
- `react-router-dom` - Routing
- `axios` - HTTP client
- `react-hot-toast` - Notifications

### **STEP 0.3: Setup MySQL Database**

```powershell
# 1. Start XAMPP → Start MySQL
# 2. Buka browser: http://localhost/phpmyadmin
# 3. Klik "New" atau "Databases"
# 4. Database name: "reservation"
# 5. Klik "Create"

# Atau via SQL command:
CREATE DATABASE IF NOT EXISTS reservation;
```

**Create Tables (Opsional - jika diperlukan):**
```sql
USE reservation;

-- Table: hotels
CREATE TABLE IF NOT EXISTS hotels (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100),
    description TEXT,
    rating INT,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: room_types
CREATE TABLE IF NOT EXISTS room_types (
    id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT,
    type_name VARCHAR(100),
    description TEXT,
    max_guests INT,
    base_price DECIMAL(10,2),
    currency VARCHAR(3),
    FOREIGN KEY (hotel_id) REFERENCES hotels(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: reservations
CREATE TABLE IF NOT EXISTS reservations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id VARCHAR(100) UNIQUE,
    hotel_id INT,
    room_type_id INT,
    check_in DATE,
    check_out DATE,
    guest_count INT,
    customer_ref VARCHAR(100),
    price DECIMAL(10,2),
    currency VARCHAR(10),
    status VARCHAR(50),
    created_by_org VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id),
    FOREIGN KEY (room_type_id) REFERENCES room_types(id)
);

-- Table: reservation_history
CREATE TABLE IF NOT EXISTS reservation_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_id VARCHAR(100),
    action VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### **STEP 0.4: Verify Installation**

```powershell
# ✅ Check Go version
go version
# Expected: go version go1.21.x windows/amd64

# ✅ Check Node.js & npm
node --version
npm --version
# Expected: v18.x.x atau v20.x.x dan npm 9.x.x+

# ✅ Check Docker
docker --version
docker-compose --version
# Expected: Docker version 20.10+ dan docker-compose version 1.29+

# ✅ Check Go dependencies installed
cd C:\Blockchain\reservasihotel\api-gateway
go list -m all
# Should show list of modules

# ✅ Check npm packages installed
cd C:\Blockchain\reservasihotel\web-ui
npm list --depth=0
# Should show installed packages without errors
```

**✅ Jika semua check berhasil, Anda siap menjalankan sistem!**

---

## 🌐 Access Points

- **Web UI (Frontend)**: http://localhost:3000
- **API Gateway (Backend)**: http://localhost:8080
- **MySQL Database**: http://localhost/phpmyadmin
- **CouchDB UIs**:
  - HotelOrg: http://localhost:5984/_utils (username: admin, password: adminpw)
  - GuestOrg: http://localhost:6984/_utils (username: admin, password: adminpw)

## 📁 Project Structure

```
reservasihotel/
├── bin/                           # Fabric CLI tools (peer, orderer, dll)
├── chaincode/
│   └── reservation/
│       ├── main.go                # Smart contract implementation
│       └── go.mod                 # Go module dependencies
├── api-gateway/
│   ├── main.go                    # API server
│   ├── blockchain.go              # Local blockchain simulation
│   ├── fabric_client.go           # Fabric SDK client
│   └── go.mod                     # Go dependencies
├── web-ui/
│   ├── src/
│   │   ├── components/            # React components
│   │   ├── pages/                 # Page components
│   │   └── services/              # API services
│   ├── package.json               # Node dependencies
│   └── vite.config.js             # Vite configuration
└── network/
    ├── docker-compose-simple.yaml # Fabric network (2 orgs)
    ├── configtx.yaml              # Channel configuration
    ├── organizations/             # Crypto materials (MSP, TLS)
    └── chaincode/                 # Chaincode mount point
```

## 🔗 API Endpoints

### Hotels
- `GET /api/v1/hotels` - List all hotels
- `GET /api/v1/hotels/:id` - Get hotel details
- `GET /api/v1/hotels/:id/rooms` - Get hotel room types

### Reservations
- `POST /api/v1/reservations` - Create new reservation
- `GET /api/v1/reservations` - List all reservations
- `GET /api/v1/reservations/:id` - Get reservation details
- `POST /api/v1/reservations/:id/confirm` - Confirm reservation
- `POST /api/v1/reservations/:id/cancel` - Cancel reservation
- `POST /api/v1/reservations/:id/checkin` - Check-in guest
- `POST /api/v1/reservations/:id/checkout` - Check-out guest
- `GET /api/v1/reservations?status=PENDING` - Filter by status
- `GET /api/v1/reservations/hotel/:hotelId?start_date=2024-01-01&end_date=2024-01-31` - Query by hotel and date range

## 🔧 Chaincode Functions

### Smart Contract Methods
1. **CreateReservation** - Creates new reservation (typically by OTA)
2. **ConfirmReservation** - Confirms reservation (by Hotel)
3. **CancelReservation** - Cancels reservation (by OTA/Hotel)
4. **CheckIn** - Processes guest check-in (by Hotel)
5. **CheckOut** - Processes guest check-out (by Hotel)
6. **GetReservation** - Retrieves reservation details
7. **QueryByHotelAndDate** - Queries reservations by hotel and date range
8. **QueryAllReservations** - Retrieves all reservations
9. **QueryReservationsByStatus** - Filters reservations by status

### Data Structures

#### Reservation
```go
type Reservation struct {
    ReservationID  string         `json:"reservationID"`
    HotelID        string         `json:"hotelID"`
    RoomTypeID     string         `json:"roomTypeID"`
    CheckIn        string         `json:"checkIn"`
    CheckOut       string         `json:"checkOut"`
    GuestCount     int            `json:"guestCount"`
    CustomerRef    string         `json:"customerRef"`
    Price          float64        `json:"price"`
    Currency       string         `json:"currency"`
    Status         string         `json:"status"`
    CreatedByOrg   string         `json:"createdByOrg"`
    LastUpdatedAt  string         `json:"lastUpdatedAt"`
    History        []HistoryEvent `json:"history"`
}
```

#### HistoryEvent
```go
type HistoryEvent struct {
    Type      string    `json:"type"`
    ActorMSP  string    `json:"actorMSP"`
    Timestamp time.Time `json:"timestamp"`
    Note      string    `json:"note"`
}
```

## 📊 Database Schema (MySQL)

### Hotels Table
```sql
CREATE TABLE hotels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100),
    description TEXT,
    rating INT,
    image_url VARCHAR(500)
);
```

### Room Types Table
```sql
CREATE TABLE room_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT,
    type_name VARCHAR(100),
    description TEXT,
    max_guests INT,
    base_price DECIMAL(10,2),
    currency VARCHAR(3),
    FOREIGN KEY (hotel_id) REFERENCES hotels(id)
);
```

## 🔄 Workflow

### 1. Reservation Creation (OTA)
```
OTA → API Gateway → Chaincode.CreateReservation → Status: PENDING
```

### 2. Hotel Confirmation
```
Hotel → API Gateway → Chaincode.ConfirmReservation → Status: CONFIRMED
```

### 3. Guest Check-in
```
Hotel → API Gateway → Chaincode.CheckIn → Status: CHECKED_IN
```

### 4. Guest Check-out
```
Hotel → API Gateway → Chaincode.CheckOut → Status: CHECKED_OUT
```

## 🛡️ Security Features

- **Endorsement Policy**: Requires minimum 2 organizations for transactions
- **MSP-based Access Control**: Organization-based permissions
- **TLS Communication**: Encrypted peer-to-peer communication
- **Immutable Ledger**: All transactions permanently recorded
- **Event History**: Complete audit trail for each reservation

## 🐛 Troubleshooting

### Common Issues

#### 1. **Docker Issues**
```powershell
# Stop all containers
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml down

# Remove volumes and restart
docker-compose -f docker-compose-simple.yaml down -v
docker-compose -f docker-compose-simple.yaml up -d

# Reset Docker completely (jika masih error)
docker system prune -a
docker volume prune -f
```

#### 2. **Port Conflicts (Windows)**
```powershell
# Check ports in use
netstat -ano | findstr :8080   # API Gateway
netstat -ano | findstr :3000   # React Frontend
netstat -ano | findstr :7050   # Orderer
netstat -ano | findstr :7051   # Peer0 HotelOrg
netstat -ano | findstr :8051   # Peer0 GuestOrg

# Kill process using port (ganti PID dengan hasil netstat)
taskkill /PID <PID> /F
```

#### 3. **MySQL Connection Issues**
```powershell
# Pastikan MySQL running di XAMPP
# Test connection via phpMyAdmin: http://localhost/phpmyadmin

# Atau test via command line
mysql -u root -p -h localhost

# Error: Database 'reservation' doesn't exist
# Solution: Buat database di phpMyAdmin atau via MySQL CLI:
# CREATE DATABASE reservation;
```

#### 3.1 **MySQL Access Denied**
```powershell
# Error: Access denied for user 'root'@'localhost'
# Solution 1: Reset MySQL password di XAMPP
# Solution 2: Update connection string di api-gateway/main.go
# Default: root:@tcp(127.0.0.1:3306)/reservation
```

#### 4. **Go Module Issues**

##### **Error: `cannot find module`**
```powershell
cd C:\Blockchain\reservasihotel\api-gateway

# Solution 1: Download dependencies
go mod download

# Solution 2: Clean cache and re-download
go clean -modcache
go mod download

# Solution 3: Tidy up go.mod
go mod tidy
```

##### **Error: `go: cannot find main module`**
```powershell
# Pastikan Anda di folder api-gateway yang ada file go.mod
cd C:\Blockchain\reservasihotel\api-gateway
ls go.mod  # Harus ada file ini
```

##### **Error: Fabric SDK compile error**
```powershell
# Fabric SDK kadang butuh CGO
# Install MinGW-w64 (untuk Windows):
# https://sourceforge.net/projects/mingw-w64/

# Set environment variable:
$env:CGO_ENABLED=1
go build
```

#### 5. **Node.js/npm Issues**

##### **Error: `npm install` gagal**
```powershell
cd C:\Blockchain\reservasihotel\web-ui

# Solution 1: Clear cache
npm cache clean --force
npm install

# Solution 2: Delete node_modules dan reinstall
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json
npm install

# Solution 3: Gunakan npm ci (clean install)
npm ci
```

##### **Error: `EACCES` permission denied**
```powershell
# Jalankan PowerShell sebagai Administrator
# Atau gunakan npm config:
npm config set unsafe-perm true
npm install
```

##### **Error: `node-gyp` build failed**
```powershell
# Install Visual Studio Build Tools
npm install --global windows-build-tools

# Atau install Python 3.x dan set npm config:
npm config set python "C:\Python311\python.exe"
```

##### **Error: Port 3000 sudah dipakai**
```powershell
# Cek proses yang pakai port 3000
netstat -ano | findstr :3000

# Kill process (ganti <PID>)
taskkill /PID <PID> /F

# Atau ubah port di package.json:
# "dev": "vite --port 3001"
```

#### 6. **Backend Shows "Offline" di Frontend**
```powershell
# 1. Cek backend benar-benar running
curl http://localhost:8080/api/v1/blockchain/stats

# 2. Clear browser cache (Ctrl+Shift+Delete)

# 3. Restart backend
cd C:\Blockchain\reservasihotel\api-gateway
# Stop dengan Ctrl+C, lalu restart:
go run main.go blockchain.go fabric_client.go
```

### Logs and Debugging

#### **Fabric Network Logs**
```powershell
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml logs -f

# Atau per-container
docker logs peer0.hotelorg.reservation.com
docker logs orderer.reservation.com
```

#### **API Gateway Logs**
```powershell
cd C:\Blockchain\reservasihotel\api-gateway
go run main.go blockchain.go fabric_client.go
# Output langsung di console
```

#### **Frontend Logs**
```powershell
cd C:\Blockchain\reservasihotel\web-ui
npm run dev
# Check browser console (F12) untuk errors
```

## 🔧 Development

### Adding New Features

#### 1. **Chaincode Modifications**
```powershell
cd C:\Blockchain\reservasihotel\chaincode\reservation
# Modify main.go
# Test locally:
go test
# Deploy akan dijelaskan di dokumentasi terpisah
```

#### 2. **API Gateway Changes**
```powershell
cd C:\Blockchain\reservasihotel\api-gateway
# Modify main.go, blockchain.go, atau fabric_client.go
# Restart: Ctrl+C lalu
go run main.go blockchain.go fabric_client.go
```

#### 3. **Frontend Updates**
```powershell
cd C:\Blockchain\reservasihotel\web-ui
# Modify React components di src/
# Changes auto-reload dengan Vite (hot reload)
```

### Testing

#### **Test API Endpoints**
```powershell
# Test Get Hotels
curl http://localhost:8080/api/v1/hotels

# Test Get Blockchain Stats
curl http://localhost:8080/api/v1/blockchain/stats

# Test Create Reservation
curl -X POST http://localhost:8080/api/v1/reservations -H "Content-Type: application/json" -d "{\"reservation_id\":\"TEST001\",\"hotel_id\":\"1\",\"room_type_id\":\"1\",\"check_in\":\"2024-01-15\",\"check_out\":\"2024-01-17\",\"guest_count\":2,\"customer_ref\":\"CUST001\",\"price\":1000000,\"currency\":\"IDR\"}"
```

## 📈 Production Deployment

### Considerations
1. **Use Fabric CA** for certificate management
2. **Configure TLS** properly for all communications
3. **Set up monitoring** with Prometheus/Grafana
4. **Implement proper logging** with ELK stack
5. **Use production-ready databases** with replication
6. **Set up load balancers** for API gateways
7. **Implement backup strategies** for ledger data

### Environment Variables
```bash
# Production API Gateway
export PORT=8080
export DATABASE_URL="user:pass@tcp(db-host:3306)/hotel_reservation"
export FABRIC_CONNECTION_PROFILE="/path/to/connection-profile.yaml"
export FABRIC_WALLET_PATH="/path/to/wallet"
export FABRIC_USER_ID="admin"
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## � Quick Reference Commands

### **Daily Development Workflow**

```powershell
# Morning startup (3 terminals)
# Terminal 1: Fabric
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml up -d

# Terminal 2: Backend
cd C:\Blockchain\reservasihotel\api-gateway
go run main.go blockchain.go fabric_client.go

# Terminal 3: Frontend
cd C:\Blockchain\reservasihotel\web-ui
npm run dev

# Terminal 4 (Optional): Caliper Benchmark
cd C:\Blockchain\reservasihotel\caliper-benchmarks
npm run benchmark-test
```

### **Restart Services**

```powershell
# Restart Backend only
# Terminal 2: Ctrl+C, then:
go run main.go blockchain.go fabric_client.go

# Restart Frontend only
# Terminal 3: Ctrl+C, then:
npm run dev

# Restart Fabric Network
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml restart
```

### **Stop All Services**

```powershell
# Stop Backend & Frontend
# Ctrl+C di masing-masing terminal

# Stop Fabric Network
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml down

# Stop XAMPP
# XAMPP Control Panel → Stop MySQL & Apache
```

### **Update Dependencies**

```powershell
# Update Go modules
cd C:\Blockchain\reservasihotel\api-gateway
go get -u ./...
go mod tidy

# Update npm packages
cd C:\Blockchain\reservasihotel\web-ui
npm update
# or
npm install <package>@latest
```

### **View Logs**

```powershell
# Fabric containers
docker logs peer0.hotelorg.reservation.com
docker logs orderer.reservation.com

# All containers
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml logs -f

# Backend logs
# Check Terminal 2 output

# Frontend logs
# Check Terminal 3 output & Browser Console (F12)
```

### **Database Management**

```powershell
# Backup database
# phpMyAdmin → Export → Go

# Restore database
# phpMyAdmin → Import → Choose file

# Clear all reservations
# phpMyAdmin → Execute SQL:
# TRUNCATE TABLE reservation_history;
# TRUNCATE TABLE reservations;
```

---

## �📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For issues and questions:
1. ✅ Check the **Troubleshooting** section above
2. ✅ Read **PANDUAN-LENGKAP.md** for step-by-step guide
3. ✅ Search existing issues on GitHub
4. ✅ Create new issue with:
   - Environment details (OS, Go version, Node version, Docker version)
   - Error logs (backend, frontend, docker)
   - Steps to reproduce
   - Screenshots (jika ada)

## 📚 Additional Documentation

- **QUICKSTART.md** - Quick 3-step setup guide
- **PANDUAN-LENGKAP.md** - Complete Indonesian guide with screenshots
- **CHANGELOG.md** - Version history and changes

## 🙏 Acknowledgments

- [Hyperledger Fabric](https://www.hyperledger.org/use/fabric) - Enterprise blockchain framework
- [Go Gin](https://gin-gonic.com/) - High-performance HTTP framework
- [React](https://react.dev/) - UI library
- [Vite](https://vitejs.dev/) - Next generation frontend tooling
- [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS framework
- [GORM](https://gorm.io/) - Go ORM library
- [MySQL](https://www.mysql.com/) - Relational database