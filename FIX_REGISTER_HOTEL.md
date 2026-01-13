# 🔧 FIX: Register Hotel Admin - Step by Step

## ❌ Masalah
- POST `/api/v1/auth/register-hotel` error
- Database schema belum lengkap untuk field owner/admin

## ✅ Solusi - Ikuti Step Ini:

### **STEP 1: Update Database (PENTING!)**

1. **Buka phpMyAdmin** → http://localhost/phpmyadmin
2. **Pilih database** `reservation`
3. **Klik tab SQL**
4. **Copy & Paste** script dibawah ini:

```sql
USE reservation;

-- 1. Create users table if not exists
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `role` varchar(50) DEFAULT 'customer',
  `hotel_id` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'active',
  `is_active` tinyint(1) DEFAULT 1,
  `email_verified` tinyint(1) DEFAULT 0,
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Add owner fields to hotels table
ALTER TABLE `hotels` 
ADD COLUMN `owner_id` int(11) DEFAULT NULL AFTER `image_url`,
ADD COLUMN `owner_name` varchar(255) DEFAULT NULL AFTER `owner_id`,
ADD COLUMN `owner_phone` varchar(20) DEFAULT NULL AFTER `owner_name`,
ADD COLUMN `owner_email` varchar(255) DEFAULT NULL AFTER `owner_phone`,
ADD COLUMN `status` varchar(20) DEFAULT 'active' AFTER `owner_email`,
ADD COLUMN `country` varchar(100) DEFAULT 'Indonesia' AFTER `city`;

-- 3. Create hotel_admins table
CREATE TABLE IF NOT EXISTS `hotel_admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` varchar(50) DEFAULT 'staff',
  `permissions` json DEFAULT NULL,
  `assigned_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_hotel_user` (`hotel_id`, `user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

5. **Klik GO** untuk execute

---

### **STEP 2: Restart Backend**

Buka PowerShell baru dan jalankan:

```powershell
cd C:\Blockchain\reservasihotel\api-gateway
go run main.go blockchain.go fabric_client.go
```

Tunggu sampai muncul:
```
🚀 Go Backend Server running on port 8080
```

---

### **STEP 3: Test Register Hotel**

Sekarang bisa test lagi dari browser/Postman:

**Endpoint:** `POST http://localhost:8080/api/v1/auth/register-hotel`

**Request Body:**
```json
{
  "email": "rexaurelius@gmail.com",
  "password": "Abcd1234@0",
  "confirmPassword": "Abcd1234@0",
  "full_name": "Muhammad Supriyadi",
  "phone": "081384215205",
  "hotel_name": "Grand Luxury Hotel",
  "hotel_city": "Bandung",
  "hotel_address": "Jln Tambora",
  "hotel_description": "Test"
}
```

---

### **STEP 4: Expected Response**

Jika berhasil, akan dapat response:

```json
{
  "message": "Hotel registered successfully",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "rexaurelius@gmail.com",
    "full_name": "Muhammad Supriyadi",
    "phone": "081384215205",
    "role": "hotel_super_admin",
    "hotel_id": 10
  },
  "hotel": {
    "id": 10,
    "name": "Grand Luxury Hotel",
    "city": "Bandung",
    "address": "Jln Tambora",
    "status": "active"
  }
}
```

---

## 🔍 Verify di Database

Setelah register berhasil, cek di phpMyAdmin:

```sql
-- Cek user baru
SELECT * FROM users ORDER BY id DESC LIMIT 1;

-- Cek hotel baru
SELECT * FROM hotels ORDER BY id DESC LIMIT 1;

-- Cek admin mapping
SELECT * FROM hotel_admins ORDER BY id DESC LIMIT 1;
```

---

## 🐛 Troubleshooting

### Error: "Email already registered"
```sql
-- Hapus user lama
DELETE FROM users WHERE email = 'rexaurelius@gmail.com';
```

### Error: "Failed to create hotel"
```sql
-- Cek struktur table
DESCRIBE hotels;
-- Pastikan ada kolom: owner_id, owner_name, owner_phone, owner_email, status
```

### Error: "Failed to assign admin role"
```sql
-- Cek apakah table hotel_admins ada
SHOW TABLES LIKE 'hotel_admins';

-- Jika tidak ada, create manual
CREATE TABLE hotel_admins (
  id INT AUTO_INCREMENT PRIMARY KEY,
  hotel_id INT NOT NULL,
  user_id INT NOT NULL,
  role VARCHAR(50) DEFAULT 'staff',
  permissions JSON,
  assigned_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

---

## 📝 Changes Made

1. ✅ Added `confirmPassword` field validation di backend
2. ✅ Updated Hotel model dengan owner fields
3. ✅ Created migration script untuk update database
4. ✅ Fixed password confirmation mismatch validation

---

## 🎯 Next Steps

Setelah berhasil register:

1. **Login** dengan credentials yang baru dibuat
2. **Access dashboard** hotel admin
3. **Manage** rooms, packages, bookings
4. **Add** staff/admin lain untuk hotel

---

**Last Updated:** January 10, 2026  
**Status:** ✅ FIXED - Ready to test!
