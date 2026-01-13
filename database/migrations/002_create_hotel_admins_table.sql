-- Migration: Create hotel_admins table
-- Date: 2026-01-10
-- Purpose: Store hotel admin/staff mappings with permissions

USE reservation;

-- Create hotel_admins table
CREATE TABLE IF NOT EXISTS `hotel_admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hotel_id` int(11) NOT NULL COMMENT 'Reference to hotels table',
  `user_id` int(11) NOT NULL COMMENT 'Reference to users table',
  `role` varchar(50) DEFAULT 'staff' COMMENT 'super_admin, admin, manager, staff',
  `permissions` json DEFAULT NULL COMMENT 'JSON object with permission flags',
  `assigned_by` int(11) DEFAULT NULL COMMENT 'User ID who assigned this admin',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_hotel_user` (`hotel_id`, `user_id`),
  KEY `idx_hotel_id` (`hotel_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_role` (`role`),
  CONSTRAINT `fk_hotel_admins_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_hotel_admins_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Hotel administrators and staff mapping';

-- Verify table created
DESCRIBE hotel_admins;

-- Show success message
SELECT 'Migration 002: hotel_admins table created successfully!' AS message;
