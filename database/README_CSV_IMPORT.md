# 📊 Database Management & CSV Import Tools

Folder ini berisi tools dan template untuk manage database reservation system.

## 📂 Struktur Folder

```
database/
├── migrations/              ← SQL migration files
│   ├── reservation.sql      ← Full database dump
│   └── add_full_board_rate.sql
├── templates/               ← ⭐ CSV TEMPLATES (NEW!)
│   ├── 1_hotels_template.csv
│   ├── 2_room_types_template.csv  
│   ├── 3_hotel_rooms_template.csv
│   ├── SUMMARY.md           ← 📖 START HERE!
│   ├── QUICKSTART.md
│   ├── README.md
│   ├── INSTRUKSI_LENGKAP.txt
│   └── EXCEL_GUIDE.txt
└── import_csv.ps1           ← Import script
```

## 🎯 Quick Links

### Mau Import Data Hotel Testing?
👉 **Baca**: [`templates/SUMMARY.md`](templates/SUMMARY.md)

**Super Quick (5 menit):**
```powershell
cd c:\Blockchain\reservasihotel\database
.\import_csv.ps1
```

### Mau Edit Data di Excel?
👉 **Baca**: [`templates/EXCEL_GUIDE.txt`](templates/EXCEL_GUIDE.txt)

**Steps:**
1. Open CSV di Excel
2. Edit data
3. Save as CSV UTF-8
4. Run `.\import_csv.ps1`

### Butuh Dokumentasi Lengkap?
👉 **Baca**: [`templates/README.md`](templates/README.md)

## 🏨 Data Hotel Testing (Pre-filled)

Template sudah diisi lengkap dengan data untuk **Hotel Testing (ID: 32)**:

- ✅ 35 Hotel Rooms (Standard, Deluxe, Suite)
- ✅ 6 Meeting Rooms (Alpha, Beta, Gamma)
- ✅ Total 41 kamar siap booking
- ✅ Harga sudah include coffee break & meals

## 🚀 Import Commands

### Basic Import (localhost, root, no password):
```powershell
.\import_csv.ps1
```

### With MySQL Password:
```powershell
.\import_csv.ps1 -MySQLPassword "yourpassword"
```

### Custom Settings:
```powershell
.\import_csv.ps1 -MySQLHost "127.0.0.1" `
                 -MySQLUser "root" `
                 -MySQLPassword "pass" `
                 -Database "reservation"
```

## 📝 Migrations

### Run Full Database Setup:
```powershell
# Via MySQL command line
mysql -u root reservation < migrations/reservation.sql

# Via PowerShell
Get-Content migrations/reservation.sql | mysql -u root reservation
```

### Apply Specific Migration:
```powershell
Get-Content migrations/add_full_board_rate.sql | mysql -u root reservation
```

## 🔧 Maintenance Scripts

### Backup Database:
```powershell
mysqldump -u root reservation > backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').sql
```

### Restore Database:
```powershell
mysql -u root reservation < backup_20260116_123456.sql
```

### Check Table Counts:
```powershell
echo "SELECT 
  (SELECT COUNT(*) FROM hotels) as hotels,
  (SELECT COUNT(*) FROM room_types) as room_types,
  (SELECT COUNT(*) FROM hotel_rooms) as hotel_rooms,
  (SELECT COUNT(*) FROM reservations) as reservations;" | mysql -u root reservation
```

## ❓ FAQs

### Q: Bagaimana cara menambah hotel baru?
A: Edit `templates/1_hotels_template.csv`, ubah ID ke nomor baru (misal 34), lalu run import script.

### Q: Bisa import data partial (hanya room types saja)?
A: Ya, bisa. Script akan import sesuai file yang ada. Bisa comment out baris tertentu di script.

### Q: Data lama akan dihapus saat import?
A: Script menggunakan `REPLACE INTO`, jadi data dengan ID sama akan di-update, bukan delete.

### Q: Format harga yang benar?
A: Angka biasa tanpa currency symbol: `500000` (bukan `Rp 500.000`)

### Q: Error "Cannot add foreign key constraint"?
A: Import harus urutan: hotels → room_types → hotel_rooms (sudah otomatis di script)

## 📚 Documentation

Dokumentasi lengkap ada di folder `templates/`:

1. **SUMMARY.md** - Overview & quick guide
2. **QUICKSTART.md** - 5-minute quick start
3. **README.md** - Complete documentation
4. **INSTRUKSI_LENGKAP.txt** - Detailed instructions
5. **EXCEL_GUIDE.txt** - Excel tips & tricks

## 🎯 Workflow Recommended

### First Time Setup:
1. Setup database: `mysql < migrations/reservation.sql`
2. Import sample data: `.\import_csv.ps1`
3. Verify in phpMyAdmin
4. Restart backend

### Adding New Hotel:
1. Copy CSV templates
2. Edit dengan Excel (ubah ID hotel)
3. Import: `.\import_csv.ps1`
4. Verify & restart backend

### Bulk Update Prices:
1. Export current data ke CSV (via phpMyAdmin)
2. Edit harga di Excel
3. Import kembali
4. Verify changes

## ✅ Checklist Sebelum Import

- [ ] MySQL sudah running (XAMPP/WAMP)
- [ ] Database `reservation` sudah dibuat
- [ ] Backup database sudah dibuat
- [ ] CSV files encoding UTF-8
- [ ] Format harga sudah benar (angka tanpa format)
- [ ] Tidak ada ID yang duplikat
- [ ] hotel_id valid di semua tables

## 🆘 Support

Jika ada masalah:
1. Cek error message di terminal
2. Baca troubleshooting di templates/README.md
3. Verifikasi data di phpMyAdmin
4. Check backend logs: `go run main.go`

---

**Happy Database Management! 🚀**
