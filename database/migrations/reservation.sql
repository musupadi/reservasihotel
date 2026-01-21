-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 16, 2026 at 05:07 PM
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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotels`
--

INSERT INTO `hotels` (`id`, `name`, `city`, `country`, `address`, `description`, `owner_id`, `owner_name`, `owner_phone`, `owner_email`, `rating`, `status`, `image_url`, `created_at`, `updated_at`) VALUES
(1, 'L\'Eminence Golf & Convention Hotel Lembang', 'Bandung', 'Indonesia', 'Jl. Malabar Dago Giri No.88, Pagerwangi, Lembang, Bandung', 'Hotel mewah dengan fasilitas convention lengkap, cocok untuk acara meeting besar dan gathering perusahaan', NULL, NULL, NULL, NULL, 4.80, 'active', 'https://images.unsplash.com/photo-1566073771259-6a8506099945', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(2, 'Padma Hotel Bandung', 'Bandung', 'Indonesia', 'Jl. Rancabentang No.56-58, Ciumbuleuit, Bandung', 'Hotel bintang 5 dengan view gunung, ideal untuk residential meeting dan team building', NULL, NULL, NULL, NULL, 4.70, 'active', 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(3, 'Grand Sunshine Resort & Convention Bandung', 'Bandung', 'Indonesia', 'Jl. Tangkuban Perahu KM. 7, Jayagiri, Lembang', 'Resort dengan convention hall besar, cocok untuk seminar nasional dan international meeting', NULL, NULL, NULL, NULL, 4.60, 'active', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(4, 'Grand Panorama Hotel Bandung', 'Bandung', 'Indonesia', 'Jl. Ir. H. Djuanda No.381, Dago, Bandung', 'Hotel strategis di Dago dengan meeting rooms modern', NULL, NULL, NULL, NULL, 4.50, 'active', 'https://images.unsplash.com/photo-1564501049412-61c2a3083791', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(5, 'Pullman Bandung Grand Central', 'Bandung', 'Indonesia', 'Jl. Diponegoro No.27, Citarum, Bandung', 'Hotel internasional dengan fasilitas MICE terlengkap di Bandung', NULL, NULL, NULL, NULL, 4.90, 'active', 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(6, 'Trans Luxury Hotel Bandung', 'Bandung', 'Indonesia', 'Jl. Gatot Subroto No.289, Cibangkong, Bandung', 'Hotel mewah dengan ballroom megah untuk event besar', NULL, NULL, NULL, NULL, 4.80, 'active', 'https://images.unsplash.com/photo-1568084680786-a84f91d1153c', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(7, 'The Jayakarta Suites Bandung', 'Bandung', 'Indonesia', 'Jl. Ir. H. Djuanda No.381A, Dago Atas, Bandung', 'Suite hotel dengan private meeting rooms untuk exclusive meeting', NULL, NULL, NULL, NULL, 4.60, 'active', 'https://images.unsplash.com/photo-1571896349842-33c89424de2d', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(8, 'Mason Pine Hotel Bandung', 'Bandung', 'Indonesia', 'Jl. Soekarno Hatta No.689, Bandung', 'Modern hotel dengan meeting facilities lengkap dan affordable', NULL, NULL, NULL, NULL, 4.40, 'active', 'https://images.unsplash.com/photo-1445019980597-93fa8acb246c', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(9, 'R Hotel Rancamaya', 'Bogor', 'Indonesia', 'Jl. Raya Golf Rancamaya, Bojong, Cipaku, Bogor', 'Resort eksklusif dengan golf course, ideal untuk corporate retreat dan executive meeting', NULL, NULL, NULL, NULL, 4.70, 'active', 'https://images.unsplash.com/photo-1571003123894-1f0594d2b5d9', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(10, 'Royal Tulip Gunung Geulis', 'Bogor', 'Indonesia', 'Jl. Pasir Angin No.1, Gadog, Megamendung, Bogor', 'Hotel resort dengan view gunung, perfect untuk outing dan team building', NULL, NULL, NULL, NULL, 4.60, 'active', 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(11, 'Novotel Bogor Golf Resort', 'Bogor', 'Indonesia', 'Jl. Padurenan, Gunung Putri, Bogor', 'International hotel dengan golf resort untuk professional meeting', NULL, NULL, NULL, NULL, 4.70, 'active', 'https://images.unsplash.com/photo-1566665797739-1674de7a421a', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(12, 'Pesona Alam Resort & Spa', 'Bogor', 'Indonesia', 'Jl. Raya Puncak KM. 77, Cipayung, Bogor', 'Nature resort dengan meeting facilities outdoor untuk creative meeting', NULL, NULL, NULL, NULL, 4.50, 'active', 'https://images.unsplash.com/photo-1582719508461-905c673771fd', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(13, 'Aston Bogor Hotel & Resort', 'Bogor', 'Indonesia', 'Jl. Malabar No.61, Bogor Tengah, Bogor', 'City hotel dengan convention center untuk business conference', NULL, NULL, NULL, NULL, 4.60, 'active', 'https://images.unsplash.com/photo-1584132967334-10e028bd69f7', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(14, 'Renaissance Bali Nusa Dua Resort', 'Bali', 'Indonesia', 'Jl. Nusa Dua, Benoa, Nusa Dua, Bali', 'Luxury resort dengan ballroom megah untuk MICE dan incentive trip', NULL, NULL, NULL, NULL, 4.80, 'active', 'https://images.unsplash.com/photo-1540541338287-41700207dee6', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(15, 'Holiday Inn Resort Bali Benoa', 'Bali', 'Indonesia', 'Jl. Pratama No.88, Tanjung Benoa, Bali', 'Beach resort dengan convention facilities untuk bleisure meeting', NULL, NULL, NULL, NULL, 4.70, 'active', 'https://images.unsplash.com/photo-1584132967334-10e028bd69f7', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(16, 'Kuta Beach Heritage Hotel', 'Bali', 'Indonesia', 'Jl. Pantai Kuta, Kuta, Bali', 'Beach hotel strategis dengan meeting rooms view sunset', NULL, NULL, NULL, NULL, 4.50, 'active', 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(17, 'Grand Mirage Resort Bali', 'Bali', 'Indonesia', 'Jl. Pratama No.74, Tanjung Benoa, Bali', 'All-inclusive resort dengan team building facilities', NULL, NULL, NULL, NULL, 4.60, 'active', 'https://images.unsplash.com/photo-1571896349842-33c89424de2d', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(18, 'Hotel Mulia Senayan Jakarta', 'Jakarta', 'Indonesia', 'Jl. Asia Afrika Senayan, Jakarta Pusat', 'Luxury hotel bintang 5 dengan convention hall internasional', NULL, NULL, NULL, NULL, 4.90, 'active', 'https://images.unsplash.com/photo-1566073771259-6a8506099945', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(19, 'Hotel Borobudur Jakarta', 'Jakarta', 'Indonesia', 'Jl. Lapangan Banteng Selatan, Jakarta Pusat', 'Heritage hotel dengan ballroom klasik untuk gala dinner dan seminar', NULL, NULL, NULL, NULL, 4.70, 'active', 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(20, 'Jambuluwuk Malioboro Hotel Yogyakarta', 'Yogyakarta', 'Indonesia', 'Jl. Gajah Mada No.67, Yogyakarta', 'Boutique hotel di pusat kota dengan meeting rooms modern', NULL, NULL, NULL, NULL, 4.60, 'active', 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(21, 'Green Peak Hotel Puncak', 'Puncak', 'Indonesia', 'Jl. Raya Puncak KM. 90, Cipanas, Puncak', 'Mountain resort dengan fresh air untuk brainstorming session', NULL, NULL, NULL, NULL, 4.50, 'active', 'https://images.unsplash.com/photo-1564501049412-61c2a3083791', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(32, 'Hotel Testing', '12312', 'Indonesia', '132123', '312', 1, 'Test', '123132', 'musupadi1501@gmail.com', 4.50, 'active', '', '2026-01-10 10:34:58', '2026-01-12 15:29:42'),
(33, 'Grand Hotel', 'Jakarta', 'Indonesia', 'Jln. Jakarta Raya', 'Test', 3, 'Muhammad', 'Farhan', 'farhan@gmail.com', 4.50, 'active', '', '2026-01-16 14:40:59', '2026-01-16 14:41:00');

-- --------------------------------------------------------

--
-- Table structure for table `hotel_admins`
--

CREATE TABLE `hotel_admins` (
  `id` int(11) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` enum('super_admin','admin','staff') DEFAULT 'staff',
  `permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`permissions`)),
  `assigned_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotel_admins`
--

INSERT INTO `hotel_admins` (`id`, `hotel_id`, `user_id`, `role`, `permissions`, `assigned_by`, `created_at`, `updated_at`) VALUES
(1, 32, 1, 'super_admin', '{\n			\"manage_admins\": true,\n			\"manage_rooms\": true,\n			\"manage_packages\": true,\n			\"view_bookings\": true,\n			\"manage_bookings\": true,\n			\"view_reports\": true\n		}', NULL, '2026-01-10 10:34:58', '2026-01-10 10:34:58'),
(2, 33, 3, 'super_admin', '{\n			\"manage_admins\": true,\n			\"manage_rooms\": true,\n			\"manage_packages\": true,\n			\"view_bookings\": true,\n			\"manage_bookings\": true,\n			\"view_reports\": true\n		}', NULL, '2026-01-16 14:40:59', '2026-01-16 14:40:59');

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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `layout_x` int(11) DEFAULT NULL COMMENT 'Koordinat X di denah (0-100 scale, percentage)',
  `layout_y` int(11) DEFAULT NULL COMMENT 'Koordinat Y di denah (0-100 scale, percentage)',
  `layout_width` int(11) DEFAULT 1 COMMENT 'Lebar kamar di grid (default 1 unit)',
  `layout_height` int(11) DEFAULT 1 COMMENT 'Tinggi kamar di grid (default 1 unit)',
  `layout_updated_at` timestamp NULL DEFAULT NULL COMMENT 'Last time layout was modified'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotel_rooms`
--

INSERT INTO `hotel_rooms` (`id`, `hotel_id`, `room_type_id`, `room_number`, `floor`, `is_blockchain_enabled`, `status`, `created_at`, `updated_at`, `layout_x`, `layout_y`, `layout_width`, `layout_height`, `layout_updated_at`) VALUES
(1, 1, 1, '101', 1, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(2, 1, 1, '102', 1, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(3, 1, 1, '103', 1, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(4, 1, 1, '104', 1, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(5, 1, 1, '105', 1, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(6, 1, 2, '201', 2, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(7, 1, 2, '202', 2, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(8, 1, 2, '203', 2, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(9, 1, 2, '204', 2, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(10, 1, 2, '205', 2, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(11, 1, 2, '206', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(12, 1, 2, '207', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(13, 1, 2, '208', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(14, 1, 2, '209', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(15, 1, 2, '210', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(16, 2, 3, '301', 3, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', 0, 0, 1, 1, '2026-01-16 02:59:53'),
(17, 2, 3, '302', 3, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', 20, 0, 1, 1, '2026-01-16 02:59:53'),
(18, 2, 3, '303', 3, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', 40, 0, 1, 1, '2026-01-16 02:59:53'),
(19, 2, 3, '304', 3, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', 60, 0, 1, 1, '2026-01-16 02:59:53'),
(20, 2, 3, '305', 3, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-16 02:59:53', 80, 0, 1, 1, '2026-01-16 02:59:53'),
(21, 2, 4, '401', 4, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(22, 2, 4, '402', 4, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(23, 2, 4, '403', 4, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(24, 2, 4, '404', 4, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(25, 2, 4, '405', 4, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(26, 2, 4, '406', 4, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(27, 2, 4, '407', 4, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(28, 2, 4, '408', 4, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(29, 2, 4, '409', 4, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(30, 2, 4, '410', 4, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(31, 3, 5, '101', 1, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(32, 3, 5, '102', 1, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(33, 3, 5, '103', 1, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(34, 3, 5, '104', 1, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(35, 3, 5, '105', 1, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(36, 3, 5, '106', 1, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(37, 3, 5, '107', 1, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(38, 3, 5, '108', 1, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(39, 3, 6, '201', 2, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(40, 3, 6, '202', 2, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(41, 3, 6, '203', 2, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(42, 3, 6, '204', 2, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(43, 3, 6, '205', 2, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(44, 3, 6, '206', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(45, 3, 6, '207', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(46, 3, 6, '208', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(47, 3, 6, '209', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(48, 3, 6, '210', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(49, 3, 6, '211', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(50, 3, 6, '212', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(51, 3, 6, '213', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(52, 3, 6, '214', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(53, 3, 6, '215', 2, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(54, 4, 7, '501', 5, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(55, 4, 7, '502', 5, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(56, 4, 7, '503', 5, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(57, 4, 7, '504', 5, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(58, 4, 7, '505', 5, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(59, 4, 8, '601', 6, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(60, 4, 8, '602', 6, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(61, 4, 8, '603', 6, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(62, 4, 8, '604', 6, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(63, 4, 8, '605', 6, 0, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(64, 4, 8, '606', 6, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(65, 4, 8, '607', 6, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(66, 4, 8, '608', 6, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(67, 4, 8, '609', 6, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(68, 4, 8, '610', 6, 1, 'AVAILABLE', '2026-01-10 06:43:26', '2026-01-10 06:43:26', NULL, NULL, 1, 1, NULL),
(69, 5, 9, '701', 7, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(70, 5, 9, '702', 7, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(71, 5, 9, '703', 7, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(72, 5, 9, '704', 7, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(73, 5, 9, '705', 7, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(74, 5, 9, '706', 7, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(75, 5, 9, '707', 7, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(76, 5, 9, '708', 7, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(77, 5, 9, '709', 7, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(78, 5, 9, '710', 7, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(79, 5, 10, '801', 8, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(80, 5, 10, '802', 8, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(81, 5, 10, '803', 8, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(82, 5, 10, '804', 8, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(83, 5, 10, '805', 8, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(84, 5, 10, '806', 8, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(85, 5, 10, '807', 8, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(86, 5, 10, '808', 8, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(87, 5, 10, '809', 8, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(88, 5, 10, '810', 8, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(89, 5, 10, '811', 8, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(90, 5, 10, '812', 8, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(91, 5, 10, '813', 8, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(92, 5, 10, '814', 8, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(93, 5, 10, '815', 8, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(94, 6, 11, '901', 9, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(95, 6, 11, '902', 9, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(96, 6, 11, '903', 9, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(97, 6, 11, '904', 9, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(98, 6, 11, '905', 9, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(99, 6, 11, '906', 9, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(100, 6, 11, '907', 9, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(101, 6, 11, '908', 9, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(102, 6, 12, '1001', 10, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(103, 6, 12, '1002', 10, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(104, 6, 12, '1003', 10, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(105, 6, 12, '1004', 10, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(106, 6, 12, '1005', 10, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(107, 6, 12, '1006', 10, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(108, 6, 12, '1007', 10, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(109, 6, 12, '1008', 10, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(110, 6, 12, '1009', 10, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(111, 6, 12, '1010', 10, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(112, 6, 12, '1011', 10, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(113, 6, 12, '1012', 10, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(114, 7, 13, '1101', 11, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(115, 7, 13, '1102', 11, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(116, 7, 13, '1103', 11, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(117, 7, 13, '1104', 11, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(118, 7, 14, '1201', 12, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(119, 7, 14, '1202', 12, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(120, 7, 14, '1203', 12, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(121, 7, 14, '1204', 12, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(122, 7, 14, '1205', 12, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(123, 7, 14, '1206', 12, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(124, 7, 14, '1207', 12, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(125, 7, 14, '1208', 12, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(126, 8, 15, '1301', 13, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(127, 8, 15, '1302', 13, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(128, 8, 15, '1303', 13, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(129, 8, 15, '1304', 13, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(130, 8, 15, '1305', 13, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(131, 8, 15, '1306', 13, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(132, 8, 16, '1401', 14, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(133, 8, 16, '1402', 14, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(134, 8, 16, '1403', 14, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(135, 8, 16, '1404', 14, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(136, 8, 16, '1405', 14, 0, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(137, 8, 16, '1406', 14, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(138, 8, 16, '1407', 14, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(139, 8, 16, '1408', 14, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(140, 8, 16, '1409', 14, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(141, 8, 16, '1410', 14, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(142, 8, 16, '1411', 14, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(143, 8, 16, '1412', 14, 1, 'AVAILABLE', '2026-01-10 06:43:50', '2026-01-10 06:43:50', NULL, NULL, 1, 1, NULL),
(144, 1, 1, '106', 1, 1, 'AVAILABLE', '2026-01-10 07:02:30', '2026-01-10 07:02:30', NULL, NULL, 1, 1, NULL),
(145, 1, 1, '107', 1, 1, 'AVAILABLE', '2026-01-10 07:02:30', '2026-01-10 07:02:30', NULL, NULL, 1, 1, NULL),
(146, 1, 1, '108', 1, 1, 'AVAILABLE', '2026-01-10 07:02:30', '2026-01-10 07:02:30', NULL, NULL, 1, 1, NULL),
(147, 1, 1, '109', 1, 1, 'AVAILABLE', '2026-01-10 07:02:30', '2026-01-10 07:02:30', NULL, NULL, 1, 1, NULL),
(148, 1, 1, '110', 1, 1, 'AVAILABLE', '2026-01-10 07:02:30', '2026-01-10 07:02:30', NULL, NULL, 1, 1, NULL),
(149, 1, 1, '111', 1, 1, 'AVAILABLE', '2026-01-10 07:02:30', '2026-01-10 07:02:30', NULL, NULL, 1, 1, NULL),
(150, 1, 1, '112', 1, 1, 'AVAILABLE', '2026-01-10 07:02:30', '2026-01-10 07:02:30', NULL, NULL, 1, 1, NULL),
(151, 1, 1, '113', 1, 1, 'AVAILABLE', '2026-01-10 07:02:30', '2026-01-10 07:02:30', NULL, NULL, 1, 1, NULL),
(152, 1, 1, '114', 1, 1, 'AVAILABLE', '2026-01-10 07:02:30', '2026-01-10 07:02:30', NULL, NULL, 1, 1, NULL),
(153, 1, 1, '115', 1, 1, 'AVAILABLE', '2026-01-10 07:02:30', '2026-01-10 07:02:30', NULL, NULL, 1, 1, NULL),
(154, 1, 1, '116', 1, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-10 07:04:09', NULL, NULL, 1, 1, NULL),
(155, 1, 1, '117', 1, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-10 07:04:09', NULL, NULL, 1, 1, NULL),
(156, 1, 1, '118', 1, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-10 07:04:09', NULL, NULL, 1, 1, NULL),
(157, 1, 1, '119', 1, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-10 07:04:09', NULL, NULL, 1, 1, NULL),
(158, 1, 1, '120', 1, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-10 07:04:09', NULL, NULL, 1, 1, NULL),
(159, 1, 1, '121', 2, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(160, 1, 1, '122', 2, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(161, 1, 1, '123', 2, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(162, 1, 1, '124', 2, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(163, 1, 1, '125', 2, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(164, 1, 1, '126', 2, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(165, 1, 1, '127', 2, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(166, 1, 1, '128', 2, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(167, 1, 1, '129', 2, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(168, 1, 1, '130', 2, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-16 02:59:53', NULL, NULL, 1, 1, '2026-01-16 02:59:53'),
(169, 1, 1, '131', 3, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-10 07:04:09', NULL, NULL, 1, 1, NULL),
(170, 1, 1, '132', 3, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-10 07:04:09', NULL, NULL, 1, 1, NULL),
(171, 1, 1, '133', 3, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-10 07:04:09', NULL, NULL, 1, 1, NULL),
(172, 1, 1, '134', 3, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-10 07:04:09', NULL, NULL, 1, 1, NULL),
(173, 1, 1, '135', 3, 1, 'AVAILABLE', '2026-01-10 07:04:09', '2026-01-10 07:04:09', NULL, NULL, 1, 1, NULL),
(174, 1, 1, '136', 3, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(175, 1, 1, '137', 3, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(176, 1, 1, '138', 3, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(177, 1, 1, '139', 3, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(178, 1, 1, '140', 3, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(179, 1, 1, '141', 4, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(180, 1, 1, '142', 4, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(181, 1, 1, '143', 4, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(182, 1, 1, '144', 4, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(183, 1, 1, '145', 4, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(184, 1, 1, '146', 4, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(185, 1, 1, '147', 4, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(186, 1, 1, '148', 4, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(187, 1, 1, '149', 4, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(188, 1, 1, '150', 4, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(189, 1, 1, '151', 5, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(190, 1, 1, '152', 5, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(191, 1, 1, '153', 5, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(192, 1, 1, '154', 5, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(193, 1, 1, '155', 5, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(194, 1, 1, '156', 5, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(195, 1, 1, '157', 5, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(196, 1, 1, '158', 5, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(197, 1, 1, '159', 5, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(198, 1, 1, '160', 5, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(199, 1, 1, '161', 6, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(200, 1, 1, '162', 6, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(201, 1, 1, '163', 6, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(202, 1, 1, '164', 6, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(203, 1, 1, '165', 6, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(204, 1, 1, '166', 6, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(205, 1, 1, '167', 6, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(206, 1, 1, '168', 6, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(207, 1, 1, '169', 6, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(208, 1, 1, '170', 6, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(209, 1, 1, '171', 7, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(210, 1, 1, '172', 7, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(211, 1, 1, '173', 7, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(212, 1, 1, '174', 7, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(213, 1, 1, '175', 7, 1, 'AVAILABLE', '2026-01-10 07:06:14', '2026-01-10 07:06:14', NULL, NULL, 1, 1, NULL),
(214, 32, 43, 'R1', 1, 1, 'AVAILABLE', '2026-01-10 11:11:41', '2026-01-16 14:17:42', 640, 40, 100, 70, '2026-01-16 14:17:42'),
(215, 32, 43, '2', 1, 1, 'AVAILABLE', '2026-01-10 11:11:57', '2026-01-16 14:17:42', 40, 140, 100, 70, '2026-01-16 14:17:42'),
(216, 32, 43, '3', 1, 1, 'AVAILABLE', '2026-01-10 11:12:16', '2026-01-16 14:17:42', 520, 340, 100, 70, '2026-01-16 14:17:42'),
(217, 32, 43, '4', 1, 1, 'AVAILABLE', '2026-01-10 11:12:57', '2026-01-16 14:17:42', 520, 40, 100, 70, '2026-01-16 14:17:42'),
(218, 32, 43, '6', 1, 1, 'AVAILABLE', '2026-01-10 11:15:51', '2026-01-16 14:17:42', 40, 240, 100, 70, '2026-01-16 14:17:42'),
(219, 32, 43, '5', 1, 1, 'AVAILABLE', '2026-01-10 11:30:53', '2026-01-16 14:17:42', 400, 140, 100, 70, '2026-01-16 14:17:42'),
(220, 32, 43, 'R12', 1, 1, 'AVAILABLE', '2026-01-10 12:06:57', '2026-01-16 14:17:42', 400, 240, 100, 70, '2026-01-16 14:17:42'),
(221, 32, 43, 'R8', 1, 1, 'AVAILABLE', '2026-01-10 12:07:03', '2026-01-16 14:17:42', 40, 340, 100, 70, '2026-01-16 14:17:42'),
(222, 32, 43, 'R9', 1, 1, 'AVAILABLE', '2026-01-10 12:07:12', '2026-01-16 14:17:42', 520, 140, 100, 70, '2026-01-16 14:17:42'),
(223, 32, 43, '10', 1, 1, 'AVAILABLE', '2026-01-10 12:07:20', '2026-01-16 14:17:42', 40, 40, 100, 70, '2026-01-16 14:17:42'),
(224, 32, 43, '11', 1, 1, 'AVAILABLE', '2026-01-10 12:07:24', '2026-01-16 14:17:42', 520, 240, 100, 70, '2026-01-16 14:17:42'),
(225, 32, 43, '13', 1, 0, 'AVAILABLE', '2026-01-10 16:32:35', '2026-01-16 14:17:42', 400, 40, 100, 70, '2026-01-16 14:17:42'),
(226, 32, 43, '100', 1, 0, 'MAINTENANCE', '2026-01-12 15:06:17', '2026-01-16 14:17:42', 400, 340, 100, 70, '2026-01-16 14:17:42'),
(227, 32, 43, 'F2', 2, 1, 'AVAILABLE', '2026-01-12 15:46:12', '2026-01-16 03:56:30', 50, 50, 100, 70, '2026-01-16 03:56:30'),
(228, 32, 44, 'D101', 1, 1, 'AVAILABLE', '2026-01-16 06:19:43', '2026-01-16 14:17:42', 280, 340, 100, 70, '2026-01-16 14:17:42'),
(229, 32, 45, 'M105', 1, 1, 'AVAILABLE', '2026-01-16 07:42:08', '2026-01-16 14:17:42', 160, 340, 100, 70, '2026-01-16 14:17:42'),
(230, 32, 45, 'M102', 3, 1, 'AVAILABLE', '2026-01-16 14:18:09', '2026-01-16 14:18:18', 40, 60, 100, 70, '2026-01-16 14:18:18');

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
  `payment_status` varchar(20) DEFAULT 'unpaid',
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_date` datetime DEFAULT NULL,
  `created_by_org` varchar(100) DEFAULT 'OTAOrgMSP',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`id`, `reservation_id`, `hotel_id`, `room_type_id`, `check_in`, `check_out`, `guest_count`, `total_rooms_needed`, `event_type`, `event_description`, `customer_name`, `customer_phone`, `customer_email`, `customer_ref`, `price_per_person`, `total_price`, `currency`, `status`, `payment_status`, `payment_method`, `payment_date`, `created_by_org`, `created_at`, `updated_at`) VALUES
(1, 'RES-1768030045023', 1, 1, '2026-01-10', '2026-01-11', 20, 20, 'Conference', 'test', 'Supriyadi', '123123213', 'musupadi1501@gmail.com', 'Test', 3100000.00, 62000000.00, 'IDR', 'PENDING', 'unpaid', NULL, NULL, 'GoBackendMSP', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(2, 'RES-1768030184060', 1, 1, '2026-01-10', '2026-01-12', 20, 20, 'Corporate Meeting', 'Test', 'Supriyadi', '123123213', 'musupadi1501@gmail.com', 'Test', 3100000.00, 62000000.00, 'IDR', 'PENDING', 'unpaid', NULL, NULL, 'GoBackendMSP', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(3, 'RES-1768221836374', 32, 43, '2026-01-12', '2026-01-13', 10, 10, 'Corporate Meeting', 'Test', 'Supriyadi', '123', 'musupadi@gmail.com', 'Test', 6000000.00, 60000000.00, 'IDR', 'CONFIRMED', 'paid', 'bank_transfer', '2026-01-12 19:58:49', 'GoBackendMSP', '2026-01-12 12:43:56', '2026-01-12 12:58:49'),
(4, 'RES-1768222774185', 32, 43, '2026-01-14', '2026-01-15', 10, 10, 'Workshop', '', 'Supriyadi', '123', 'musupadi@gmail.com', 'Test', 6000000.00, 60000000.00, 'IDR', 'CANCELLED', 'unpaid', '', NULL, 'GoBackendMSP', '2026-01-12 12:59:34', '2026-01-12 13:02:02'),
(5, 'RES-1768230547886', 32, 43, '2026-01-21', '2026-01-22', 10, 10, 'Conference', 'Test', 'Supriyadi', '123', 'musupadi@gmail.com', 'Test', 6000000.00, 60000000.00, 'IDR', 'CONFIRMED', 'paid', 'bank_transfer', '2026-01-12 22:09:50', 'GoBackendMSP', '2026-01-12 15:09:07', '2026-01-12 15:09:50'),
(6, 'RES-1768230656502', 32, 43, '2026-01-15', '2026-01-16', 10, 10, 'Corporate Meeting', 'Test', 'Supriyadi', '123', 'musupadi@gmail.com', 'Test', 6000000.00, 60000000.00, 'IDR', 'CANCELLED', 'unpaid', '', NULL, 'GoBackendMSP', '2026-01-12 15:10:56', '2026-01-12 15:12:19'),
(7, 'RES-1768546875275', 32, 43, '2026-01-16', '2026-01-17', 2, 2, 'workshop', 'Test', 'Supriyadi', '123', 'musupadi@gmail.com', '', 6000000.00, 12000000.00, 'IDR', 'CANCELLED', 'unpaid', '', NULL, 'GoBackendMSP', '2026-01-16 07:01:15', '2026-01-16 10:07:52'),
(8, 'RES-1768557782328', 32, 45, '2026-01-16', '2026-01-17', 3, 3, 'Meeting', '', 'Supriyadi', '123', 'musupadi@gmail.com', '', 1000000.00, 37000000.00, 'IDR', 'CANCELLED', 'unpaid', '', NULL, 'GoBackendMSP', '2026-01-16 10:03:02', '2026-01-16 10:07:41'),
(9, 'RES-1768558332691', 32, 43, '2026-01-17', '2026-01-18', 13, 12, 'Meeting', '', 'Supriyadi', '123', 'musupadi@gmail.com', '', 1000000.00, 911000000.00, 'IDR', 'CONFIRMED', 'paid', 'bank_transfer', '2026-01-16 17:14:23', 'GoBackendMSP', '2026-01-16 10:12:12', '2026-01-16 10:14:23'),
(10, 'RES-1768572716780', 32, 45, '2026-02-07', '2026-02-08', 7, 3, 'meeting', 'Test', 'Supriyadi', '123', 'musupadi@gmail.com', 'Test', 1000000.00, 113000000.00, 'IDR', 'CONFIRMED', 'paid', 'bank_transfer', '2026-01-16 21:14:31', 'GoBackendMSP', '2026-01-16 14:11:56', '2026-01-16 14:14:31'),
(11, 'RES-1768576745983', 32, 43, '2026-01-23', '2026-01-24', 3, 3, 'Meeting', '', 'Supriyadi', '123', 'musupadi@gmail.com', '', 1000000.00, 37000000.00, 'IDR', 'PENDING', 'unpaid', '', NULL, 'GoBackendMSP', '2026-01-16 15:19:05', '2026-01-16 15:19:05'),
(12, 'RES-1768579610288', 32, 45, '2026-01-30', '2026-01-31', 2, 2, 'Meeting', '', 'Supriyadi', '123', 'musupadi@gmail.com', '', 4500000.00, 24510000.00, 'IDR', 'PENDING', 'unpaid', '', NULL, 'GoBackendMSP', '2026-01-16 16:06:50', '2026-01-16 16:06:50');

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

--
-- Dumping data for table `reservation_history`
--

INSERT INTO `reservation_history` (`id`, `reservation_id`, `action`, `status`, `note`, `performed_by`, `performed_at`) VALUES
(1, 'RES-1768030045023', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00'),
(2, 'RES-1768030184060', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00'),
(3, 'RES-1768221836374', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00'),
(4, 'RES-1768221836374', 'PAID', 'CONFIRMED', 'Payment received via bank_transfer', 'GoBackendMSP', '0000-00-00 00:00:00'),
(5, 'RES-1768221836374', 'CONFIRMED', 'CONFIRMED', 'Reservation auto-confirmed after payment', 'GoBackendMSP', '0000-00-00 00:00:00'),
(6, 'RES-1768222774185', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00'),
(7, 'RES-1768222774185', 'CANCELLED', 'CANCELLED', 'Cancelled by admin: Cancel', 'GoBackendMSP', '0000-00-00 00:00:00'),
(8, 'RES-1768230547886', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00'),
(9, 'RES-1768230547886', 'PAID', 'CONFIRMED', 'Payment received via bank_transfer', 'GoBackendMSP', '0000-00-00 00:00:00'),
(10, 'RES-1768230547886', 'CONFIRMED', 'CONFIRMED', 'Reservation auto-confirmed after payment', 'GoBackendMSP', '0000-00-00 00:00:00'),
(11, 'RES-1768230656502', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00'),
(12, 'RES-1768230656502', 'CANCELLED', 'CANCELLED', 'Cancelled by admin: Penuh', 'GoBackendMSP', '0000-00-00 00:00:00'),
(13, 'RES-1768546875275', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00'),
(14, 'RES-1768557782328', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00'),
(15, 'RES-1768557782328', 'CANCELLED', 'CANCELLED', 'Cancelled by admin: Pending', 'GoBackendMSP', '0000-00-00 00:00:00'),
(16, 'RES-1768546875275', 'CANCELLED', 'CANCELLED', 'Cancelled by admin: Pending', 'GoBackendMSP', '0000-00-00 00:00:00'),
(17, 'RES-1768558332691', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00'),
(18, 'RES-1768558332691', 'PAID', 'CONFIRMED', 'Payment received via bank_transfer', 'GoBackendMSP', '0000-00-00 00:00:00'),
(19, 'RES-1768558332691', 'CONFIRMED', 'CONFIRMED', 'Reservation auto-confirmed after payment', 'GoBackendMSP', '0000-00-00 00:00:00'),
(20, 'RES-1768572716780', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00'),
(21, 'RES-1768572716780', 'PAID', 'CONFIRMED', 'Payment received via bank_transfer', 'GoBackendMSP', '0000-00-00 00:00:00'),
(22, 'RES-1768572716780', 'CONFIRMED', 'CONFIRMED', 'Reservation auto-confirmed after payment', 'GoBackendMSP', '0000-00-00 00:00:00'),
(23, 'RES-1768576745983', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00'),
(24, 'RES-1768579610288', 'CREATED', 'PENDING', 'Reservation created via Go backend with Local Simulation', 'GoBackendMSP', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `room_reservations`
--

CREATE TABLE `room_reservations` (
  `id` int(11) NOT NULL,
  `reservation_id` varchar(100) NOT NULL,
  `hotel_room_id` int(11) NOT NULL,
  `check_in` date NOT NULL,
  `start_time` time DEFAULT NULL,
  `check_out` date NOT NULL,
  `end_time` time DEFAULT NULL,
  `booking_duration_hours` decimal(4,2) DEFAULT NULL,
  `guest_names` text DEFAULT NULL COMMENT 'Nama tamu yang menempati kamar ini (JSON array)',
  `status` varchar(20) DEFAULT 'BOOKED' COMMENT 'BOOKED, CHECKED_IN, CHECKED_OUT, CANCELLED',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room_reservations`
--

INSERT INTO `room_reservations` (`id`, `reservation_id`, `hotel_room_id`, `check_in`, `start_time`, `check_out`, `end_time`, `booking_duration_hours`, `guest_names`, `status`, `created_at`, `updated_at`) VALUES
(1, 'RES-1768030045023', 144, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(2, 'RES-1768030045023', 145, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(3, 'RES-1768030045023', 147, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(4, 'RES-1768030045023', 146, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(5, 'RES-1768030045023', 151, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(6, 'RES-1768030045023', 150, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(7, 'RES-1768030045023', 149, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(8, 'RES-1768030045023', 148, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(9, 'RES-1768030045023', 152, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(10, 'RES-1768030045023', 153, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(11, 'RES-1768030045023', 154, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(12, 'RES-1768030045023', 155, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(13, 'RES-1768030045023', 159, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(14, 'RES-1768030045023', 158, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(15, 'RES-1768030045023', 157, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(16, 'RES-1768030045023', 156, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(17, 'RES-1768030045023', 160, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(18, 'RES-1768030045023', 161, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(19, 'RES-1768030045023', 162, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(20, 'RES-1768030045023', 163, '2026-01-10', NULL, '2026-01-11', NULL, NULL, '', 'BOOKED', '2026-01-10 07:27:25', '2026-01-10 07:27:25'),
(21, 'RES-1768030184060', 164, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(22, 'RES-1768030184060', 165, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(23, 'RES-1768030184060', 166, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(24, 'RES-1768030184060', 167, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(25, 'RES-1768030184060', 171, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(26, 'RES-1768030184060', 170, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(27, 'RES-1768030184060', 169, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(28, 'RES-1768030184060', 168, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(29, 'RES-1768030184060', 172, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(30, 'RES-1768030184060', 173, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(31, 'RES-1768030184060', 174, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(32, 'RES-1768030184060', 175, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(33, 'RES-1768030184060', 178, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(34, 'RES-1768030184060', 179, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(35, 'RES-1768030184060', 177, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(36, 'RES-1768030184060', 176, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(37, 'RES-1768030184060', 180, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(38, 'RES-1768030184060', 181, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(39, 'RES-1768030184060', 182, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(40, 'RES-1768030184060', 183, '2026-01-10', NULL, '2026-01-12', NULL, NULL, '', 'BOOKED', '2026-01-10 07:29:44', '2026-01-10 07:29:44'),
(41, 'RES-1768221836374', 214, '2026-01-12', NULL, '2026-01-13', NULL, NULL, '', 'BOOKED', '2026-01-12 12:43:56', '2026-01-12 12:43:56'),
(42, 'RES-1768221836374', 223, '2026-01-12', NULL, '2026-01-13', NULL, NULL, '', 'BOOKED', '2026-01-12 12:43:56', '2026-01-12 12:43:56'),
(43, 'RES-1768221836374', 224, '2026-01-12', NULL, '2026-01-13', NULL, NULL, '', 'BOOKED', '2026-01-12 12:43:56', '2026-01-12 12:43:56'),
(44, 'RES-1768221836374', 215, '2026-01-12', NULL, '2026-01-13', NULL, NULL, '', 'BOOKED', '2026-01-12 12:43:56', '2026-01-12 12:43:56'),
(45, 'RES-1768221836374', 218, '2026-01-12', NULL, '2026-01-13', NULL, NULL, '', 'BOOKED', '2026-01-12 12:43:56', '2026-01-12 12:43:56'),
(46, 'RES-1768221836374', 219, '2026-01-12', NULL, '2026-01-13', NULL, NULL, '', 'BOOKED', '2026-01-12 12:43:56', '2026-01-12 12:43:56'),
(47, 'RES-1768221836374', 217, '2026-01-12', NULL, '2026-01-13', NULL, NULL, '', 'BOOKED', '2026-01-12 12:43:56', '2026-01-12 12:43:56'),
(48, 'RES-1768221836374', 216, '2026-01-12', NULL, '2026-01-13', NULL, NULL, '', 'BOOKED', '2026-01-12 12:43:56', '2026-01-12 12:43:56'),
(49, 'RES-1768221836374', 220, '2026-01-12', NULL, '2026-01-13', NULL, NULL, '', 'BOOKED', '2026-01-12 12:43:56', '2026-01-12 12:43:56'),
(50, 'RES-1768221836374', 221, '2026-01-12', NULL, '2026-01-13', NULL, NULL, '', 'BOOKED', '2026-01-12 12:43:56', '2026-01-12 12:43:56'),
(51, 'RES-1768222774185', 214, '2026-01-14', NULL, '2026-01-15', NULL, NULL, '', 'BOOKED', '2026-01-12 12:59:34', '2026-01-12 12:59:34'),
(52, 'RES-1768222774185', 223, '2026-01-14', NULL, '2026-01-15', NULL, NULL, '', 'BOOKED', '2026-01-12 12:59:34', '2026-01-12 12:59:34'),
(53, 'RES-1768222774185', 215, '2026-01-14', NULL, '2026-01-15', NULL, NULL, '', 'BOOKED', '2026-01-12 12:59:34', '2026-01-12 12:59:34'),
(54, 'RES-1768222774185', 218, '2026-01-14', NULL, '2026-01-15', NULL, NULL, '', 'BOOKED', '2026-01-12 12:59:34', '2026-01-12 12:59:34'),
(55, 'RES-1768222774185', 224, '2026-01-14', NULL, '2026-01-15', NULL, NULL, '', 'BOOKED', '2026-01-12 12:59:34', '2026-01-12 12:59:34'),
(56, 'RES-1768222774185', 217, '2026-01-14', NULL, '2026-01-15', NULL, NULL, '', 'BOOKED', '2026-01-12 12:59:34', '2026-01-12 12:59:34'),
(57, 'RES-1768222774185', 219, '2026-01-14', NULL, '2026-01-15', NULL, NULL, '', 'BOOKED', '2026-01-12 12:59:34', '2026-01-12 12:59:34'),
(58, 'RES-1768222774185', 222, '2026-01-14', NULL, '2026-01-15', NULL, NULL, '', 'BOOKED', '2026-01-12 12:59:34', '2026-01-12 12:59:34'),
(59, 'RES-1768222774185', 221, '2026-01-14', NULL, '2026-01-15', NULL, NULL, '', 'BOOKED', '2026-01-12 12:59:34', '2026-01-12 12:59:34'),
(60, 'RES-1768222774185', 220, '2026-01-14', NULL, '2026-01-15', NULL, NULL, '', 'BOOKED', '2026-01-12 12:59:34', '2026-01-12 12:59:34'),
(61, 'RES-1768230547886', 222, '2026-01-21', NULL, '2026-01-22', NULL, NULL, '', 'BOOKED', '2026-01-12 15:09:07', '2026-01-12 15:09:07'),
(62, 'RES-1768230547886', 223, '2026-01-21', NULL, '2026-01-22', NULL, NULL, '', 'BOOKED', '2026-01-12 15:09:07', '2026-01-12 15:09:07'),
(63, 'RES-1768230547886', 214, '2026-01-21', NULL, '2026-01-22', NULL, NULL, '', 'BOOKED', '2026-01-12 15:09:07', '2026-01-12 15:09:07'),
(64, 'RES-1768230547886', 224, '2026-01-21', NULL, '2026-01-22', NULL, NULL, '', 'BOOKED', '2026-01-12 15:09:07', '2026-01-12 15:09:07'),
(65, 'RES-1768230547886', 215, '2026-01-21', NULL, '2026-01-22', NULL, NULL, '', 'BOOKED', '2026-01-12 15:09:07', '2026-01-12 15:09:07'),
(66, 'RES-1768230547886', 217, '2026-01-21', NULL, '2026-01-22', NULL, NULL, '', 'BOOKED', '2026-01-12 15:09:07', '2026-01-12 15:09:07'),
(67, 'RES-1768230547886', 219, '2026-01-21', NULL, '2026-01-22', NULL, NULL, '', 'BOOKED', '2026-01-12 15:09:07', '2026-01-12 15:09:07'),
(68, 'RES-1768230547886', 216, '2026-01-21', NULL, '2026-01-22', NULL, NULL, '', 'BOOKED', '2026-01-12 15:09:07', '2026-01-12 15:09:07'),
(69, 'RES-1768230547886', 218, '2026-01-21', NULL, '2026-01-22', NULL, NULL, '', 'BOOKED', '2026-01-12 15:09:07', '2026-01-12 15:09:07'),
(70, 'RES-1768230547886', 221, '2026-01-21', NULL, '2026-01-22', NULL, NULL, '', 'BOOKED', '2026-01-12 15:09:07', '2026-01-12 15:09:07'),
(71, 'RES-1768230656502', 214, '2026-01-15', NULL, '2026-01-16', NULL, NULL, '', 'BOOKED', '2026-01-12 15:10:56', '2026-01-12 15:10:56'),
(72, 'RES-1768230656502', 223, '2026-01-15', NULL, '2026-01-16', NULL, NULL, '', 'BOOKED', '2026-01-12 15:10:56', '2026-01-12 15:10:56'),
(73, 'RES-1768230656502', 224, '2026-01-15', NULL, '2026-01-16', NULL, NULL, '', 'BOOKED', '2026-01-12 15:10:56', '2026-01-12 15:10:56'),
(74, 'RES-1768230656502', 215, '2026-01-15', NULL, '2026-01-16', NULL, NULL, '', 'BOOKED', '2026-01-12 15:10:56', '2026-01-12 15:10:56'),
(75, 'RES-1768230656502', 218, '2026-01-15', NULL, '2026-01-16', NULL, NULL, '', 'BOOKED', '2026-01-12 15:10:56', '2026-01-12 15:10:56'),
(76, 'RES-1768230656502', 219, '2026-01-15', NULL, '2026-01-16', NULL, NULL, '', 'BOOKED', '2026-01-12 15:10:56', '2026-01-12 15:10:56'),
(77, 'RES-1768230656502', 217, '2026-01-15', NULL, '2026-01-16', NULL, NULL, '', 'BOOKED', '2026-01-12 15:10:56', '2026-01-12 15:10:56'),
(78, 'RES-1768230656502', 216, '2026-01-15', NULL, '2026-01-16', NULL, NULL, '', 'BOOKED', '2026-01-12 15:10:56', '2026-01-12 15:10:56'),
(79, 'RES-1768230656502', 220, '2026-01-15', NULL, '2026-01-16', NULL, NULL, '', 'BOOKED', '2026-01-12 15:10:56', '2026-01-12 15:10:56'),
(80, 'RES-1768230656502', 221, '2026-01-15', NULL, '2026-01-16', NULL, NULL, '', 'BOOKED', '2026-01-12 15:10:56', '2026-01-12 15:10:56'),
(81, 'RES-1768546875275', 214, '2026-01-16', NULL, '2026-01-17', NULL, NULL, '', 'BOOKED', '2026-01-16 07:01:15', '2026-01-16 07:01:15'),
(82, 'RES-1768546875275', 217, '2026-01-16', NULL, '2026-01-17', NULL, NULL, '', 'BOOKED', '2026-01-16 07:01:15', '2026-01-16 07:01:15'),
(83, 'RES-1768557782328', 229, '2026-01-16', '08:00:00', '2026-01-17', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:03:02', '2026-01-16 10:03:02'),
(84, 'RES-1768557782328', 222, '2026-01-16', '08:00:00', '2026-01-17', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:03:02', '2026-01-16 10:03:02'),
(85, 'RES-1768557782328', 220, '2026-01-16', '08:00:00', '2026-01-17', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:03:02', '2026-01-16 10:03:02'),
(86, 'RES-1768558332691', 220, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(87, 'RES-1768558332691', 219, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(88, 'RES-1768558332691', 224, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(89, 'RES-1768558332691', 217, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(90, 'RES-1768558332691', 214, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(91, 'RES-1768558332691', 222, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(92, 'RES-1768558332691', 216, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(93, 'RES-1768558332691', 215, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(94, 'RES-1768558332691', 223, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(95, 'RES-1768558332691', 218, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(96, 'RES-1768558332691', 228, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(97, 'RES-1768558332691', 229, '2026-01-17', '08:00:00', '2026-01-18', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 10:12:12', '2026-01-16 10:12:12'),
(98, 'RES-1768572716780', 229, '2026-02-07', '08:00:00', '2026-02-08', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 14:11:56', '2026-01-16 14:11:56'),
(99, 'RES-1768572716780', 228, '2026-02-07', '08:00:00', '2026-02-08', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 14:11:56', '2026-01-16 14:11:56'),
(100, 'RES-1768572716780', 216, '2026-02-07', '08:00:00', '2026-02-08', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 14:11:56', '2026-01-16 14:11:56'),
(101, 'RES-1768576745983', 222, '2026-01-23', '08:00:00', '2026-01-24', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 15:19:06', '2026-01-16 15:19:06'),
(102, 'RES-1768576745983', 229, '2026-01-23', '08:00:00', '2026-01-24', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 15:19:06', '2026-01-16 15:19:06'),
(103, 'RES-1768576745983', 224, '2026-01-23', '08:00:00', '2026-01-24', '13:00:00', 5.00, '', 'BOOKED', '2026-01-16 15:19:06', '2026-01-16 15:19:06'),
(104, 'RES-1768579610288', 229, '2026-01-30', '12:00:00', '2026-01-31', '22:00:00', 10.00, '', 'BOOKED', '2026-01-16 16:06:50', '2026-01-16 16:06:50'),
(105, 'RES-1768579610288', 228, '2026-01-30', '12:00:00', '2026-01-31', '22:00:00', 10.00, '', 'BOOKED', '2026-01-16 16:06:50', '2026-01-16 16:06:50');

-- --------------------------------------------------------

--
-- Table structure for table `room_types`
--

CREATE TABLE `room_types` (
  `id` int(11) NOT NULL,
  `hotel_id` int(11) NOT NULL,
  `type_name` varchar(100) NOT NULL,
  `room_category` enum('hotel_room','meeting_room') NOT NULL DEFAULT 'hotel_room' COMMENT 'Type of room: hotel_room for overnight stays, meeting_room for hourly bookings',
  `description` text DEFAULT NULL,
  `price_per_person` decimal(12,2) NOT NULL COMMENT 'Harga per orang untuk meeting package',
  `pricing_type` enum('per_night','per_hour','half_day','full_day') NOT NULL DEFAULT 'per_night' COMMENT 'Pricing model: per_night for hotels, per_hour/half_day/full_day for meeting rooms',
  `hourly_rate` decimal(10,2) DEFAULT NULL,
  `half_day_rate` decimal(10,2) DEFAULT NULL,
  `full_day_rate` decimal(10,2) DEFAULT NULL,
  `full_board_rate` decimal(10,2) DEFAULT NULL,
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

INSERT INTO `room_types` (`id`, `hotel_id`, `type_name`, `room_category`, `description`, `price_per_person`, `pricing_type`, `hourly_rate`, `half_day_rate`, `full_day_rate`, `full_board_rate`, `min_capacity`, `max_capacity`, `total_rooms`, `blockchain_reserved_rooms`, `available_rooms`, `amenities`, `created_at`, `updated_at`) VALUES
(1, 1, 'Residential Meeting Single', 'hotel_room', 'Full board package with single bed room, meeting room, meals, coffee breaks', 3100000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 100, 5, 5, 5, 'AC, LCD Projector, Sound System, WiFi, Meals 3x, Coffee Break 2x', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(2, 1, 'Residential Meeting Twin Share', 'hotel_room', 'Full board package with twin share room, meeting room, meals, coffee breaks', 2500000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 100, 10, 5, 10, 'AC, LCD Projector, Sound System, WiFi, Meals 3x, Coffee Break 2x', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(3, 2, 'Residential Meeting Single', 'hotel_room', 'Premium meeting package with luxury accommodation', 2000000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 80, 5, 5, 5, 'AC, LED Screen, Audio System, High-Speed WiFi, Meals, Snacks', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(4, 2, 'Residential Meeting Twin Share', 'hotel_room', 'Premium meeting package with shared accommodation', 1600000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 80, 10, 5, 10, 'AC, LED Screen, Audio System, High-Speed WiFi, Meals, Snacks', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(5, 3, 'Residential Meeting Single', 'hotel_room', 'Convention package with mountain view', 1200000.00, 'per_night', NULL, NULL, NULL, NULL, 30, 150, 8, 5, 8, 'AC, Projector, Microphone, WiFi, Full Board Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(6, 3, 'Residential Meeting Twin Share', 'hotel_room', 'Convention package with shared room', 950000.00, 'per_night', NULL, NULL, NULL, NULL, 30, 150, 15, 5, 15, 'AC, Projector, Microphone, WiFi, Full Board Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(7, 4, 'Residential Meeting Single', 'hotel_room', 'Standard meeting package with city view', 800000.00, 'per_night', NULL, NULL, NULL, NULL, 10, 50, 5, 5, 5, 'AC, Projector, WiFi, Meals 3x', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(8, 4, 'Residential Meeting Twin Share', 'hotel_room', 'Standard meeting package twin room', 650000.00, 'per_night', NULL, NULL, NULL, NULL, 10, 50, 10, 5, 10, 'AC, Projector, WiFi, Meals 3x', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(9, 5, 'Residential Meeting Single', 'hotel_room', 'International MICE package premium', 2500000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 200, 10, 5, 10, 'Smart Board, Video Conference, Premium Meals, Executive Lounge', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(10, 5, 'Residential Meeting Twin Share', 'hotel_room', 'International MICE package standard', 2000000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 200, 15, 5, 15, 'Smart Board, Video Conference, Premium Meals, Executive Lounge', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(11, 6, 'Residential Meeting Single', 'hotel_room', 'Luxury ballroom meeting package', 2200000.00, 'per_night', NULL, NULL, NULL, NULL, 25, 150, 8, 5, 8, 'LED Wall, Professional Sound, Gourmet Meals, Spa Access', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(12, 6, 'Residential Meeting Twin Share', 'hotel_room', 'Luxury meeting package shared', 1800000.00, 'per_night', NULL, NULL, NULL, NULL, 25, 150, 12, 5, 12, 'LED Wall, Professional Sound, Gourmet Meals, Spa Access', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(13, 7, 'Residential Meeting Single', 'hotel_room', 'Executive suite meeting package', 1800000.00, 'per_night', NULL, NULL, NULL, NULL, 10, 40, 4, 4, 4, 'Private Meeting Room, Butler Service, Premium Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(14, 7, 'Residential Meeting Twin Share', 'hotel_room', 'Executive meeting package shared', 1400000.00, 'per_night', NULL, NULL, NULL, NULL, 10, 40, 8, 5, 8, 'Private Meeting Room, Butler Service, Premium Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(15, 8, 'Residential Meeting Single', 'hotel_room', 'Modern meeting package affordable', 900000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 60, 6, 5, 6, 'Smart TV, WiFi, Standard Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(16, 8, 'Residential Meeting Twin Share', 'hotel_room', 'Modern meeting package budget', 700000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 60, 12, 5, 12, 'Smart TV, WiFi, Standard Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(17, 9, 'Residential Meeting Single', 'hotel_room', 'Golf resort meeting package premium', 1900000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 80, 5, 5, 5, 'Golf Access, Meeting Room, Spa, Full Board', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(18, 9, 'Residential Meeting Twin Share', 'hotel_room', 'Golf resort meeting package standard', 1500000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 80, 10, 5, 10, 'Golf Access, Meeting Room, Spa, Full Board', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(19, 10, 'Residential Meeting Single', 'hotel_room', 'Mountain view meeting package', 1700000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 70, 5, 5, 5, 'Outdoor Activities, Meeting Hall, Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(20, 10, 'Residential Meeting Twin Share', 'hotel_room', 'Mountain view shared package', 1350000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 70, 10, 5, 10, 'Outdoor Activities, Meeting Hall, Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(21, 11, 'Residential Meeting Single', 'hotel_room', 'International golf meeting package', 1650000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 90, 6, 5, 6, 'Golf Course, Convention Hall, International Cuisine', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(22, 11, 'Residential Meeting Twin Share', 'hotel_room', 'International meeting shared', 1300000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 90, 12, 5, 12, 'Golf Course, Convention Hall, International Cuisine', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(23, 12, 'Residential Meeting Single', 'hotel_room', 'Nature retreat meeting package', 1500000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 60, 4, 4, 4, 'Nature Activities, Spa, Organic Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(24, 12, 'Residential Meeting Twin Share', 'hotel_room', 'Nature retreat shared package', 1200000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 60, 8, 5, 8, 'Nature Activities, Spa, Organic Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(25, 13, 'Residential Meeting Single', 'hotel_room', 'City convention meeting package', 1400000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 100, 7, 5, 7, 'Convention Center, City Access, Business Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(26, 13, 'Residential Meeting Twin Share', 'hotel_room', 'City convention shared', 1100000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 100, 14, 5, 14, 'Convention Center, City Access, Business Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(27, 14, 'Residential Meeting Single', 'hotel_room', 'Luxury Bali MICE package', 2000000.00, 'per_night', NULL, NULL, NULL, NULL, 25, 120, 8, 5, 8, 'Beach Access, Ballroom, Water Sports, Gala Dinner', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(28, 14, 'Residential Meeting Twin Share', 'hotel_room', 'Luxury Bali meeting shared', 1600000.00, 'per_night', NULL, NULL, NULL, NULL, 25, 120, 15, 5, 15, 'Beach Access, Ballroom, Water Sports, Gala Dinner', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(29, 15, 'Residential Meeting Single', 'hotel_room', 'Beach resort meeting package', 1900000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 100, 6, 5, 6, 'Beach Activities, Meeting Rooms, Sunset Dinner', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(30, 15, 'Residential Meeting Twin Share', 'hotel_room', 'Beach resort shared package', 1500000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 100, 12, 5, 12, 'Beach Activities, Meeting Rooms, Sunset Dinner', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(31, 16, 'Residential Meeting Single', 'hotel_room', 'Beachfront meeting package', 1300000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 70, 5, 5, 5, 'Ocean View, Meeting Space, Balinese Cuisine', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(32, 16, 'Residential Meeting Twin Share', 'hotel_room', 'Beachfront shared package', 1000000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 70, 10, 5, 10, 'Ocean View, Meeting Space, Balinese Cuisine', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(33, 17, 'Residential Meeting Single', 'hotel_room', 'All-inclusive meeting package', 1600000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 90, 6, 5, 6, 'All Meals, Activities, Team Building, Meeting Hall', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(34, 17, 'Residential Meeting Twin Share', 'hotel_room', 'All-inclusive shared package', 1250000.00, 'per_night', NULL, NULL, NULL, NULL, 20, 90, 12, 5, 12, 'All Meals, Activities, Team Building, Meeting Hall', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(35, 18, 'Residential Meeting Single', 'hotel_room', 'Presidential meeting package', 2100000.00, 'per_night', NULL, NULL, NULL, NULL, 30, 200, 10, 5, 10, 'Grand Ballroom, VIP Service, Fine Dining, Limousine', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(36, 18, 'Residential Meeting Twin Share', 'hotel_room', 'Presidential shared package', 1700000.00, 'per_night', NULL, NULL, NULL, NULL, 30, 200, 20, 5, 20, 'Grand Ballroom, VIP Service, Fine Dining, Limousine', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(37, 19, 'Residential Meeting Single', 'hotel_room', 'Heritage meeting package', 1900000.00, 'per_night', NULL, NULL, NULL, NULL, 25, 150, 8, 5, 8, 'Classic Ballroom, Cultural Experience, Premium Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(38, 19, 'Residential Meeting Twin Share', 'hotel_room', 'Heritage shared package', 1500000.00, 'per_night', NULL, NULL, NULL, NULL, 25, 150, 15, 5, 15, 'Classic Ballroom, Cultural Experience, Premium Meals', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(39, 20, 'Residential Meeting Single', 'hotel_room', 'Cultural meeting package', 1200000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 60, 5, 5, 5, 'Batik Workshop, Meeting Room, Local Cuisine', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(40, 20, 'Residential Meeting Twin Share', 'hotel_room', 'Cultural shared package', 950000.00, 'per_night', NULL, NULL, NULL, NULL, 15, 60, 10, 5, 10, 'Batik Workshop, Meeting Room, Local Cuisine', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(41, 21, 'Residential Meeting Single', 'hotel_room', 'Mountain retreat meeting package', 1100000.00, 'per_night', NULL, NULL, NULL, NULL, 10, 50, 4, 4, 4, 'Fresh Air, Nature Walk, Outdoor Meeting', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(42, 21, 'Residential Meeting Twin Share', 'hotel_room', 'Mountain retreat shared', 850000.00, 'per_night', NULL, NULL, NULL, NULL, 10, 50, 8, 5, 8, 'Fresh Air, Nature Walk, Outdoor Meeting', '2026-01-10 06:43:26', '2026-01-10 06:43:26'),
(43, 32, 'Standard Room', 'hotel_room', 'Test', 6000000.00, 'per_night', NULL, NULL, NULL, NULL, 1, 2, 200, 150, 200, 'Test', '2026-01-10 11:09:08', '2026-01-16 06:16:37'),
(44, 32, 'Deluxe Room', 'hotel_room', 'Deluxe Room', 10000000.00, 'per_night', NULL, NULL, NULL, NULL, 1, 4, 10, 5, 10, 'AC dan Lain2', '2026-01-16 06:19:26', '2026-01-16 06:19:26'),
(45, 32, 'Meeting Room Alpha', 'meeting_room', 'Meeting Room Half Day', 0.00, 'per_night', 500000.00, 1000000.00, 1200000.00, 4500000.00, 10, 20, 10, 5, 10, 'AC', '2026-01-16 07:41:46', '2026-01-16 15:57:20');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL,
  `role` enum('customer','hotel_admin','hotel_super_admin','system_admin') DEFAULT 'customer',
  `hotel_id` int(11) DEFAULT NULL,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `full_name`, `phone`, `company`, `role`, `hotel_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'musupadi1501@gmail.com', '$2a$10$41ZV2uUx0b2ZQ9EsOYB3N.0Xgdpvs9VhBY0RVVY.kxeHaameTdTxW', 'Test', '123132', '', 'hotel_super_admin', 32, 'active', '2026-01-10 10:34:58', '2026-01-10 10:34:58'),
(2, 'musupadi@gmail.com', '$2a$10$U7v0/S4tJDMzZE8HrVyLEux8KXT0w9La79wCodfQR7MIiULVETq1y', 'Supriyadi', '123', 'Test', 'customer', NULL, 'active', '2026-01-10 12:01:48', '2026-01-10 12:01:48'),
(3, 'farhan@gmail.com', '$2a$10$PYDUqiw2dAwParehMo8iNOThg21Y2H/6RW0lUHZEPRerXcgj0SpUG', 'Muhammad', 'Farhan', '', 'hotel_super_admin', 33, 'active', '2026-01-16 14:40:59', '2026-01-16 14:40:59');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `hotels`
--
ALTER TABLE `hotels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_city` (`city`),
  ADD KEY `idx_name` (`name`),
  ADD KEY `idx_hotels_owner_id` (`owner_id`),
  ADD KEY `idx_hotels_status` (`status`);

--
-- Indexes for table `hotel_admins`
--
ALTER TABLE `hotel_admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_hotel_user` (`hotel_id`,`user_id`),
  ADD KEY `assigned_by` (`assigned_by`),
  ADD KEY `idx_hotel` (`hotel_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Indexes for table `hotel_rooms`
--
ALTER TABLE `hotel_rooms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_room_number` (`hotel_id`,`room_number`),
  ADD KEY `idx_hotel_id` (`hotel_id`),
  ADD KEY `idx_room_type_id` (`room_type_id`),
  ADD KEY `idx_blockchain_enabled` (`is_blockchain_enabled`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_hotel_rooms_floor` (`hotel_id`,`floor`),
  ADD KEY `idx_hotel_rooms_type_floor` (`hotel_id`,`room_type_id`,`floor`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `reservation_id` (`reservation_id`),
  ADD KEY `room_type_id` (`room_type_id`),
  ADD KEY `idx_reservation_id` (`reservation_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_check_in` (`check_in`),
  ADD KEY `idx_hotel_id` (`hotel_id`),
  ADD KEY `idx_event_type` (`event_type`),
  ADD KEY `idx_payment_status` (`payment_status`);

--
-- Indexes for table `reservation_history`
--
ALTER TABLE `reservation_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reservation_id` (`reservation_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_performed_at` (`performed_at`);

--
-- Indexes for table `room_reservations`
--
ALTER TABLE `room_reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reservation_id` (`reservation_id`),
  ADD KEY `idx_hotel_room_id` (`hotel_room_id`),
  ADD KEY `idx_dates` (`check_in`,`check_out`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `room_types`
--
ALTER TABLE `room_types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_hotel_id` (`hotel_id`),
  ADD KEY `idx_price` (`price_per_person`),
  ADD KEY `idx_capacity` (`min_capacity`,`max_capacity`),
  ADD KEY `idx_room_category` (`room_category`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_hotel_id` (`hotel_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `hotels`
--
ALTER TABLE `hotels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `hotel_admins`
--
ALTER TABLE `hotel_admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `hotel_rooms`
--
ALTER TABLE `hotel_rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=231;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `reservation_history`
--
ALTER TABLE `reservation_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `room_reservations`
--
ALTER TABLE `room_reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `room_types`
--
ALTER TABLE `room_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `hotel_admins`
--
ALTER TABLE `hotel_admins`
  ADD CONSTRAINT `hotel_admins_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `hotel_admins_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `hotel_admins_ibfk_3` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `hotel_rooms`
--
ALTER TABLE `hotel_rooms`
  ADD CONSTRAINT `hotel_rooms_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `hotel_rooms_ibfk_2` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reservation_history`
--
ALTER TABLE `reservation_history`
  ADD CONSTRAINT `reservation_history_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`reservation_id`) ON DELETE CASCADE;

--
-- Constraints for table `room_reservations`
--
ALTER TABLE `room_reservations`
  ADD CONSTRAINT `room_reservations_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`reservation_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `room_reservations_ibfk_2` FOREIGN KEY (`hotel_room_id`) REFERENCES `hotel_rooms` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `room_types`
--
ALTER TABLE `room_types`
  ADD CONSTRAINT `room_types_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
