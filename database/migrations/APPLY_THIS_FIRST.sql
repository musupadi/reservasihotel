-- ============================================
-- IMPORTANT: RUN THIS FIRST!
-- Apply these migrations to fix register-hotel endpoint
-- ============================================

USE reservation;

-- 1. Check if users table exists, if not create it
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
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role`),
  KEY `idx_hotel_id` (`hotel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 2. Add missing columns to hotels table if they don't exist
ALTER TABLE `hotels` 
ADD COLUMN IF NOT EXISTS `owner_id` int(11) DEFAULT NULL COMMENT 'Super admin user ID' AFTER `image_url`,
ADD COLUMN IF NOT EXISTS `owner_name` varchar(255) DEFAULT NULL AFTER `owner_id`,
ADD COLUMN IF NOT EXISTS `owner_phone` varchar(20) DEFAULT NULL AFTER `owner_name`,
ADD COLUMN IF NOT EXISTS `owner_email` varchar(255) DEFAULT NULL AFTER `owner_phone`,
ADD COLUMN IF NOT EXISTS `status` varchar(20) DEFAULT 'active' COMMENT 'active, inactive, pending' AFTER `owner_email`,
ADD COLUMN IF NOT EXISTS `country` varchar(100) DEFAULT 'Indonesia' AFTER `city`;

-- 3. Create hotel_admins table if not exists
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
  KEY `idx_role` (`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Hotel administrators and staff mapping';

-- 4. Add indexes for better performance
CREATE INDEX IF NOT EXISTS `idx_hotels_owner_id` ON `hotels`(`owner_id`);
CREATE INDEX IF NOT EXISTS `idx_hotels_status` ON `hotels`(`status`);

-- 5. Show results
SELECT '✅ Migration completed successfully!' AS status;
SELECT 'Now restart your Go backend!' AS next_step;

-- Verify tables
SHOW TABLES;
