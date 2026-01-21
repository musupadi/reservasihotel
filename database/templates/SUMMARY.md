# 📦 PAKET LENGKAP: Template Import Data Hotel Testing

Saya sudah buatkan template lengkap untuk memudahkan isi data hotel via Excel/CSV!

## 📁 Lokasi File
```
c:\Blockchain\reservasihotel\database\
├── templates/
│   ├── 1_hotels_template.csv          ← Data hotel (sudah diisi)
│   ├── 2_room_types_template.csv      ← Tipe kamar & harga (sudah diisi)
│   ├── 3_hotel_rooms_template.csv     ← Nomor kamar fisik (sudah diisi)
│   ├── QUICKSTART.md                  ← Panduan 5 menit
│   ├── README.md                      ← Dokumentasi lengkap
│   ├── INSTRUKSI_LENGKAP.txt         ← Step by step detail
│   └── EXCEL_GUIDE.txt               ← Tips Excel
└── import_csv.ps1                     ← Script import otomatis
```

## ✅ Data Hotel Testing Yang Sudah Diisi

### 🏨 Hotel Testing (ID: 32)
- **Lokasi**: Jakarta, Jl. Sudirman No. 123
- **Rating**: 4.70 ⭐
- **Total Rooms**: 41 kamar (35 hotel + 6 meeting)

### 🛏️ Hotel Rooms (35 kamar):

**Standard Room** - 20 kamar (Lantai 1-2)
- Room: 101-110, 201-210
- Harga: Rp 500,000/person/night
- Capacity: 1-2 orang
- Fasilitas: AC, TV, WiFi, Bathroom, Breakfast

**Deluxe Room** - 10 kamar (Lantai 3)
- Room: 301-310  
- Harga: Rp 750,000/person/night
- Capacity: 1-2 orang
- Fasilitas: AC, TV 42", WiFi, Bathtub, Breakfast, Mini Bar

**Suite Room** - 5 kamar (Lantai 4)
- Room: 401-405
- Harga: Rp 1,200,000/person/night
- Capacity: 1-3 orang
- Fasilitas: AC, Smart TV, WiFi, Jacuzzi, Breakfast, Mini Bar, Living Room

### 🎤 Meeting Rooms (6 ruangan):

**Meeting Room Alpha** - 3 ruangan (Lantai 5)
- Room: M-ALPHA-1, M-ALPHA-2, M-ALPHA-3
- Capacity: 10-25 orang
- Half Day (4h): Rp 1,500,000 + 1x coffee break
- Full Day (8h): Rp 2,500,000 + 2x coffee break + lunch
- Full Board (12h): Rp 3,500,000 + 2x coffee break + lunch + dinner
- Fasilitas: AC, Projector, Whiteboard, WiFi, Sound System

**Meeting Room Beta** - 2 ruangan (Lantai 6)
- Room: M-BETA-1, M-BETA-2
- Capacity: 20-50 orang
- Half Day: Rp 2,500,000
- Full Day: Rp 4,000,000
- Full Board: Rp 5,500,000
- Fasilitas: AC, LED Screen 65", Whiteboard, Flipchart, WiFi, Sound System with Mic

**Meeting Room Gamma** - 1 ruangan (Lantai 7)
- Room: M-GAMMA-1 (Ballroom)
- Capacity: 50-100 orang
- Half Day: Rp 4,000,000
- Full Day: Rp 6,500,000
- Full Board: Rp 9,000,000
- Fasilitas: AC Central, Projector HD, Stage, WiFi Fiber, Pro Sound System, Spotlight

## 🚀 Cara Import (Super Mudah!)

### Opsi 1: Langsung Import (Data Sudah Lengkap)
```powershell
# 1. Pastikan MySQL running (XAMPP/WAMP)
# 2. Jalankan import
cd c:\Blockchain\reservasihotel\database
.\import_csv.ps1

# 3. Restart backend
cd ..\api-gateway
go run main.go

# 4. Test di browser: http://localhost:3001
```

### Opsi 2: Edit Dulu di Excel
```powershell
# 1. Buka file CSV dengan Excel
Excel → Open → templates\1_hotels_template.csv

# 2. Edit data (harga, nama, fasilitas, dll)

# 3. Save as CSV (UTF-8)

# 4. Jalankan import
cd c:\Blockchain\reservasihotel\database
.\import_csv.ps1
```

## 📝 Cara Edit di Excel

### Buka CSV di Excel:
1. Klik kanan file CSV → Open With → Microsoft Excel
2. Atau: Excel → Data → From Text/CSV

### Edit Data:
- **Hotels**: Ubah nama, alamat, deskripsi
- **Room Types**: Ubah harga, kapasitas, amenities
- **Hotel Rooms**: Tambah/kurang nomor kamar

### Tips Excel:
```excel
Auto-generate nomor kamar:
Cell A2: 101
Cell A3: =A2+1
Drag down → 101, 102, 103...

Meeting room names:
=CONCATENATE("M-ALPHA-", ROW()-1)
Result: M-ALPHA-1, M-ALPHA-2...
```

### Save:
- File → Save As
- Format: **CSV UTF-8 (Comma delimited)**
- ❌ JANGAN: CSV (MS-DOS)

## 🎯 Yang Perlu Diperhatikan

### ✅ DO:
- Gunakan encoding UTF-8
- Format angka tanpa currency symbol (500000, bukan Rp 500.000)
- Pastikan hotel_id sama (32)
- Import urutan: hotels → room_types → hotel_rooms

### ❌ DON'T:
- Jangan ubah header (baris pertama)
- Jangan hapus kolom
- Jangan duplikat ID
- Jangan pakai titik/koma di angka harga

## 🔧 Troubleshooting

### MySQL Error:
```powershell
# Add MySQL to PATH
$env:PATH += ";C:\xampp\mysql\bin"

# Atau pakai password
.\import_csv.ps1 -MySQLPassword "yourpass"
```

### Duplicate Entry:
- Script otomatis update data (REPLACE INTO)
- Data lama akan di-replace dengan data baru
- Tidak masalah!

### Data Tidak Muncul:
```powershell
# Restart backend
cd ..\api-gateway
Get-Process | Where-Object {$_.ProcessName -eq "go"} | Stop-Process -Force
go run main.go
```

## 📊 Verifikasi Import

Setelah import, cek di phpMyAdmin:

```sql
-- Cek hotel
SELECT * FROM hotels WHERE id = 32;

-- Cek room types
SELECT * FROM room_types WHERE hotel_id = 32;

-- Cek hotel rooms
SELECT * FROM hotel_rooms WHERE hotel_id = 32;

-- Summary
SELECT 
  (SELECT COUNT(*) FROM room_types WHERE hotel_id = 32) as room_types,
  (SELECT COUNT(*) FROM hotel_rooms WHERE hotel_id = 32) as hotel_rooms;
```

Expected result:
- hotel: 1 row
- room_types: 6 rows
- hotel_rooms: 41 rows

## 📚 Dokumentasi

Baca dokumentasi lengkap di folder `templates/`:

1. **QUICKSTART.md** → Panduan cepat 5 menit
2. **README.md** → Dokumentasi detail & troubleshooting
3. **INSTRUKSI_LENGKAP.txt** → Step by step lengkap
4. **EXCEL_GUIDE.txt** → Tips & tricks Excel

## 🎉 Selesai!

Setelah import berhasil:
1. ✓ 41 kamar siap booking
2. ✓ 3 tipe hotel room (Standard, Deluxe, Suite)
3. ✓ 3 tipe meeting room (Alpha, Beta, Gamma)
4. ✓ Harga sudah include coffee break & meals
5. ✓ Tinggal test booking flow!

---

**Enjoy! 🚀**

Jika ada pertanyaan atau butuh custom data, tinggal edit CSV-nya aja di Excel!
