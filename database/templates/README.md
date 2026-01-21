# 📊 Database CSV Import Templates

Template ini untuk memudahkan pengisian data hotel, room types, dan hotel rooms melalui Excel/CSV yang kemudian bisa langsung di-import ke database.

## 📁 File Templates

### 1. `1_hotels_template.csv` - Data Hotel
Isi informasi hotel utama:
- **id**: ID hotel (gunakan 32 untuk Hotel Testing)
- **name**: Nama hotel
- **city**: Kota lokasi hotel
- **country**: Negara (default: Indonesia)
- **address**: Alamat lengkap
- **description**: Deskripsi hotel dan fasilitasnya
- **owner_name**: Nama pemilik hotel
- **owner_phone**: No. telp pemilik (format: +62xxx)
- **owner_email**: Email pemilik
- **rating**: Rating hotel (0.00 - 5.00)
- **status**: Status hotel (active/inactive)
- **image_url**: URL gambar hotel (dari unsplash atau lainnya)

### 2. `2_room_types_template.csv` - Tipe Kamar
Isi tipe-tipe kamar yang tersedia:

#### Untuk Hotel Room (Residential Meeting):
- **room_category**: `hotel_room`
- **pricing_type**: `per_night`
- **price_per_person**: Harga per orang per malam
- **min_capacity**: Kapasitas minimum (biasanya 1)
- **max_capacity**: Kapasitas maximum per room (1-4)
- Kosongkan: hourly_rate, half_day_rate, full_day_rate, full_board_rate

#### Untuk Meeting Room:
- **room_category**: `meeting_room`
- **pricing_type**: `half_day` (sistem package-based)
- **price_per_person**: 0 (tidak dipakai untuk meeting room)
- **half_day_rate**: Harga paket 4 jam (include 1x coffee break)
- **full_day_rate**: Harga paket 8 jam (include 2x coffee break + 1x meals)
- **full_board_rate**: Harga paket 12 jam (include 2x coffee break + 2x meals)
- **min_capacity**: Minimum peserta (10-50)
- **max_capacity**: Maximum peserta (25-100)
- Kosongkan: hourly_rate

### 3. `3_hotel_rooms_template.csv` - Daftar Kamar Fisik
Isi daftar nomor kamar yang tersedia:
- **id**: ID unique untuk room (mulai dari 200+)
- **hotel_id**: ID hotel (32 untuk Hotel Testing)
- **room_type_id**: ID room type (ambil dari tabel room_types)
- **room_number**: Nomor kamar (contoh: 101, 102, M-ALPHA-1)
- **floor**: Lantai kamar (1-10)
- **is_blockchain_enabled**: 1 (enable booking) atau 0 (walk-in only)
- **status**: AVAILABLE / MAINTENANCE / BLOCKED

## 🎯 Contoh Data Hotel Testing (hotel_id=32)

Template sudah diisi dengan data lengkap untuk Hotel Testing:

### Hotel Rooms:
- **Standard Room** (20 kamar): Lantai 1-2, room 101-210
  - Price: Rp 500,000/person/night
  - Capacity: 1-2 orang
  - Twin bed, AC, TV, WiFi, Breakfast

- **Deluxe Room** (10 kamar): Lantai 3, room 301-310
  - Price: Rp 750,000/person/night
  - Capacity: 1-2 orang
  - King bed, AC, TV 42", WiFi, Bathtub, Mini Bar

- **Suite Room** (5 kamar): Lantai 4, room 401-405
  - Price: Rp 1,200,000/person/night
  - Capacity: 1-3 orang
  - Living room, Jacuzzi, Smart TV

### Meeting Rooms:
- **Meeting Room Alpha** (3 rooms): Lantai 5, M-ALPHA-1,2,3
  - Capacity: 10-25 people
  - Half Day (4h): Rp 1,500,000 (1x coffee break)
  - Full Day (8h): Rp 2,500,000 (2x coffee break + lunch)
  - Full Board (12h): Rp 3,500,000 (2x coffee break + lunch + dinner)

- **Meeting Room Beta** (2 rooms): Lantai 6, M-BETA-1,2
  - Capacity: 20-50 people
  - Half Day: Rp 2,500,000
  - Full Day: Rp 4,000,000
  - Full Board: Rp 5,500,000

- **Meeting Room Gamma** (1 room): Lantai 7, M-GAMMA-1
  - Capacity: 50-100 people (Ballroom)
  - Half Day: Rp 4,000,000
  - Full Day: Rp 6,500,000
  - Full Board: Rp 9,000,000

**Total: 41 rooms** (35 hotel rooms + 6 meeting rooms)

## 🚀 Cara Menggunakan

### Opsi 1: Edit di Excel (Recommended)
1. Buka file CSV dengan Excel atau Google Sheets
2. Edit data sesuai kebutuhan
3. Save as CSV (pastikan encoding UTF-8)
4. Run import script

### Opsi 2: Edit di Text Editor
1. Buka file CSV dengan Notepad++ atau VS Code
2. Edit data (pisahkan kolom dengan koma)
3. Save dengan encoding UTF-8
4. Run import script

### Import ke Database:
```powershell
# Pastikan MySQL sudah running (XAMPP/WAMP)
cd c:\Blockchain\reservasihotel\database

# Import dengan default settings (localhost, root, no password)
.\import_csv.ps1

# Atau dengan custom settings
.\import_csv.ps1 -MySQLUser "root" -MySQLPassword "yourpassword" -Database "reservation"
```

## ⚠️ Penting!

1. **ID Harus Unique**: Jangan duplikat ID di CSV
2. **hotel_id Harus Ada**: Pastikan hotel sudah ada sebelum import room types
3. **room_type_id Harus Valid**: Cek ID room type sebelum assign ke hotel rooms
4. **Format CSV**: Gunakan koma sebagai delimiter, UTF-8 encoding
5. **Empty Values**: Gunakan kosong atau NULL untuk field optional

## 🔧 Troubleshooting

### Error: "Duplicate entry for key PRIMARY"
- ID yang digunakan sudah ada di database
- Ubah ID menjadi nomor yang belum dipakai atau gunakan REPLACE INTO

### Error: "Cannot add foreign key constraint"
- hotel_id atau room_type_id tidak ditemukan
- Pastikan import hotels dulu, baru room_types, terakhir hotel_rooms

### Error: "Data too long for column"
- Text melebihi batas karakter
- Persingkat deskripsi atau amenities

### CSV tidak terbaca dengan benar
- Pastikan encoding UTF-8
- Cek delimiter (harus koma, bukan semicolon)
- Escape quotes dengan double quotes jika ada koma di dalam text

## 📝 Tips

1. **Backup Database**: Sebelum import, backup dulu database
   ```powershell
   mysqldump -u root reservation > backup.sql
   ```

2. **Test dengan Data Kecil**: Import 1-2 rows dulu untuk test

3. **Gunakan Excel Formulas**: Untuk generate room numbers otomatis
   ```excel
   =CONCATENATE("M-ALPHA-", ROW()-1)
   ```

4. **Validasi Data**: Cek dulu di Excel sebelum import:
   - Tidak ada cell kosong di kolom required
   - Format angka benar (tanpa currency symbol)
   - Tidak ada special characters yang aneh

## 📞 Support

Jika ada masalah saat import:
1. Cek error message di PowerShell output
2. Verifikasi data di phpMyAdmin
3. Cek foreign key constraints
4. Test dengan data lebih sedikit

---

**Happy importing! 🎉**
