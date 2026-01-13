-- Migration: Remove calculated columns from room_types
-- These fields are now calculated on-the-fly from hotel_rooms table

ALTER TABLE room_types 
  DROP COLUMN total_rooms,
  DROP COLUMN blockchain_reserved_rooms,
  DROP COLUMN available_rooms;
