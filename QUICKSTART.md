# 🏨 Hotel Reservation System - Quick Start Guide

## ⚡ Super Fast Setup (3 Terminals)

### ✅ Prerequisites
- Docker Desktop (running)
- XAMPP (MySQL running)
- Go 1.20+
- Node.js 16+

---

## 🚀 **3-Step Quick Start**

### **Terminal 1: Start Fabric Network**
```powershell
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml up -d
docker ps  # Verify 5 containers running
```

### **Terminal 2: Start Go Backend**
```powershell
cd C:\Blockchain\reservasihotel\api-gateway
go run main.go blockchain.go fabric_client.go
# Wait for: "Listening and serving HTTP on :8080"
```

**📌 Note:** 
- Command `go run main.go blockchain.go fabric_client.go` akan compile **semua 3 file Go** sekaligus
- **TIDAK perlu** buka file `main.go`, `blockchain.go`, atau `fabric_client.go` secara manual
- Go akan otomatis compile dan run semua dependencies

### **Terminal 3: Start React Frontend**
```powershell
cd C:\Blockchain\reservasihotel\web-ui
npm run dev
# Open: http://localhost:3000
```

---

## 🌐 Access Points

| Service | URL | Status |
|---------|-----|--------|
| **Frontend** | http://localhost:3000 | ✅ |
| **API Backend** | http://localhost:8080 | ✅ |
| **CouchDB (HotelOrg)** | http://localhost:5984/_utils | ✅ |
| **CouchDB (GuestOrg)** | http://localhost:6984/_utils | ✅ |
| **phpMyAdmin** | http://localhost/phpmyadmin | ✅ |

---

## ✨ What You Can Do

1. **Browse Hotels** - View all available hotels
2. **Book Reservation** - Create new reservation
3. **View Reservations** - See all bookings
4. **Confirm/Cancel** - Manage reservation status
5. **Check-in/Check-out** - Process guest arrival/departure
6. **Blockchain History** - View immutable audit trail

---

## 🛑 Stop All Services

### Stop Frontend & Backend
```powershell
# Press Ctrl+C in each terminal
```

### Stop Fabric Network
```powershell
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml down
```

---

## � Quick Troubleshooting

### Port Already in Use?
```powershell
# Check and kill process
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

### Docker Issues?
```powershell
docker-compose -f docker-compose-simple.yaml down -v
docker system prune -f
docker-compose -f docker-compose-simple.yaml up -d
```

### Backend Shows Offline?
```powershell
# Test backend
curl http://localhost:8080/api/v1/health

# Clear browser cache (Ctrl+Shift+Delete)
# Restart backend
```

### Blockchain History Shows "No blockchain history available"?
```
This is NORMAL in development mode!

Blockchain history is currently using MOCK data because:
- Real chaincode not yet deployed to Fabric network
- System using development/simulation mode

To fix:
1. Restart backend to load latest code
2. Blockchain history will show mock transactions
3. For REAL blockchain data, deploy chaincode (advanced)
```

---

## 📖 Need More Details?

👉 **Read Full Guide:** `PANDUAN-LENGKAP.md`  
👉 **Technical Docs:** `README.md`

### 📱 Features Demo
- **Hotel Browsing**: View available hotels with ratings
- **Room Selection**: Choose room types with pricing
- **Booking Process**: Create reservations with customer details
- **Status Management**: Confirm, cancel, check-in, check-out
- **Blockchain Integration**: All reservations stored on Hyperledger Fabric

### 🔧 If Something Goes Wrong
1. Make sure all 3 terminals are running
2. Check MySQL is running in XAMPP
3. Verify Docker Desktop is running
4. Check the main README.md for detailed troubleshooting

### 🏨 Sample Hotels Available
1. **Grand Hotel Jakarta** - Luxury hotel in Jakarta
2. **Beach Resort Bali** - Beachfront resort in Bali  
3. **Mountain View Hotel** - Peaceful retreat in Bogor

Each hotel has multiple room types with different pricing and capacity.