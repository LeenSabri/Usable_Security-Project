-- RentGo Database Schema
-- Drop and recreate database for clean installation
DROP DATABASE IF EXISTS rentgo_db;
CREATE DATABASE rentgo_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE rentgo_db;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role ENUM('customer', 'employee', 'manager') DEFAULT 'customer',
    profile_image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Cars Table
CREATE TABLE IF NOT EXISTS cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT NOT NULL,
    color VARCHAR(30),
    price_per_day DECIMAL(10, 2) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    plate_number VARCHAR(20) UNIQUE,
    seats INT DEFAULT 5,
    transmission ENUM('automatic', 'manual') DEFAULT 'automatic',
    fuel_type ENUM('petrol', 'diesel', 'electric', 'hybrid') DEFAULT 'petrol',
    status ENUM('available', 'rented', 'maintenance') DEFAULT 'available',
    mileage INT DEFAULT 0,
    features JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_brand (brand),
    INDEX idx_price (price_per_day)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Bookings Table
CREATE TABLE IF NOT EXISTS bookings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    car_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    pickup_location VARCHAR(255),
    pickup_lat DECIMAL(10, 8),
    pickup_lon DECIMAL(11, 8),
    phone VARCHAR(20),
    id_card_image VARCHAR(255),
    license_image VARCHAR(255),
    payment_method ENUM('visa', 'credit', 'cash') DEFAULT 'cash',
    payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'active', 'completed', 'cancelled') DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_car_id (car_id),
    INDEX idx_status (status),
    INDEX idx_dates (start_date, end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Deliveries Table
CREATE TABLE IF NOT EXISTS deliveries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    employee_id INT,
    delivery_type ENUM('pickup', 'return') NOT NULL,
    scheduled_date DATETIME NOT NULL,
    actual_date DATETIME,
    location VARCHAR(255),
    location_lat DECIMAL(10, 8),
    location_lon DECIMAL(11, 8),
    status ENUM('pending', 'in_progress', 'completed', 'cancelled') DEFAULT 'pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_booking_id (booking_id),
    INDEX idx_employee_id (employee_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Requests Table
CREATE TABLE IF NOT EXISTS requests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    type ENUM('booking', 'maintenance', 'support', 'cancellation') NOT NULL,
    subject VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('pending', 'in_progress', 'resolved', 'rejected') DEFAULT 'pending',
    priority ENUM('low', 'medium', 'high') DEFAULT 'medium',
    assigned_to INT,
    resolved_at DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Favorites Table
CREATE TABLE IF NOT EXISTS favorites (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    car_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_favorite (user_id, car_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_car_id (car_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Notifications Table
CREATE TABLE IF NOT EXISTS notifications (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('booking', 'delivery', 'payment', 'system', 'promotion') DEFAULT 'system',
    is_read BOOLEAN DEFAULT FALSE,
    link VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Feedback Table
CREATE TABLE IF NOT EXISTS feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    booking_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_rating (rating)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert Default Admin User
INSERT INTO users (username, email, password, full_name, phone, role) VALUES 
('admin', 'admin@rentgo.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin User', '0599999999', 'manager');
-- Password: password

-- Insert Sample Cars
INSERT INTO cars (name, brand, model, year, color, price_per_day, description, plate_number, seats, transmission, fuel_type, status) VALUES 
('Toyota Camry 2023', 'Toyota', 'Camry', 2023, 'White', 65.00, 'Comfortable sedan with excellent fuel economy and spacious interior', 'ABC-1234', 5, 'automatic', 'petrol', 'available'),
('BMW X5 2022', 'BMW', 'X5', 2022, 'Black', 120.00, 'Luxury SUV with premium features and advanced technology', 'XYZ-5678', 7, 'automatic', 'diesel', 'available'),
('Mercedes-Benz C-Class', 'Mercedes-Benz', 'C-Class', 2023, 'Silver', 95.00, 'Elegant and powerful sedan with sophisticated design', 'MER-9012', 5, 'automatic', 'petrol', 'available'),
('Honda Civic 2022', 'Honda', 'Civic', 2022, 'Gray', 55.00, 'Reliable and efficient compact car perfect for city driving', 'HON-3456', 5, 'manual', 'petrol', 'available'),
('Tesla Model 3', 'Tesla', 'Model 3', 2023, 'White', 85.00, 'Electric car with autopilot features and zero emissions', 'TES-7890', 5, 'automatic', 'electric', 'available'),
('Nissan Patrol', 'Nissan', 'Patrol', 2022, 'Black', 110.00, 'Powerful SUV for desert adventures and off-road capabilities', 'NIS-2468', 7, 'automatic', 'diesel', 'available');

-- Insert Sample Notifications
INSERT INTO notifications (user_id, title, message, type) VALUES 
(1, 'Welcome to RentGo!', 'Thank you for joining RentGo. Start booking your favorite cars now!', 'system');

