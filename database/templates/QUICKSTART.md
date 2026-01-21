# 🚀 QUICK START GUIDE - Import Data Hotel Testing

## ⚡ Super Cepat (5 Menit)

### Step 1: Pastikan MySQL Running
- Buka XAMPP/WAMP
- Start MySQL service
- Buka phpMyAdmin → database `reservation` harus ada

### Step 2: Import Data
```powershell
cd c:\Blockchain\reservasihotel\database
.\import_csv.ps1
```

### Step 3: Verifikasi
Buka phpMyAdmin, cek:
- ✓ hotels: ada Hotel Testing (id=32)
- ✓ room_types: ada 6 tipe (3 hotel room + 3 meeting room)
- ✓ hotel_rooms: ada 41 kamar

### Step 4: Test di Frontend
```powershell
# Restart backend
cd ..\api-gateway
go run main.go

# Di browser: http://localhost:3001
# Login → Pilih Hotel Testing → Booking
```

---

## 📊 Data yang Akan Di-Import

### Hotel Testing (id=32)
📍 Jakarta, Jl. Sudirman No. 123

**35 Hotel Rooms:**
- 20x Standard Room (101-110, 201-210) - Rp 500K/person
- 10x Deluxe Room (301-310) - Rp 750K/person
- 5x Suite Room (401-405) - Rp 1.2M/person

**6 Meeting Rooms:**
- 3x Alpha (M-ALPHA-1,2,3) 10-25 pax - Half: 1.5M, Full: 2.5M, Board: 3.5M
- 2x Beta (M-BETA-1,2) 20-50 pax - Half: 2.5M, Full: 4M, Board: 5.5M
- 1x Gamma (M-GAMMA-1) 50-100 pax - Half: 4M, Full: 6.5M, Board: 9M

**Total: 41 rooms siap booking!**

---

## 🛠️ Customize Data (Opsional)

Kalau mau edit data sebelum import:

1. Buka Excel/Google Sheets
2. File → Open → pilih CSV
3. Edit sesuai kebutuhan:
   - Ubah harga
   - Tambah/kurangi kamar
   - Ganti nama tipe kamar
   - Update amenities
4. Save as CSV (UTF-8)
5. Run import script lagi

---

## ❓ Troubleshooting

### "mysql: command not found"
```powershell
# Add MySQL ke PATH atau gunakan full path:
$env:PATH += ";C:\xampp\mysql\bin"
```

### "Access denied for user"
```powershell
# Tambahkan password MySQL:
.\import_csv.ps1 -MySQLPassword "yourpassword"
```

### "Duplicate entry"
- Data sudah ada di database
- Script otomatis update (REPLACE INTO)
- Tidak masalah, data akan di-replace

### Import berhasil tapi tidak muncul
```powershell
# Restart backend
cd ..\api-gateway
Get-Process | Where-Object {$_.ProcessName -eq "go"} | Stop-Process -Force
go run main.go
```

---

## 📝 Script Parameters

```powershell
# Default (localhost, root, no password)
.\import_csv.ps1

# Custom MySQL settings
.\import_csv.ps1 -MySQLHost "127.0.0.1" `
                 -MySQLPort 3306 `
                 -MySQLUser "root" `
                 -MySQLPassword "mypassword" `
                 -Database "reservation" `
                 -CSVFolder ".\templates"
```

---

## ✅ Success Indicators

Setelah import berhasil, kamu akan lihat:
```
✓ MySQL connection successful!
✓ Successfully imported 1 rows (hotels)
✓ Successfully imported 6 rows (room types)
✓ Successfully imported 41 rows (hotel rooms)
✓ All data imported successfully!
```

---

## 🎯 Next Steps

1. ✓ Data berhasil di-import
2. → Restart backend
3. → Login ke hotel-admin dashboard
4. → Verifikasi room types dan rooms
5. → Test booking flow
6. → Enjoy! 🎉

---

Butuh bantuan? Cek [README.md](README.md) atau [INSTRUKSI_LENGKAP.txt](INSTRUKSI_LENGKAP.txt)
