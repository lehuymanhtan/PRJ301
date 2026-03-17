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
    userId              INT IDENTITY(1,1) PRIMARY KEY,
    username            NVARCHAR(50)  NOT NULL UNIQUE,
    password            NVARCHAR(50)  NOT NULL,
    role                NVARCHAR(10)  NOT NULL CHECK (role IN (N'admin', N'user')),
    name                NVARCHAR(100) NOT NULL,
    gender              NVARCHAR(10)  NOT NULL CHECK (gender IN (N'male', N'female', N'other')),
    dateOfBirth         DATE          NOT NULL,
    phone               NVARCHAR(20)  NULL,
    email               NVARCHAR(100) NOT NULL UNIQUE,
    isVerified          BIT           NOT NULL DEFAULT 0,
    verificationCode    NVARCHAR(10)  NULL,
    verificationToken   NVARCHAR(100) NULL,
    verificationExpiry  DATETIME2     NULL,
    points              INT           NOT NULL DEFAULT 0,
    membershipTier      NVARCHAR(20)  NOT NULL DEFAULT 'Regular',
    lastPurchaseDate    DATETIME2     NULL,
    pointResetDate      DATETIME2     NULL,
    resetToken          NVARCHAR(100) NULL,
    resetTokenExpiry    DATETIME2     NULL
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
INSERT INTO Users (username, password, role, name, gender, dateOfBirth, phone, email, isVerified) VALUES
    (N'admin', N'admin123', N'admin', N'Administrator', N'other', '2000-01-01', NULL,          N'admin@example.com', 1),
    (N'user1', N'user123',  N'user',  N'User One',      N'male',  '1995-05-15', N'0901000001', N'user1@example.com', 1),
    (N'user2', N'user123',  N'user',  N'User Two',      N'female','1998-09-20', N'0901000002', N'user2@example.com', 1);
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
    (N'Wireless Mouse',       399000,   N'Ergonomic 2.4GHz wireless mouse',         150, '2025-11-01', N'Electronics',   1),
    (N'Mechanical Keyboard',  1249000,  N'TKL mechanical keyboard, blue switches',   80, '2025-11-15', N'Electronics',   1),
    (N'USB-C Hub 7-in-1',     749000,   N'7-port USB-C hub with HDMI and PD',        60, '2025-12-01', N'Electronics',   2),
    (N'Laptop Stand',         565000,   N'Aluminum adjustable laptop stand',         200, '2025-12-10', N'Accessories',   2),
    (N'Office Chair',         4990000,  N'Ergonomic mesh office chair',               30, '2025-10-20', N'Furniture',     3),
    (N'Standing Desk',        8750000,  N'Electric height-adjustable standing desk',  15, '2025-10-05', N'Furniture',     3),
    (N'Webcam 1080p',         999000,   N'Full HD webcam with built-in microphone',  120, '2026-01-08', N'Electronics',   1),
    (N'HDMI Cable 2m',        215000,   N'High-speed HDMI 2.0 cable 2 meters',      300, '2026-01-15', N'Accessories',   2),
    (N'Desk Lamp LED',        450000,   N'Dimmable LED desk lamp with USB port',     90, '2026-02-01', N'Accessories',   3),
    (N'Notebook A5',          99000,    N'80-page hardcover A5 notebook',            500, '2026-02-10', N'Stationery',  NULL);
GO

-- ====== Orders Table ======
CREATE TABLE Orders
(
    id         INT IDENTITY(1,1) PRIMARY KEY,
    userId     INT           NULL     REFERENCES Users(userId),
    totalPrice FLOAT         NOT NULL DEFAULT 0,
    status     NVARCHAR(20)  NOT NULL DEFAULT 'Pending'
        CHECK (status IN (N'Pending', N'Processing', N'Shipped', N'Delivered',
                          N'Completed', N'Cancelled', N'Deleted', N'Refunded'))
    createdAt  DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    shippingFullName  NVARCHAR(100) NULL,
    shippingPhone     NVARCHAR(15)  NULL,
    shippingProvinceId INT          NULL     REFERENCES Provinces(id),
    shippingDistrict  NVARCHAR(100) NULL,
    shippingWard      NVARCHAR(100) NULL,
    shippingAddress   NVARCHAR(255) NULL
);
GO

-- ====== OrderDetails Table ======
CREATE TABLE OrderDetails
(
    id          INT IDENTITY(1,1) PRIMARY KEY,
    orderId     INT           NOT NULL REFERENCES Orders(id),
    productId   INT           NULL     REFERENCES Products(id),
    productName NVARCHAR(100) NOT NULL,
    quantity    INT           NOT NULL DEFAULT 1,
    price       FLOAT         NOT NULL DEFAULT 0
);
GO

-- ====== Sample Data: Orders ======
-- user1 (userId=2): 2 orders
-- user2 (userId=3): 1 order
INSERT INTO Orders (userId, totalPrice, status, createdAt) VALUES
    (2, 2047000,  N'Completed', '2026-03-01'),   -- order 1: user1
    (2, 565000,   N'Shipped',   '2026-03-05'),   -- order 2: user1
    (3, 6187000,  N'Pending',   '2026-03-08'),   -- order 3: user2
    (3, 215000,   N'Cancelled', '2026-03-08');   -- order 4: user2
GO

-- ====== Sample Data: OrderDetails ======
-- Order 1 (user1, Completed): Wireless Mouse x2 + Mechanical Keyboard x1
INSERT INTO OrderDetails (orderId, productId, productName, quantity, price) VALUES
    (1, 1, N'Wireless Mouse',      2, 399000),
    (1, 2, N'Mechanical Keyboard', 1, 1249000);
GO

-- Order 2 (user1, Shipped): Laptop Stand x1
INSERT INTO OrderDetails (orderId, productId, productName, quantity, price) VALUES
    (2, 4, N'Laptop Stand', 1, 565000);
GO

-- Order 3 (user2, Pending): Office Chair x1 + Webcam 1080p x1 + Notebook A5 x1
INSERT INTO OrderDetails (orderId, productId, productName, quantity, price) VALUES
    (3, 5, N'Office Chair',  1, 4990000),
    (3, 7, N'Webcam 1080p',  1,  999000),
    (3, 10, N'Notebook A5',  2,   99000);
GO

-- Order 4 (user2, Cancelled): HDMI Cable 2m x1
INSERT INTO OrderDetails (orderId, productId, productName, quantity, price) VALUES
    (4, 8, N'HDMI Cable 2m', 1, 215000);
GO




CREATE TRIGGER trg_minus_stock_after_order
ON OrderDetails
AFTER INSERT
AS
BEGIN
    UPDATE p
    SET p.stock = p.stock - i.quantity
    FROM Products p
    JOIN inserted i ON p.id = i.productId
END
GO

CREATE TRIGGER trg_restore_stock_when_cancel
ON Orders
AFTER UPDATE
AS
BEGIN
    UPDATE p
    SET p.stock = p.stock + od.quantity
    FROM Products p
    JOIN OrderDetails od ON p.id = od.productId
    JOIN inserted i ON od.orderId = i.id
    JOIN deleted d ON i.id = d.id
    WHERE i.status = 'Cancelled'
      AND d.status <> 'Cancelled'
END
GO

-- ====== RefundRequests Table ======
CREATE TABLE RefundRequests
(
    id            INT IDENTITY(1,1) PRIMARY KEY,
    orderId       INT            NOT NULL REFERENCES Orders(id),
    userId        INT            NOT NULL REFERENCES Users(userId),
    reason        NVARCHAR(100)  NOT NULL,
    description   NVARCHAR(1000) NULL,
    status        NVARCHAR(30)   NOT NULL DEFAULT 'Pending'
        CHECK (status IN (N'Pending', N'WaitForReturn', N'Verifying',
                          N'Done', N'Rejected', N'Cancelled')),
    returnAddress NVARCHAR(500)  NULL,
    createdAt     DATETIME2      NOT NULL DEFAULT GETDATE()
);
GO

-- ====== Provinces Table ======
CREATE TABLE Provinces
(
    id       INT IDENTITY(1,1) PRIMARY KEY,
    nameVi   NVARCHAR(100) NOT NULL,
    nameEn   NVARCHAR(100) NOT NULL,
    isActive BIT           NOT NULL DEFAULT 1
);
GO

-- ====== UserAddresses Table ======
CREATE TABLE UserAddresses
(
    id            INT IDENTITY(1,1) PRIMARY KEY,
    userId        INT           NOT NULL REFERENCES Users(userId),
    fullName      NVARCHAR(100) NOT NULL,
    phone         NVARCHAR(15)  NOT NULL,
    provinceId    INT           NOT NULL REFERENCES Provinces(id),
    district      NVARCHAR(100) NOT NULL,
    ward          NVARCHAR(100) NOT NULL,
    addressDetail NVARCHAR(255) NOT NULL,
    isDefault     BIT           NOT NULL DEFAULT 0,
    createdAt     DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE)
);
GO

-- ====== Sample Data: Provinces (34 provinces/cities of Vietnam) ======
INSERT INTO Provinces (nameVi, nameEn, isActive) VALUES
    (N'Hà Nội', 'Ha Noi', 1),
    (N'Cao Bằng', 'Cao Bang', 1),
    (N'Tuyên Quang', 'Tuyen Quang', 1),
    (N'Điện Biên', 'Dien Bien', 1),
    (N'Lai Châu', 'Lai Chau', 1),
    (N'Sơn La', 'Son La', 1),
    (N'Lào Cai', 'Lao Cai', 1),
    (N'Thái Nguyên', 'Thai Nguyen', 1),
    (N'Lạng Sơn', 'Lang Son', 1),
    (N'Quảng Ninh', 'Quang Ninh', 1),
    (N'Bắc Ninh', 'Bac Ninh', 1),
    (N'Phú Thọ', 'Phu Tho', 1),
    (N'Hải Phòng', 'Hai Phong', 1),
    (N'Hưng Yên', 'Hung Yen', 1),
    (N'Ninh Bình', 'Ninh Binh', 1),
    (N'Thanh Hóa', 'Thanh Hoa', 1),
    (N'Nghệ An', 'Nghe An', 1),
    (N'Hà Tĩnh', 'Ha Tinh', 1),
    (N'Quảng Trị', 'Quang Tri', 1),
    (N'Huế', 'Hue', 1),
    (N'Đà Nẵng', 'Da Nang', 1),
    (N'Quảng Ngãi', 'Quang Ngai', 1),
    (N'Gia Lai', 'Gia Lai', 1),
    (N'Khánh Hòa', 'Khanh Hoa', 1),
    (N'Đắk Lắk', 'Dak Lak', 1),
    (N'Lâm Đồng', 'Lam Dong', 1),
    (N'Đồng Nai', 'Dong Nai', 1),
    (N'Hồ Chí Minh', 'Ho Chi Minh City', 1),
    (N'Tây Ninh', 'Tay Ninh', 1),
    (N'Đồng Tháp', 'Dong Thap', 1),
    (N'Vĩnh Long', 'Vinh Long', 1),
    (N'An Giang', 'An Giang', 1),
    (N'Cần Thơ', 'Can Tho', 1),
    (N'Cà Mau', 'Ca Mau', 1);
GO

-- ====== Migration: Add email verification columns to existing database ======
-- Skip this block if you are creating the database fresh from the CREATE TABLE above.
/*
ALTER TABLE Users ADD
    isVerified         BIT           NOT NULL DEFAULT 0,
    verificationCode   NVARCHAR(10)  NULL,
    verificationToken  NVARCHAR(100) NULL,
    verificationExpiry DATETIME2     NULL;
GO

-- Mark all pre-existing users as verified so they can still log in.
UPDATE Users SET isVerified = 1;
GO
*/

-- ====== Migration: Add password reset columns to existing Users table ======
-- Skip this block if you are creating the database fresh.
/*
ALTER TABLE Users ADD
    resetToken       NVARCHAR(100) NULL,
    resetTokenExpiry DATETIME2     NULL;
GO
*/

-- ====== Migration: add createdAt column to existing Orders table ======
-- Skip this block if you are creating the database fresh from the CREATE TABLE above.
/*
ALTER TABLE Orders ADD
    createdAt DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE);
GO
*/

-- ====== Migration: Add shipping address columns to existing Orders table ======
-- Skip this block if you are creating the database fresh.
/*
ALTER TABLE Orders ADD
    shippingFullName   NVARCHAR(100) NULL,
    shippingPhone      NVARCHAR(15)  NULL,
    shippingProvinceId INT           NULL REFERENCES Provinces(id),
    shippingDistrict   NVARCHAR(100) NULL,
    shippingWard       NVARCHAR(100) NULL,
    shippingAddress    NVARCHAR(255) NULL;
GO
*/

-- ====== Migration: Add Provinces and UserAddresses tables to existing database ======
-- Skip this block if you are creating the database fresh.
/*
CREATE TABLE Provinces
(
    id       INT IDENTITY(1,1) PRIMARY KEY,
    nameVi   NVARCHAR(100) NOT NULL,
    nameEn   NVARCHAR(100) NOT NULL,
    isActive BIT           NOT NULL DEFAULT 1
);
GO

CREATE TABLE UserAddresses
(
    id            INT IDENTITY(1,1) PRIMARY KEY,
    userId        INT           NOT NULL REFERENCES Users(userId),
    fullName      NVARCHAR(100) NOT NULL,
    phone         NVARCHAR(15)  NOT NULL,
    provinceId    INT           NOT NULL REFERENCES Provinces(id),
    district      NVARCHAR(100) NOT NULL,
    ward          NVARCHAR(100) NOT NULL,
    addressDetail NVARCHAR(255) NOT NULL,
    isDefault     BIT           NOT NULL DEFAULT 0,
    createdAt     DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE)
);
GO

-- Insert provinces data
INSERT INTO Provinces (nameVi, nameEn, isActive) VALUES
    (N'Hà Nội', 'Ha Noi', 1),
    (N'Cao Bằng', 'Cao Bang', 1),
    (N'Tuyên Quang', 'Tuyen Quang', 1),
    (N'Điện Biên', 'Dien Bien', 1),
    (N'Lai Châu', 'Lai Chau', 1),
    (N'Sơn La', 'Son La', 1),
    (N'Lào Cai', 'Lao Cai', 1),
    (N'Thái Nguyên', 'Thai Nguyen', 1),
    (N'Lạng Sơn', 'Lang Son', 1),
    (N'Quảng Ninh', 'Quang Ninh', 1),
    (N'Bắc Ninh', 'Bac Ninh', 1),
    (N'Phú Thọ', 'Phu Tho', 1),
    (N'Hải Phòng', 'Hai Phong', 1),
    (N'Hưng Yên', 'Hung Yen', 1),
    (N'Ninh Bình', 'Ninh Binh', 1),
    (N'Thanh Hóa', 'Thanh Hoa', 1),
    (N'Nghệ An', 'Nghe An', 1),
    (N'Hà Tĩnh', 'Ha Tinh', 1),
    (N'Quảng Trị', 'Quang Tri', 1),
    (N'Huế', 'Hue', 1),
    (N'Đà Nẵng', 'Da Nang', 1),
    (N'Quảng Ngãi', 'Quang Ngai', 1),
    (N'Gia Lai', 'Gia Lai', 1),
    (N'Khánh Hòa', 'Khanh Hoa', 1),
    (N'Đắk Lắk', 'Dak Lak', 1),
    (N'Lâm Đồng', 'Lam Dong', 1),
    (N'Đồng Nai', 'Dong Nai', 1),
    (N'Hồ Chí Minh', 'Ho Chi Minh City', 1),
    (N'Tây Ninh', 'Tay Ninh', 1),
    (N'Đồng Tháp', 'Dong Thap', 1),
    (N'Vĩnh Long', 'Vinh Long', 1),
    (N'An Giang', 'An Giang', 1),
    (N'Cần Thơ', 'Can Tho', 1),
    (N'Cà Mau', 'Ca Mau', 1);
GO
*/

-- ====== Migration: Convert Orders.shippingProvince to shippingProvinceId ======
-- If you have an existing database using the old text-based shippingProvince field:
/*
-- Step 1: Add the new shippingProvinceId column
ALTER TABLE Orders ADD shippingProvinceId INT NULL REFERENCES Provinces(id);
GO

-- Step 2: Migrate existing data by matching province names
-- Update based on Vietnamese name matching
UPDATE o
SET o.shippingProvinceId = p.id
FROM Orders o
JOIN Provinces p ON o.shippingProvince = p.nameVi
WHERE o.shippingProvince IS NOT NULL;
GO

-- Step 3: (Optional) Drop the old shippingProvince column after verifying migration
-- Uncomment only after confirming all data is properly migrated:
-- ALTER TABLE Orders DROP COLUMN shippingProvince;
-- GO
*/

-- ====== View: Daily Income Summary ======
-- Shows completed income and pending income (un-complete orders) per day.
CREATE OR ALTER VIEW vw_DailyIncome AS
SELECT
    createdAt                                                                  AS incomeDate,
    SUM(CASE WHEN status = N'Completed'
             THEN totalPrice ELSE 0 END)                                       AS completedIncome,
    SUM(CASE WHEN status IN (N'Pending', N'Processing', N'Shipped', N'Delivered')
             THEN totalPrice ELSE 0 END)                                       AS pendingIncome
FROM Orders
WHERE status NOT IN (N'Cancelled', N'Deleted')
GROUP BY createdAt;
GO

-- ====== Migration: Add Refunded status to Orders + RefundRequests table ======
-- Run this block if you already have the database.
/*
-- Drop the old CHECK constraint (find the name first with:
--   SELECT name FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('Orders')
-- then replace CK__Orders__status__XXXXXXXX with the actual name)
ALTER TABLE Orders DROP CONSTRAINT CK__Orders__status__XXXXXXXX;
GO
ALTER TABLE Orders ADD CONSTRAINT CK_Orders_status
    CHECK (status IN (N'Pending', N'Processing', N'Shipped', N'Delivered',
                      N'Completed', N'Cancelled', N'Deleted', N'Refunded'));
GO

CREATE TABLE RefundRequests
(
    id            INT IDENTITY(1,1) PRIMARY KEY,
    orderId       INT            NOT NULL REFERENCES Orders(id),
    userId        INT            NOT NULL REFERENCES Users(userId),
    reason        NVARCHAR(100)  NOT NULL,
    description   NVARCHAR(1000) NULL,
    status        NVARCHAR(30)   NOT NULL DEFAULT 'Pending'
        CHECK (status IN (N'Pending', N'WaitForReturn', N'Verifying',
                          N'Done', N'Rejected', N'Cancelled')),
    returnAddress NVARCHAR(500)  NULL,
    createdAt     DATETIME2      NOT NULL DEFAULT GETDATE()
);
GO
*/

-- ====== Loyalty Feature Tables ======
-- If creating the database fresh, add these columns to the Users table above
-- and add these tables alongside the others.
-- If migrating an existing database, run the ALTER TABLE and CREATE TABLE
-- statements below (the ones inside the /* */ block).

-- ---- For fresh database: add to your CREATE TABLE Users block ----
-- points           INT           NOT NULL DEFAULT 0,
-- membershipTier   NVARCHAR(20)  NOT NULL DEFAULT 'Regular',
-- lastPurchaseDate DATETIME2     NULL,
-- pointResetDate   DATETIME2     NULL,

-- ---- Fresh database tables ----
CREATE TABLE PointHistory
(
    id           INT IDENTITY(1,1) PRIMARY KEY,
    userId       INT            NOT NULL REFERENCES Users(userId),
    orderId      INT            NULL REFERENCES Orders(id),
    amount       DECIMAL(12,2)  NULL,
    pointsEarned INT            NULL,
    type         NVARCHAR(20)   NOT NULL DEFAULT 'EARN',
    createdAt    DATETIME2      NOT NULL DEFAULT GETDATE()
);
GO

CREATE TABLE LoyaltyConfig
(
    id        INT PRIMARY KEY,
    pointRate INT NOT NULL DEFAULT 1
);
GO

INSERT INTO LoyaltyConfig (id, pointRate) VALUES (1, 1);
GO

-- ====== Migration: Add Loyalty columns to existing Users table ======
-- Skip this block if you are creating the database fresh.
/*
ALTER TABLE Users ADD
    points           INT           NOT NULL DEFAULT 0,
    membershipTier   NVARCHAR(20)  NOT NULL DEFAULT 'Regular',
    lastPurchaseDate DATETIME2     NULL,
    pointResetDate   DATETIME2     NULL;
GO
*/
-- Tier thresholds
-- Regular
-- → Bronze (10,000)
-- → Silver (20,000)
-- → Gold (50,000)
-- → Platinum (100,000)
-- → Diamond (200,000)

-- ====== Prophet Forecast Table ======
-- Stores metadata for 3-month sales forecasts
CREATE TABLE ProphetForecasts
(
    id                   INT IDENTITY(1,1) PRIMARY KEY,
    jobId                NVARCHAR(100)  NOT NULL UNIQUE,
    outputFolder         NVARCHAR(500)  NULL,
    forecastPlotPath     NVARCHAR(500)  NULL,
    monthlyBarPath       NVARCHAR(500)  NULL,
    componentsPlotPath   NVARCHAR(500)  NULL,
    monthlyCSVPath       NVARCHAR(500)  NULL,
    predictedAt          DATETIME2      NOT NULL,
    status               NVARCHAR(20)   NOT NULL DEFAULT 'completed' CHECK (status IN ('completed', 'error')),
    errorMessage         NVARCHAR(1000) NULL,
    createdAt            DATETIME2      NOT NULL DEFAULT GETDATE()
);
GO

