-- Check bookings data
USE reservation;

-- Check total reservations
SELECT COUNT(*) as total_reservations FROM reservations;

-- Check latest 10 reservations
SELECT 
    id,
    reservation_id,
    hotel_id,
    customer_name,
    customer_email,
    status,
    payment_status,
    total_price,
    check_in,
    created_at
FROM reservations 
ORDER BY created_at DESC 
LIMIT 10;

-- Check reservations by status
SELECT 
    status,
    payment_status,
    COUNT(*) as count
FROM reservations
GROUP BY status, payment_status;

-- Check if user exists
SELECT 
    id,
    email,
    full_name,
    role,
    hotel_id
FROM users
WHERE email = 'musuapadi@gmail.com';
