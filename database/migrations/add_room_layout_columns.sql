-- ==========================================
-- MIGRATION: Add Room Layout Support
-- Version: 1.0
-- Date: 2026-01-16
-- Description: Add columns for room layout/denah functionality
--              Allows hotel admin to visually arrange rooms on a floor plan
-- ==========================================

USE reservation;

-- Step 1: Add layout columns to hotel_rooms table
ALTER TABLE hotel_rooms 
ADD COLUMN layout_x INT DEFAULT NULL COMMENT 'Koordinat X di denah (0-100 scale, percentage)',
ADD COLUMN layout_y INT DEFAULT NULL COMMENT 'Koordinat Y di denah (0-100 scale, percentage)',
ADD COLUMN layout_width INT DEFAULT 1 COMMENT 'Lebar kamar di grid (default 1 unit)',
ADD COLUMN layout_height INT DEFAULT 1 COMMENT 'Tinggi kamar di grid (default 1 unit)',
ADD COLUMN layout_updated_at TIMESTAMP NULL DEFAULT NULL COMMENT 'Last time layout was modified';

-- Step 2: Create indexes for better query performance
CREATE INDEX idx_hotel_rooms_floor ON hotel_rooms(hotel_id, floor);
CREATE INDEX idx_hotel_rooms_type_floor ON hotel_rooms(hotel_id, room_type_id, floor);

-- Step 3: Add sample layout data for testing (Optional)
-- Auto-arrange Hotel 1, Floor 2 rooms in a grid pattern (5 columns)

-- For Hotel 1, Floor 2 - arrange in 5 columns with 20% width spacing
UPDATE hotel_rooms 
SET 
  layout_x = (((@row_number := @row_number + 1) - 1) % 5) * 20,
  layout_y = FLOOR(((@row_number2 := @row_number2 + 1) - 1) / 5) * 25,
  layout_width = 1,
  layout_height = 1,
  layout_updated_at = NOW()
WHERE hotel_id = 1 AND floor = 2;

-- Reset variables
SET @row_number = 0;
SET @row_number2 = 0;

-- For Hotel 2, Floor 3 - arrange in 5 columns
UPDATE hotel_rooms 
SET 
  layout_x = (((@row_number := @row_number + 1) - 1) % 5) * 20,
  layout_y = FLOOR(((@row_number2 := @row_number2 + 1) - 1) / 5) * 25,
  layout_width = 1,
  layout_height = 1,
  layout_updated_at = NOW()
WHERE hotel_id = 2 AND floor = 3;

-- Step 4: Verify the changes
SELECT 
  id,
  hotel_id,
  room_number,
  floor,
  layout_x,
  layout_y,
  layout_width,
  layout_height,
  layout_updated_at
FROM hotel_rooms 
WHERE hotel_id IN (1, 2) AND floor IN (2, 3)
ORDER BY hotel_id, floor, room_number;

-- ==========================================
-- ROLLBACK SCRIPT (if needed)
-- ==========================================
-- To remove these changes, run:
/*
DROP INDEX idx_hotel_rooms_floor ON hotel_rooms;
DROP INDEX idx_hotel_rooms_type_floor ON hotel_rooms;

ALTER TABLE hotel_rooms 
DROP COLUMN layout_x,
DROP COLUMN layout_y,
DROP COLUMN layout_width,
DROP COLUMN layout_height,
DROP COLUMN layout_updated_at;
*/

-- ==========================================
-- NOTES:
-- ==========================================
-- 1. layout_x and layout_y are percentages (0-100) of the canvas size
-- 2. This allows responsive layouts regardless of screen size
-- 3. layout_width and layout_height are in grid units (default 1)
-- 4. NULL values mean the room hasn't been positioned yet
-- 5. Hotel admins can drag & drop rooms to set positions
-- 6. Auto-arrange feature can populate these values automatically
