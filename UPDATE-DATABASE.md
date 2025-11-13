# 🗄️ Update Database - 21 Hotels Real Data

## Quick Command (Pilih salah satu)

### ✅ Option 1: Via MySQL Command Line
```powershell
# Pastikan MySQL sedang jalan di XAMPP
mysql -u root -p reservation < C:\Blockchain\reservasihotel\database\insert_hotel_data_v2.sql

# Atau tanpa password (default XAMPP)
mysql -u root reservation < C:\Blockchain\reservasihotel\database\insert_hotel_data_v2.sql
```

### ✅ Option 2: Via phpMyAdmin
1. Buka http://localhost/phpmyadmin
2. Pilih database **reservation**
3. Klik tab **Import**
4. Klik **Choose File**
5. Pilih file `C:\Blockchain\reservasihotel\database\insert_hotel_data_v2.sql`
6. Scroll ke bawah, klik **Import**
7. Tunggu sampai selesai

### ✅ Option 3: Via SQL Tab di phpMyAdmin
1. Buka http://localhost/phpmyadmin
2. Pilih database **reservation**
3. Klik tab **SQL**
4. Copy seluruh isi file `insert_hotel_data_v2.sql`
5. Paste ke text area SQL
6. Klik **Go**

---

## 📊 Apa yang Akan Di-Update?

### Sebelum (Data Lama):
- ❌ 3 hotels saja (Grand Hotel Jakarta, Beach Resort Bali, Mountain View Hotel)
- ❌ Room types dengan kolom `price` (per kamar)
- ❌ Tidak ada min/max capacity
- ❌ Tidak ada event fields

### Sesudah (Data Baru):
- ✅ **21 hotels** real Indonesia:
  - 🏨 Bandung: 8 hotels (L'Eminence, Padma, Grand Sunshine, dll)
  - 🏨 Bogor: 5 hotels (R Hotel Rancamaya, Royal Tulip, Novotel, dll)
  - 🏨 Bali: 4 hotels (Renaissance, Holiday Inn, Kuta Beach, Grand Mirage)
  - 🏨 Jakarta: 2 hotels (Hotel Mulia, Hotel Borobudur)
  - 🏨 Yogyakarta: 1 hotel (Jambuluwuk Malioboro)
  - 🏨 Puncak: 1 hotel (Novus Giri Resort)

- ✅ **42 meeting packages** (2 per hotel):
  - Single Day Package (1D0N)
  - Twin Share Package (2D1N)
  - Price: Rp 650K - Rp 3.1M per person
  - Capacity: 30-500 guests

- ✅ **Auto-calculation** ready:
  - `price_per_person` (harga per orang)
  - `min_capacity` & `max_capacity` (range peserta)
  - Event fields (event_type, event_description, customer details)

---

## ✅ Verify Data Sukses Terupdate

### Via phpMyAdmin:
```sql
-- Cek jumlah hotels (harus 21)
SELECT COUNT(*) FROM hotels;

-- Cek list hotels
SELECT id, name, city FROM hotels ORDER BY city, name;

-- Cek jumlah room_types/packages (harus 42)
SELECT COUNT(*) FROM room_types;

-- Cek contoh packages dengan price_per_person
SELECT h.name AS hotel, rt.name AS package, 
       rt.price_per_person, rt.min_capacity, rt.max_capacity
FROM room_types rt
JOIN hotels h ON rt.hotel_id = h.id
LIMIT 10;
```

### Via Browser (Test API):
```
# Get all hotels (harus return 21 hotels)
http://localhost:8080/api/v1/hotels

# Get hotel by ID
http://localhost:8080/api/v1/hotels/1

# Get room types untuk hotel tertentu
http://localhost:8080/api/v1/hotels/1/room-types
```

---

## 🚨 Troubleshooting

### "Access denied for user 'root'@'localhost'"
```powershell
# Coba tanpa password
mysql -u root reservation < C:\Blockchain\reservasihotel\database\insert_hotel_data_v2.sql

# Atau dengan password XAMPP (biasanya kosong atau 'root')
mysql -u root -p reservation < C:\Blockchain\reservasihotel\database\insert_hotel_data_v2.sql
```

### "Database 'reservation' doesn't exist"
```powershell
# Buat database dulu
mysql -u root -e "CREATE DATABASE IF NOT EXISTS reservation CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Atau via phpMyAdmin: New > Database name: reservation > Create
```

### "Table doesn't exist"
```powershell
# Import schema dulu baru data
mysql -u root reservation < C:\Blockchain\reservasihotel\database\schema_update_v2.sql
mysql -u root reservation < C:\Blockchain\reservasihotel\database\insert_hotel_data_v2.sql
```

### MySQL command not found
```powershell
# Add MySQL ke PATH atau gunakan full path
C:\xampp\mysql\bin\mysql -u root reservation < C:\Blockchain\reservasihotel\database\insert_hotel_data_v2.sql
```

---

## 🔄 Restart Services Setelah Update

```powershell
# 1. Restart Go Backend (Ctrl+C dulu di terminal backend)
cd C:\Blockchain\reservasihotel\api-gateway
go run main.go blockchain.go fabric_client.go

# 2. Restart Next.js Frontend (Ctrl+C dulu di terminal frontend)
cd C:\Blockchain\reservasihotel\frontend-nextjs
npm run dev

# 3. Test di browser
# http://localhost:3001/hotels
# Harus tampil 21 hotels!
```

---

## 📝 SQL File Structure

```
database/
├── schema_update_v2.sql      <- Schema baru (price_per_person, capacity, events)
└── insert_hotel_data_v2.sql  <- Data 21 hotels + 42 packages ⬅️ IMPORT INI!
```

---

## ✨ After Import Success

Kamu akan punya:
- ✅ 21 hotels across Indonesia
- ✅ 42 meeting packages with transparent pricing
- ✅ Auto-calculation ready (price × guest_count)
- ✅ Filter by city: Bandung, Bogor, Bali, Jakarta, Yogyakarta, Puncak
- ✅ Real hotel data dengan description lengkap

**Next Steps:**
1. Import SQL via salah satu cara di atas
2. Restart backend Go
3. Restart frontend Next.js
4. Browse http://localhost:3001/hotels
5. Lihat 21 hotels tampil dengan lengkap! 🎉
