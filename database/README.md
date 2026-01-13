# 🗄️ Database Setup Instructions

## Prerequisites
- XAMPP/MySQL running
- Database `reservation` sudah dibuat

---

## 📦 Setup Database

### **Option 1: Fresh Install (Recommended for New Setup)**

Jalankan script SQL dengan urutan berikut:

```powershell
# 1. Masuk ke MySQL
mysql -u root -p

# 2. Create database
CREATE DATABASE IF NOT EXISTS reservation;
USE reservation;

# 3. Import main schema (hotels, room_types, reservations, dll)
SOURCE C:/Blockchain/reservasihotel/database/reservation.sql;

# 4. Import users and roles
SOURCE C:/Blockchain/reservasihotel/database/users_and_roles.sql;

# 5. Verify tables
SHOW TABLES;
DESCRIBE hotels;
DESCRIBE users;
DESCRIBE hotel_admins;
```

### **Option 2: Update Existing Database (Migration)**

Jika database sudah ada dan butuh update:

```powershell
# Masuk ke MySQL
mysql -u root -p reservation

# Run migration untuk add owner fields ke hotels
SOURCE C:/Blockchain/reservasihotel/database/migrations/001_add_hotel_owner_fields.sql;

# Run migration untuk create hotel_admins table
SOURCE C:/Blockchain/reservasihotel/database/migrations/002_create_hotel_admins_table.sql;
```

---

## ✅ Verify Database Setup

```sql
USE reservation;

-- Check all tables
SHOW TABLES;

-- Check hotels table structure
DESCRIBE hotels;
-- Should have: owner_id, owner_name, owner_phone, owner_email, status

-- Check users table structure  
DESCRIBE users;
-- Should have: hotel_id, status, role

-- Check hotel_admins table
DESCRIBE hotel_admins;
-- Should have: hotel_id, user_id, role, permissions
```

---

## 🔄 Reset Database (Development Only)

**⚠️ WARNING: This will DELETE all data!**

```sql
DROP DATABASE IF EXISTS reservation;
CREATE DATABASE reservation;
USE reservation;

-- Import semua script dari awal
SOURCE C:/Blockchain/reservasihotel/database/reservation.sql;
SOURCE C:/Blockchain/reservasihotel/database/users_and_roles.sql;
```

---

## 📋 Table Structure Overview

### **users**
- `id` - Primary key
- `email` - Unique, untuk login
- `password` - Hashed password
- `full_name` - Nama lengkap
- `phone` - Nomor telepon
- `company` - Nama perusahaan (optional)
- `role` - customer, hotel_admin, hotel_super_admin, system_admin
- `hotel_id` - Foreign key ke hotels (NULL untuk customer)
- `status` - active, inactive, suspended
- `created_at`, `updated_at`

### **hotels**
- `id` - Primary key
- `name`, `city`, `address`, `description`
- `rating` - Rating hotel
- `image_url` - URL gambar hotel
- `owner_id` - Foreign key ke users (super admin hotel)
- `owner_name`, `owner_phone`, `owner_email` - Info owner
- `status` - active, inactive, pending_approval
- `created_at`, `updated_at`

### **hotel_admins**
- `id` - Primary key
- `hotel_id` - Foreign key ke hotels
- `user_id` - Foreign key ke users
- `role` - super_admin, admin, staff
- `permissions` - JSON object
- `assigned_by` - User ID yang assign
- `created_at`, `updated_at`

---

## 🎯 Test Registration

Setelah database setup, test endpoint `/auth/register-hotel`:

```bash
curl -X POST http://localhost:8080/api/v1/auth/register-hotel \
  -H "Content-Type: application/json" \
  -d '{
    "email": "owner@hotel.com",
    "password": "password123",
    "full_name": "Hotel Owner",
    "phone": "081234567890",
    "hotel_name": "My New Hotel",
    "hotel_city": "Bandung",
    "hotel_address": "Jl. Example No.123",
    "hotel_description": "Beautiful hotel in Bandung"
  }'
```

Expected response:
```json
{
  "message": "Hotel registered successfully",
  "token": "eyJhbGciOiJIUzI1...",
  "user": {
    "id": 1,
    "email": "owner@hotel.com",
    "full_name": "Hotel Owner",
    "phone": "081234567890",
    "role": "hotel_super_admin",
    "hotel_id": 10
  },
  "hotel": {
    "id": 10,
    "name": "My New Hotel",
    "city": "Bandung",
    "address": "Jl. Example No.123",
    "status": "active"
  }
}
```

---

## 📝 Notes

1. **Foreign Keys**: `users.hotel_id` references `hotels.id`
2. **Roles**: 
   - `customer` - Regular user yang booking
   - `hotel_super_admin` - Owner hotel (full access)
   - `hotel_admin` - Admin hotel (manage bookings, rooms)
   - `system_admin` - Admin system (manage all)
3. **Hotel Status**:
   - `active` - Hotel aktif dan bisa dibooking
   - `inactive` - Hotel tidak aktif
   - `pending_approval` - Hotel baru register, menunggu approval
