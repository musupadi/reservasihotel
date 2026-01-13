-- Migration: Add payment columns to reservations table
-- Date: 2026-01-12
-- Description: Menambahkan kolom payment_status, payment_method, dan payment_date

USE reservation;

-- Add payment_status column if not exists
SET @col_exists_status = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'reservation' 
    AND TABLE_NAME = 'reservations' 
    AND COLUMN_NAME = 'payment_status'
);

SET @sql_status = IF(@col_exists_status = 0,
    'ALTER TABLE reservations ADD COLUMN payment_status VARCHAR(20) DEFAULT ''unpaid'' AFTER status',
    'SELECT ''Column payment_status already exists'' AS message'
);
PREPARE stmt FROM @sql_status;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add payment_method column if not exists
SET @col_exists_method = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'reservation' 
    AND TABLE_NAME = 'reservations' 
    AND COLUMN_NAME = 'payment_method'
);

SET @sql_method = IF(@col_exists_method = 0,
    'ALTER TABLE reservations ADD COLUMN payment_method VARCHAR(50) DEFAULT NULL AFTER payment_status',
    'SELECT ''Column payment_method already exists'' AS message'
);
PREPARE stmt FROM @sql_method;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add payment_date column if not exists
SET @col_exists_date = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = 'reservation' 
    AND TABLE_NAME = 'reservations' 
    AND COLUMN_NAME = 'payment_date'
);

SET @sql_date = IF(@col_exists_date = 0,
    'ALTER TABLE reservations ADD COLUMN payment_date DATETIME DEFAULT NULL AFTER payment_method',
    'SELECT ''Column payment_date already exists'' AS message'
);
PREPARE stmt FROM @sql_date;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Update existing records to have unpaid status
UPDATE reservations 
SET payment_status = 'unpaid' 
WHERE payment_status IS NULL OR payment_status = '';

-- Create index if not exists
SET @index_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = 'reservation' 
    AND TABLE_NAME = 'reservations' 
    AND INDEX_NAME = 'idx_payment_status'
);

SET @sql_index = IF(@index_exists = 0,
    'CREATE INDEX idx_payment_status ON reservations(payment_status)',
    'SELECT ''Index idx_payment_status already exists'' AS message'
);
PREPARE stmt FROM @sql_index;
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
AND TABLE_NAME = 'reservations' 
AND COLUMN_NAME LIKE 'payment%';

SELECT 'Migration completed successfully! ✓' AS message;
