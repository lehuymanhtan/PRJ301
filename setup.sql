-- =====================================================
-- Database setup script for PRJ301
-- Replace YOUR_DB with your actual database name
-- =====================================================

USE master;
GO

CREATE DATABASE PRJ301_ASSIGNMENT;
GO

USE PRJ301_ASSIGNMENT;
GO

-- ====== Users Table ======
CREATE TABLE Users
(
    userId      INT IDENTITY(1,1) PRIMARY KEY,
    username    NVARCHAR(50)  NOT NULL UNIQUE,
    password    NVARCHAR(50)  NOT NULL,
    role        NVARCHAR(10)  NOT NULL CHECK (role IN (N'admin', N'user')),
    name        NVARCHAR(100) NOT NULL,
    gender      NVARCHAR(10)  NOT NULL CHECK (gender IN (N'male', N'female', N'other')),
    dateOfBirth DATE          NOT NULL,
    phone       NVARCHAR(20)  NULL,
    email       NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- ====== Suppliers Table ======
CREATE TABLE Suppliers
(
    id      INT IDENTITY(1,1) PRIMARY KEY,
    name    NVARCHAR(100) NOT NULL,
    phone   NVARCHAR(20)  NULL,
    email   NVARCHAR(100) NULL,
    address NVARCHAR(255) NULL,
    status  BIT           NOT NULL DEFAULT 1
);
GO

-- ====== Products Table ======
CREATE TABLE Products
(
    id          INT IDENTITY(1,1) PRIMARY KEY,
    name        NVARCHAR(100) NOT NULL,
    price       FLOAT         NOT NULL DEFAULT 0,
    description NVARCHAR(500) NULL,
    stock       INT           NOT NULL DEFAULT 0,
    importDate  DATE          NULL,
    category    NVARCHAR(100) NULL,
    supplierId  INT           NULL REFERENCES Suppliers(id)
);
GO

-- ====== Sample Data: Users ======
INSERT INTO Users (username, password, role, name, gender, dateOfBirth, phone, email) VALUES
    (N'admin', N'admin123', N'admin', N'Administrator', N'other', '2000-01-01', NULL,          N'admin@example.com'),
    (N'user1', N'user123',  N'user',  N'User One',      N'male',  '1995-05-15', N'0901000001', N'user1@example.com'),
    (N'user2', N'user123',  N'user',  N'User Two',      N'female','1998-09-20', N'0901000002', N'user2@example.com');
GO

-- ====== Sample Data: Suppliers ======
INSERT INTO Suppliers (name, phone, email, address, status) VALUES
    (N'TechSource Co.',     N'0281000001', N'contact@techsource.com',  N'12 Nguyen Hue, Ho Chi Minh City',  1),
    (N'Global Parts Ltd.',  N'0281000002', N'sales@globalparts.com',   N'45 Le Loi, Ho Chi Minh City',      1),
    (N'VietSupply JSC.',    N'0281000003', N'info@vietsupply.vn',      N'78 Tran Hung Dao, Ha Noi',         1),
    (N'EastTrade Import',   N'0281000004', N'trade@easttrade.com',     N'99 Hai Ba Trung, Da Nang',         0);
GO

-- ====== Sample Data: Products ======
INSERT INTO Products (name, price, description, stock, importDate, category, supplierId) VALUES
    (N'Wireless Mouse',       15.99,  N'Ergonomic 2.4GHz wireless mouse',         150, '2025-11-01', N'Electronics',   1),
    (N'Mechanical Keyboard',  49.99,  N'TKL mechanical keyboard, blue switches',   80, '2025-11-15', N'Electronics',   1),
    (N'USB-C Hub 7-in-1',     29.99,  N'7-port USB-C hub with HDMI and PD',        60, '2025-12-01', N'Electronics',   2),
    (N'Laptop Stand',         22.50,  N'Aluminum adjustable laptop stand',         200, '2025-12-10', N'Accessories',   2),
    (N'Office Chair',        199.00,  N'Ergonomic mesh office chair',               30, '2025-10-20', N'Furniture',     3),
    (N'Standing Desk',       350.00,  N'Electric height-adjustable standing desk',  15, '2025-10-05', N'Furniture',     3),
    (N'Webcam 1080p',         39.99,  N'Full HD webcam with built-in microphone',  120, '2026-01-08', N'Electronics',   1),
    (N'HDMI Cable 2m',         8.50,  N'High-speed HDMI 2.0 cable 2 meters',      300, '2026-01-15', N'Accessories',   2),
    (N'Desk Lamp LED',        18.00,  N'Dimmable LED desk lamp with USB port',     90, '2026-02-01', N'Accessories',   3),
    (N'Notebook A5',           3.99,  N'80-page hardcover A5 notebook',            500, '2026-02-10', N'Stationery',  NULL);
GO
