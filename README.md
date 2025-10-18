# 🏨 Hotel Reservation System with Hyperledger Fabric

Sistem reservasi hotel berbasis blockchain menggunakan **Hyperledger Fabric**, **Go Backend**, **React Frontend**, dan **MySQL Database**.

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

### 2. **Docker Desktop**
- Download: https://www.docker.com/products/docker-desktop
- **PENTING**: Pastikan Docker Desktop sudah running sebelum start Fabric

### 3. **Go (Golang)**
- Download: https://go.dev/dl/
- Versi: 1.19+
- Cek: `go version`

### 4. **Node.js & npm**
- Download: https://nodejs.org/
- Versi: 16.x+
- Cek: `node --version` dan `npm --version`

---

## 🚀 Cara Menjalankan Sistem

### **STEP 1: Start MySQL Database**

```
1. Buka XAMPP Control Panel
2. Klik "Start" untuk Apache dan MySQL
3. Buka browser: http://localhost/phpmyadmin
4. Buat database: "reservation"
```

### **STEP 2: Start Hyperledger Fabric Network**

```powershell
# Pastikan Docker Desktop running
docker ps

# Start Fabric Network
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml up -d

# Verifikasi containers running (harus ada 5 containers)
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

**Expected Output:**
```
NAMES                              STATUS          PORTS
peer0.guestorg.reservation.com     Up X minutes    0.0.0.0:8051->8051/tcp
peer0.hotelorg.reservation.com     Up X minutes    0.0.0.0:7051->7051/tcp
couchdb1                           Up X minutes    0.0.0.0:6984->5984/tcp
couchdb0                           Up X minutes    0.0.0.0:5984->5984/tcp
orderer.reservation.com            Up X minutes    0.0.0.0:7050->7050/tcp
```

### **STEP 3: Start Go API Backend**

```powershell
# Buka terminal baru
cd C:\Blockchain\reservasihotel\api-gateway
go run main.go blockchain.go fabric_client.go
```

**Expected Output:**
```
[GIN-debug] Listening and serving HTTP on :8080
Backend running on http://localhost:8080
```

### **STEP 4: Start React Frontend**

```powershell
# Buka terminal baru
cd C:\Blockchain\reservasihotel\web-ui
npm run dev
```

**Expected Output:**
```
  VITE v5.x.x  ready in xxx ms
  ➜  Local:   http://localhost:3000/
```

## 🌐 Access Points

- **Web UI**: http://localhost:3000
- **API Gateway**: http://localhost:8080
- **CouchDB UIs**:
  - HotelOrg: http://localhost:5984/_utils
  - OTAOrg: http://localhost:7984/_utils
  - PaymentOrg: http://localhost:8984/_utils

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
```

#### 4. **Go Module Issues**
```powershell
cd C:\Blockchain\reservasihotel\api-gateway
go clean -modcache
go mod download
go mod tidy
```

#### 5. **Node.js/npm Issues**
```powershell
cd C:\Blockchain\reservasihotel\web-ui
Remove-Item -Recurse -Force node_modules
Remove-Item package-lock.json
npm install
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

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For issues and questions:
1. Check the troubleshooting section
2. Search existing issues on GitHub
3. Create new issue with detailed description
4. Include logs and environment details

## 🙏 Acknowledgments

- Hyperledger Fabric community
- Go Gin framework
- React and Vite teams
- Tailwind CSS team
- MySQL community