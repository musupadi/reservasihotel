-- =============================================
-- FIX ROOM DIMENSIONS
-- Update layout_width dan layout_height ke ukuran pixel yang proper
-- =============================================

-- Update Hotel Rooms (Standard/Deluxe/Superior rooms): 90px x 70px
UPDATE hotel_rooms 
SET layout_width = 90, layout_height = 70
WHERE room_number NOT LIKE 'M-%'  -- Exclude meeting rooms
AND layout_width < 50;  -- Only update if current value is small

-- Update Executive/Premium Suites: 110px x 85px (lebih besar)
UPDATE hotel_rooms 
SET layout_width = 110, layout_height = 85
WHERE room_type_id IN (3, 9, 15, 21, 27)  -- Executive/Premium/Presidential Suite types
AND room_number NOT LIKE 'M-%'
AND layout_width < 50;

-- Update Small Meeting Rooms (Sakura, Mawar, Cempaka, Dahlia, Anggrek): 120px x 90px
UPDATE hotel_rooms 
SET layout_width = 120, layout_height = 90
WHERE room_type_id IN (4, 10, 16, 22, 28)
AND room_number LIKE 'M-%'
AND layout_width < 50;

-- Update Medium Meeting Rooms (Melati, Mawar, Cempaka, Teratai, Kenanga): 150px x 100px
UPDATE hotel_rooms 
SET layout_width = 150, layout_height = 100
WHERE room_type_id IN (5, 11, 17, 23, 29)
AND room_number LIKE 'M-%'
AND layout_width < 50;

-- Update Large Ballrooms: 250px x 180px
UPDATE hotel_rooms 
SET layout_width = 250, layout_height = 180
WHERE room_type_id IN (6, 12, 18, 24, 30)
AND room_number LIKE 'M-%'
AND layout_width < 50;

-- Verify changes
SELECT 
    hr.id,
    hr.room_number,
    rt.type_name,
    hr.layout_width,
    hr.layout_height,
    hr.room_number LIKE 'M-%' as is_meeting_room
FROM hotel_rooms hr
LEFT JOIN room_types rt ON hr.room_type_id = rt.id
ORDER BY hr.hotel_id, hr.floor, hr.room_number
LIMIT 50;
