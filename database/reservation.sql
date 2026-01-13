-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 13, 2025 at 05:05 AM
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
  `owner_id` int(11) DEFAULT NULL COMMENT 'Super admin user ID',
  `owner_name` varchar(255) DEFAULT NULL,
  `owner_phone` varchar(20) DEFAULT NULL,
  `owner_email` varchar(255) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'active' COMMENT 'active, inactive, pending',
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
-- Sample data for table `hotel_rooms`
-- Format: 5 kamar pertama = walk-in only (is_blockchain_enabled=0), sisanya = blockchain enabled (is_blockchain_enabled=1)
--

INSERT INTO `hotel_rooms` (`hotel_id`, `room_type_id`, `room_number`, `floor`, `is_blockchain_enabled`, `status`) VALUES
-- Hotel 1: L'Eminence Golf - Residential Meeting Single (5 rooms)
(1, 1, '101', 1, 0, 'AVAILABLE'), (1, 1, '102', 1, 0, 'AVAILABLE'), (1, 1, '103', 1, 0, 'AVAILABLE'), 
(1, 1, '104', 1, 0, 'AVAILABLE'), (1, 1, '105', 1, 0, 'AVAILABLE'),
-- Hotel 1: L'Eminence Golf - Residential Meeting Twin Share (10 rooms: 5 walk-in + 5 blockchain)
(1, 2, '201', 2, 0, 'AVAILABLE'), (1, 2, '202', 2, 0, 'AVAILABLE'), (1, 2, '203', 2, 0, 'AVAILABLE'), 
(1, 2, '204', 2, 0, 'AVAILABLE'), (1, 2, '205', 2, 0, 'AVAILABLE'),
(1, 2, '206', 2, 1, 'AVAILABLE'), (1, 2, '207', 2, 1, 'AVAILABLE'), (1, 2, '208', 2, 1, 'AVAILABLE'), 
(1, 2, '209', 2, 1, 'AVAILABLE'), (1, 2, '210', 2, 1, 'AVAILABLE'),

-- Hotel 2: Padma Hotel - Residential Meeting Single (5 rooms)
(2, 3, '301', 3, 0, 'AVAILABLE'), (2, 3, '302', 3, 0, 'AVAILABLE'), (2, 3, '303', 3, 0, 'AVAILABLE'), 
(2, 3, '304', 3, 0, 'AVAILABLE'), (2, 3, '305', 3, 0, 'AVAILABLE'),
-- Hotel 2: Padma Hotel - Residential Meeting Twin Share (10 rooms)
(2, 4, '401', 4, 0, 'AVAILABLE'), (2, 4, '402', 4, 0, 'AVAILABLE'), (2, 4, '403', 4, 0, 'AVAILABLE'), 
(2, 4, '404', 4, 0, 'AVAILABLE'), (2, 4, '405', 4, 0, 'AVAILABLE'),
(2, 4, '406', 4, 1, 'AVAILABLE'), (2, 4, '407', 4, 1, 'AVAILABLE'), (2, 4, '408', 4, 1, 'AVAILABLE'), 
(2, 4, '409', 4, 1, 'AVAILABLE'), (2, 4, '410', 4, 1, 'AVAILABLE'),

-- Hotel 3: Grand Sunshine Resort - Residential Meeting Single (8 rooms)
(3, 5, '101', 1, 0, 'AVAILABLE'), (3, 5, '102', 1, 0, 'AVAILABLE'), (3, 5, '103', 1, 0, 'AVAILABLE'), 
(3, 5, '104', 1, 0, 'AVAILABLE'), (3, 5, '105', 1, 0, 'AVAILABLE'),
(3, 5, '106', 1, 1, 'AVAILABLE'), (3, 5, '107', 1, 1, 'AVAILABLE'), (3, 5, '108', 1, 1, 'AVAILABLE'),
-- Hotel 3: Grand Sunshine Resort - Residential Meeting Twin Share (15 rooms)
(3, 6, '201', 2, 0, 'AVAILABLE'), (3, 6, '202', 2, 0, 'AVAILABLE'), (3, 6, '203', 2, 0, 'AVAILABLE'), 
(3, 6, '204', 2, 0, 'AVAILABLE'), (3, 6, '205', 2, 0, 'AVAILABLE'),
(3, 6, '206', 2, 1, 'AVAILABLE'), (3, 6, '207', 2, 1, 'AVAILABLE'), (3, 6, '208', 2, 1, 'AVAILABLE'), 
(3, 6, '209', 2, 1, 'AVAILABLE'), (3, 6, '210', 2, 1, 'AVAILABLE'),
(3, 6, '211', 2, 1, 'AVAILABLE'), (3, 6, '212', 2, 1, 'AVAILABLE'), (3, 6, '213', 2, 1, 'AVAILABLE'), 
(3, 6, '214', 2, 1, 'AVAILABLE'), (3, 6, '215', 2, 1, 'AVAILABLE'),

-- Hotel 4: Grand Panorama - Residential Meeting Single (5 rooms)
(4, 7, '501', 5, 0, 'AVAILABLE'), (4, 7, '502', 5, 0, 'AVAILABLE'), (4, 7, '503', 5, 0, 'AVAILABLE'), 
(4, 7, '504', 5, 0, 'AVAILABLE'), (4, 7, '505', 5, 0, 'AVAILABLE'),
-- Hotel 4: Grand Panorama - Residential Meeting Twin Share (10 rooms)
(4, 8, '601', 6, 0, 'AVAILABLE'), (4, 8, '602', 6, 0, 'AVAILABLE'), (4, 8, '603', 6, 0, 'AVAILABLE'), 
(4, 8, '604', 6, 0, 'AVAILABLE'), (4, 8, '605', 6, 0, 'AVAILABLE'),
(4, 8, '606', 6, 1, 'AVAILABLE'), (4, 8, '607', 6, 1, 'AVAILABLE'), (4, 8, '608', 6, 1, 'AVAILABLE'), 
(4, 8, '609', 6, 1, 'AVAILABLE'), (4, 8, '610', 6, 1, 'AVAILABLE'),

-- Hotel 5: Pullman Bandung - Residential Meeting Single (10 rooms)
(5, 9, '701', 7, 0, 'AVAILABLE'), (5, 9, '702', 7, 0, 'AVAILABLE'), (5, 9, '703', 7, 0, 'AVAILABLE'), 
(5, 9, '704', 7, 0, 'AVAILABLE'), (5, 9, '705', 7, 0, 'AVAILABLE'),
(5, 9, '706', 7, 1, 'AVAILABLE'), (5, 9, '707', 7, 1, 'AVAILABLE'), (5, 9, '708', 7, 1, 'AVAILABLE'), 
(5, 9, '709', 7, 1, 'AVAILABLE'), (5, 9, '710', 7, 1, 'AVAILABLE'),
-- Hotel 5: Pullman Bandung - Residential Meeting Twin Share (15 rooms)
(5, 10, '801', 8, 0, 'AVAILABLE'), (5, 10, '802', 8, 0, 'AVAILABLE'), (5, 10, '803', 8, 0, 'AVAILABLE'), 
(5, 10, '804', 8, 0, 'AVAILABLE'), (5, 10, '805', 8, 0, 'AVAILABLE'),
(5, 10, '806', 8, 1, 'AVAILABLE'), (5, 10, '807', 8, 1, 'AVAILABLE'), (5, 10, '808', 8, 1, 'AVAILABLE'), 
(5, 10, '809', 8, 1, 'AVAILABLE'), (5, 10, '810', 8, 1, 'AVAILABLE'),
(5, 10, '811', 8, 1, 'AVAILABLE'), (5, 10, '812', 8, 1, 'AVAILABLE'), (5, 10, '813', 8, 1, 'AVAILABLE'), 
(5, 10, '814', 8, 1, 'AVAILABLE'), (5, 10, '815', 8, 1, 'AVAILABLE'),

-- Hotel 6: Trans Luxury - Residential Meeting Single (8 rooms)
(6, 11, '901', 9, 0, 'AVAILABLE'), (6, 11, '902', 9, 0, 'AVAILABLE'), (6, 11, '903', 9, 0, 'AVAILABLE'), 
(6, 11, '904', 9, 0, 'AVAILABLE'), (6, 11, '905', 9, 0, 'AVAILABLE'),
(6, 11, '906', 9, 1, 'AVAILABLE'), (6, 11, '907', 9, 1, 'AVAILABLE'), (6, 11, '908', 9, 1, 'AVAILABLE'),
-- Hotel 6: Trans Luxury - Residential Meeting Twin Share (12 rooms)
(6, 12, '1001', 10, 0, 'AVAILABLE'), (6, 12, '1002', 10, 0, 'AVAILABLE'), (6, 12, '1003', 10, 0, 'AVAILABLE'), 
(6, 12, '1004', 10, 0, 'AVAILABLE'), (6, 12, '1005', 10, 0, 'AVAILABLE'),
(6, 12, '1006', 10, 1, 'AVAILABLE'), (6, 12, '1007', 10, 1, 'AVAILABLE'), (6, 12, '1008', 10, 1, 'AVAILABLE'), 
(6, 12, '1009', 10, 1, 'AVAILABLE'), (6, 12, '1010', 10, 1, 'AVAILABLE'),
(6, 12, '1011', 10, 1, 'AVAILABLE'), (6, 12, '1012', 10, 1, 'AVAILABLE'),

-- Hotel 7: Jayakarta Suites - Residential Meeting Single (4 rooms)
(7, 13, '1101', 11, 0, 'AVAILABLE'), (7, 13, '1102', 11, 0, 'AVAILABLE'), (7, 13, '1103', 11, 0, 'AVAILABLE'), 
(7, 13, '1104', 11, 0, 'AVAILABLE'),
-- Hotel 7: Jayakarta Suites - Residential Meeting Twin Share (8 rooms)
(7, 14, '1201', 12, 0, 'AVAILABLE'), (7, 14, '1202', 12, 0, 'AVAILABLE'), (7, 14, '1203', 12, 0, 'AVAILABLE'), 
(7, 14, '1204', 12, 0, 'AVAILABLE'), (7, 14, '1205', 12, 0, 'AVAILABLE'),
(7, 14, '1206', 12, 1, 'AVAILABLE'), (7, 14, '1207', 12, 1, 'AVAILABLE'), (7, 14, '1208', 12, 1, 'AVAILABLE'),

-- Hotel 8: Mason Pine - Residential Meeting Single (6 rooms)
(8, 15, '1301', 13, 0, 'AVAILABLE'), (8, 15, '1302', 13, 0, 'AVAILABLE'), (8, 15, '1303', 13, 0, 'AVAILABLE'), 
(8, 15, '1304', 13, 0, 'AVAILABLE'), (8, 15, '1305', 13, 0, 'AVAILABLE'),
(8, 15, '1306', 13, 1, 'AVAILABLE'),
-- Hotel 8: Mason Pine - Residential Meeting Twin Share (12 rooms)
(8, 16, '1401', 14, 0, 'AVAILABLE'), (8, 16, '1402', 14, 0, 'AVAILABLE'), (8, 16, '1403', 14, 0, 'AVAILABLE'), 
(8, 16, '1404', 14, 0, 'AVAILABLE'), (8, 16, '1405', 14, 0, 'AVAILABLE'),
(8, 16, '1406', 14, 1, 'AVAILABLE'), (8, 16, '1407', 14, 1, 'AVAILABLE'), (8, 16, '1408', 14, 1, 'AVAILABLE'), 
(8, 16, '1409', 14, 1, 'AVAILABLE'), (8, 16, '1410', 14, 1, 'AVAILABLE'),
(8, 16, '1411', 14, 1, 'AVAILABLE'), (8, 16, '1412', 14, 1, 'AVAILABLE'),

-- Hotel 9: R Hotel Rancamaya - Residential Meeting Single (5 rooms)
(9, 17, '101', 1, 0, 'AVAILABLE'), (9, 17, '102', 1, 0, 'AVAILABLE'), (9, 17, '103', 1, 0, 'AVAILABLE'), 
(9, 17, '104', 1, 0, 'AVAILABLE'), (9, 17, '105', 1, 0, 'AVAILABLE'),
-- Hotel 9: R Hotel Rancamaya - Residential Meeting Twin Share (10 rooms)
(9, 18, '201', 2, 0, 'AVAILABLE'), (9, 18, '202', 2, 0, 'AVAILABLE'), (9, 18, '203', 2, 0, 'AVAILABLE'), 
(9, 18, '204', 2, 0, 'AVAILABLE'), (9, 18, '205', 2, 0, 'AVAILABLE'),
(9, 18, '206', 2, 1, 'AVAILABLE'), (9, 18, '207', 2, 1, 'AVAILABLE'), (9, 18, '208', 2, 1, 'AVAILABLE'), 
(9, 18, '209', 2, 1, 'AVAILABLE'), (9, 18, '210', 2, 1, 'AVAILABLE'),

-- Hotel 10: Royal Tulip - Residential Meeting Single (5 rooms)
(10, 19, '301', 3, 0, 'AVAILABLE'), (10, 19, '302', 3, 0, 'AVAILABLE'), (10, 19, '303', 3, 0, 'AVAILABLE'), 
(10, 19, '304', 3, 0, 'AVAILABLE'), (10, 19, '305', 3, 0, 'AVAILABLE'),
-- Hotel 10: Royal Tulip - Residential Meeting Twin Share (10 rooms)
(10, 20, '401', 4, 0, 'AVAILABLE'), (10, 20, '402', 4, 0, 'AVAILABLE'), (10, 20, '403', 4, 0, 'AVAILABLE'), 
(10, 20, '404', 4, 0, 'AVAILABLE'), (10, 20, '405', 4, 0, 'AVAILABLE'),
(10, 20, '406', 4, 1, 'AVAILABLE'), (10, 20, '407', 4, 1, 'AVAILABLE'), (10, 20, '408', 4, 1, 'AVAILABLE'), 
(10, 20, '409', 4, 1, 'AVAILABLE'), (10, 20, '410', 4, 1, 'AVAILABLE'),

-- Hotel 11: Novotel Bogor - Residential Meeting Single (6 rooms)
(11, 21, '501', 5, 0, 'AVAILABLE'), (11, 21, '502', 5, 0, 'AVAILABLE'), (11, 21, '503', 5, 0, 'AVAILABLE'), 
(11, 21, '504', 5, 0, 'AVAILABLE'), (11, 21, '505', 5, 0, 'AVAILABLE'),
(11, 21, '506', 5, 1, 'AVAILABLE'),
-- Hotel 11: Novotel Bogor - Residential Meeting Twin Share (12 rooms)
(11, 22, '601', 6, 0, 'AVAILABLE'), (11, 22, '602', 6, 0, 'AVAILABLE'), (11, 22, '603', 6, 0, 'AVAILABLE'), 
(11, 22, '604', 6, 0, 'AVAILABLE'), (11, 22, '605', 6, 0, 'AVAILABLE'),
(11, 22, '606', 6, 1, 'AVAILABLE'), (11, 22, '607', 6, 1, 'AVAILABLE'), (11, 22, '608', 6, 1, 'AVAILABLE'), 
(11, 22, '609', 6, 1, 'AVAILABLE'), (11, 22, '610', 6, 1, 'AVAILABLE'),
(11, 22, '611', 6, 1, 'AVAILABLE'), (11, 22, '612', 6, 1, 'AVAILABLE'),

-- Hotel 12: Pesona Alam - Residential Meeting Single (4 rooms)
(12, 23, '701', 7, 0, 'AVAILABLE'), (12, 23, '702', 7, 0, 'AVAILABLE'), (12, 23, '703', 7, 0, 'AVAILABLE'), 
(12, 23, '704', 7, 0, 'AVAILABLE'),
-- Hotel 12: Pesona Alam - Residential Meeting Twin Share (8 rooms)
(12, 24, '801', 8, 0, 'AVAILABLE'), (12, 24, '802', 8, 0, 'AVAILABLE'), (12, 24, '803', 8, 0, 'AVAILABLE'), 
(12, 24, '804', 8, 0, 'AVAILABLE'), (12, 24, '805', 8, 0, 'AVAILABLE'),
(12, 24, '806', 8, 1, 'AVAILABLE'), (12, 24, '807', 8, 1, 'AVAILABLE'), (12, 24, '808', 8, 1, 'AVAILABLE'),

-- Hotel 13: Aston Bogor - Residential Meeting Single (7 rooms)
(13, 25, '901', 9, 0, 'AVAILABLE'), (13, 25, '902', 9, 0, 'AVAILABLE'), (13, 25, '903', 9, 0, 'AVAILABLE'), 
(13, 25, '904', 9, 0, 'AVAILABLE'), (13, 25, '905', 9, 0, 'AVAILABLE'),
(13, 25, '906', 9, 1, 'AVAILABLE'), (13, 25, '907', 9, 1, 'AVAILABLE'),
-- Hotel 13: Aston Bogor - Residential Meeting Twin Share (14 rooms)
(13, 26, '1001', 10, 0, 'AVAILABLE'), (13, 26, '1002', 10, 0, 'AVAILABLE'), (13, 26, '1003', 10, 0, 'AVAILABLE'), 
(13, 26, '1004', 10, 0, 'AVAILABLE'), (13, 26, '1005', 10, 0, 'AVAILABLE'),
(13, 26, '1006', 10, 1, 'AVAILABLE'), (13, 26, '1007', 10, 1, 'AVAILABLE'), (13, 26, '1008', 10, 1, 'AVAILABLE'), 
(13, 26, '1009', 10, 1, 'AVAILABLE'), (13, 26, '1010', 10, 1, 'AVAILABLE'),
(13, 26, '1011', 10, 1, 'AVAILABLE'), (13, 26, '1012', 10, 1, 'AVAILABLE'), (13, 26, '1013', 10, 1, 'AVAILABLE'), 
(13, 26, '1014', 10, 1, 'AVAILABLE'),

-- Hotel 14: Renaissance Bali - Residential Meeting Single (8 rooms)
(14, 27, '101', 1, 0, 'AVAILABLE'), (14, 27, '102', 1, 0, 'AVAILABLE'), (14, 27, '103', 1, 0, 'AVAILABLE'), 
(14, 27, '104', 1, 0, 'AVAILABLE'), (14, 27, '105', 1, 0, 'AVAILABLE'),
(14, 27, '106', 1, 1, 'AVAILABLE'), (14, 27, '107', 1, 1, 'AVAILABLE'), (14, 27, '108', 1, 1, 'AVAILABLE'),
-- Hotel 14: Renaissance Bali - Residential Meeting Twin Share (15 rooms)
(14, 28, '201', 2, 0, 'AVAILABLE'), (14, 28, '202', 2, 0, 'AVAILABLE'), (14, 28, '203', 2, 0, 'AVAILABLE'), 
(14, 28, '204', 2, 0, 'AVAILABLE'), (14, 28, '205', 2, 0, 'AVAILABLE'),
(14, 28, '206', 2, 1, 'AVAILABLE'), (14, 28, '207', 2, 1, 'AVAILABLE'), (14, 28, '208', 2, 1, 'AVAILABLE'), 
(14, 28, '209', 2, 1, 'AVAILABLE'), (14, 28, '210', 2, 1, 'AVAILABLE'),
(14, 28, '211', 2, 1, 'AVAILABLE'), (14, 28, '212', 2, 1, 'AVAILABLE'), (14, 28, '213', 2, 1, 'AVAILABLE'), 
(14, 28, '214', 2, 1, 'AVAILABLE'), (14, 28, '215', 2, 1, 'AVAILABLE'),

-- Hotel 15: Holiday Inn Bali - Residential Meeting Single (6 rooms)
(15, 29, '301', 3, 0, 'AVAILABLE'), (15, 29, '302', 3, 0, 'AVAILABLE'), (15, 29, '303', 3, 0, 'AVAILABLE'), 
(15, 29, '304', 3, 0, 'AVAILABLE'), (15, 29, '305', 3, 0, 'AVAILABLE'),
(15, 29, '306', 3, 1, 'AVAILABLE'),
-- Hotel 15: Holiday Inn Bali - Residential Meeting Twin Share (12 rooms)
(15, 30, '401', 4, 0, 'AVAILABLE'), (15, 30, '402', 4, 0, 'AVAILABLE'), (15, 30, '403', 4, 0, 'AVAILABLE'), 
(15, 30, '404', 4, 0, 'AVAILABLE'), (15, 30, '405', 4, 0, 'AVAILABLE'),
(15, 30, '406', 4, 1, 'AVAILABLE'), (15, 30, '407', 4, 1, 'AVAILABLE'), (15, 30, '408', 4, 1, 'AVAILABLE'), 
(15, 30, '409', 4, 1, 'AVAILABLE'), (15, 30, '410', 4, 1, 'AVAILABLE'),
(15, 30, '411', 4, 1, 'AVAILABLE'), (15, 30, '412', 4, 1, 'AVAILABLE'),

-- Hotel 16: Kuta Beach Heritage - Residential Meeting Single (5 rooms)
(16, 31, '501', 5, 0, 'AVAILABLE'), (16, 31, '502', 5, 0, 'AVAILABLE'), (16, 31, '503', 5, 0, 'AVAILABLE'), 
(16, 31, '504', 5, 0, 'AVAILABLE'), (16, 31, '505', 5, 0, 'AVAILABLE'),
-- Hotel 16: Kuta Beach Heritage - Residential Meeting Twin Share (10 rooms)
(16, 32, '601', 6, 0, 'AVAILABLE'), (16, 32, '602', 6, 0, 'AVAILABLE'), (16, 32, '603', 6, 0, 'AVAILABLE'), 
(16, 32, '604', 6, 0, 'AVAILABLE'), (16, 32, '605', 6, 0, 'AVAILABLE'),
(16, 32, '606', 6, 1, 'AVAILABLE'), (16, 32, '607', 6, 1, 'AVAILABLE'), (16, 32, '608', 6, 1, 'AVAILABLE'), 
(16, 32, '609', 6, 1, 'AVAILABLE'), (16, 32, '610', 6, 1, 'AVAILABLE'),

-- Hotel 17: Grand Mirage Bali - Residential Meeting Single (6 rooms)
(17, 33, '701', 7, 0, 'AVAILABLE'), (17, 33, '702', 7, 0, 'AVAILABLE'), (17, 33, '703', 7, 0, 'AVAILABLE'), 
(17, 33, '704', 7, 0, 'AVAILABLE'), (17, 33, '705', 7, 0, 'AVAILABLE'),
(17, 33, '706', 7, 1, 'AVAILABLE'),
-- Hotel 17: Grand Mirage Bali - Residential Meeting Twin Share (12 rooms)
(17, 34, '801', 8, 0, 'AVAILABLE'), (17, 34, '802', 8, 0, 'AVAILABLE'), (17, 34, '803', 8, 0, 'AVAILABLE'), 
(17, 34, '804', 8, 0, 'AVAILABLE'), (17, 34, '805', 8, 0, 'AVAILABLE'),
(17, 34, '806', 8, 1, 'AVAILABLE'), (17, 34, '807', 8, 1, 'AVAILABLE'), (17, 34, '808', 8, 1, 'AVAILABLE'), 
(17, 34, '809', 8, 1, 'AVAILABLE'), (17, 34, '810', 8, 1, 'AVAILABLE'),
(17, 34, '811', 8, 1, 'AVAILABLE'), (17, 34, '812', 8, 1, 'AVAILABLE'),

-- Hotel 18: Hotel Mulia - Residential Meeting Single (10 rooms)
(18, 35, '101', 1, 0, 'AVAILABLE'), (18, 35, '102', 1, 0, 'AVAILABLE'), (18, 35, '103', 1, 0, 'AVAILABLE'), 
(18, 35, '104', 1, 0, 'AVAILABLE'), (18, 35, '105', 1, 0, 'AVAILABLE'),
(18, 35, '106', 1, 1, 'AVAILABLE'), (18, 35, '107', 1, 1, 'AVAILABLE'), (18, 35, '108', 1, 1, 'AVAILABLE'), 
(18, 35, '109', 1, 1, 'AVAILABLE'), (18, 35, '110', 1, 1, 'AVAILABLE'),
-- Hotel 18: Hotel Mulia - Residential Meeting Twin Share (20 rooms)
(18, 36, '201', 2, 0, 'AVAILABLE'), (18, 36, '202', 2, 0, 'AVAILABLE'), (18, 36, '203', 2, 0, 'AVAILABLE'), 
(18, 36, '204', 2, 0, 'AVAILABLE'), (18, 36, '205', 2, 0, 'AVAILABLE'),
(18, 36, '206', 2, 1, 'AVAILABLE'), (18, 36, '207', 2, 1, 'AVAILABLE'), (18, 36, '208', 2, 1, 'AVAILABLE'), 
(18, 36, '209', 2, 1, 'AVAILABLE'), (18, 36, '210', 2, 1, 'AVAILABLE'),
(18, 36, '211', 2, 1, 'AVAILABLE'), (18, 36, '212', 2, 1, 'AVAILABLE'), (18, 36, '213', 2, 1, 'AVAILABLE'), 
(18, 36, '214', 2, 1, 'AVAILABLE'), (18, 36, '215', 2, 1, 'AVAILABLE'),
(18, 36, '216', 2, 1, 'AVAILABLE'), (18, 36, '217', 2, 1, 'AVAILABLE'), (18, 36, '218', 2, 1, 'AVAILABLE'), 
(18, 36, '219', 2, 1, 'AVAILABLE'), (18, 36, '220', 2, 1, 'AVAILABLE'),

-- Hotel 19: Hotel Borobudur - Residential Meeting Single (8 rooms)
(19, 37, '301', 3, 0, 'AVAILABLE'), (19, 37, '302', 3, 0, 'AVAILABLE'), (19, 37, '303', 3, 0, 'AVAILABLE'), 
(19, 37, '304', 3, 0, 'AVAILABLE'), (19, 37, '305', 3, 0, 'AVAILABLE'),
(19, 37, '306', 3, 1, 'AVAILABLE'), (19, 37, '307', 3, 1, 'AVAILABLE'), (19, 37, '308', 3, 1, 'AVAILABLE'),
-- Hotel 19: Hotel Borobudur - Residential Meeting Twin Share (15 rooms)
(19, 38, '401', 4, 0, 'AVAILABLE'), (19, 38, '402', 4, 0, 'AVAILABLE'), (19, 38, '403', 4, 0, 'AVAILABLE'), 
(19, 38, '404', 4, 0, 'AVAILABLE'), (19, 38, '405', 4, 0, 'AVAILABLE'),
(19, 38, '406', 4, 1, 'AVAILABLE'), (19, 38, '407', 4, 1, 'AVAILABLE'), (19, 38, '408', 4, 1, 'AVAILABLE'), 
(19, 38, '409', 4, 1, 'AVAILABLE'), (19, 38, '410', 4, 1, 'AVAILABLE'),
(19, 38, '411', 4, 1, 'AVAILABLE'), (19, 38, '412', 4, 1, 'AVAILABLE'), (19, 38, '413', 4, 1, 'AVAILABLE'), 
(19, 38, '414', 4, 1, 'AVAILABLE'), (19, 38, '415', 4, 1, 'AVAILABLE'),

-- Hotel 20: Jambuluwuk Malioboro - Residential Meeting Single (5 rooms)
(20, 39, '501', 5, 0, 'AVAILABLE'), (20, 39, '502', 5, 0, 'AVAILABLE'), (20, 39, '503', 5, 0, 'AVAILABLE'), 
(20, 39, '504', 5, 0, 'AVAILABLE'), (20, 39, '505', 5, 0, 'AVAILABLE'),
-- Hotel 20: Jambuluwuk Malioboro - Residential Meeting Twin Share (10 rooms)
(20, 40, '601', 6, 0, 'AVAILABLE'), (20, 40, '602', 6, 0, 'AVAILABLE'), (20, 40, '603', 6, 0, 'AVAILABLE'), 
(20, 40, '604', 6, 0, 'AVAILABLE'), (20, 40, '605', 6, 0, 'AVAILABLE'),
(20, 40, '606', 6, 1, 'AVAILABLE'), (20, 40, '607', 6, 1, 'AVAILABLE'), (20, 40, '608', 6, 1, 'AVAILABLE'), 
(20, 40, '609', 6, 1, 'AVAILABLE'), (20, 40, '610', 6, 1, 'AVAILABLE'),

-- Hotel 21: Green Peak Puncak - Residential Meeting Single (4 rooms)
(21, 41, '701', 7, 0, 'AVAILABLE'), (21, 41, '702', 7, 0, 'AVAILABLE'), (21, 41, '703', 7, 0, 'AVAILABLE'), 
(21, 41, '704', 7, 0, 'AVAILABLE'),
-- Hotel 21: Green Peak Puncak - Residential Meeting Twin Share (8 rooms)
(21, 42, '801', 8, 0, 'AVAILABLE'), (21, 42, '802', 8, 0, 'AVAILABLE'), (21, 42, '803', 8, 0, 'AVAILABLE'), 
(21, 42, '804', 8, 0, 'AVAILABLE'), (21, 42, '805', 8, 0, 'AVAILABLE'),
(21, 42, '806', 8, 1, 'AVAILABLE'), (21, 42, '807', 8, 1, 'AVAILABLE'), (21, 42, '808', 8, 1, 'AVAILABLE');

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

INSERT INTO `room_types` (`id`, `hotel_id`, `type_name`, `description`, `price_per_person`, `min_capacity`, `max_capacity`, `available_rooms`, `amenities`, `created_at`, `updated_at`) VALUES
(1, 1, 'Residential Meeting Single', 'Full board package with single bed room, meeting room, meals, coffee breaks', 3100000.00, 20, 100, 5, 'AC, LCD Projector, Sound System, WiFi, Meals 3x, Coffee Break 2x', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(2, 1, 'Residential Meeting Twin Share', 'Full board package with twin share room, meeting room, meals, coffee breaks', 2500000.00, 20, 100, 10, 'AC, LCD Projector, Sound System, WiFi, Meals 3x, Coffee Break 2x', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(3, 2, 'Residential Meeting Single', 'Premium meeting package with luxury accommodation', 2000000.00, 15, 80, 5, 'AC, LED Screen, Audio System, High-Speed WiFi, Meals, Snacks', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(4, 2, 'Residential Meeting Twin Share', 'Premium meeting package with shared accommodation', 1600000.00, 15, 80, 10, 'AC, LED Screen, Audio System, High-Speed WiFi, Meals, Snacks', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(5, 3, 'Residential Meeting Single', 'Convention package with mountain view', 1200000.00, 30, 150, 8, 'AC, Projector, Microphone, WiFi, Full Board Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(6, 3, 'Residential Meeting Twin Share', 'Convention package with shared room', 950000.00, 30, 150, 15, 'AC, Projector, Microphone, WiFi, Full Board Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(7, 4, 'Residential Meeting Single', 'Standard meeting package with city view', 800000.00, 10, 50, 5, 'AC, Projector, WiFi, Meals 3x', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(8, 4, 'Residential Meeting Twin Share', 'Standard meeting package twin room', 650000.00, 10, 50, 10, 'AC, Projector, WiFi, Meals 3x', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(9, 5, 'Residential Meeting Single', 'International MICE package premium', 2500000.00, 20, 200, 10, 'Smart Board, Video Conference, Premium Meals, Executive Lounge', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(10, 5, 'Residential Meeting Twin Share', 'International MICE package standard', 2000000.00, 20, 200, 15, 'Smart Board, Video Conference, Premium Meals, Executive Lounge', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(11, 6, 'Residential Meeting Single', 'Luxury ballroom meeting package', 2200000.00, 25, 150, 8, 'LED Wall, Professional Sound, Gourmet Meals, Spa Access', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(12, 6, 'Residential Meeting Twin Share', 'Luxury meeting package shared', 1800000.00, 25, 150, 12, 'LED Wall, Professional Sound, Gourmet Meals, Spa Access', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(13, 7, 'Residential Meeting Single', 'Executive suite meeting package', 1800000.00, 10, 40, 4, 'Private Meeting Room, Butler Service, Premium Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(14, 7, 'Residential Meeting Twin Share', 'Executive meeting package shared', 1400000.00, 10, 40, 8, 'Private Meeting Room, Butler Service, Premium Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(15, 8, 'Residential Meeting Single', 'Modern meeting package affordable', 900000.00, 15, 60, 6, 'Smart TV, WiFi, Standard Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(16, 8, 'Residential Meeting Twin Share', 'Modern meeting package budget', 700000.00, 15, 60, 12, 'Smart TV, WiFi, Standard Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(17, 9, 'Residential Meeting Single', 'Golf resort meeting package premium', 1900000.00, 20, 80, 5, 'Golf Access, Meeting Room, Spa, Full Board', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(18, 9, 'Residential Meeting Twin Share', 'Golf resort meeting package standard', 1500000.00, 20, 80, 10, 'Golf Access, Meeting Room, Spa, Full Board', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(19, 10, 'Residential Meeting Single', 'Mountain view meeting package', 1700000.00, 15, 70, 5, 'Outdoor Activities, Meeting Hall, Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(20, 10, 'Residential Meeting Twin Share', 'Mountain view shared package', 1350000.00, 15, 70, 10, 'Outdoor Activities, Meeting Hall, Meals', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(21, 11, 'Residential Meeting Single', 'International golf meeting package', 1650000.00, 20, 90, 6, 'Golf Course, Convention Hall, International Cuisine', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(22, 11, 'Residential Meeting Twin Share', 'International meeting shared', 1300000.00, 20, 90, 12, 'Golf Course, Convention Hall, International Cuisine', '2025-11-13 04:04:40', '2025-11-13 04:04:40'),
(23, 12, 'Residential Meeting Single', 'Nature retreat meeting package', 1500000.00, 15, 60, 4, 'Nature Activities, Spa, Organic Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(24, 12, 'Residential Meeting Twin Share', 'Nature retreat shared package', 1200000.00, 15, 60, 8, 'Nature Activities, Spa, Organic Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(25, 13, 'Residential Meeting Single', 'City convention meeting package', 1400000.00, 20, 100, 7, 'Convention Center, City Access, Business Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(26, 13, 'Residential Meeting Twin Share', 'City convention shared', 1100000.00, 20, 100, 14, 'Convention Center, City Access, Business Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(27, 14, 'Residential Meeting Single', 'Luxury Bali MICE package', 2000000.00, 25, 120, 8, 'Beach Access, Ballroom, Water Sports, Gala Dinner', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(28, 14, 'Residential Meeting Twin Share', 'Luxury Bali meeting shared', 1600000.00, 25, 120, 15, 'Beach Access, Ballroom, Water Sports, Gala Dinner', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(29, 15, 'Residential Meeting Single', 'Beach resort meeting package', 1900000.00, 20, 100, 6, 'Beach Activities, Meeting Rooms, Sunset Dinner', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(30, 15, 'Residential Meeting Twin Share', 'Beach resort shared package', 1500000.00, 20, 100, 12, 'Beach Activities, Meeting Rooms, Sunset Dinner', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(31, 16, 'Residential Meeting Single', 'Beachfront meeting package', 1300000.00, 15, 70, 5, 'Ocean View, Meeting Space, Balinese Cuisine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(32, 16, 'Residential Meeting Twin Share', 'Beachfront shared package', 1000000.00, 15, 70, 10, 'Ocean View, Meeting Space, Balinese Cuisine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(33, 17, 'Residential Meeting Single', 'All-inclusive meeting package', 1600000.00, 20, 90, 6, 'All Meals, Activities, Team Building, Meeting Hall', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(34, 17, 'Residential Meeting Twin Share', 'All-inclusive shared package', 1250000.00, 20, 90, 12, 'All Meals, Activities, Team Building, Meeting Hall', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(35, 18, 'Residential Meeting Single', 'Presidential meeting package', 2100000.00, 30, 200, 10, 'Grand Ballroom, VIP Service, Fine Dining, Limousine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(36, 18, 'Residential Meeting Twin Share', 'Presidential shared package', 1700000.00, 30, 200, 20, 'Grand Ballroom, VIP Service, Fine Dining, Limousine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(37, 19, 'Residential Meeting Single', 'Heritage meeting package', 1900000.00, 25, 150, 8, 'Classic Ballroom, Cultural Experience, Premium Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(38, 19, 'Residential Meeting Twin Share', 'Heritage shared package', 1500000.00, 25, 150, 15, 'Classic Ballroom, Cultural Experience, Premium Meals', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(39, 20, 'Residential Meeting Single', 'Cultural meeting package', 1200000.00, 15, 60, 5, 'Batik Workshop, Meeting Room, Local Cuisine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(40, 20, 'Residential Meeting Twin Share', 'Cultural shared package', 950000.00, 15, 60, 10, 'Batik Workshop, Meeting Room, Local Cuisine', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(41, 21, 'Residential Meeting Single', 'Mountain retreat meeting package', 1100000.00, 10, 50, 4, 'Fresh Air, Nature Walk, Outdoor Meeting', '2025-11-13 04:04:41', '2025-11-13 04:04:41'),
(42, 21, 'Residential Meeting Twin Share', 'Mountain retreat shared', 850000.00, 10, 50, 8, 'Fresh Air, Nature Walk, Outdoor Meeting', '2025-11-13 04:04:41', '2025-11-13 04:04:41');

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

--
-- Indexes for table `hotel_rooms`
--
ALTER TABLE `hotel_rooms`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_room_number` (`hotel_id`,`room_number`),
  ADD KEY `idx_hotel_id` (`hotel_id`),
  ADD KEY `idx_room_type_id` (`room_type_id`),
  ADD KEY `idx_blockchain_enabled` (`is_blockchain_enabled`),
  ADD KEY `idx_status` (`status`);

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
  ADD KEY `idx_event_type` (`event_type`);

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
-- Indexes for table `reservation_history`
--
ALTER TABLE `reservation_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reservation_id` (`reservation_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_performed_at` (`performed_at`);

--
-- Indexes for table `room_types`
--
ALTER TABLE `room_types`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_hotel_id` (`hotel_id`),
  ADD KEY `idx_price` (`price_per_person`),
  ADD KEY `idx_capacity` (`min_capacity`,`max_capacity`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `hotel_rooms`
--
ALTER TABLE `hotel_rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hotels`
--
ALTER TABLE `hotels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservation_history`
--
ALTER TABLE `reservation_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `room_reservations`
--
ALTER TABLE `room_reservations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `room_types`
--
ALTER TABLE `room_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- Constraints for dumped tables
--

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
