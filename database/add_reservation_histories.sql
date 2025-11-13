-- Add/update reservation_history table for tracking status changes
-- This table already exists but we need to ensure it's properly set up
-- Run this file after running add_users_table.sql

USE reservation;

-- Drop the old table if it exists with different structure
DROP TABLE IF EXISTS `reservation_history`;

-- Create reservation_history table with correct structure matching the code
CREATE TABLE `reservation_history` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `reservation_id` VARCHAR(100) NOT NULL,
  `action` VARCHAR(50) NOT NULL COMMENT 'Action performed: CREATED, CONFIRMED, CANCELLED, etc',
  `status` VARCHAR(50) NOT NULL COMMENT 'New status after action',
  `note` TEXT COMMENT 'Additional notes about the status change',
  `performed_by` VARCHAR(100) DEFAULT NULL COMMENT 'MSP or user who performed the action',
  `performed_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_reservation_id (`reservation_id`),
  INDEX idx_action (`action`),
  INDEX idx_performed_at (`performed_at`),
  FOREIGN KEY (`reservation_id`) REFERENCES `reservations`(`reservation_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Add history entries for existing reservations (if any)
INSERT INTO `reservation_history` (`reservation_id`, `action`, `status`, `note`, `performed_by`)
SELECT 
  `reservation_id`,
  'CREATED' as action,
  `status`,
  CONCAT('Reservation created for hotel ', `hotel_id`, ' - ', `event_type`) as note,
  `created_by_org` as performed_by
FROM `reservations`
WHERE NOT EXISTS (
  SELECT 1 FROM `reservation_history` 
  WHERE `reservation_history`.`reservation_id` = `reservations`.`reservation_id`
);

SELECT 'reservation_history table updated successfully!' as Status;
