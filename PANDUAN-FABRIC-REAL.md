# 🚀 PANDUAN CONNECT KE REAL HYPERLEDGER FABRIC

## 📋 Overview

Document ini menjelaskan cara **menghubungkan backend Go ke real Hyperledger Fabric blockchain** (bukan mock lagi).

---

## ✅ Prerequisites

Yang sudah kamu punya:
- ✅ Docker Desktop running
- ✅ Fabric network containers (peer, orderer, couchdb)
- ✅ Crypto materials (MSP, TLS certificates)
- ✅ Go backend dengan fabric_client.go
- ✅ MySQL database

---

## 📦 Yang Sudah Dibuat

### 1. Chaincode (Smart Contract)
**File:** `chaincode/reservation/reservation.go`

**Features:**
- ✅ CreateReservation (dengan auto-calculation support)
- ✅ GetReservation
- ✅ UpdateReservationStatus
- ✅ ConfirmReservation, CancelReservation
- ✅ CheckIn, CheckOut
- ✅ GetAllReservations
- ✅ GetReservationHistory
- ✅ InitLedger

**Struct:**
```go
type Reservation struct {
    ReservationID    string
    HotelID          string
    RoomTypeID       string
    GuestCount       int
    EventType        string
    EventDescription string
    CustomerName     string
    CustomerPhone    string
    CustomerEmail    string
    PricePerPerson   float64
    TotalPrice       float64
    Status           string
    // ... dan fields lainnya
}
```

### 2. Deployment Scripts
- `network/scripts/deploy-chaincode.sh` (Linux/Mac)
- `network/scripts/deploy-chaincode.ps1` (Windows) ⭐

---

## 🚀 CARA DEPLOY CHAINCODE

### Step 1: Stop Docker Containers yang Ada
```powershell
cd C:\Blockchain\reservasihotel\network
docker-compose down
```

### Step 2: Jalankan Deploy Script
```powershell
cd C:\Blockchain\reservasihotel\network\scripts
.\deploy-chaincode.ps1
```

**Script akan otomatis:**
1. Start semua containers (orderer, peer0.hotelorg, peer0.guestorg, couchdb)
2. Create channel `mychannel`
3. Join peers ke channel
4. Package chaincode
5. Install chaincode ke semua peers
6. Approve chaincode untuk semua organizations
7. Commit chaincode ke channel
8. Initialize ledger dengan sample data

**Expected Output:**
```
🚀 Starting Fabric Network & Deploy
✅ Containers started
✅ Channel created
✅ Peers joined
✅ Chaincode packaged
✅ Chaincode installed
✅ Chaincode approved
✅ Chaincode committed
✅ Ledger initialized
```

### Step 3: Verify Deployment
```powershell
# Check containers
docker ps

# Expected output: 6 containers running
# - orderer.reservation.com
# - peer0.hotelorg.reservation.com
# - peer0.guestorg.reservation.com
# - couchdb0
# - couchdb1
# - cli
```

---

## 🔧 UPDATE BACKEND CONNECTION

### Step 4: Update fabric_client.go

Ganti function `Initialize()` dengan connection profile yang benar.

**Current (Mock):**
```go
func (fc *FabricClient) Initialize() error {
    fc.IsConnected = true  // Mock
    return nil
}
```

**Update to (Real):**
```go
func (fc *FabricClient) Initialize() error {
    // Load connection profile
    wallet, err := gateway.NewFileSystemWallet("wallet")
    if err != nil {
        return fmt.Errorf("failed to create wallet: %v", err)
    }

    gw, err := gateway.Connect(
        gateway.WithConfig(config.FromFile("connection-profile.yaml")),
        gateway.WithIdentity(wallet, "admin"),
    )
    if err != nil {
        return fmt.Errorf("failed to connect: %v", err)
    }

    network, err := gw.GetNetwork("mychannel")
    if err != nil {
        return fmt.Errorf("failed to get network: %v", err)
    }

    fc.Gateway = gw
    fc.Network = network
    fc.Contract = network.GetContract("reservation")
    fc.IsConnected = true

    log.Println("✅ Connected to real Hyperledger Fabric")
    return nil
}
```

### Step 5: Set UseFabric = true

Di `main.go`, pastikan:
```go
useFabric := os.Getenv("USE_FABRIC") == "true" || true  // Force true
```

Atau tambah environment variable:
```powershell
$env:USE_FABRIC="true"
```

---

## 🧪 TESTING REAL BLOCKCHAIN

### Test 1: Create Reservation
```powershell
$body = @{
    reservation_id = "RES-FABRIC-001"
    hotel_id = "1"
    room_type_id = "1"
    guest_count = 50
    event_type = "Birthday Party"
    customer_name = "Test User"
    customer_phone = "08123456789"
    check_in = "2025-11-20"
    check_out = "2025-11-22"
} | ConvertTo-Json

Invoke-RestMethod -Method POST `
    -Uri "http://localhost:8080/api/v1/reservations" `
    -ContentType "application/json" `
    -Body $body
```

**Expected:**
- Data tersimpan di MySQL ✅
- Transaction tercatat di Fabric blockchain ✅
- Response menunjukkan "blockchain": "Hyperledger Fabric"

### Test 2: Get Blockchain History
```powershell
Invoke-RestMethod -Uri "http://localhost:8080/api/v1/reservations/RES-FABRIC-001/history"
```

**Expected:**
- Menampilkan transaction history dari Fabric ledger
- Bukan mock data lagi!
- TxID dari blockchain
- Timestamp real
- Block number

### Test 3: Update Status
```powershell
Invoke-RestMethod -Method POST `
    -Uri "http://localhost:8080/api/v1/reservations/RES-FABRIC-001/confirm"
```

**Expected:**
- Status berubah di MySQL
- New transaction di blockchain
- History bertambah

---

## 🎯 VERIFICATION CHECKLIST

### Database (MySQL)
```sql
SELECT * FROM reservations WHERE reservation_id = 'RES-FABRIC-001';
-- Should show the reservation
```

### Blockchain (Fabric)
```powershell
# Query dari CLI container
docker exec cli peer chaincode query `
    -C mychannel `
    -n reservation `
    -c '{"function":"GetReservation","Args":["RES-FABRIC-001"]}'
```

**Expected:**
```json
{
  "reservationID": "RES-FABRIC-001",
  "hotelID": "1",
  "guestCount": 50,
  "totalPrice": 155000000,
  "status": "CONFIRMED"
}
```

---

## 🔍 TROUBLESHOOTING

### Issue 1: Orderer not starting
**Solution:**
```powershell
# Regenerate crypto materials
cd network
./scripts/generate-crypto.sh
```

### Issue 2: Channel already exists
**Solution:**
```powershell
# Remove existing channel artifacts
docker-compose down -v
rm -rf channel-artifacts/*
# Run deploy script again
```

### Issue 3: Chaincode install failed
**Solution:**
```powershell
# Check chaincode syntax
cd chaincode/reservation
go mod tidy
go build
```

### Issue 4: Connection timeout
**Solution:**
```powershell
# Check containers
docker ps
# Check logs
docker logs peer0.hotelorg.reservation.com
docker logs orderer.reservation.com
```

### Issue 5: fabric_client still mock
**Solution:**
1. Pastikan `USE_FABRIC=true`
2. Verify connection profile loaded
3. Check wallet dan identity
4. Restart Go backend

---

## 📊 ARCHITECTURE DIAGRAM

```
User Request
    ↓
Go Backend (main.go)
    ↓
┌─────────────────────────────────────┐
│ 1. Save to MySQL Database (REAL)   │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ 2. fabric_client.go                 │
│    - CreateReservation()            │
│    - SubmitTransaction()            │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ 3. Hyperledger Fabric Network       │
│    ├─ Orderer (consensus)           │
│    ├─ Peer0.HotelOrg (endorser)     │
│    ├─ Peer0.GuestOrg (endorser)     │
│    └─ CouchDB (state database)      │
└─────────────────────────────────────┘
    ↓
┌─────────────────────────────────────┐
│ 4. Chaincode (reservation.go)       │
│    - Validate transaction           │
│    - Save to ledger                 │
│    - Return result                  │
└─────────────────────────────────────┘
    ↓
Response to User
```

---

## 🎉 SUCCESS INDICATORS

✅ **Kamu berhasil jika:**
1. Script deploy-chaincode.ps1 selesai tanpa error
2. 6 containers running (docker ps)
3. Backend log menunjukkan "Connected to real Hyperledger Fabric"
4. Reservation response menunjukkan `"blockchain": "Hyperledger Fabric"`
5. Query chaincode dari CLI berhasil
6. GetReservationHistory mengembalikan data dari ledger (bukan mock)

---

## 🚀 QUICK START (TL;DR)

```powershell
# 1. Deploy chaincode
cd C:\Blockchain\reservasihotel\network\scripts
.\deploy-chaincode.ps1

# 2. Set environment
$env:USE_FABRIC="true"

# 3. Restart backend
cd C:\Blockchain\reservasihotel\api-gateway
go run main.go blockchain.go fabric_client.go

# 4. Test
Invoke-RestMethod -Uri "http://localhost:8080/api/v1/health"
# Should show fabric_enabled: true

# 5. Create booking
# Use Postman atau curl untuk test
```

---

## 📝 NOTES

### Mock vs Real:
- **Mock**: `fc.Contract == nil` → Data hanya ke MySQL
- **Real**: `fc.Contract != nil` → Data ke MySQL + Fabric blockchain

### Performance:
- Real Fabric lebih lambat (consensus, endorsement)
- Typical response: 2-5 seconds
- Mock response: < 100ms

### Development Workflow:
1. **Development**: Use mock (fast iteration)
2. **Testing**: Use real Fabric (verify integration)
3. **Production**: Real Fabric with proper network setup

---

## 🎓 NEXT STEPS

Setelah berhasil connect:
1. ✅ Test semua CRUD operations
2. ✅ Verify blockchain history
3. ✅ Test multi-org scenarios
4. ✅ Deploy chaincode updates
5. ✅ Monitor blockchain performance
6. ✅ Setup production network

---

## 🆘 NEED HELP?

Jika ada error saat deploy:
1. Check file `TROUBLESHOOTING.md`
2. Lihat docker logs: `docker logs [container-name]`
3. Verify crypto materials di `network/organizations/`
4. Test chaincode locally: `cd chaincode/reservation && go test`

---

**Good Luck! 🚀**

*Document dibuat: November 13, 2025*
