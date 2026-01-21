# 🔧 API Gateway - Go Backend

Backend API server untuk Hotel Reservation System menggunakan Go (Golang), Gin Framework, GORM, dan Hyperledger Fabric SDK.

---

## 🚀 Quick Start - Cara Menjalankan Backend

### **Prasyarat:**
✅ Go (Golang) v1.19+ sudah terinstall  
✅ MySQL (XAMPP) sudah running  
✅ Database "reservation" sudah dibuat  
✅ Docker Desktop sudah running  
✅ Blockchain network sudah running  

---

### **🔥 Langkah Cepat - Jalankan Backend**

```powershell
# 1. Masuk ke folder api-gateway
cd C:\Blockchain\reservasihotel\api-gateway

# 2. Jalankan backend server
go run main.go blockchain.go fabric_client.go

# Expected output:
# [GIN-debug] Listening and serving HTTP on :8080
# Backend running on http://localhost:8080
```

### **✅ Test Backend Berjalan**

Buka browser atau gunakan curl:
```powershell
# Test blockchain stats
curl http://localhost:8080/api/v1/blockchain/stats

# Test get hotels
curl http://localhost:8080/api/v1/hotels

# Test get reservations
curl http://localhost:8080/api/v1/reservations
```

---

## 📦 Setup Pertama Kali (First Time Installation)

### **1. Install Go Dependencies**

```powershell
cd C:\Blockchain\reservasihotel\api-gateway

# Download semua dependencies
go mod download

# Verify semua modules
go mod verify

# Output expected: "all modules verified"
```

### **2. Verify Dependencies Installed**

```powershell
# List semua modules
go list -m all

# Expected modules:
# - github.com/gin-gonic/gin v1.x.x
# - gorm.io/gorm v1.x.x
# - gorm.io/driver/mysql v1.x.x
# - github.com/hyperledger/fabric-sdk-go v1.x.x
# - github.com/gin-contrib/cors v1.x.x
# - github.com/joho/godotenv v1.x.x
```

### **3. Setup Environment Variables (Optional)**

Buat file `.env` jika ingin customize konfigurasi:

```env
# Database Configuration
DB_HOST=127.0.0.1
DB_PORT=3306
DB_USER=root
DB_PASSWORD=
DB_NAME=reservation

# Server Configuration
PORT=8080

# Fabric Configuration (jika menggunakan real Fabric network)
FABRIC_CONFIG_PATH=../network/connection-profile.yaml
FABRIC_CHANNEL_NAME=reservationchannel
FABRIC_CHAINCODE_NAME=reservation
```

---

## 🏗️ Struktur File

```
api-gateway/
├── main.go              # Server utama, routing, middleware
├── blockchain.go        # Simulasi blockchain lokal (untuk dev/testing)
├── fabric_client.go     # Client untuk koneksi ke Fabric network
├── go.mod               # Go module dependencies
├── go.sum               # Checksums untuk dependencies
├── .env                 # Environment variables (optional)
└── README.md            # Dokumentasi ini
```

### **File Details:**

#### **main.go**
- Setup Gin server
- Define API routes
- CORS middleware
- Database connection (GORM)
- Handlers untuk hotels & reservations

#### **blockchain.go**
- In-memory blockchain simulation
- Untuk development tanpa Fabric network
- Mendukung operasi: CreateReservation, ConfirmReservation, CheckIn, CheckOut

#### **fabric_client.go**
- Client untuk koneksi ke Hyperledger Fabric network
- Invoke chaincode functions
- Query ledger

---

## 🔗 API Endpoints

### **Blockchain Stats**
```
GET /api/v1/blockchain/stats
```
Response:
```json
{
  "totalBlocks": 5,
  "totalReservations": 3,
  "status": "online"
}
```

### **Hotels**
```
GET /api/v1/hotels              # List all hotels
GET /api/v1/hotels/:id          # Get hotel by ID
GET /api/v1/hotels/:id/rooms    # Get room types by hotel ID
```

### **Reservations**
```
POST   /api/v1/reservations                # Create reservation
GET    /api/v1/reservations                # List all reservations
GET    /api/v1/reservations/:id            # Get reservation by ID
POST   /api/v1/reservations/:id/confirm    # Confirm reservation
POST   /api/v1/reservations/:id/cancel     # Cancel reservation
POST   /api/v1/reservations/:id/checkin    # Guest check-in
POST   /api/v1/reservations/:id/checkout   # Guest check-out
GET    /api/v1/reservations?status=PENDING # Filter by status
```

### **Example Request: Create Reservation**
```powershell
curl -X POST http://localhost:8080/api/v1/reservations `
  -H "Content-Type: application/json" `
  -d '{
    "reservation_id": "RES001",
    "hotel_id": "1",
    "room_type_id": "1",
    "check_in": "2024-02-01",
    "check_out": "2024-02-03",
    "guest_count": 2,
    "customer_ref": "CUST001",
    "price": 1500000,
    "currency": "IDR"
  }'
```

---

## 🔧 Configuration

### **Database Connection**

Default connection string di `main.go`:
```go
dsn := "root:@tcp(127.0.0.1:3306)/reservation?charset=utf8mb4&parseTime=True&loc=Local"
```

Untuk mengubah:
- **User**: Ganti `root` dengan MySQL username Anda
- **Password**: Tambahkan password setelah `:` (contoh: `root:password`)
- **Host**: Ganti `127.0.0.1` jika MySQL di server lain
- **Port**: Ganti `3306` jika MySQL menggunakan port berbeda
- **Database**: Ganti `reservation` jika nama database berbeda

### **Server Port**

Default port: `8080`

Untuk mengubah, edit di `main.go`:
```go
router.Run(":8080") // Ganti 8080 dengan port yang diinginkan
```

---

## 🐛 Troubleshooting

### **Error: "command not found: go"**
```powershell
# Install Go dari https://go.dev/dl/
# Atau verify instalasi:
go version
```

### **Error: "cannot find module"**
```powershell
cd C:\Blockchain\reservasihotel\api-gateway

# Solution 1: Download dependencies
go mod download

# Solution 2: Clean cache dan download ulang
go clean -modcache
go mod download

# Solution 3: Tidy up go.mod
go mod tidy
```

### **Error: "Error 1045: Access denied for user 'root'@'localhost'"**
```powershell
# MySQL password salah atau user tidak ada
# Solution 1: Reset password di XAMPP
# Solution 2: Update connection string di main.go
# Contoh dengan password:
dsn := "root:yourpassword@tcp(127.0.0.1:3306)/reservation?..."
```

### **Error: "Error 1049: Unknown database 'reservation'"**
```powershell
# Database belum dibuat
# Solution: Buat database di phpMyAdmin
# 1. Buka http://localhost/phpmyadmin
# 2. Klik "New" atau "Databases"
# 3. Nama: "reservation"
# 4. Klik "Create"
```

### **Error: Port 8080 already in use**
```powershell
# Cek proses yang menggunakan port 8080
netstat -ano | findstr :8080

# Kill process (ganti <PID> dengan hasil netstat)
taskkill /PID <PID> /F

# Atau ubah port di main.go:
router.Run(":8081")  # Gunakan port lain
```

### **Error: CGO build failed**
```powershell
# Fabric SDK kadang butuh CGO compiler
# Install MinGW-w64 (untuk Windows):
# https://sourceforge.net/projects/mingw-w64/

# Set environment variable:
$env:CGO_ENABLED=1

# Lalu build lagi:
go run main.go blockchain.go fabric_client.go
```

### **Error: "CORS policy blocked"**
```powershell
# Backend sudah include CORS middleware
# Jika masih error, verify di main.go ada:
# router.Use(cors.Default())

# Atau gunakan custom CORS config:
config := cors.DefaultConfig()
config.AllowOrigins = []string{"http://localhost:3000"}
router.Use(cors.New(config))
```

---

## 📊 Monitoring & Logs

### **View Backend Logs**
```powershell
# Logs tampil langsung di terminal saat backend running
# Format: [GIN] timestamp | status | latency | client IP | method | path
```

### **Enable Debug Mode**
```go
// Di main.go, tambahkan:
gin.SetMode(gin.DebugMode)  // Default mode
// gin.SetMode(gin.ReleaseMode)  // Production mode
```

### **Database Query Logs**
```go
// Di main.go, enable GORM logger:
db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{
    Logger: logger.Default.LogMode(logger.Info), // Show SQL queries
})
```

---

## 🔨 Development

### **Auto-reload saat Development**

Install `air` untuk hot reload:
```powershell
# Install air
go install github.com/cosmtrek/air@latest

# Jalankan dengan air
air

# air akan auto-restart backend saat file .go berubah
```

### **Build Executable**
```powershell
# Build untuk Windows
go build -o api-gateway.exe main.go blockchain.go fabric_client.go

# Jalankan executable
.\api-gateway.exe
```

### **Build untuk OS lain**
```powershell
# Linux
$env:GOOS="linux"
$env:GOARCH="amd64"
go build -o api-gateway main.go blockchain.go fabric_client.go

# macOS
$env:GOOS="darwin"
$env:GOARCH="amd64"
go build -o api-gateway main.go blockchain.go fabric_client.go
```

---

## 🧪 Testing

### **Test API dengan curl**
```powershell
# Test health check
curl http://localhost:8080/api/v1/blockchain/stats

# Test get hotels
curl http://localhost:8080/api/v1/hotels

# Test create reservation
curl -X POST http://localhost:8080/api/v1/reservations `
  -H "Content-Type: application/json" `
  -d '{"reservation_id":"TEST001","hotel_id":"1","room_type_id":"1","check_in":"2024-02-01","check_out":"2024-02-03","guest_count":2,"customer_ref":"CUST001","price":1000000,"currency":"IDR"}'
```

### **Test dengan Postman**
1. Import collection dari folder `postman/` (jika ada)
2. Atau buat request manual ke endpoints di atas

---

## 📚 Dependencies

### **Main Dependencies:**
```
github.com/gin-gonic/gin          # Web framework
gorm.io/gorm                       # ORM
gorm.io/driver/mysql               # MySQL driver
github.com/gin-contrib/cors        # CORS middleware
github.com/joho/godotenv           # Environment variables
github.com/hyperledger/fabric-sdk-go # Fabric SDK (for production)
```

### **Update Dependencies:**
```powershell
# Update semua dependencies ke versi terbaru
go get -u ./...

# Tidy up go.mod
go mod tidy

# Verify
go mod verify
```

---

## 🔄 Daily Workflow

### **Start Backend (Development)**
```powershell
cd C:\Blockchain\reservasihotel\api-gateway
go run main.go blockchain.go fabric_client.go
```

### **Restart Backend**
```powershell
# Tekan Ctrl+C untuk stop
# Lalu jalankan lagi:
go run main.go blockchain.go fabric_client.go
```

### **Stop Backend**
```powershell
# Tekan Ctrl+C di terminal
```

---

## 📞 Support

Jika mengalami masalah:
1. ✅ Cek bagian **Troubleshooting** di atas
2. ✅ Verify semua prerequisites sudah installed
3. ✅ Pastikan MySQL dan Docker running
4. ✅ Check logs di terminal untuk error messages

---

## 📄 License

MIT License - See main project README.md
