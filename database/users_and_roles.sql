-- Users table with role support
CREATE TABLE IF NOT EXISTS users (
    id INT(11) PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    company VARCHAR(100),
    role ENUM('customer', 'hotel_admin', 'hotel_super_admin', 'system_admin') DEFAULT 'customer',
    hotel_id INT(11) DEFAULT NULL,
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE SET NULL,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_hotel_id (hotel_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Hotel admins mapping table (for multiple admins per hotel)
CREATE TABLE IF NOT EXISTS hotel_admins (
    id INT(11) PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT(11) NOT NULL,
    user_id INT(11) NOT NULL,
    role ENUM('super_admin', 'admin', 'staff') DEFAULT 'staff',
    permissions JSON,
    assigned_by INT(11),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE KEY unique_hotel_user (hotel_id, user_id),
    INDEX idx_hotel (hotel_id),
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Update hotels table to add owner/creator
ALTER TABLE hotels 
ADD COLUMN IF NOT EXISTS owner_id INT(11) DEFAULT NULL AFTER description,
ADD COLUMN IF NOT EXISTS owner_name VARCHAR(100) DEFAULT NULL AFTER owner_id,
ADD COLUMN IF NOT EXISTS owner_phone VARCHAR(20) DEFAULT NULL AFTER owner_name,
ADD COLUMN IF NOT EXISTS owner_email VARCHAR(100) DEFAULT NULL AFTER owner_phone,
ADD COLUMN IF NOT EXISTS status ENUM('active', 'inactive', 'pending_approval') DEFAULT 'active' AFTER rating;
