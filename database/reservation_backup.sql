-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 10, 2026 at 07:36 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `reservation`
--

-- --------------------------------------------------------

--
-- Table structure for table `hotels`
--

CREATE TABLE `hotels` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `address` text NOT NULL,
  `description` text DEFAULT NULL,
  `rating` decimal(3,2) DEFAULT 4.50,
  `image_url` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotels`
--

INSERT INTO `hotels` (`id`, `name`, `city`, `address`, `description`, `rating`, `image_url`, `created_at`, `updated_at`) VALUES
(1, 'L\'Eminence Golf & Convention Hotel Lembang', 'Bandung', 'Jl. Malabar Dago Giri No.88, Pagerwangi, Lembang, Bandung', 'Hotel mewah dengan fasilitas convention lengkap, cocok untuk acara meeting besar dan gathering perusahaan', 4.80, 'https://images.unsplash.com/photo-1566073771259-6a8506099945', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(2, 'Padma Hotel Bandung', 'Bandung', 'Jl. Rancabentang No.56-58, Ciumbuleuit, Bandung', 'Hotel bintang 5 dengan view gunung, ideal untuk residential meeting dan team building', 4.70, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(3, 'Grand Sunshine Resort & Convention Bandung', 'Bandung', 'Jl. Tangkuban Perahu KM. 7, Jayagiri, Lembang', 'Resort dengan convention hall besar, cocok untuk seminar nasional dan international meeting', 4.60, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(4, 'Grand Panorama Hotel Bandung', 'Bandung', 'Jl. Ir. H. Djuanda No.381, Dago, Bandung', 'Hotel strategis di Dago dengan meeting rooms modern', 4.50, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(5, 'Pullman Bandung Grand Central', 'Bandung', 'Jl. Diponegoro No.27, Citarum, Bandung', 'Hotel internasional dengan fasilitas MICE terlengkap di Bandung', 4.90, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(6, 'Trans Luxury Hotel Bandung', 'Bandung', 'Jl. Gatot Subroto No.289, Cibangkong, Bandung', 'Hotel mewah dengan ballroom megah untuk event besar', 4.80, 'https://images.unsplash.com/photo-1568084680786-a84f91d1153c', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(7, 'The Jayakarta Suites Bandung', 'Bandung', 'Jl. Ir. H. Djuanda No.381A, Dago Atas, Bandung', 'Suite hotel dengan private meeting rooms untuk exclusive meeting', 4.60, 'https://images.unsplash.com/photo-1571896349842-33c89424de2d', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(8, 'Mason Pine Hotel Bandung', 'Bandung', 'Jl. Soekarno Hatta No.689, Bandung', 'Modern hotel dengan meeting facilities lengkap dan affordable', 4.40, 'https://images.unsplash.com/photo-1445019980597-93fa8acb246c', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(9, 'R Hotel Rancamaya', 'Bogor', 'Jl. Raya Golf Rancamaya, Bojong, Cipaku, Bogor', 'Resort eksklusif dengan golf course, ideal untuk corporate retreat dan executive meeting', 4.70, 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(10, 'Royal Tulip Gunung Geulis', 'Bogor', 'Jl. Pasir Angin No.1, Gadog, Megamendung, Bogor', 'Hotel resort dengan view gunung, perfect untuk outing dan team building', 4.60, 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(11, 'Novotel Bogor Golf Resort', 'Bogor', 'Jl. Padurenan, Gunung Putri, Bogor', 'International hotel dengan golf resort untuk professional meeting', 4.70, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(12, 'Pesona Alam Resort & Spa', 'Bogor', 'Jl. Raya Puncak KM. 77, Cipayung, Bogor', 'Nature resort dengan meeting facilities outdoor untuk creative meeting', 4.50, 'https://images.unsplash.com/photo-1582719508461-905c673771fd', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(13, 'Aston Bogor Hotel & Resort', 'Bogor', 'Jl. Malabar No.61, Bogor Tengah, Bogor', 'City hotel dengan convention center untuk business conference', 4.60, 'https://images.unsplash.com/photo-1584132967334-10e028bd69f7', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(14, 'Renaissance Bali Nusa Dua Resort', 'Bali', 'Jl. Nusa Dua, Benoa, Nusa Dua, Bali', 'Luxury resort dengan ballroom megah untuk MICE dan incentive trip', 4.80, 'https://images.unsplash.com/photo-1540541338287-41700207dee6', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(15, 'Holiday Inn Resort Bali Benoa', 'Bali', 'Jl. Pratama No.88, Tanjung Benoa, Bali', 'Beach resort dengan convention facilities untuk bleisure meeting', 4.70, 'https://images.unsplash.com/photo-1584132967334-10e028bd69f7', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(16, 'Kuta Beach Heritage Hotel', 'Bali', 'Jl. Pantai Kuta, Kuta, Bali', 'Beach hotel strategis dengan meeting rooms view sunset', 4.50, 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(17, 'Grand Mirage Resort Bali', 'Bali', 'Jl. Pratama No.74, Tanjung Benoa, Bali', 'All-inclusive resort dengan team building facilities', 4.60, 'https://images.unsplash.com/photo-1571896349842-33c89424de2d', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(18, 'Hotel Mulia Senayan Jakarta', 'Jakarta', 'Jl. Asia Afrika Senayan, Jakarta Pusat', 'Luxury hotel bintang 5 dengan convention hall internasional', 4.90, 'https://images.unsplash.com/photo-1566073771259-6a8506099945', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(19, 'Hotel Borobudur Jakarta', 'Jakarta', 'Jl. Lapangan Banteng Selatan, Jakarta Pusat', 'Heritage hotel dengan ballroom klasik untuk gala dinner dan seminar', 4.70, 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(20, 'Jambuluwuk Malioboro Hotel Yogyakarta', 'Yogyakarta', 'Jl. Gajah Mada No.67, Yogyakarta', 'Boutique hotel di pusat kota dengan meeting rooms modern', 4.60, 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(21, 'Green Peak Hotel Puncak', 'Puncak', 'Jl. Raya Puncak KM. 90, Cipanas, Puncak', 'Mountain resort dengan fresh air untuk brainstorming session', 4.50, 'https://images.unsplash.com/photo-1564501049412-61c2a3083791', '2025-11-13 04:04:40', '2025-11-13 04:04:40');

-- --------------------------------------------------------

--
-- Table structure for table `hotel_rooms`
--

CREATE TABLE `hotel_rooms` (
  `id` int(11) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `room_type_id` int(11) NOT NULL,
  `room_number` varchar(20) NOT NULL COMMENT 'Nomor kamar: 101, 102, 201, etc',
  `floor` int(11) DEFAULT 1 COMMENT 'Lantai berapa',
  `is_blockchain_enabled` tinyint(1) DEFAULT 1 COMMENT '1=bisa booking blockchain, 0=hanya walk-in',
  `status` varchar(20) DEFAULT 'AVAILABLE' COMMENT 'AVAILABLE, MAINTENANCE, BLOCKED',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotel_rooms`
--

INSERT INTO `hotel_rooms` (`id`, `hotel_id`, `room_type_id`, `room_number`, `floor`, `is_blockchain_enabled`, `status`, `created_at`, `updated_at`) VALUES
(0, 1, 1, '101', 1, 0, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 1, '102', 1, 0, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 1, '103', 1, 0, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 1, '104', 1, 0, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 1, '105', 1, 0, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 2, '201', 2, 0, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 2, '202', 2, 0, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 2, '203', 2, 0, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 2, '204', 2, 0, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 2, '205', 2, 0, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 2, '206', 2, 1, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 2, '207', 2, 1, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 2, '208', 2, 1, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 2, '209', 2, 1, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51'),
(0, 1, 2, '210', 2, 1, 'AVAILABLE', '2026-01-10 06:35:51', '2026-01-10 06:35:51');

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `id` int(11) NOT NULL,
  `reservation_id` varchar(100) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `room_type_id` int(11) NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `guest_count` int(11) NOT NULL COMMENT 'Jumlah peserta meeting/event',
  `total_rooms_needed` int(11) NOT NULL DEFAULT 1 COMMENT 'Jumlah kamar yang dibutuhkan',
  `event_type` varchar(50) DEFAULT 'Meeting' COMMENT 'Meeting, Seminar, Birthday, Wedding, dll',
  `event_description` text DEFAULT NULL COMMENT 'Detail acara: ultah, meeting, dll',
  `customer_name` varchar(100) NOT NULL,
  `customer_phone` varchar(20) NOT NULL,
  `customer_email` varchar(100) DEFAULT NULL,
  `customer_ref` varchar(100) DEFAULT NULL,
  `price_per_person` decimal(12,2) NOT NULL COMMENT 'Harga per orang',
  `total_price` decimal(12,2) NOT NULL COMMENT 'Total = price_per_person * guest_count',
  `currency` varchar(10) DEFAULT 'IDR',
  `status` varchar(50) DEFAULT 'PENDING',
  `created_by_org` varchar(100) DEFAULT 'OTAOrgMSP',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservation_history`
--

CREATE TABLE `reservation_history` (
  `id` int(11) NOT NULL,
  `reservation_id` varchar(100) NOT NULL,
  `action` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL,
  `note` text DEFAULT NULL,
  `performed_by` varchar(100) DEFAULT NULL,
  `performed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_reservations`
--

CREATE TABLE `room_reservations` (
  `id` int(11) NOT NULL,
  `reservation_id` varchar(100) NOT NULL,
  `hotel_room_id` int(11) NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `guest_names` text DEFAULT NULL COMMENT 'Nama tamu yang menempati kamar ini (JSON array)',
  `status` varchar(20) DEFAULT 'BOOKED' COMMENT 'BOOKED, CHECKED_IN, CHECKED_OUT, CANCELLED',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `room_types`
--

CREATE TABLE `room_types` (
  `id` int(11) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `type_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `price_per_person` decimal(12,2) NOT NULL COMMENT 'Harga per orang untuk meeting package',
  `min_capacity` int(11) NOT NULL DEFAULT 10 COMMENT 'Minimum peserta',
  `max_capacity` int(11) NOT NULL DEFAULT 100 COMMENT 'Maximum peserta',
  `total_rooms` int(11) DEFAULT 10 COMMENT 'Total kamar yang tersedia di hotel',
  `blockchain_reserved_rooms` int(11) DEFAULT 5 COMMENT 'Jumlah kamar yang TIDAK bisa di-booking blockchain (untuk walk-in)',
  `available_rooms` int(11) DEFAULT 10 COMMENT 'Legacy field - akan dihitung dari hotel_rooms',
  `amenities` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room_types`
--

INSERT INTO `room_types` (`id`, `hotel_id`, `type_name`, `description`, `price_per_person`, `min_capacity`, `max_capacity`, `total_rooms`, `blockchain_reserved_rooms`, `available_rooms`, `amenities`, `created_at`, `updated_at`) VALUES
(1, 1, 'Residential Meeting Single', 'Full board package with single bed room, meeting room, meals, coffee breaks', 3100000.00, 20, 100, 10, 5, 5, 'AC, LCD Projector, Sound System, WiFi, Meals 3x, Coffee Break 2x', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(2, 1, 'Residential Meeting Twin Share', 'Full board package with twin share room, meeting room, meals, coffee breaks', 2500000.00, 20, 100, 10, 5, 10, 'AC, LCD Projector, Sound System, WiFi, Meals 3x, Coffee Break 2x', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(3, 2, 'Residential Meeting Single', 'Premium meeting package with luxury accommodation', 2000000.00, 15, 80, 10, 5, 5, 'AC, LED Screen, Audio System, High-Speed WiFi, Meals, Snacks', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(4, 2, 'Residential Meeting Twin Share', 'Premium meeting package with shared accommodation', 1600000.00, 15, 80, 10, 5, 10, 'AC, LED Screen, Audio System, High-Speed WiFi, Meals, Snacks', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(5, 3, 'Residential Meeting Single', 'Convention package with mountain view', 1200000.00, 30, 150, 10, 5, 8, 'AC, Projector, Microphone, WiFi, Full Board Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(6, 3, 'Residential Meeting Twin Share', 'Convention package with shared room', 950000.00, 30, 150, 10, 5, 15, 'AC, Projector, Microphone, WiFi, Full Board Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(7, 4, 'Residential Meeting Single', 'Standard meeting package with city view', 800000.00, 10, 50, 10, 5, 5, 'AC, Projector, WiFi, Meals 3x', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(8, 4, 'Residential Meeting Twin Share', 'Standard meeting package twin room', 650000.00, 10, 50, 10, 5, 10, 'AC, Projector, WiFi, Meals 3x', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(9, 5, 'Residential Meeting Single', 'International MICE package premium', 2500000.00, 20, 200, 10, 5, 10, 'Smart Board, Video Conference, Premium Meals, Executive Lounge', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(10, 5, 'Residential Meeting Twin Share', 'International MICE package standard', 2000000.00, 20, 200, 10, 5, 15, 'Smart Board, Video Conference, Premium Meals, Executive Lounge', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(11, 6, 'Residential Meeting Single', 'Luxury ballroom meeting package', 2200000.00, 25, 150, 10, 5, 8, 'LED Wall, Professional Sound, Gourmet Meals, Spa Access', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(12, 6, 'Residential Meeting Twin Share', 'Luxury meeting package shared', 1800000.00, 25, 150, 10, 5, 12, 'LED Wall, Professional Sound, Gourmet Meals, Spa Access', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(13, 7, 'Residential Meeting Single', 'Executive suite meeting package', 1800000.00, 10, 40, 10, 5, 4, 'Private Meeting Room, Butler Service, Premium Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(14, 7, 'Residential Meeting Twin Share', 'Executive meeting package shared', 1400000.00, 10, 40, 10, 5, 8, 'Private Meeting Room, Butler Service, Premium Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(15, 8, 'Residential Meeting Single', 'Modern meeting package affordable', 900000.00, 15, 60, 10, 5, 6, 'Smart TV, WiFi, Standard Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(16, 8, 'Residential Meeting Twin Share', 'Modern meeting package budget', 700000.00, 15, 60, 10, 5, 12, 'Smart TV, WiFi, Standard Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(17, 9, 'Residential Meeting Single', 'Golf resort meeting package premium', 1900000.00, 20, 80, 10, 5, 5, 'Golf Access, Meeting Room, Spa, Full Board', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(18, 9, 'Residential Meeting Twin Share', 'Golf resort meeting package standard', 1500000.00, 20, 80, 10, 5, 10, 'Golf Access, Meeting Room, Spa, Full Board', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(19, 10, 'Residential Meeting Single', 'Mountain view meeting package', 1700000.00, 15, 70, 10, 5, 5, 'Outdoor Activities, Meeting Hall, Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(20, 10, 'Residential Meeting Twin Share', 'Mountain view shared package', 1350000.00, 15, 70, 10, 5, 10, 'Outdoor Activities, Meeting Hall, Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(21, 11, 'Residential Meeting Single', 'International golf meeting package', 1650000.00, 20, 90, 10, 5, 6, 'Golf Course, Convention Hall, International Cuisine', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(22, 11, 'Residential Meeting Twin Share', 'International meeting shared', 1300000.00, 20, 90, 10, 5, 12, 'Golf Course, Convention Hall, International Cuisine', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(23, 12, 'Residential Meeting Single', 'Nature retreat meeting package', 1500000.00, 15, 60, 10, 5, 4, 'Nature Activities, Spa, Organic Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(24, 12, 'Residential Meeting Twin Share', 'Nature retreat shared package', 1200000.00, 15, 60, 10, 5, 8, 'Nature Activities, Spa, Organic Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(25, 13, 'Residential Meeting Single', 'City convention meeting package', 1400000.00, 20, 100, 10, 5, 7, 'Convention Center, City Access, Business Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(26, 13, 'Residential Meeting Twin Share', 'City convention shared', 1100000.00, 20, 100, 10, 5, 14, 'Convention Center, City Access, Business Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(27, 14, 'Residential Meeting Single', 'Luxury Bali MICE package', 2000000.00, 25, 120, 10, 5, 8, 'Beach Access, Ballroom, Water Sports, Gala Dinner', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(28, 14, 'Residential Meeting Twin Share', 'Luxury Bali meeting shared', 1600000.00, 25, 120, 10, 5, 15, 'Beach Access, Ballroom, Water Sports, Gala Dinner', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(29, 15, 'Residential Meeting Single', 'Beach resort meeting package', 1900000.00, 20, 100, 10, 5, 6, 'Beach Activities, Meeting Rooms, Sunset Dinner', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(30, 15, 'Residential Meeting Twin Share', 'Beach resort shared package', 1500000.00, 20, 100, 10, 5, 12, 'Beach Activities, Meeting Rooms, Sunset Dinner', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(31, 16, 'Residential Meeting Single', 'Beachfront meeting package', 1300000.00, 15, 70, 10, 5, 5, 'Ocean View, Meeting Space, Balinese Cuisine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(32, 16, 'Residential Meeting Twin Share', 'Beachfront shared package', 1000000.00, 15, 70, 10, 5, 10, 'Ocean View, Meeting Space, Balinese Cuisine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(33, 17, 'Residential Meeting Single', 'All-inclusive meeting package', 1600000.00, 20, 90, 10, 5, 6, 'All Meals, Activities, Team Building, Meeting Hall', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(34, 17, 'Residential Meeting Twin Share', 'All-inclusive shared package', 1250000.00, 20, 90, 10, 5, 12, 'All Meals, Activities, Team Building, Meeting Hall', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(35, 18, 'Residential Meeting Single', 'Presidential meeting package', 2100000.00, 30, 200, 10, 5, 10, 'Grand Ballroom, VIP Service, Fine Dining, Limousine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(36, 18, 'Residential Meeting Twin Share', 'Presidential shared package', 1700000.00, 30, 200, 10, 5, 20, 'Grand Ballroom, VIP Service, Fine Dining, Limousine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(37, 19, 'Residential Meeting Single', 'Heritage meeting package', 1900000.00, 25, 150, 10, 5, 8, 'Classic Ballroom, Cultural Experience, Premium Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(38, 19, 'Residential Meeting Twin Share', 'Heritage shared package', 1500000.00, 25, 150, 10, 5, 15, 'Classic Ballroom, Cultural Experience, Premium Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(39, 20, 'Residential Meeting Single', 'Cultural meeting package', 1200000.00, 15, 60, 10, 5, 5, 'Batik Workshop, Meeting Room, Local Cuisine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(40, 20, 'Residential Meeting Twin Share', 'Cultural shared package', 950000.00, 15, 60, 10, 5, 10, 'Batik Workshop, Meeting Room, Local Cuisine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(41, 21, 'Residential Meeting Single', 'Mountain retreat meeting package', 1100000.00, 10, 50, 10, 5, 4, 'Fresh Air, Nature Walk, Outdoor Meeting', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(42, 21, 'Residential Meeting Twin Share', 'Mountain retreat shared', 850000.00, 10, 50, 10, 5, 8, 'Fresh Air, Nature Walk, Outdoor Meeting', '2025-11-13 04:04:41', '2025-11-13 04:04:41');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `hotels`
--
ALTER TABLE `hotels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_city` (`city`),
  ADD KEY `idx_name` (`name`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
