-- Check user_id in reservations
USE reservation;

-- Check structure - apakah ada kolom user_id?
SHOW COLUMNS FROM reservations LIKE 'user_id';

-- Check data - apakah user_id terisi?
SELECT 
    id,
    user_id,
    reservation_id,
    hotel_id,
    customer_name,
    customer_email,
    status,
    payment_status,
    created_at
FROM reservations 
ORDER BY created_at DESC;

-- Check berapa yang punya user_id NULL
SELECT 
    COUNT(*) as total,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) as null_user_id,
    SUM(CASE WHEN user_id IS NOT NULL THEN 1 ELSE 0 END) as has_user_id
FROM reservations;
