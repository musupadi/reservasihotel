-- Add Meeting Room Support
-- This migration adds fields to support meeting room bookings with hourly/session pricing

-- Add room category to distinguish hotel rooms from meeting rooms
ALTER TABLE room_types 
ADD COLUMN room_category ENUM('hotel_room', 'meeting_room') NOT NULL DEFAULT 'hotel_room' AFTER type_name;

-- Add pricing type field
ALTER TABLE room_types 
ADD COLUMN pricing_type ENUM('per_night', 'per_hour', 'half_day', 'full_day') NOT NULL DEFAULT 'per_night' AFTER price_per_person;

-- Add additional pricing fields for meeting rooms
ALTER TABLE room_types 
ADD COLUMN hourly_rate DECIMAL(10,2) DEFAULT NULL AFTER pricing_type,
ADD COLUMN half_day_rate DECIMAL(10,2) DEFAULT NULL AFTER hourly_rate,
ADD COLUMN full_day_rate DECIMAL(10,2) DEFAULT NULL AFTER half_day_rate;

-- Add time fields to reservations for meeting room bookings
ALTER TABLE room_reservations
ADD COLUMN start_time TIME DEFAULT NULL AFTER check_in,
ADD COLUMN end_time TIME DEFAULT NULL AFTER check_out,
ADD COLUMN booking_duration_hours DECIMAL(4,2) DEFAULT NULL AFTER end_time;

-- Add index for room category queries
ALTER TABLE room_types ADD INDEX idx_room_category (room_category);

-- Comment on columns
ALTER TABLE room_types 
MODIFY COLUMN room_category ENUM('hotel_room', 'meeting_room') NOT NULL DEFAULT 'hotel_room' 
COMMENT 'Type of room: hotel_room for overnight stays, meeting_room for hourly bookings';

ALTER TABLE room_types 
MODIFY COLUMN pricing_type ENUM('per_night', 'per_hour', 'half_day', 'full_day') NOT NULL DEFAULT 'per_night'
COMMENT 'Pricing model: per_night for hotels, per_hour/half_day/full_day for meeting rooms';
