-- =============================================
-- RESERVATION DATABASE - REALISTIC DATA
-- =============================================
-- Complete database with realistic hotel data
-- Generated: 2026-01-17
-- Password semua hotel: Abcd1234@@
-- =============================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- Drop existing tables (fresh start)
DROP TABLE IF EXISTS `room_reservations`;
DROP TABLE IF EXISTS `reservations`;
DROP TABLE IF EXISTS `hotel_rooms`;
DROP TABLE IF EXISTS `room_types`;
DROP TABLE IF EXISTS `hotel_admins`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `hotels`;

-- =============================================
-- CREATE TABLES
-- =============================================

CREATE TABLE `hotels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `country` varchar(100) DEFAULT 'Indonesia',
  `address` text NOT NULL,
  `description` text DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `owner_name` varchar(100) DEFAULT NULL,
  `owner_phone` varchar(20) DEFAULT NULL,
  `owner_email` varchar(100) DEFAULT NULL,
  `rating` decimal(3,2) DEFAULT 4.50,
  `status` enum('active','inactive','pending_approval') DEFAULT 'active',
  `image_url` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `role` enum('customer','hotel_admin','hotel_super_admin','system_admin') DEFAULT 'customer',
  `hotel_id` int(11) DEFAULT NULL,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `hotel_id` (`hotel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `hotel_admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` enum('super_admin','admin','staff') DEFAULT 'staff',
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `assigned_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `hotel_id` (`hotel_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `room_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) NOT NULL,
  `type_name` varchar(100) NOT NULL,
  `room_category` enum('hotel_room','meeting_room') NOT NULL DEFAULT 'hotel_room',
  `description` text DEFAULT NULL,
  `price_per_person` decimal(12,2) NOT NULL,
  `pricing_type` enum('per_night','per_hour','half_day','full_day','full_board') NOT NULL DEFAULT 'per_night',
  `hourly_rate` decimal(10,2) DEFAULT NULL,
  `half_day_rate` decimal(10,2) DEFAULT NULL,
  `full_day_rate` decimal(10,2) DEFAULT NULL,
  `full_board_rate` decimal(10,2) DEFAULT NULL,
  `min_capacity` int(11) NOT NULL DEFAULT 10,
  `max_capacity` int(11) NOT NULL DEFAULT 100,
  `total_rooms` int(11) DEFAULT 10,
  `blockchain_reserved_rooms` int(11) DEFAULT 5,
  `available_rooms` int(11) DEFAULT 10,
  `amenities` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `hotel_id` (`hotel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `hotel_rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) NOT NULL,
  `room_type_id` int(11) NOT NULL,
  `room_number` varchar(20) NOT NULL,
  `floor` int(11) DEFAULT 1,
  `is_blockchain_enabled` tinyint(1) DEFAULT 1,
  `status` varchar(20) DEFAULT 'AVAILABLE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `layout_x` int(11) DEFAULT NULL,
  `layout_y` int(11) DEFAULT NULL,
  `layout_width` int(11) DEFAULT 1,
  `layout_height` int(11) DEFAULT 1,
  `layout_updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_room` (`hotel_id`,`room_number`),
  KEY `room_type_id` (`room_type_id`),
  KEY `hotel_id` (`hotel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `reservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reservation_id` varchar(50) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `room_type_id` int(11) NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `guest_count` int(11) NOT NULL DEFAULT 1,
  `event_type` varchar(100) DEFAULT NULL,
  `event_description` text DEFAULT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_email` varchar(100) NOT NULL,
  `customer_phone` varchar(20) NOT NULL,
  `customer_ref` varchar(100) DEFAULT NULL,
  `total_price` decimal(12,2) NOT NULL,
  `payment_status` enum('pending','paid','cancelled','refunded') DEFAULT 'pending',
  `blockchain_tx_id` varchar(255) DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `booking_duration_hours` decimal(5,2) DEFAULT NULL,
  `pricing_type` enum('per_night','per_hour','half_day','full_day','full_board') DEFAULT 'per_night',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `reservation_id` (`reservation_id`),
  KEY `hotel_id` (`hotel_id`),
  KEY `room_type_id` (`room_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `room_reservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reservation_id` int(11) NOT NULL,
  `hotel_room_id` int(11) NOT NULL,
  `guest_count` int(11) NOT NULL DEFAULT 1,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `booking_duration_hours` decimal(5,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `reservation_id` (`reservation_id`),
  KEY `hotel_room_id` (`hotel_room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =============================================
-- INSERT DATA - Hotels
-- =============================================

INSERT INTO `hotels` (`id`, `name`, `city`, `country`, `address`, `description`, `owner_id`, `owner_name`, `owner_phone`, `owner_email`, `rating`, `status`, `image_url`, `created_at`, `updated_at`) VALUES
(1, 'L''Eminence Golf & Convention Hotel Lembang', 'Bandung', 'Indonesia', 'Jl. Malabar Dago Giri No.88, Pagerwangi, Lembang, Bandung', 'Hotel mewah dengan fasilitas convention lengkap, cocok untuk acara meeting besar dan gathering perusahaan. Dilengkapi dengan 5 meeting room berkapasitas 20-200 orang dan 50 kamar hotel untuk residential meeting.', 1, 'Budi Santoso', '+62811-2345-6789', 'budi.santoso@leminence.co.id', 4.80, 'active', 'https://images.unsplash.com/photo-1566073771259-6a8506099945', NOW(), NOW()),
(2, 'Padma Hotel Bandung', 'Bandung', 'Indonesia', 'Jl. Rancabentang No.56-58, Ciumbuleuit, Bandung', 'Hotel bintang 5 dengan view gunung, ideal untuk residential meeting dan team building. Memiliki 6 meeting room dengan kapasitas hingga 150 orang dan 60 kamar hotel premium.', 2, 'Dewi Lestari', '+62812-3456-7890', 'dewi.lestari@padmahotels.com', 4.70, 'active', 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa', NOW(), NOW()),
(3, 'Grand Sunshine Resort & Convention Bandung', 'Bandung', 'Indonesia', 'Jl. Tangkuban Perahu KM. 7, Jayagiri, Lembang', 'Resort dengan convention hall besar, cocok untuk seminar nasional dan international meeting. Dilengkapi 8 meeting room dan 80 kamar resort untuk MICE events.', 3, 'Agus Wijaya', '+62813-4567-8901', 'agus.wijaya@grandsunshine.com', 4.60, 'active', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b', NOW(), NOW()),
(4, 'Pullman Bandung Grand Central', 'Bandung', 'Indonesia', 'Jl. Diponegoro No.27, Citarum, Bandung', 'Hotel internasional dengan fasilitas MICE terlengkap di Bandung. Memiliki 7 meeting room dengan teknologi modern dan 70 kamar executive untuk business travelers.', 4, 'Siti Nurhaliza', '+62814-5678-9012', 'siti.nurhaliza@pullman-bandung.com', 4.90, 'active', 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb', NOW(), NOW()),
(5, 'Trans Luxury Hotel Bandung', 'Bandung', 'Indonesia', 'Jl. Gatot Subroto No.289, Cibangkong, Bandung', 'Hotel mewah dengan ballroom megah untuk event besar. Dilengkapi 5 meeting room luxury dan 55 kamar suite untuk VIP guests.', 5, 'Andi Wijaya', '+62815-6789-0123', 'andi.wijaya@transluxury.co.id', 4.80, 'active', 'https://images.unsplash.com/photo-1568084680786-a84f91d1153c', NOW(), NOW());

-- =============================================
-- INSERT DATA - Users (Password: Abcd1234@@)
-- =============================================

INSERT INTO `users` (`id`, `email`, `password`, `full_name`, `phone`, `company`, `role`, `hotel_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'musupadi1501@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Muhammad Supriyadi', '+62851-7788-9900', 'L''Eminence Golf & Convention', 'hotel_super_admin', 1, 'active', NOW(), NOW()),
(2, 'dewi.lestari@padmahotels.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Dewi Lestari', '+62812-3456-7890', 'Padma Hotels Indonesia', 'hotel_super_admin', 2, 'active', NOW(), NOW()),
(3, 'agus.wijaya@grandsunshine.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Agus Wijaya', '+62813-4567-8901', 'Grand Sunshine Resort', 'hotel_super_admin', 3, 'active', NOW(), NOW()),
(4, 'siti.nurhaliza@pullman-bandung.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Siti Nurhaliza', '+62814-5678-9012', 'Pullman Bandung', 'hotel_super_admin', 4, 'active', NOW(), NOW()),
(5, 'andi.wijaya@transluxury.co.id', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Andi Wijaya', '+62815-6789-0123', 'Trans Luxury Hotel', 'hotel_super_admin', 5, 'active', NOW(), NOW()),
(100, 'customer@test.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Test Customer', '+62821-9999-8888', 'PT Testing Indonesia', 'customer', NULL, 'active', NOW(), NOW()),
(101, 'musupadi@gmail.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Supriyadi', '+62858-1234-5678', 'PT Berkah Jaya', 'customer', NULL, 'active', NOW(), NOW());

-- =============================================
-- INSERT DATA - Hotel Admins
-- =============================================

INSERT INTO `hotel_admins` (`id`, `hotel_id`, `user_id`, `role`, `permissions`, `assigned_by`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'super_admin', '{"manage_admins": true, "manage_rooms": true, "manage_packages": true, "view_bookings": true, "manage_bookings": true, "view_reports": true}', NULL, NOW(), NOW()),
(2, 2, 2, 'super_admin', '{"manage_admins": true, "manage_rooms": true, "manage_packages": true, "view_bookings": true, "manage_bookings": true, "view_reports": true}', NULL, NOW(), NOW()),
(3, 3, 3, 'super_admin', '{"manage_admins": true, "manage_rooms": true, "manage_packages": true, "view_bookings": true, "manage_bookings": true, "view_reports": true}', NULL, NOW(), NOW()),
(4, 4, 4, 'super_admin', '{"manage_admins": true, "manage_rooms": true, "manage_packages": true, "view_bookings": true, "manage_bookings": true, "view_reports": true}', NULL, NOW(), NOW()),
(5, 5, 5, 'super_admin', '{"manage_admins": true, "manage_rooms": true, "manage_packages": true, "view_bookings": true, "manage_bookings": true, "view_reports": true}', NULL, NOW(), NOW());

-- =============================================
-- INSERT DATA - Room Types (5 hotels sample)
-- =============================================

INSERT INTO `room_types` (`id`, `hotel_id`, `type_name`, `room_category`, `description`, `price_per_person`, `pricing_type`, `hourly_rate`, `half_day_rate`, `full_day_rate`, `full_board_rate`, `min_capacity`, `max_capacity`, `total_rooms`, `blockchain_reserved_rooms`, `available_rooms`, `amenities`, `created_at`, `updated_at`) VALUES
-- L'Eminence (Hotel 1)
(1, 1, 'Standard Twin', 'hotel_room', 'Kamar standard dengan 2 single bed, AC, TV, WiFi', 450000, 'per_night', NULL, NULL, NULL, NULL, 1, 2, 20, 5, 20, 'AC, TV LED 32", WiFi, Shower, Breakfast', NOW(), NOW()),
(2, 1, 'Deluxe King', 'hotel_room', 'Kamar deluxe king bed dengan bathtub', 650000, 'per_night', NULL, NULL, NULL, NULL, 1, 2, 15, 5, 15, 'AC, TV LED 42", WiFi, Bathtub, Breakfast, Mini Bar', NOW(), NOW()),
(3, 1, 'Executive Suite', 'hotel_room', 'Suite executive dengan living room dan jacuzzi', 1200000, 'per_night', NULL, NULL, NULL, NULL, 1, 3, 10, 3, 10, 'AC, Smart TV 55", WiFi, Jacuzzi, Living Room, Mini Bar', NOW(), NOW()),
(4, 1, 'Meeting Room Sakura', 'meeting_room', 'Ruang meeting kecil untuk 15-30 orang', 0, 'half_day', NULL, 1800000, 3000000, 4200000, 15, 30, 2, 0, 2, 'AC, Projector, Sound System, Whiteboard, WiFi, Coffee Break, Meals', NOW(), NOW()),
(5, 1, 'Meeting Room Melati', 'meeting_room', 'Ruang meeting medium untuk 25-60 orang', 0, 'half_day', NULL, 3000000, 5000000, 7000000, 25, 60, 2, 0, 2, 'AC, LED Screen, Pro Sound, Stage, WiFi, Coffee Break, Lunch Buffet', NOW(), NOW()),
(6, 1, 'Grand Ballroom', 'meeting_room', 'Ballroom besar untuk 80-200 orang', 0, 'half_day', NULL, 8000000, 13000000, 18000000, 80, 200, 1, 0, 1, 'AC, Multiple Projectors, Pro Audio, LED Walls, Stage, WiFi, Full Catering', NOW(), NOW()),

-- Padma (Hotel 2)
(7, 2, 'Superior Twin', 'hotel_room', 'Kamar superior twin dengan mountain view', 550000, 'per_night', NULL, NULL, NULL, NULL, 1, 2, 25, 5, 25, 'AC, TV 42", WiFi, Shower, Breakfast, Mountain View', NOW(), NOW()),
(8, 2, 'Deluxe Double', 'hotel_room', 'Kamar deluxe dengan balkon pribadi', 750000, 'per_night', NULL, NULL, NULL, NULL, 1, 2, 20, 5, 20, 'AC, TV 50", WiFi, Bathtub, Breakfast, Balcony', NOW(), NOW()),
(9, 2, 'Premium Suite', 'hotel_room', 'Suite premium dengan living room', 1400000, 'per_night', NULL, NULL, NULL, NULL, 1, 3, 8, 3, 8, 'AC, Smart TV 60", WiFi, Jacuzzi, Living Room, Premium Amenities', NOW(), NOW()),
(10, 2, 'Meeting Room Cempaka', 'meeting_room', 'Meeting room untuk 10-25 orang', 0, 'half_day', NULL, 2000000, 3500000, 4800000, 10, 25, 3, 0, 3, 'AC, Interactive Display, Video Conference, WiFi, Coffee & Meals', NOW(), NOW()),
(11, 2, 'Meeting Room Anggrek', 'meeting_room', 'Meeting room untuk 30-70 orang', 0, 'half_day', NULL, 3500000, 5800000, 8000000, 30, 70, 2, 0, 2, 'AC, Multiple Screens, Pro Sound, Stage, WiFi, Full Catering', NOW(), NOW()),
(12, 2, 'Convention Hall Padma', 'meeting_room', 'Convention hall untuk 70-150 orang', 0, 'half_day', NULL, 9000000, 15000000, 21000000, 70, 150, 1, 0, 1, 'AC, HD Projectors, Pro Audio, LED Backdrop, WiFi, Premium Catering', NOW(), NOW());

-- Grand Sunshine (Hotel 3)
INSERT INTO `room_types` (`id`, `hotel_id`, `type_name`, `room_category`, `description`, `price_per_person`, `pricing_type`, `hourly_rate`, `half_day_rate`, `full_day_rate`, `full_board_rate`, `min_capacity`, `max_capacity`, `total_rooms`, `blockchain_reserved_rooms`, `available_rooms`, `amenities`, `created_at`, `updated_at`) VALUES
(13, 3, 'Deluxe Twin', 'hotel_room', 'Kamar deluxe twin dengan view resort', 600000, 'per_night', NULL, NULL, NULL, NULL, 1, 2, 30, 8, 30, 'AC, TV 50", WiFi, Shower, Breakfast, Resort View', NOW(), NOW()),
(14, 3, 'Grand Suite', 'hotel_room', 'Suite dengan balkon luas', 950000, 'per_night', NULL, NULL, NULL, NULL, 1, 2, 25, 8, 25, 'AC, TV 55", WiFi, Bathtub, Breakfast, Balcony', NOW(), NOW()),
(15, 3, 'Presidential Suite', 'hotel_room', 'Suite mewah dengan living room', 1600000, 'per_night', NULL, NULL, NULL, NULL, 1, 4, 12, 4, 12, 'AC, Smart TV 65", WiFi, Jacuzzi, Living Room, Premium Service', NOW(), NOW()),
(16, 3, 'Meeting Room Mawar', 'meeting_room', 'Meeting room untuk 12-30 orang', 0, 'half_day', NULL, 2200000, 3800000, 5200000, 12, 30, 4, 0, 4, 'AC, Smart Board, Video Conf, WiFi, Coffee & Meals', NOW(), NOW()),
(17, 3, 'Meeting Room Kenanga', 'meeting_room', 'Meeting room untuk 35-80 orang', 0, 'half_day', NULL, 4000000, 6500000, 9000000, 35, 80, 3, 0, 3, 'AC, LED Display, Pro Sound, Stage, WiFi, Full Catering', NOW(), NOW()),
(18, 3, 'Grand Convention Center', 'meeting_room', 'Convention center untuk 100-250 orang', 0, 'half_day', NULL, 10000000, 16000000, 22000000, 100, 250, 1, 0, 1, 'AC, Multiple Projectors, Pro Audio, LED Walls, WiFi, VIP Catering', NOW(), NOW());

-- Pullman (Hotel 4)
INSERT INTO `room_types` (`id`, `hotel_id`, `type_name`, `room_category`, `description`, `price_per_person`, `pricing_type`, `hourly_rate`, `half_day_rate`, `full_day_rate`, `full_board_rate`, `min_capacity`, `max_capacity`, `total_rooms`, `blockchain_reserved_rooms`, `available_rooms`, `amenities`, `created_at`, `updated_at`) VALUES
(19, 4, 'Superior Room', 'hotel_room', 'Kamar superior city view', 700000, 'per_night', NULL, NULL, NULL, NULL, 1, 2, 28, 7, 28, 'AC, Smart TV 43", WiFi, Shower, Breakfast, City View', NOW(), NOW()),
(20, 4, 'Executive Room', 'hotel_room', 'Kamar executive dengan workspace', 950000, 'per_night', NULL, NULL, NULL, NULL, 1, 2, 22, 7, 22, 'AC, Smart TV 50", WiFi, Bathtub, Breakfast, Work Desk', NOW(), NOW()),
(21, 4, 'Pullman Suite', 'hotel_room', 'Suite dengan lounge akses', 1650000, 'per_night', NULL, NULL, NULL, NULL, 1, 3, 10, 4, 10, 'AC, Smart TV 60", WiFi, Jacuzzi, Lounge Access, Butler Service', NOW(), NOW()),
(22, 4, 'Meeting Room Dahlia', 'meeting_room', 'Meeting room untuk 15-35 orang', 0, 'half_day', NULL, 2500000, 4200000, 5800000, 15, 35, 3, 0, 3, 'AC, Interactive Display, Video Conf, WiFi, Coffee & Lunch', NOW(), NOW()),
(23, 4, 'Meeting Room Teratai', 'meeting_room', 'Meeting room untuk 40-90 orang', 0, 'half_day', NULL, 4500000, 7500000, 10500000, 40, 90, 2, 0, 2, 'AC, Multiple Screens, Pro Audio, Stage, WiFi, Premium Catering', NOW(), NOW()),
(24, 4, 'Pullman Ballroom', 'meeting_room', 'Ballroom internasional untuk 120-300 orang', 0, 'half_day', NULL, 12000000, 20000000, 28000000, 120, 300, 1, 0, 1, 'AC, HD Projectors, Concert Audio, LED Backdrop, WiFi, VIP Catering', NOW(), NOW());

-- Trans Luxury (Hotel 5)
INSERT INTO `room_types` (`id`, `hotel_id`, `type_name`, `room_category`, `description`, `price_per_person`, `pricing_type`, `hourly_rate`, `half_day_rate`, `full_day_rate`, `full_board_rate`, `min_capacity`, `max_capacity`, `total_rooms`, `blockchain_reserved_rooms`, `available_rooms`, `amenities`, `created_at`, `updated_at`) VALUES
(25, 5, 'Luxury Twin', 'hotel_room', 'Kamar luxury dengan amenities premium', 850000, 'per_night', NULL, NULL, NULL, NULL, 1, 2, 22, 6, 22, 'AC, Smart TV 50", WiFi, Rain Shower, Breakfast, Premium Toiletries', NOW(), NOW()),
(26, 5, 'Executive Suite', 'hotel_room', 'Suite executive dengan ruang kerja', 1150000, 'per_night', NULL, NULL, NULL, NULL, 1, 2, 18, 6, 18, 'AC, Smart TV 55", WiFi, Bathtub, Breakfast, Office Space', NOW(), NOW()),
(27, 5, 'Presidential Suite', 'hotel_room', 'Suite presidential dengan jacuzzi dan view', 2000000, 'per_night', NULL, NULL, NULL, NULL, 1, 3, 8, 3, 8, 'AC, Smart TV 70", WiFi, Outdoor Jacuzzi, Living Room, VIP Service', NOW(), NOW()),
(28, 5, 'Meeting Room Flamboyan', 'meeting_room', 'Meeting room untuk 20-40 orang', 0, 'half_day', NULL, 2800000, 4800000, 6600000, 20, 40, 2, 0, 2, 'AC, LED Display, Pro Sound, WiFi, Coffee & Meals', NOW(), NOW()),
(29, 5, 'Meeting Room Bougenville', 'meeting_room', 'Meeting room untuk 50-100 orang', 0, 'half_day', NULL, 5000000, 8500000, 12000000, 50, 100, 2, 0, 2, 'AC, Multiple Displays, Concert Sound, Stage, WiFi, Full Catering', NOW(), NOW()),
(30, 5, 'Trans Grand Ballroom', 'meeting_room', 'Grand ballroom untuk 150-350 orang', 0, 'half_day', NULL, 15000000, 25000000, 35000000, 150, 350, 1, 0, 1, 'AC, 4K Projectors, Pro Audio, LED Walls, Green Room, WiFi, Premium Catering', NOW(), NOW());

-- =============================================
-- INSERT DATA - Hotel Rooms
-- =============================================

-- L'Eminence Hotel (Hotel 1) - 2 lantai, layout 4 kolom
INSERT INTO `hotel_rooms` (`id`, `hotel_id`, `room_type_id`, `room_number`, `floor`, `is_blockchain_enabled`, `status`, `layout_x`, `layout_y`, `layout_width`, `layout_height`, `created_at`, `updated_at`) VALUES
-- LANTAI 1 - Standard Twin (20 kamar)
(1001, 1, 1, '101', 1, 1, 'AVAILABLE', 8, 10, 18, 15, NOW(), NOW()),
(1002, 1, 1, '102', 1, 1, 'AVAILABLE', 28, 10, 18, 15, NOW(), NOW()),
(1003, 1, 1, '103', 1, 1, 'AVAILABLE', 48, 10, 18, 15, NOW(), NOW()),
(1004, 1, 1, '104', 1, 1, 'AVAILABLE', 68, 10, 18, 15, NOW(), NOW()),
(1005, 1, 1, '105', 1, 1, 'AVAILABLE', 8, 28, 18, 15, NOW(), NOW()),
(1006, 1, 1, '106', 1, 1, 'AVAILABLE', 28, 28, 18, 15, NOW(), NOW()),
(1007, 1, 1, '107', 1, 1, 'AVAILABLE', 48, 28, 18, 15, NOW(), NOW()),
(1008, 1, 1, '108', 1, 1, 'AVAILABLE', 68, 28, 18, 15, NOW(), NOW()),
(1009, 1, 1, '109', 1, 1, 'AVAILABLE', 8, 46, 18, 15, NOW(), NOW()),
(1010, 1, 1, '110', 1, 1, 'AVAILABLE', 28, 46, 18, 15, NOW(), NOW()),
(1011, 1, 1, '111', 1, 1, 'AVAILABLE', 48, 46, 18, 15, NOW(), NOW()),
(1012, 1, 1, '112', 1, 1, 'AVAILABLE', 68, 46, 18, 15, NOW(), NOW()),
(1013, 1, 1, '113', 1, 1, 'AVAILABLE', 8, 64, 18, 15, NOW(), NOW()),
(1014, 1, 1, '114', 1, 1, 'AVAILABLE', 28, 64, 18, 15, NOW(), NOW()),
(1015, 1, 1, '115', 1, 1, 'AVAILABLE', 48, 64, 18, 15, NOW(), NOW()),
(1016, 1, 1, '116', 1, 1, 'AVAILABLE', 68, 64, 18, 15, NOW(), NOW()),
(1017, 1, 1, '117', 1, 1, 'AVAILABLE', 8, 82, 18, 15, NOW(), NOW()),
(1018, 1, 1, '118', 1, 1, 'AVAILABLE', 28, 82, 18, 15, NOW(), NOW()),
(1019, 1, 1, '119', 1, 1, 'AVAILABLE', 48, 82, 18, 15, NOW(), NOW()),
(1020, 1, 1, '120', 1, 1, 'AVAILABLE', 68, 82, 18, 15, NOW(), NOW()),

-- LANTAI 2 - Deluxe King (15 kamar)
(1021, 1, 2, '201', 2, 1, 'AVAILABLE', 8, 10, 18, 16, NOW(), NOW()),
(1022, 1, 2, '202', 2, 1, 'AVAILABLE', 28, 10, 18, 16, NOW(), NOW()),
(1023, 1, 2, '203', 2, 1, 'AVAILABLE', 48, 10, 18, 16, NOW(), NOW()),
(1024, 1, 2, '204', 2, 1, 'AVAILABLE', 68, 10, 18, 16, NOW(), NOW()),
(1025, 1, 2, '205', 2, 1, 'AVAILABLE', 8, 29, 18, 16, NOW(), NOW()),
(1026, 1, 2, '206', 2, 1, 'AVAILABLE', 28, 29, 18, 16, NOW(), NOW()),
(1027, 1, 2, '207', 2, 1, 'AVAILABLE', 48, 29, 18, 16, NOW(), NOW()),
(1028, 1, 2, '208', 2, 1, 'AVAILABLE', 68, 29, 18, 16, NOW(), NOW()),
(1029, 1, 2, '209', 2, 1, 'AVAILABLE', 8, 48, 18, 16, NOW(), NOW()),
(1030, 1, 2, '210', 2, 1, 'AVAILABLE', 28, 48, 18, 16, NOW(), NOW()),
(1031, 1, 2, '211', 2, 1, 'AVAILABLE', 48, 48, 18, 16, NOW(), NOW()),
(1032, 1, 2, '212', 2, 1, 'AVAILABLE', 68, 48, 18, 16, NOW(), NOW()),
(1033, 1, 2, '213', 2, 1, 'AVAILABLE', 18, 67, 18, 16, NOW(), NOW()),
(1034, 1, 2, '214', 2, 1, 'AVAILABLE', 38, 67, 18, 16, NOW(), NOW()),
(1035, 1, 2, '215', 2, 1, 'AVAILABLE', 58, 67, 18, 16, NOW(), NOW()),

-- Executive Suite (10 kamar) - lantai 2 bagian premium
(1036, 1, 3, '216', 2, 1, 'AVAILABLE', 8, 86, 22, 18, NOW(), NOW()),
(1037, 1, 3, '217', 2, 1, 'AVAILABLE', 32, 86, 22, 18, NOW(), NOW()),
(1038, 1, 3, '218', 2, 1, 'AVAILABLE', 56, 86, 22, 18, NOW(), NOW()),
(1039, 1, 3, '219', 2, 1, 'AVAILABLE', 20, 105, 22, 18, NOW(), NOW()),
(1040, 1, 3, '220', 2, 1, 'AVAILABLE', 44, 105, 22, 18, NOW(), NOW()),
(1041, 1, 3, '221', 2, 1, 'AVAILABLE', 68, 105, 22, 18, NOW(), NOW()),
(1042, 1, 3, '222', 2, 1, 'AVAILABLE', 8, 124, 22, 18, NOW(), NOW()),
(1043, 1, 3, '223', 2, 1, 'AVAILABLE', 32, 124, 22, 18, NOW(), NOW()),
(1044, 1, 3, '224', 2, 1, 'AVAILABLE', 56, 124, 22, 18, NOW(), NOW()),
(1045, 1, 3, '225', 2, 1, 'AVAILABLE', 32, 143, 22, 18, NOW(), NOW()),

-- Meeting Room Sakura (2 rooms)
(1046, 1, 4, 'M-Sakura-A', 2, 1, 'AVAILABLE', 8, 162, 35, 25, NOW(), NOW()),
(1047, 1, 4, 'M-Sakura-B', 2, 1, 'AVAILABLE', 50, 162, 35, 25, NOW(), NOW()),

-- Meeting Room Melati (2 rooms) 
(1048, 1, 5, 'M-Melati-A', 2, 1, 'AVAILABLE', 8, 188, 40, 28, NOW(), NOW()),
(1049, 1, 5, 'M-Melati-B', 2, 1, 'AVAILABLE', 52, 188, 40, 28, NOW(), NOW()),

-- Grand Ballroom (1 room)
(1050, 1, 6, 'M-Grand-Ballroom', 2, 1, 'AVAILABLE', 15, 217, 70, 50, NOW(), NOW());

-- Padma Hotel (Hotel 2) - 3 lantai, layout 4 kolom
INSERT INTO `hotel_rooms` (`id`, `hotel_id`, `room_type_id`, `room_number`, `floor`, `is_blockchain_enabled`, `status`, `layout_x`, `layout_y`, `layout_width`, `layout_height`, `created_at`, `updated_at`) VALUES
-- LANTAI 1 - Superior Twin (12 kamar)
(2001, 2, 7, '101', 1, 1, 'AVAILABLE', 8, 10, 18, 15, NOW(), NOW()),
(2002, 2, 7, '102', 1, 1, 'AVAILABLE', 28, 10, 18, 15, NOW(), NOW()),
(2003, 2, 7, '103', 1, 1, 'AVAILABLE', 48, 10, 18, 15, NOW(), NOW()),
(2004, 2, 7, '104', 1, 1, 'AVAILABLE', 68, 10, 18, 15, NOW(), NOW()),
(2005, 2, 7, '105', 1, 1, 'AVAILABLE', 8, 28, 18, 15, NOW(), NOW()),
(2006, 2, 7, '106', 1, 1, 'AVAILABLE', 28, 28, 18, 15, NOW(), NOW()),
(2007, 2, 7, '107', 1, 1, 'AVAILABLE', 48, 28, 18, 15, NOW(), NOW()),
(2008, 2, 7, '108', 1, 1, 'AVAILABLE', 68, 28, 18, 15, NOW(), NOW()),
(2009, 2, 7, '109', 1, 1, 'AVAILABLE', 8, 46, 18, 15, NOW(), NOW()),
(2010, 2, 7, '110', 1, 1, 'AVAILABLE', 28, 46, 18, 15, NOW(), NOW()),
(2011, 2, 7, '111', 1, 1, 'AVAILABLE', 48, 46, 18, 15, NOW(), NOW()),
(2012, 2, 7, '112', 1, 1, 'AVAILABLE', 68, 46, 18, 15, NOW(), NOW()),

-- LANTAI 2 - Superior Twin lanjutan (13 kamar)
(2013, 2, 7, '201', 2, 1, 'AVAILABLE', 8, 10, 18, 15, NOW(), NOW()),
(2014, 2, 7, '202', 2, 1, 'AVAILABLE', 28, 10, 18, 15, NOW(), NOW()),
(2015, 2, 7, '203', 2, 1, 'AVAILABLE', 48, 10, 18, 15, NOW(), NOW()),
(2016, 2, 7, '204', 2, 1, 'AVAILABLE', 68, 10, 18, 15, NOW(), NOW()),
(2017, 2, 7, '205', 2, 1, 'AVAILABLE', 8, 28, 18, 15, NOW(), NOW()),
(2018, 2, 7, '206', 2, 1, 'AVAILABLE', 28, 28, 18, 15, NOW(), NOW()),
(2019, 2, 7, '207', 2, 1, 'AVAILABLE', 48, 28, 18, 15, NOW(), NOW()),
(2020, 2, 7, '208', 2, 1, 'AVAILABLE', 68, 28, 18, 15, NOW(), NOW()),
(2021, 2, 7, '209', 2, 1, 'AVAILABLE', 8, 46, 18, 15, NOW(), NOW()),
(2022, 2, 7, '210', 2, 1, 'AVAILABLE', 28, 46, 18, 15, NOW(), NOW()),
(2023, 2, 7, '211', 2, 1, 'AVAILABLE', 48, 46, 18, 15, NOW(), NOW()),
(2024, 2, 7, '212', 2, 1, 'AVAILABLE', 68, 46, 18, 15, NOW(), NOW()),
(2025, 2, 7, '213', 2, 1, 'AVAILABLE', 38, 64, 18, 15, NOW(), NOW()),

-- LANTAI 2 - Deluxe Double (20 kamar)
(2026, 2, 8, '214', 2, 1, 'AVAILABLE', 8, 82, 18, 16, NOW(), NOW()),
(2027, 2, 8, '215', 2, 1, 'AVAILABLE', 28, 82, 18, 16, NOW(), NOW()),
(2028, 2, 8, '216', 2, 1, 'AVAILABLE', 48, 82, 18, 16, NOW(), NOW()),
(2029, 2, 8, '217', 2, 1, 'AVAILABLE', 68, 82, 18, 16, NOW(), NOW()),
(2030, 2, 8, '218', 2, 1, 'AVAILABLE', 8, 101, 18, 16, NOW(), NOW()),
(2031, 2, 8, '219', 2, 1, 'AVAILABLE', 28, 101, 18, 16, NOW(), NOW()),
(2032, 2, 8, '220', 2, 1, 'AVAILABLE', 48, 101, 18, 16, NOW(), NOW()),
(2033, 2, 8, '221', 2, 1, 'AVAILABLE', 68, 101, 18, 16, NOW(), NOW()),

-- LANTAI 3 - Deluxe Double lanjutan (12 kamar)
(2034, 2, 8, '301', 3, 1, 'AVAILABLE', 8, 10, 18, 16, NOW(), NOW()),
(2035, 2, 8, '302', 3, 1, 'AVAILABLE', 28, 10, 18, 16, NOW(), NOW()),
(2036, 2, 8, '303', 3, 1, 'AVAILABLE', 48, 10, 18, 16, NOW(), NOW()),
(2037, 2, 8, '304', 3, 1, 'AVAILABLE', 68, 10, 18, 16, NOW(), NOW()),
(2038, 2, 8, '305', 3, 1, 'AVAILABLE', 8, 29, 18, 16, NOW(), NOW()),
(2039, 2, 8, '306', 3, 1, 'AVAILABLE', 28, 29, 18, 16, NOW(), NOW()),
(2040, 2, 8, '307', 3, 1, 'AVAILABLE', 48, 29, 18, 16, NOW(), NOW()),
(2041, 2, 8, '308', 3, 1, 'AVAILABLE', 68, 29, 18, 16, NOW(), NOW()),
(2042, 2, 8, '309', 3, 1, 'AVAILABLE', 8, 48, 18, 16, NOW(), NOW()),
(2043, 2, 8, '310', 3, 1, 'AVAILABLE', 28, 48, 18, 16, NOW(), NOW()),
(2044, 2, 8, '311', 3, 1, 'AVAILABLE', 48, 48, 18, 16, NOW(), NOW()),
(2045, 2, 8, '312', 3, 1, 'AVAILABLE', 68, 48, 18, 16, NOW(), NOW()),

-- Premium Suite (8 kamar) - lantai 3
(2046, 2, 9, '313', 3, 1, 'AVAILABLE', 8, 67, 22, 18, NOW(), NOW()),
(2047, 2, 9, '314', 3, 1, 'AVAILABLE', 32, 67, 22, 18, NOW(), NOW()),
(2048, 2, 9, '315', 3, 1, 'AVAILABLE', 56, 67, 22, 18, NOW(), NOW()),
(2049, 2, 9, '316', 3, 1, 'AVAILABLE', 8, 88, 22, 18, NOW(), NOW()),
(2050, 2, 9, '317', 3, 1, 'AVAILABLE', 32, 88, 22, 18, NOW(), NOW()),
(2051, 2, 9, '318', 3, 1, 'AVAILABLE', 56, 88, 22, 18, NOW(), NOW()),
(2052, 2, 9, '319', 3, 1, 'AVAILABLE', 16, 109, 22, 18, NOW(), NOW()),
(2053, 2, 9, '320', 3, 1, 'AVAILABLE', 48, 109, 22, 18, NOW(), NOW()),

-- Meeting Room Cempaka (3 rooms)
(2054, 2, 10, 'M-Cempaka-A', 3, 1, 'AVAILABLE', 8, 128, 28, 24, NOW(), NOW()),
(2055, 2, 10, 'M-Cempaka-B', 3, 1, 'AVAILABLE', 38, 128, 28, 24, NOW(), NOW()),
(2056, 2, 10, 'M-Cempaka-C', 3, 1, 'AVAILABLE', 68, 128, 28, 24, NOW(), NOW()),

-- Meeting Room Anggrek (2 rooms) 
(2057, 2, 11, 'M-Anggrek-A', 3, 1, 'AVAILABLE', 12, 154, 38, 28, NOW(), NOW()),
(2058, 2, 11, 'M-Anggrek-B', 3, 1, 'AVAILABLE', 54, 154, 38, 28, NOW(), NOW()),

-- Convention Hall Padma (1 room)
(2059, 2, 12, 'M-Convention-Hall', 3, 1, 'AVAILABLE', 15, 184, 70, 52, NOW(), NOW());

-- Grand Sunshine Hotel (Hotel 3) - 3 lantai, layout 4 kolom
INSERT INTO `hotel_rooms` (`id`, `hotel_id`, `room_type_id`, `room_number`, `floor`, `is_blockchain_enabled`, `status`, `layout_x`, `layout_y`, `layout_width`, `layout_height`, `created_at`, `updated_at`) VALUES
-- LANTAI 1 - Deluxe Twin (12 kamar)
(3001, 3, 13, '101', 1, 1, 'AVAILABLE', 8, 10, 18, 15, NOW(), NOW()),
(3002, 3, 13, '102', 1, 1, 'AVAILABLE', 28, 10, 18, 15, NOW(), NOW()),
(3003, 3, 13, '103', 1, 1, 'AVAILABLE', 48, 10, 18, 15, NOW(), NOW()),
(3004, 3, 13, '104', 1, 1, 'AVAILABLE', 68, 10, 18, 15, NOW(), NOW()),
(3005, 3, 13, '105', 1, 1, 'AVAILABLE', 8, 28, 18, 15, NOW(), NOW()),
(3006, 3, 13, '106', 1, 1, 'AVAILABLE', 28, 28, 18, 15, NOW(), NOW()),
(3007, 3, 13, '107', 1, 1, 'AVAILABLE', 48, 28, 18, 15, NOW(), NOW()),
(3008, 3, 13, '108', 1, 1, 'AVAILABLE', 68, 28, 18, 15, NOW(), NOW()),
(3009, 3, 13, '109', 1, 1, 'AVAILABLE', 8, 46, 18, 15, NOW(), NOW()),
(3010, 3, 13, '110', 1, 1, 'AVAILABLE', 28, 46, 18, 15, NOW(), NOW()),
(3011, 3, 13, '111', 1, 1, 'AVAILABLE', 48, 46, 18, 15, NOW(), NOW()),
(3012, 3, 13, '112', 1, 1, 'AVAILABLE', 68, 46, 18, 15, NOW(), NOW()),

-- LANTAI 2 - Deluxe Twin lanjutan (18 kamar)
(3013, 3, 13, '201', 2, 1, 'AVAILABLE', 8, 10, 18, 15, NOW(), NOW()),
(3014, 3, 13, '202', 2, 1, 'AVAILABLE', 28, 10, 18, 15, NOW(), NOW()),
(3015, 3, 13, '203', 2, 1, 'AVAILABLE', 48, 10, 18, 15, NOW(), NOW()),
(3016, 3, 13, '204', 2, 1, 'AVAILABLE', 68, 10, 18, 15, NOW(), NOW()),
(3017, 3, 13, '205', 2, 1, 'AVAILABLE', 8, 28, 18, 15, NOW(), NOW()),
(3018, 3, 13, '206', 2, 1, 'AVAILABLE', 28, 28, 18, 15, NOW(), NOW()),
(3019, 3, 13, '207', 2, 1, 'AVAILABLE', 48, 28, 18, 15, NOW(), NOW()),
(3020, 3, 13, '208', 2, 1, 'AVAILABLE', 68, 28, 18, 15, NOW(), NOW()),
(3021, 3, 13, '209', 2, 1, 'AVAILABLE', 8, 46, 18, 15, NOW(), NOW()),
(3022, 3, 13, '210', 2, 1, 'AVAILABLE', 28, 46, 18, 15, NOW(), NOW()),
(3023, 3, 13, '211', 2, 1, 'AVAILABLE', 48, 46, 18, 15, NOW(), NOW()),
(3024, 3, 13, '212', 2, 1, 'AVAILABLE', 68, 46, 18, 15, NOW(), NOW()),
(3025, 3, 13, '213', 2, 1, 'AVAILABLE', 8, 64, 18, 15, NOW(), NOW()),
(3026, 3, 13, '214', 2, 1, 'AVAILABLE', 28, 64, 18, 15, NOW(), NOW()),
(3027, 3, 13, '215', 2, 1, 'AVAILABLE', 48, 64, 18, 15, NOW(), NOW()),
(3028, 3, 13, '216', 2, 1, 'AVAILABLE', 68, 64, 18, 15, NOW(), NOW()),
(3029, 3, 13, '217', 2, 1, 'AVAILABLE', 18, 82, 18, 15, NOW(), NOW()),
(3030, 3, 13, '218', 2, 1, 'AVAILABLE', 58, 82, 18, 15, NOW(), NOW()),

-- LANTAI 2 - Grand Suite (25 kamar)
(3031, 3, 14, '219', 2, 1, 'AVAILABLE', 8, 100, 18, 16, NOW(), NOW()),
(3032, 3, 14, '220', 2, 1, 'AVAILABLE', 28, 100, 18, 16, NOW(), NOW()),
(3033, 3, 14, '221', 2, 1, 'AVAILABLE', 48, 100, 18, 16, NOW(), NOW()),
(3034, 3, 14, '222', 2, 1, 'AVAILABLE', 68, 100, 18, 16, NOW(), NOW()),
(3035, 3, 14, '223', 2, 1, 'AVAILABLE', 8, 119, 18, 16, NOW(), NOW()),
(3036, 3, 14, '224', 2, 1, 'AVAILABLE', 28, 119, 18, 16, NOW(), NOW()),
(3037, 3, 14, '225', 2, 1, 'AVAILABLE', 48, 119, 18, 16, NOW(), NOW()),
(3038, 3, 14, '226', 2, 1, 'AVAILABLE', 68, 119, 18, 16, NOW(), NOW()),

-- LANTAI 3 - Grand Suite lanjutan (17 kamar)
(3039, 3, 14, '301', 3, 1, 'AVAILABLE', 8, 10, 18, 16, NOW(), NOW()),
(3040, 3, 14, '302', 3, 1, 'AVAILABLE', 28, 10, 18, 16, NOW(), NOW()),
(3041, 3, 14, '303', 3, 1, 'AVAILABLE', 48, 10, 18, 16, NOW(), NOW()),
(3042, 3, 14, '304', 3, 1, 'AVAILABLE', 68, 10, 18, 16, NOW(), NOW()),
(3043, 3, 14, '305', 3, 1, 'AVAILABLE', 8, 29, 18, 16, NOW(), NOW()),
(3044, 3, 14, '306', 3, 1, 'AVAILABLE', 28, 29, 18, 16, NOW(), NOW()),
(3045, 3, 14, '307', 3, 1, 'AVAILABLE', 48, 29, 18, 16, NOW(), NOW()),
(3046, 3, 14, '308', 3, 1, 'AVAILABLE', 68, 29, 18, 16, NOW(), NOW()),
(3047, 3, 14, '309', 3, 1, 'AVAILABLE', 8, 48, 18, 16, NOW(), NOW()),
(3048, 3, 14, '310', 3, 1, 'AVAILABLE', 28, 48, 18, 16, NOW(), NOW()),
(3049, 3, 14, '311', 3, 1, 'AVAILABLE', 48, 48, 18, 16, NOW(), NOW()),
(3050, 3, 14, '312', 3, 1, 'AVAILABLE', 68, 48, 18, 16, NOW(), NOW()),
(3051, 3, 14, '313', 3, 1, 'AVAILABLE', 8, 67, 18, 16, NOW(), NOW()),
(3052, 3, 14, '314', 3, 1, 'AVAILABLE', 28, 67, 18, 16, NOW(), NOW()),
(3053, 3, 14, '315', 3, 1, 'AVAILABLE', 48, 67, 18, 16, NOW(), NOW()),
(3054, 3, 14, '316', 3, 1, 'AVAILABLE', 68, 67, 18, 16, NOW(), NOW()),
(3055, 3, 14, '317', 3, 1, 'AVAILABLE', 38, 86, 18, 16, NOW(), NOW()),

-- Presidential Suite (12 kamar) - lantai 3
(3056, 3, 15, '318', 3, 1, 'AVAILABLE', 8, 105, 22, 18, NOW(), NOW()),
(3057, 3, 15, '319', 3, 1, 'AVAILABLE', 32, 105, 22, 18, NOW(), NOW()),
(3058, 3, 15, '320', 3, 1, 'AVAILABLE', 56, 105, 22, 18, NOW(), NOW()),
(3059, 3, 15, '321', 3, 1, 'AVAILABLE', 8, 126, 22, 18, NOW(), NOW()),
(3060, 3, 15, '322', 3, 1, 'AVAILABLE', 32, 126, 22, 18, NOW(), NOW()),
(3061, 3, 15, '323', 3, 1, 'AVAILABLE', 56, 126, 22, 18, NOW(), NOW()),
(3062, 3, 15, '324', 3, 1, 'AVAILABLE', 8, 147, 22, 18, NOW(), NOW()),
(3063, 3, 15, '325', 3, 1, 'AVAILABLE', 32, 147, 22, 18, NOW(), NOW()),
(3064, 3, 15, '326', 3, 1, 'AVAILABLE', 56, 147, 22, 18, NOW(), NOW()),
(3065, 3, 15, '327', 3, 1, 'AVAILABLE', 14, 168, 22, 18, NOW(), NOW()),
(3066, 3, 15, '328', 3, 1, 'AVAILABLE', 38, 168, 22, 18, NOW(), NOW()),
(3067, 3, 15, '329', 3, 1, 'AVAILABLE', 62, 168, 22, 18, NOW(), NOW()),

-- Meeting Room Mawar (4 rooms)
(3068, 3, 16, 'M-Mawar-A', 3, 1, 'AVAILABLE', 8, 189, 32, 26, NOW(), NOW()),
(3069, 3, 16, 'M-Mawar-B', 3, 1, 'AVAILABLE', 44, 189, 32, 26, NOW(), NOW()),
(3070, 3, 16, 'M-Mawar-C', 3, 1, 'AVAILABLE', 8, 218, 32, 26, NOW(), NOW()),
(3071, 3, 16, 'M-Mawar-D', 3, 1, 'AVAILABLE', 44, 218, 32, 26, NOW(), NOW()),

-- Meeting Room Kenanga (3 rooms) 
(3072, 3, 17, 'M-Kenanga-A', 3, 1, 'AVAILABLE', 10, 247, 38, 30, NOW(), NOW()),
(3073, 3, 17, 'M-Kenanga-B', 3, 1, 'AVAILABLE', 52, 247, 38, 30, NOW(), NOW()),
(3074, 3, 17, 'M-Kenanga-C', 3, 1, 'AVAILABLE', 28, 280, 38, 30, NOW(), NOW()),

-- Grand Convention Center (1 room)
(3075, 3, 18, 'M-Grand-Convention', 3, 1, 'AVAILABLE', 12, 313, 76, 58, NOW(), NOW());

-- Pullman Hotel (Hotel 4) - 2 lantai, layout 4 kolom
INSERT INTO `hotel_rooms` (`id`, `hotel_id`, `room_type_id`, `room_number`, `floor`, `is_blockchain_enabled`, `status`, `layout_x`, `layout_y`, `layout_width`, `layout_height`, `created_at`, `updated_at`) VALUES
-- LANTAI 1 - Superior Room (16 kamar)
(4001, 4, 19, '101', 1, 1, 'AVAILABLE', 8, 10, 18, 15, NOW(), NOW()),
(4002, 4, 19, '102', 1, 1, 'AVAILABLE', 28, 10, 18, 15, NOW(), NOW()),
(4003, 4, 19, '103', 1, 1, 'AVAILABLE', 48, 10, 18, 15, NOW(), NOW()),
(4004, 4, 19, '104', 1, 1, 'AVAILABLE', 68, 10, 18, 15, NOW(), NOW()),
(4005, 4, 19, '105', 1, 1, 'AVAILABLE', 8, 28, 18, 15, NOW(), NOW()),
(4006, 4, 19, '106', 1, 1, 'AVAILABLE', 28, 28, 18, 15, NOW(), NOW()),
(4007, 4, 19, '107', 1, 1, 'AVAILABLE', 48, 28, 18, 15, NOW(), NOW()),
(4008, 4, 19, '108', 1, 1, 'AVAILABLE', 68, 28, 18, 15, NOW(), NOW()),
(4009, 4, 19, '109', 1, 1, 'AVAILABLE', 8, 46, 18, 15, NOW(), NOW()),
(4010, 4, 19, '110', 1, 1, 'AVAILABLE', 28, 46, 18, 15, NOW(), NOW()),
(4011, 4, 19, '111', 1, 1, 'AVAILABLE', 48, 46, 18, 15, NOW(), NOW()),
(4012, 4, 19, '112', 1, 1, 'AVAILABLE', 68, 46, 18, 15, NOW(), NOW()),
(4013, 4, 19, '113', 1, 1, 'AVAILABLE', 8, 64, 18, 15, NOW(), NOW()),
(4014, 4, 19, '114', 1, 1, 'AVAILABLE', 28, 64, 18, 15, NOW(), NOW()),
(4015, 4, 19, '115', 1, 1, 'AVAILABLE', 48, 64, 18, 15, NOW(), NOW()),
(4016, 4, 19, '116', 1, 1, 'AVAILABLE', 68, 64, 18, 15, NOW(), NOW()),

-- LANTAI 2 - Superior Room lanjutan (12 kamar)
(4017, 4, 19, '201', 2, 1, 'AVAILABLE', 8, 10, 18, 15, NOW(), NOW()),
(4018, 4, 19, '202', 2, 1, 'AVAILABLE', 28, 10, 18, 15, NOW(), NOW()),
(4019, 4, 19, '203', 2, 1, 'AVAILABLE', 48, 10, 18, 15, NOW(), NOW()),
(4020, 4, 19, '204', 2, 1, 'AVAILABLE', 68, 10, 18, 15, NOW(), NOW()),
(4021, 4, 19, '205', 2, 1, 'AVAILABLE', 8, 28, 18, 15, NOW(), NOW()),
(4022, 4, 19, '206', 2, 1, 'AVAILABLE', 28, 28, 18, 15, NOW(), NOW()),
(4023, 4, 19, '207', 2, 1, 'AVAILABLE', 48, 28, 18, 15, NOW(), NOW()),
(4024, 4, 19, '208', 2, 1, 'AVAILABLE', 68, 28, 18, 15, NOW(), NOW()),
(4025, 4, 19, '209', 2, 1, 'AVAILABLE', 8, 46, 18, 15, NOW(), NOW()),
(4026, 4, 19, '210', 2, 1, 'AVAILABLE', 28, 46, 18, 15, NOW(), NOW()),
(4027, 4, 19, '211', 2, 1, 'AVAILABLE', 48, 46, 18, 15, NOW(), NOW()),
(4028, 4, 19, '212', 2, 1, 'AVAILABLE', 68, 46, 18, 15, NOW(), NOW()),

-- LANTAI 2 - Executive Room (22 kamar)
(4029, 4, 20, '213', 2, 1, 'AVAILABLE', 8, 64, 18, 16, NOW(), NOW()),
(4030, 4, 20, '214', 2, 1, 'AVAILABLE', 28, 64, 18, 16, NOW(), NOW()),
(4031, 4, 20, '215', 2, 1, 'AVAILABLE', 48, 64, 18, 16, NOW(), NOW()),
(4032, 4, 20, '216', 2, 1, 'AVAILABLE', 68, 64, 18, 16, NOW(), NOW()),
(4033, 4, 20, '217', 2, 1, 'AVAILABLE', 8, 83, 18, 16, NOW(), NOW()),
(4034, 4, 20, '218', 2, 1, 'AVAILABLE', 28, 83, 18, 16, NOW(), NOW()),
(4035, 4, 20, '219', 2, 1, 'AVAILABLE', 48, 83, 18, 16, NOW(), NOW()),
(4036, 4, 20, '220', 2, 1, 'AVAILABLE', 68, 83, 18, 16, NOW(), NOW()),
(4037, 4, 20, '221', 2, 1, 'AVAILABLE', 8, 102, 18, 16, NOW(), NOW()),
(4038, 4, 20, '222', 2, 1, 'AVAILABLE', 28, 102, 18, 16, NOW(), NOW()),
(4039, 4, 20, '223', 2, 1, 'AVAILABLE', 48, 102, 18, 16, NOW(), NOW()),
(4040, 4, 20, '224', 2, 1, 'AVAILABLE', 68, 102, 18, 16, NOW(), NOW()),
(4041, 4, 20, '225', 2, 1, 'AVAILABLE', 8, 121, 18, 16, NOW(), NOW()),
(4042, 4, 20, '226', 2, 1, 'AVAILABLE', 28, 121, 18, 16, NOW(), NOW()),
(4043, 4, 20, '227', 2, 1, 'AVAILABLE', 48, 121, 18, 16, NOW(), NOW()),
(4044, 4, 20, '228', 2, 1, 'AVAILABLE', 68, 121, 18, 16, NOW(), NOW()),
(4045, 4, 20, '229', 2, 1, 'AVAILABLE', 8, 140, 18, 16, NOW(), NOW()),
(4046, 4, 20, '230', 2, 1, 'AVAILABLE', 28, 140, 18, 16, NOW(), NOW()),
(4047, 4, 20, '231', 2, 1, 'AVAILABLE', 48, 140, 18, 16, NOW(), NOW()),
(4048, 4, 20, '232', 2, 1, 'AVAILABLE', 68, 140, 18, 16, NOW(), NOW()),
(4049, 4, 20, '233', 2, 1, 'AVAILABLE', 18, 159, 18, 16, NOW(), NOW()),
(4050, 4, 20, '234', 2, 1, 'AVAILABLE', 58, 159, 18, 16, NOW(), NOW()),

-- Pullman Suite (10 kamar)
(4051, 4, 21, '235', 2, 1, 'AVAILABLE', 8, 178, 22, 18, NOW(), NOW()),
(4052, 4, 21, '236', 2, 1, 'AVAILABLE', 32, 178, 22, 18, NOW(), NOW()),
(4053, 4, 21, '237', 2, 1, 'AVAILABLE', 56, 178, 22, 18, NOW(), NOW()),
(4054, 4, 21, '238', 2, 1, 'AVAILABLE', 8, 199, 22, 18, NOW(), NOW()),
(4055, 4, 21, '239', 2, 1, 'AVAILABLE', 32, 199, 22, 18, NOW(), NOW()),
(4056, 4, 21, '240', 2, 1, 'AVAILABLE', 56, 199, 22, 18, NOW(), NOW()),
(4057, 4, 21, '241', 2, 1, 'AVAILABLE', 8, 220, 22, 18, NOW(), NOW()),
(4058, 4, 21, '242', 2, 1, 'AVAILABLE', 32, 220, 22, 18, NOW(), NOW()),
(4059, 4, 21, '243', 2, 1, 'AVAILABLE', 56, 220, 22, 18, NOW(), NOW()),
(4060, 4, 21, '244', 2, 1, 'AVAILABLE', 32, 241, 22, 18, NOW(), NOW()),

-- Meeting Room Dahlia (3 rooms)
(4061, 4, 22, 'M-Dahlia-A', 2, 1, 'AVAILABLE', 10, 262, 30, 26, NOW(), NOW()),
(4062, 4, 22, 'M-Dahlia-B', 2, 1, 'AVAILABLE', 44, 262, 30, 26, NOW(), NOW()),
(4063, 4, 22, 'M-Dahlia-C', 2, 1, 'AVAILABLE', 27, 291, 30, 26, NOW(), NOW()),

-- Meeting Room Teratai (2 rooms) 
(4064, 4, 23, 'M-Teratai-A', 2, 1, 'AVAILABLE', 12, 320, 38, 30, NOW(), NOW()),
(4065, 4, 23, 'M-Teratai-B', 2, 1, 'AVAILABLE', 54, 320, 38, 30, NOW(), NOW()),

-- Pullman Ballroom (1 room)
(4066, 4, 24, 'M-Pullman-Ballroom', 2, 1, 'AVAILABLE', 10, 353, 80, 65, NOW(), NOW());
-- Trans Luxury Hotel (Hotel 5) - 3 lantai, layout 4 kolom
INSERT INTO `hotel_rooms` (`id`, `hotel_id`, `room_type_id`, `room_number`, `floor`, `is_blockchain_enabled`, `status`, `layout_x`, `layout_y`, `layout_width`, `layout_height`, `created_at`, `updated_at`) VALUES
-- LANTAI 1 - Luxury Twin (10 kamar)
(5001, 5, 25, '101', 1, 1, 'AVAILABLE', 8, 10, 18, 15, NOW(), NOW()),
(5002, 5, 25, '102', 1, 1, 'AVAILABLE', 28, 10, 18, 15, NOW(), NOW()),
(5003, 5, 25, '103', 1, 1, 'AVAILABLE', 48, 10, 18, 15, NOW(), NOW()),
(5004, 5, 25, '104', 1, 1, 'AVAILABLE', 68, 10, 18, 15, NOW(), NOW()),
(5005, 5, 25, '105', 1, 1, 'AVAILABLE', 8, 28, 18, 15, NOW(), NOW()),
(5006, 5, 25, '106', 1, 1, 'AVAILABLE', 28, 28, 18, 15, NOW(), NOW()),
(5007, 5, 25, '107', 1, 1, 'AVAILABLE', 48, 28, 18, 15, NOW(), NOW()),
(5008, 5, 25, '108', 1, 1, 'AVAILABLE', 68, 28, 18, 15, NOW(), NOW()),
(5009, 5, 25, '109', 1, 1, 'AVAILABLE', 18, 46, 18, 15, NOW(), NOW()),
(5010, 5, 25, '110', 1, 1, 'AVAILABLE', 58, 46, 18, 15, NOW(), NOW()),

-- LANTAI 2 - Luxury Twin lanjutan (12 kamar)
(5011, 5, 25, '201', 2, 1, 'AVAILABLE', 8, 10, 18, 15, NOW(), NOW()),
(5012, 5, 25, '202', 2, 1, 'AVAILABLE', 28, 10, 18, 15, NOW(), NOW()),
(5013, 5, 25, '203', 2, 1, 'AVAILABLE', 48, 10, 18, 15, NOW(), NOW()),
(5014, 5, 25, '204', 2, 1, 'AVAILABLE', 68, 10, 18, 15, NOW(), NOW()),
(5015, 5, 25, '205', 2, 1, 'AVAILABLE', 8, 28, 18, 15, NOW(), NOW()),
(5016, 5, 25, '206', 2, 1, 'AVAILABLE', 28, 28, 18, 15, NOW(), NOW()),
(5017, 5, 25, '207', 2, 1, 'AVAILABLE', 48, 28, 18, 15, NOW(), NOW()),
(5018, 5, 25, '208', 2, 1, 'AVAILABLE', 68, 28, 18, 15, NOW(), NOW()),
(5019, 5, 25, '209', 2, 1, 'AVAILABLE', 8, 46, 18, 15, NOW(), NOW()),
(5020, 5, 25, '210', 2, 1, 'AVAILABLE', 28, 46, 18, 15, NOW(), NOW()),
(5021, 5, 25, '211', 2, 1, 'AVAILABLE', 48, 46, 18, 15, NOW(), NOW()),
(5022, 5, 25, '212', 2, 1, 'AVAILABLE', 68, 46, 18, 15, NOW(), NOW()),

-- LANTAI 2 - Executive Suite (18 kamar)
(5023, 5, 26, '213', 2, 1, 'AVAILABLE', 8, 64, 18, 16, NOW(), NOW()),
(5024, 5, 26, '214', 2, 1, 'AVAILABLE', 28, 64, 18, 16, NOW(), NOW()),
(5025, 5, 26, '215', 2, 1, 'AVAILABLE', 48, 64, 18, 16, NOW(), NOW()),
(5026, 5, 26, '216', 2, 1, 'AVAILABLE', 68, 64, 18, 16, NOW(), NOW()),
(5027, 5, 26, '217', 2, 1, 'AVAILABLE', 8, 83, 18, 16, NOW(), NOW()),
(5028, 5, 26, '218', 2, 1, 'AVAILABLE', 28, 83, 18, 16, NOW(), NOW()),
(5029, 5, 26, '219', 2, 1, 'AVAILABLE', 48, 83, 18, 16, NOW(), NOW()),
(5030, 5, 26, '220', 2, 1, 'AVAILABLE', 68, 83, 18, 16, NOW(), NOW()),
(5031, 5, 26, '221', 2, 1, 'AVAILABLE', 8, 102, 18, 16, NOW(), NOW()),
(5032, 5, 26, '222', 2, 1, 'AVAILABLE', 28, 102, 18, 16, NOW(), NOW()),
(5033, 5, 26, '223', 2, 1, 'AVAILABLE', 48, 102, 18, 16, NOW(), NOW()),
(5034, 5, 26, '224', 2, 1, 'AVAILABLE', 68, 102, 18, 16, NOW(), NOW()),
(5035, 5, 26, '225', 2, 1, 'AVAILABLE', 8, 121, 18, 16, NOW(), NOW()),
(5036, 5, 26, '226', 2, 1, 'AVAILABLE', 28, 121, 18, 16, NOW(), NOW()),
(5037, 5, 26, '227', 2, 1, 'AVAILABLE', 48, 121, 18, 16, NOW(), NOW()),
(5038, 5, 26, '228', 2, 1, 'AVAILABLE', 68, 121, 18, 16, NOW(), NOW()),
(5039, 5, 26, '229', 2, 1, 'AVAILABLE', 18, 140, 18, 16, NOW(), NOW()),
(5040, 5, 26, '230', 2, 1, 'AVAILABLE', 58, 140, 18, 16, NOW(), NOW()),

-- LANTAI 3 - Presidential Suite (8 kamar)
(5041, 5, 27, '301', 3, 1, 'AVAILABLE', 8, 10, 22, 18, NOW(), NOW()),
(5042, 5, 27, '302', 3, 1, 'AVAILABLE', 32, 10, 22, 18, NOW(), NOW()),
(5043, 5, 27, '303', 3, 1, 'AVAILABLE', 56, 10, 22, 18, NOW(), NOW()),
(5044, 5, 27, '304', 3, 1, 'AVAILABLE', 8, 31, 22, 18, NOW(), NOW()),
(5045, 5, 27, '305', 3, 1, 'AVAILABLE', 32, 31, 22, 18, NOW(), NOW()),
(5046, 5, 27, '306', 3, 1, 'AVAILABLE', 56, 31, 22, 18, NOW(), NOW()),
(5047, 5, 27, '307', 3, 1, 'AVAILABLE', 20, 52, 22, 18, NOW(), NOW()),
(5048, 5, 27, '308', 3, 1, 'AVAILABLE', 44, 52, 22, 18, NOW(), NOW()),

-- Meeting Room Anggrek (3 rooms)
(5049, 5, 28, 'M-Anggrek-A', 3, 1, 'AVAILABLE', 10, 73, 28, 24, NOW(), NOW()),
(5050, 5, 28, 'M-Anggrek-B', 3, 1, 'AVAILABLE', 42, 73, 28, 24, NOW(), NOW()),
(5051, 5, 28, 'M-Anggrek-C', 3, 1, 'AVAILABLE', 26, 100, 28, 24, NOW(), NOW()),

-- Meeting Room Kenanga (1 room)
(5052, 5, 29, 'M-Kenanga', 3, 1, 'AVAILABLE', 12, 127, 36, 28, NOW(), NOW()),

-- Trans Grand Ballroom (1 room)
(5053, 5, 30, 'M-Trans-Ballroom', 3, 1, 'AVAILABLE', 10, 158, 78, 60, NOW(), NOW());

-- Password (semua): Abcd1234@@
-- =============================================
