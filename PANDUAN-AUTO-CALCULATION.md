# 🎉 PANDUAN LENGKAP - Sistem Booking Meeting/Event dengan Auto-Kalkulasi

## 📋 Fitur Baru yang Sudah Ditambahkan

### ✨ Auto-Calculation System
Sistem sekarang bisa **otomatis menghitung harga total** berdasarkan:
- **Price Per Person**: Harga per orang dari meeting package
- **Guest Count**: Jumlah peserta meeting/event
- **Formula**: `Total Price = Price Per Person × Guest Count`

### 🏨 Meeting Package System
Setiap hotel memiliki 2 jenis residential meeting package:
1. **Residential Meeting Single** (single bed, harga lebih tinggi)
2. **Residential Meeting Twin Share** (twin bed, harga lebih murah)

Setiap package memiliki:
- Price Per Person (Rp 450,000 - Rp 3,100,000)
- Min Capacity (10-30 orang)
- Max Capacity (40-200 orang)
- Full amenities (meals, coffee breaks, meeting room, dll)

---

## 🚀 LANGKAH-LANGKAH DEPLOYMENT

### Step 1: Update Database Schema

1. **Buka phpMyAdmin**
   ```
   http://localhost/phpmyadmin
   ```

2. **Pilih database `reservation`**

3. **Import Schema V2**
   - Tab **Import**
   - Browse: `C:\Blockchain\reservasihotel\database\schema_update_v2.sql`
   - Klik **Go**
   - ✅ Ini akan update schema dengan field baru:
     * `price_per_person` di room_types
     * `min_capacity`, `max_capacity` di room_types
     * `event_type`, `event_description` di reservations
     * `customer_name`, `customer_phone`, `customer_email` di reservations
     * `price_per_person`, `total_price` di reservations

4. **Import Data V2**
   - Tab **Import** lagi
   - Browse: `C:\Blockchain\reservasihotel\database\insert_hotel_data_v2.sql`
   - Klik **Go**
   - ✅ Ini akan insert 21 hotels dengan 42 meeting packages

5. **Verify Data**
   ```sql
   -- Check total hotels
   SELECT COUNT(*) FROM hotels;
   -- Harusnya: 21
   
   -- Check total packages
   SELECT COUNT(*) FROM room_types;
   -- Harusnya: 42
   
   -- Sample data
   SELECT 
       h.name AS hotel_name,
       h.city,
       rt.type_name,
       rt.price_per_person,
       rt.min_capacity,
       rt.max_capacity
   FROM hotels h
   JOIN room_types rt ON h.id = rt.hotel_id
   LIMIT 10;
   ```

### Step 2: Restart Backend

1. **Stop backend lama** (Ctrl+C di terminal backend)

2. **Restart backend**
   ```powershell
   cd C:\Blockchain\reservasihotel\api-gateway
   go run main.go blockchain.go fabric_client.go
   ```

3. **Verify backend running**
   - Buka: http://localhost:8080/api/v1/health
   - Should show: `"status": "online"`

### Step 3: Testing Auto-Calculation

#### Test 1: Calculate Price (Simulasi)

**Request:**
```bash
POST http://localhost:8080/api/v1/calculate-price
Content-Type: application/json

{
  "room_type_id": 1,
  "guest_count": 50
}
```

**Expected Response:**
```json
{
  "hotel_name": "L'Eminence Golf & Convention Hotel Lembang",
  "hotel_city": "Bandung",
  "room_type": "Residential Meeting Single",
  "price_per_person": 3100000,
  "guest_count": 50,
  "total_price": 155000000,
  "currency": "IDR",
  "calculation": "Rp 3100000 x 50 orang = Rp 155000000",
  "amenities": "AC, LCD Projector, Sound System, WiFi, Meals 3x, Coffee Break 2x"
}
```

**Artinya:**
- Meeting untuk 50 orang di L'Eminence
- Harga per orang: Rp 3,100,000
- **Total harga: Rp 155,000,000** (otomatis dikalkulasi!)

---

#### Test 2: Create Booking (Ultah 50 Orang)

**Scenario:** Booking untuk acara ultah di L'Eminence, 50 undangan

**Request:**
```bash
POST http://localhost:8080/api/v1/reservations
Content-Type: application/json

{
  "reservation_id": "RES-ULTAH-001",
  "hotel_id": "1",
  "room_type_id": "1",
  "check_in": "2025-11-20",
  "check_out": "2025-11-22",
  "guest_count": 50,
  "event_type": "Birthday Party",
  "event_description": "Acara ultah perusahaan untuk 50 orang karyawan",
  "customer_name": "Budi Santoso",
  "customer_phone": "08123456789",
  "customer_email": "budi@company.com"
}
```

**Expected Response:**
```json
{
  "message": "Reservation created successfully",
  "reservation": {
    "reservationID": "RES-ULTAH-001",
    "hotelID": "1",
    "roomTypeID": "1",
    "checkIn": "2025-11-20",
    "checkOut": "2025-11-22",
    "guestCount": 50,
    "eventType": "Birthday Party",
    "eventDescription": "Acara ultah perusahaan untuk 50 orang karyawan",
    "customerName": "Budi Santoso",
    "customerPhone": "08123456789",
    "customerEmail": "budi@company.com",
    "pricePerPerson": 3100000,
    "totalPrice": 155000000,
    "currency": "IDR",
    "status": "PENDING"
  },
  "blockchain": "Local Simulation",
  "calculation": {
    "formula": "50 guests × Rp 3,100,000 = Rp 155,000,000",
    "breakdown": {
      "price_per_person": 3100000,
      "guest_count": 50,
      "total": 155000000
    }
  }
}
```

---

#### Test 3: Validation - Minimum Capacity

**Request:**
```json
{
  "reservation_id": "RES-TEST-002",
  "hotel_id": "1",
  "room_type_id": "1",
  "check_in": "2025-11-20",
  "check_out": "2025-11-22",
  "guest_count": 5,
  "event_type": "Meeting",
  "customer_name": "Test User"
}
```

**Expected Error:**
```json
{
  "error": "Minimum capacity for this package is 20 guests"
}
```

---

#### Test 4: Validation - Maximum Capacity

**Request:**
```json
{
  "guest_count": 150
}
```

**Expected Error:**
```json
{
  "error": "Maximum capacity for this package is 100 guests"
}
```

---

## 🎯 CONTOH USE CASES

### Case 1: Corporate Meeting (30 Orang)
```json
{
  "hotel_id": "2",
  "room_type_id": "4",
  "guest_count": 30,
  "event_type": "Corporate Meeting",
  "event_description": "Quarterly business review meeting"
}
```
**Calculation:**
- Padma Hotel Bandung - Twin Share
- Price: Rp 1,600,000/person
- Total: Rp 48,000,000

---

### Case 2: Wedding Gathering (80 Orang)
```json
{
  "hotel_id": "18",
  "room_type_id": "35",
  "guest_count": 80,
  "event_type": "Wedding",
  "event_description": "Pre-wedding family gathering"
}
```
**Calculation:**
- Hotel Mulia Jakarta - Single
- Price: Rp 2,100,000/person
- Total: Rp 168,000,000

---

### Case 3: Workshop (25 Orang)
```json
{
  "hotel_id": "14",
  "room_type_id": "28",
  "guest_count": 25,
  "event_type": "Workshop",
  "event_description": "Leadership development workshop"
}
```
**Calculation:**
- Renaissance Bali - Twin Share
- Price: Rp 1,600,000/person
- Total: Rp 40,000,000

---

## 📊 DAFTAR HOTEL & HARGA

### 💰 Range Harga:
- **Termurah**: Rp 650,000/orang (Twin Share)
- **Termahal**: Rp 3,100,000/orang (Single)
- **Rata-rata**: Rp 1,500,000/orang

### 🏙️ By City:

**BANDUNG (8 hotels)**
1. L'Eminence - Rp 2.5jt - 3.1jt (min 20, max 100)
2. Padma - Rp 1.6jt - 2jt (min 15, max 80)
3. Grand Sunshine - Rp 950k - 1.2jt (min 30, max 150)
4. Grand Panorama - Rp 650k - 800k (min 10, max 50)
5. Pullman - Rp 2jt - 2.5jt (min 20, max 200)
6. Trans Luxury - Rp 1.8jt - 2.2jt (min 25, max 150)
7. Jayakarta Suites - Rp 1.4jt - 1.8jt (min 10, max 40)
8. Mason Pine - Rp 700k - 900k (min 15, max 60)

**BOGOR (5 hotels)**
9. R Hotel Rancamaya - Rp 1.5jt - 1.9jt
10. Royal Tulip - Rp 1.35jt - 1.7jt
11. Novotel - Rp 1.3jt - 1.65jt
12. Pesona Alam - Rp 1.2jt - 1.5jt
13. Aston - Rp 1.1jt - 1.4jt

**BALI (4 hotels)**
14. Renaissance - Rp 1.6jt - 2jt
15. Holiday Inn - Rp 1.5jt - 1.9jt
16. Kuta Beach - Rp 1jt - 1.3jt
17. Grand Mirage - Rp 1.25jt - 1.6jt

**JAKARTA (2 hotels)**
18. Hotel Mulia - Rp 1.7jt - 2.1jt
19. Borobudur - Rp 1.5jt - 1.9jt

**YOGYAKARTA (1 hotel)**
20. Jambuluwuk - Rp 950k - 1.2jt

**PUNCAK (1 hotel)**
21. Green Peak - Rp 850k - 1.1jt

---

## 🔍 API Endpoints

### 1. GET Hotels
```
GET http://localhost:8080/api/v1/hotels
```

### 2. GET Hotel Details + Packages
```
GET http://localhost:8080/api/v1/hotels/{id}/rooms
```

### 3. Calculate Price (Simulasi)
```
POST http://localhost:8080/api/v1/calculate-price
{
  "room_type_id": 1,
  "guest_count": 50
}
```

### 4. Create Booking
```
POST http://localhost:8080/api/v1/reservations
{
  "reservation_id": "RES-XXX",
  "hotel_id": "1",
  "room_type_id": "1",
  "check_in": "2025-11-20",
  "check_out": "2025-11-22",
  "guest_count": 50,
  "event_type": "Birthday Party",
  "event_description": "Acara ultah",
  "customer_name": "Budi",
  "customer_phone": "08123456789",
  "customer_email": "budi@email.com"
}
```

### 5. GET Reservations
```
GET http://localhost:8080/api/v1/reservations
```

---

## ✅ Checklist Testing

- [ ] Database schema updated
- [ ] 21 hotels inserted
- [ ] 42 meeting packages inserted
- [ ] Backend restarted successfully
- [ ] Test calculate-price endpoint
- [ ] Test create booking dengan 50 orang
- [ ] Test validation min capacity
- [ ] Test validation max capacity
- [ ] Verify total price = guest_count × price_per_person
- [ ] Check blockchain history
- [ ] Test different event types (Birthday, Meeting, Wedding, Workshop)

---

## 🎊 SUCCESS CRITERIA

✅ **Sistem berhasil jika:**
1. Calculate-price mengembalikan total harga yang benar
2. Create booking otomatis menghitung total_price
3. Validasi capacity bekerja (min/max)
4. Bisa booking untuk berbagai event types
5. Data tersimpan di MySQL + blockchain
6. Frontend bisa display semua 21 hotels
7. Frontend bisa filter by city
8. Harga ditampilkan dalam format Rupiah

---

## 📝 Notes

- **Auto-calculation**: Backend otomatis menghitung, frontend tidak perlu kirim `total_price`
- **Validation**: Backend akan reject jika guest_count < min atau > max capacity
- **Event Types**: Birthday, Meeting, Wedding, Workshop, Seminar, Conference, Training, Gathering, dll
- **Currency**: Default IDR (Rupiah Indonesia)
- **Status Flow**: PENDING → CONFIRMED → CHECKED_IN → CHECKED_OUT
- **Blockchain**: Semua transaksi tercatat di blockchain ledger

---

## 🚨 Troubleshooting

### Error: "Minimum capacity is X guests"
➡️ Guest count terlalu sedikit, tambah jumlah peserta

### Error: "Maximum capacity is X guests"
➡️ Guest count terlalu banyak, kurangi atau pilih package lain

### Error: "Room type not found"
➡️ room_type_id salah atau belum diinsert

### Backend error: "undefined field Price"
➡️ Backend belum direstart setelah update code

---

## 🎉 SELESAI!

Sistem sekarang siap digunakan untuk **auto-calculation booking meeting/event** dengan berbagai kapasitas peserta!

**Contoh real:**
> "Saya mau booking acara ultah di Hotel Mulia Jakarta untuk 50 orang"
> 
> Sistem akan otomatis kalkulasi:
> - Price per person: Rp 2,100,000
> - Guest count: 50
> - **Total: Rp 105,000,000** ✨

**Magic!** 🎩✨
