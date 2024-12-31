-- Створення бази даних
CREATE DATABASE IF NOT EXISTS realestate CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE realestate;

-- Таблиця users (користувачі)
CREATE TABLE IF NOT EXISTS users (
    UserID INT NOT NULL AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20) NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Role ENUM('buyer', 'seller', 'admin') DEFAULT 'buyer',
    PRIMARY KEY (UserID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця properties (нерухомість)
CREATE TABLE IF NOT EXISTS properties (
    PropertyID INT NOT NULL AUTO_INCREMENT,
    Title VARCHAR(150) NOT NULL,
    Description TEXT NOT NULL,
    Price DECIMAL(15, 2) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Type ENUM('apartment', 'house', 'commercial', 'land') NOT NULL,
    SellerID INT NOT NULL,
    ListingDate DATE NOT NULL,
    PRIMARY KEY (PropertyID),
    FOREIGN KEY (SellerID) REFERENCES users(UserID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Таблиця inquiries (запити на нерухомість)
CREATE TABLE IF NOT EXISTS inquiries (
    InquiryID INT NOT NULL AUTO_INCREMENT,
    PropertyID INT NOT NULL,
    BuyerID INT NOT NULL,
    InquiryDate DATE NOT NULL,
    Message TEXT,
    PRIMARY KEY (InquiryID),
    FOREIGN KEY (PropertyID) REFERENCES properties(PropertyID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (BuyerID) REFERENCES users(UserID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Наповнення таблиці users
INSERT INTO users (FirstName, LastName, Email, Phone, PasswordHash, Role) VALUES
    ('Іван', 'Петров', 'ivan.petrov@example.com', '+380991234567', 'hashed_password1', 'seller'),
    ('Марія', 'Іваненко', 'mariya.ivanenko@example.com', '+380997654321', 'hashed_password2', 'buyer'),
    ('Олексій', 'Сидоров', 'oleksiy.sidorov@example.com', '+380959876543', 'hashed_password3', 'seller'),
    ('Юлія', 'Коваленко', 'yulia.kovalenko@example.com', '+380931234567', 'hashed_password4', 'buyer');

-- Наповнення таблиці properties
INSERT INTO properties (Title, Description, Price, Location, Type, SellerID, ListingDate) VALUES
    ('Простора квартира в центрі', '3-кімнатна квартира з ремонтом', 120000.00, 'Київ, вул. Хрещатик, 10', 'apartment', 1, '2023-11-15'),
    ('Приватний будинок біля лісу', 'Будинок 150 кв.м з великим подвір\'ям', 95000.00, 'Львівська область, с. Підгірці', 'house', 3, '2023-11-20');

-- Наповнення таблиці inquiries
INSERT INTO inquiries (PropertyID, BuyerID, InquiryDate, Message) VALUES
    (1, 2, '2023-12-01', 'Доброго дня! Цікавить стан ремонту в квартирі.'),
    (2, 4, '2023-12-05', 'Чи можна оглянути будинок у вихідні?');

-- Перевірка даних
SELECT * FROM users;
SELECT * FROM properties;
SELECT * FROM inquiries;
