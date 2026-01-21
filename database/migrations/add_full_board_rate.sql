-- Migration: Add full_board_rate column to room_types table
-- Date: 2026-01-16
-- Description: Menambahkan kolom full_board_rate untuk paket Full Board (2x Coffee Break + 2x Meals)

USE reservation;

-- Add full_board_rate column if not exists
SET @col_exists_full_board = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'reservation' 
    AND TABLE_NAME = 'room_types' 
    AND COLUMN_NAME = 'full_board_rate'
);

SET @sql_full_board = IF(@col_exists_full_board = 0,
    'ALTER TABLE room_types ADD COLUMN full_board_rate DECIMAL(10,2) DEFAULT NULL AFTER full_day_rate',
    'SELECT ''Column full_board_rate already exists'' AS message'
);
PREPARE stmt FROM @sql_full_board;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Verify the changes
SELECT 
    COLUMN_NAME,
    COLUMN_TYPE,
    COLUMN_DEFAULT,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'reservation' 
AND TABLE_NAME = 'room_types' 
AND COLUMN_NAME LIKE '%rate';

SELECT 'Migration completed successfully! ✓' AS message;
