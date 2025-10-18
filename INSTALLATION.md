# 🚀 Installation Guide - Hotel Reservation System

## ⚡ Quick Setup (First Time Installation)

### 📋 Prerequisites Checklist

Before starting, make sure you have:

- ✅ **XAMPP** installed (for MySQL)
- ✅ **Docker Desktop** installed and running
- ✅ **Go 1.19+** installed
- ✅ **Node.js 16+** installed
- ✅ **Git** installed (optional)

---

## 📦 Step-by-Step Installation

### **1️⃣ Clone/Download Project**

```powershell
# Option A: Clone from GitHub
git clone https://github.com/YOUR_USERNAME/reservasihotel.git
cd reservasihotel

# Option B: Extract ZIP file
# Extract to C:\Blockchain\reservasihotel
```

---

### **2️⃣ Install Go Dependencies**

```powershell
cd C:\Blockchain\reservasihotel\api-gateway

# Download all Go modules
go mod download

# Verify installation
go mod verify
```

**Expected output:**
```
all modules verified
```

**Installed packages:**
- `github.com/gin-gonic/gin` - Web framework
- `gorm.io/gorm` - ORM
- `gorm.io/driver/mysql` - MySQL driver
- `github.com/hyperledger/fabric-sdk-go` - Fabric SDK
- `github.com/gin-contrib/cors` - CORS middleware

**Installation time:** ~1-2 minutes

---

### **3️⃣ Install Node.js Dependencies**

```powershell
cd C:\Blockchain\reservasihotel\web-ui

# Install all npm packages
npm install
```

**Expected output:**
```
added 200+ packages in 30s
```

**Installed packages:**
- `react` & `react-dom` - React framework
- `vite` - Build tool
- `tailwindcss` - CSS framework
- `react-router-dom` - Routing
- `axios` - HTTP client
- `react-hot-toast` - Notifications

**Installation time:** ~2-5 minutes (depends on internet speed)

---

### **4️⃣ Setup MySQL Database**

```powershell
# 1. Open XAMPP Control Panel
# 2. Click "Start" for MySQL

# 3. Open browser: http://localhost/phpmyadmin

# 4. Click "New" → Create database "reservation"

# 5. Select database "reservation" → Click "SQL" tab

# 6. Copy-paste SQL schema (see README.md) and Execute
```

**SQL Schema:** See `README.md` Section "STEP 0.3: Setup MySQL Database"

---

### **5️⃣ Pull Docker Images**

```powershell
cd C:\Blockchain\reservasihotel

# Make sure Docker Desktop is running
docker --version

# Pull Hyperledger Fabric images
docker pull hyperledger/fabric-peer:2.5
docker pull hyperledger/fabric-orderer:2.5
docker pull hyperledger/fabric-tools:2.5
docker pull couchdb:3.3.2
```

**Expected output:**
```
Status: Downloaded newer image for hyperledger/fabric-peer:2.5
```

**Download time:** ~5-10 minutes (first time only)

---

### **6️⃣ Verification** ✅

Run these commands to verify installation:

```powershell
# ✅ Check Go
go version
# Expected: go version go1.21.x windows/amd64

# ✅ Check Node.js & npm
node --version
npm --version
# Expected: v18.x.x and npm 9.x.x

# ✅ Check Docker
docker --version
docker ps
# Expected: Docker version 20.10.x and empty list (OK)

# ✅ Check Go modules
cd C:\Blockchain\reservasihotel\api-gateway
go mod verify
# Expected: all modules verified

# ✅ Check npm packages
cd C:\Blockchain\reservasihotel\web-ui
npm list --depth=0
# Expected: list of packages without errors

# ✅ Check MySQL
# Open http://localhost/phpmyadmin
# Database "reservation" should exist

# ✅ Check Docker images
docker images | findstr hyperledger
# Expected: list of fabric images
```

---

## 🎉 Installation Complete!

If all checks pass ✅, you're ready to run the system!

**Next steps:**
1. Read `QUICKSTART.md` for 3-step startup
2. Read `PANDUAN-LENGKAP.md` for detailed guide
3. Read `README.md` for technical documentation

---

## ⚠️ Common Installation Issues

### **Issue: `go mod download` fails**

**Solution:**
```powershell
# Set Go proxy
go env -w GOPROXY=https://proxy.golang.org,direct

# Clear cache and retry
go clean -modcache
go mod download
```

### **Issue: `npm install` fails**

**Solution:**
```powershell
# Clear npm cache
npm cache clean --force

# Retry install
npm install

# Or delete node_modules and retry
Remove-Item -Recurse -Force node_modules
npm install
```

### **Issue: Docker pull fails**

**Solution:**
```powershell
# Make sure Docker Desktop is running
# Check internet connection
# Retry pull command
docker pull hyperledger/fabric-peer:2.5
```

### **Issue: MySQL database creation fails**

**Solution:**
```powershell
# Make sure MySQL is running in XAMPP
# Open phpMyAdmin: http://localhost/phpmyadmin
# Create database manually via UI
# Click "New" → Enter "reservation" → Click "Create"
```

---

## 📞 Need Help?

- 📖 Read **README.md** - Complete technical documentation
- 📖 Read **PANDUAN-LENGKAP.md** - Step-by-step guide (Bahasa Indonesia)
- 📖 Read **QUICKSTART.md** - Quick startup guide
- 🐛 Check **Troubleshooting** section in README.md
- 💬 Create issue on GitHub with error details

---

## 📝 Installation Summary

| Step | Component | Time | Status |
|------|-----------|------|--------|
| 1 | Clone project | 1 min | ✅ |
| 2 | Go dependencies | 1-2 min | ✅ |
| 3 | npm dependencies | 2-5 min | ✅ |
| 4 | MySQL database | 2 min | ✅ |
| 5 | Docker images | 5-10 min | ✅ |
| 6 | Verification | 2 min | ✅ |

**Total time:** ~15-25 minutes (first time only)

**After installation, startup time is only ~2-3 minutes!** 🚀
