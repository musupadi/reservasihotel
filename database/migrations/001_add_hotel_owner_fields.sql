-- Migration: Add owner and status fields to hotels table
-- Date: 2026-01-10
-- Purpose: Support hotel registration with owner information

USE reservation;

-- Add new columns to hotels table
ALTER TABLE `hotels` 
ADD COLUMN `owner_id` int(11) DEFAULT NULL COMMENT 'Super admin user ID' AFTER `image_url`,
ADD COLUMN `owner_name` varchar(255) DEFAULT NULL AFTER `owner_id`,
ADD COLUMN `owner_phone` varchar(20) DEFAULT NULL AFTER `owner_name`,
ADD COLUMN `owner_email` varchar(255) DEFAULT NULL AFTER `owner_phone`,
ADD COLUMN `status` varchar(20) DEFAULT 'active' COMMENT 'active, inactive, pending' AFTER `owner_email`;

-- Add foreign key constraint (optional)
-- ALTER TABLE `hotels` 
-- ADD CONSTRAINT `fk_hotels_owner` 
-- FOREIGN KEY (`owner_id`) REFERENCES `users`(`id`) ON DELETE SET NULL;

-- Create index for better query performance
CREATE INDEX `idx_hotels_owner_id` ON `hotels`(`owner_id`);
CREATE INDEX `idx_hotels_status` ON `hotels`(`status`);

-- Verify changes
DESCRIBE hotels;

-- Show success message
SELECT 'Migration 001 completed successfully!' AS message;
