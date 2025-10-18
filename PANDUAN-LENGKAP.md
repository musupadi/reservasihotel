# 🏨 PANDUAN LENGKAP - Hotel Reservation System

## 🚀 Cara Menjalankan Sistem (Step by Step)

### **LANGKAH 1: Start MySQL Database** 📊

1. **Buka XAMPP Control Panel**
   - Cari di Start Menu: "XAMPP"
   - Atau buka dari: `C:\xampp\xampp-control.exe`

2. **Start Services**
   ```
   ✅ Klik "Start" untuk Apache
   ✅ Klik "Start" untuk MySQL
   ✅ Tunggu hingga status: "Running" (hijau)
   ```

3. **Buat Database**
   ```
   ✅ Buka browser: http://localhost/phpmyadmin
   ✅ Klik tab "Databases"
   ✅ Ketik nama database: reservation
   ✅ Klik "Create"
   ```

---

### **LANGKAH 2: Start Hyperledger Fabric Network** ⛓️

1. **Pastikan Docker Desktop Running**
   ```
   ✅ Cari di Start Menu: "Docker Desktop"
   ✅ Klik untuk membuka
   ✅ Tunggu sampai Docker icon di system tray hijau
   ```

2. **Buka PowerShell/Terminal**
   ```
   ✅ Tekan Win + X
   ✅ Pilih "Windows PowerShell" atau "Terminal"
   ```

3. **Start Fabric Network**
   ```powershell
   # Masuk ke folder network
   cd C:\Blockchain\reservasihotel\network
   
   # Start containers
   docker-compose -f docker-compose-simple.yaml up -d
   
   # Tunggu 10-15 detik
   # Cek status containers
   docker ps
   ```

4. **Verifikasi - Harus ada 5-6 containers:**
   ```
   ✅ orderer.reservation.com
   ✅ peer0.hotelorg.reservation.com
   ✅ peer0.guestorg.reservation.com
   ✅ couchdb0
   ✅ couchdb1
   ✅ cli (optional)
   ```

---

### **LANGKAH 3: Start Go Backend** 🟦

1. **Buka Terminal/PowerShell BARU (Terminal 1)**
   ```
   ✅ Buka terminal baru (jangan tutup yang lama)
   ```

2. **Jalankan Go Backend**
   ```powershell
   # Masuk ke folder api-gateway
   cd C:\Blockchain\reservasihotel\api-gateway
   
   # Jalankan backend
   go run main.go blockchain.go fabric_client.go
   ```

3. **Cek Output - Harus muncul:**
   ```
   ✅ Database connected successfully
   ✅ Real Hyperledger Fabric connected!
   ✅ Go Backend Server running on port 8080
   ✅ Listening and serving HTTP on :8080
   ```

4. **JANGAN TUTUP TERMINAL INI! Biarkan tetap berjalan**

---

### **LANGKAH 4: Start React Frontend** ⚛️

1. **Buka Terminal/PowerShell BARU (Terminal 2)**
   ```
   ✅ Buka terminal baru lagi
   ✅ Sekarang ada 2 terminal yang running
   ```

2. **Install Dependencies (hanya PERTAMA KALI)**
   ```powershell
   cd C:\Blockchain\reservasihotel\web-ui
   npm install
   ```

3. **Jalankan Frontend**
   ```powershell
   npm run dev
   ```

4. **Cek Output - Harus muncul:**
   ```
   ✅ VITE ready in xxx ms
   ✅ Local:   http://localhost:3000/
   ✅ Network: http://192.168.x.x:3000/
   ```

5. **Buka Browser**
   ```
   ✅ Buka: http://localhost:3000
   ```

---

## ✅ CHECKLIST - Pastikan Semua Running

Setelah semua langkah di atas, sistem Anda harus:

```
📊 XAMPP Control Panel:
   ✅ Apache: Running (hijau)
   ✅ MySQL: Running (hijau)

🐳 Docker Desktop:
   ✅ Status: Running (hijau di system tray)
   ✅ Containers: 5-6 containers running

💻 Terminal 1 (Go Backend):
   ✅ Output: "Listening and serving HTTP on :8080"
   ✅ Status: JANGAN DITUTUP, biarkan running

💻 Terminal 2 (React Frontend):
   ✅ Output: "Local: http://localhost:3000/"
   ✅ Status: JANGAN DITUTUP, biarkan running

🌐 Browser:
   ✅ http://localhost:3000 terbuka
   ✅ Menampilkan halaman Hotel Reservation System
```

---

## 🧪 TEST SISTEM

### Test 1: Cek Backend API
```powershell
# Buka terminal baru (Terminal 3)
curl http://localhost:8080/

# Harus muncul response JSON dengan status: "running"
```

### Test 2: Cek Hotels
```
✅ Buka browser: http://localhost:3000/hotels
✅ Harus muncul list hotel
```

### Test 3: Buat Booking
```
✅ Pilih salah satu hotel
✅ Klik "Book Now"
✅ Isi form booking
✅ Submit
✅ Cek di menu "Reservations"
```

### Test 4: Cek Blockchain History
```
✅ Buka "Reservations"
✅ Klik tombol "📋 Blockchain History" di reservation
✅ Harus muncul popup dengan history
```

---

## 🛑 CARA MENGHENTIKAN SISTEM

### Urutan STOP (penting!):

1. **Stop React Frontend**
   ```
   ✅ Klik terminal yang menjalankan "npm run dev"
   ✅ Tekan: Ctrl + C
   ✅ Tutup terminal
   ```

2. **Stop Go Backend**
   ```
   ✅ Klik terminal yang menjalankan "go run"
   ✅ Tekan: Ctrl + C
   ✅ Tutup terminal
   ```

3. **Stop Fabric Network**
   ```powershell
   # Buka terminal baru
   cd C:\Blockchain\reservasihotel\network
   docker-compose -f docker-compose-simple.yaml down
   ```

4. **Stop XAMPP**
   ```
   ✅ Buka XAMPP Control Panel
   ✅ Klik "Stop" untuk MySQL
   ✅ Klik "Stop" untuk Apache
   ```

5. **Stop Docker Desktop (Optional)**
   ```
   ✅ Klik kanan Docker icon di system tray
   ✅ Pilih "Quit Docker Desktop"
   ```

---

## ❌ TROUBLESHOOTING

### Problem 1: "Port 8080 already in use"
```powershell
# Cari dan kill process di port 8080
netstat -ano | findstr :8080
# Catat PID yang muncul (angka di kolom terakhir)

# Kill process (ganti 1234 dengan PID Anda)
taskkill /PID 1234 /F

# Coba jalankan ulang Go backend
```

### Problem 2: Docker containers tidak start
```powershell
# Stop semua containers
cd C:\Blockchain\reservasihotel\network
docker-compose -f docker-compose-simple.yaml down

# Hapus volumes
docker volume prune -f

# Start ulang
docker-compose -f docker-compose-simple.yaml up -d

# Tunggu 15 detik, cek status
docker ps
```

### Problem 3: Database connection failed
```
✅ Pastikan XAMPP MySQL running (status hijau)
✅ Pastikan database "reservation" sudah dibuat
✅ Buka phpMyAdmin dan cek: http://localhost/phpmyadmin
✅ Restart MySQL di XAMPP
```

### Problem 4: Frontend tidak bisa connect ke backend
```
✅ Pastikan Go backend running di port 8080
✅ Test: curl http://localhost:8080/
✅ Cek firewall tidak block port 8080
✅ Restart Go backend
```

### Problem 5: "go: command not found"
```
✅ Install Go dari: https://go.dev/dl/
✅ Restart terminal setelah install
✅ Test: go version
```

### Problem 6: "npm: command not found"
```
✅ Install Node.js dari: https://nodejs.org/
✅ Restart terminal setelah install
✅ Test: node --version && npm --version
```

---

## 📝 CATATAN PENTING

### DO's ✅
- ✅ Selalu start XAMPP terlebih dahulu
- ✅ Pastikan Docker Desktop running sebelum start Fabric
- ✅ Jalankan Go backend setelah Fabric ready
- ✅ Biarkan semua terminal tetap terbuka saat sistem running
- ✅ Gunakan Ctrl + C untuk stop service dengan aman

### DON'Ts ❌
- ❌ Jangan tutup terminal paksa (klik X)
- ❌ Jangan stop XAMPP saat sistem masih running
- ❌ Jangan restart Docker saat containers sedang running
- ❌ Jangan jalankan lebih dari 1 instance backend bersamaan

---

## 📊 PORT YANG DIGUNAKAN

```
✅ 3000  - React Frontend
✅ 3306  - MySQL Database
✅ 5984  - CouchDB0
✅ 6984  - CouchDB1
✅ 7050  - Fabric Orderer
✅ 7051  - Fabric Peer0 (HotelOrg)
✅ 8051  - Fabric Peer1 (GuestOrg)
✅ 8080  - Go Backend API
```

**PASTIKAN PORT INI TIDAK DIGUNAKAN APLIKASI LAIN!**

---

## 🎯 FITUR YANG BISA DICOBA

### 1. Hotel Management
```
✅ Lihat daftar hotel
✅ Lihat detail hotel
✅ Lihat tipe kamar
✅ Lihat harga per kamar
```

### 2. Booking Reservation
```
✅ Pilih hotel dan kamar
✅ Pilih tanggal check-in/out
✅ Isi jumlah tamu
✅ Submit booking
✅ Lihat reservation ID
```

### 3. Reservation Management
```
✅ Lihat semua reservations
✅ Filter by status (PENDING, CONFIRMED, dll)
✅ Confirm reservation
✅ Cancel reservation
✅ Check-in guest
✅ Check-out guest
```

### 4. Blockchain Features
```
✅ Lihat blockchain status
✅ Lihat blockchain stats (block height, transactions)
✅ Lihat transaction history per reservation
✅ Audit trail lengkap (siapa, kapan, apa)
```

---

## 📞 BANTUAN LEBIH LANJUT

Jika masih ada error:

1. **Screenshot error message**
2. **Check terminal output** (Go backend & React frontend)
3. **Check Docker logs**: `docker logs <container_name>`
4. **Check browser console**: Tekan F12 → Console tab

---

**Version**: 1.0.0  
**Last Updated**: October 2025  
**Platform**: Windows 10/11

**SELAMAT MENCOBA! 🎉**
