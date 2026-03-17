-- =====================================================
-- Migration Script for Password Recovery & i18n
-- Run this on EXISTING databases only
-- For new installations, use setup.sql instead
-- =====================================================

USE PRJ301_ASSIGNMENT;
GO

PRINT '=== Starting Migration ==='
GO

-- =====================================================
-- Part 1: Password Recovery Feature
-- =====================================================

PRINT 'Adding password recovery fields to Users table...'
GO

-- Check if columns already exist
IF NOT EXISTS (SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('Users')
    AND name = 'resetToken')
BEGIN
    ALTER TABLE Users ADD
        resetToken       NVARCHAR(100) NULL,
        resetTokenExpiry DATETIME2     NULL;

    PRINT '✓ Password recovery fields added successfully'
END
ELSE
BEGIN
    PRINT '⚠ Password recovery fields already exist - skipping'
END
GO

-- =====================================================
-- PART 2: User Language Preference
-- =====================================================

PRINT 'Adding language preference field to Users table...'
GO

-- Check if column already exists
IF NOT EXISTS (SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('Users')
    AND name = 'preferredLanguage')
BEGIN
    ALTER TABLE Users ADD
        preferredLanguage NVARCHAR(5) NOT NULL DEFAULT 'vi';

    PRINT '✓ Language preference field added successfully'
END
ELSE
BEGIN
    PRINT '⚠ Language preference field already exists - skipping'
END
GO

-- =====================================================
-- PART 2: Internationalization (i18n) Feature
-- =====================================================

PRINT 'Adding internationalization fields to Products table...'
GO

-- Check if columns already exist
IF NOT EXISTS (SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('Products')
    AND name = 'name_en')
BEGIN
    ALTER TABLE Products ADD
        name_en        NVARCHAR(100) NULL,
        description_en NVARCHAR(500) NULL,
        category_en    NVARCHAR(100) NULL;

    PRINT '✓ Internationalization fields added successfully'
END
ELSE
BEGIN
    PRINT '⚠ Internationalization fields already exist - skipping'
END
GO

-- =====================================================
-- PART 3: Sample Data Population (Optional)
-- =====================================================

PRINT 'Populating sample English translations for products...'
GO

-- Update existing products with English translations
-- Modify these based on your actual product names

UPDATE Products 
SET name_en = 'Wireless Mouse',
    description_en = 'Ergonomic 2.4GHz wireless mouse',
    category_en = 'Electronics'
WHERE id = 1 AND name = N'Wireless Mouse';

UPDATE Products 
SET name_en = 'Mechanical Keyboard',
    description_en = 'TKL mechanical keyboard, blue switches',
    category_en = 'Electronics'
WHERE id = 2 AND name = N'Mechanical Keyboard';

UPDATE Products 
SET name_en = 'USB-C Hub 7-in-1',
    description_en = '7-port USB-C hub with HDMI and PD',
    category_en = 'Electronics'
WHERE id = 3 AND name = N'USB-C Hub 7-in-1';

UPDATE Products 
SET name_en = 'Laptop Stand',
    description_en = 'Aluminum adjustable laptop stand',
    category_en = 'Accessories'
WHERE id = 4 AND name = N'Laptop Stand';

UPDATE Products 
SET name_en = 'Office Chair',
    description_en = 'Ergonomic mesh office chair',
    category_en = 'Furniture'
WHERE id = 5 AND name = N'Office Chair';

UPDATE Products 
SET name_en = 'Standing Desk',
    description_en = 'Electric height-adjustable standing desk',
    category_en = 'Furniture'
WHERE id = 6 AND name = N'Standing Desk';

UPDATE Products 
SET name_en = 'Webcam 1080p',
    description_en = 'Full HD webcam with built-in microphone',
    category_en = 'Electronics'
WHERE id = 7 AND name = N'Webcam 1080p';

UPDATE Products 
SET name_en = 'HDMI Cable 2m',
    description_en = 'High-speed HDMI 2.0 cable 2 meters',
    category_en = 'Accessories'
WHERE id = 8 AND name = N'HDMI Cable 2m';

UPDATE Products 
SET name_en = 'Desk Lamp LED',
    description_en = 'Dimmable LED desk lamp with USB port',
    category_en = 'Accessories'
WHERE id = 9 AND name = N'Desk Lamp LED';

UPDATE Products 
SET name_en = 'Notebook A5',
    description_en = '80-page hardcover A5 notebook',
    category_en = 'Stationery'
WHERE id = 10 AND name = N'Notebook A5';

PRINT '✓ Sample translations populated'
GO

-- =====================================================
-- PART 4: Verification
-- =====================================================

PRINT '=== Verifying Migration ==='
GO

-- Check Users table
IF EXISTS (SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('Users') AND name = 'resetToken')
    PRINT '✓ Users.resetToken exists'
ELSE
    PRINT '✗ ERROR: Users.resetToken missing'

IF EXISTS (SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('Users') AND name = 'resetTokenExpiry')
    PRINT '✓ Users.resetTokenExpiry exists'
ELSE
    PRINT '✗ ERROR: Users.resetTokenExpiry missing'

IF EXISTS (SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('Users') AND name = 'preferredLanguage')
    PRINT '✓ Users.preferredLanguage exists'
ELSE
    PRINT '✗ ERROR: Users.preferredLanguage missing'

-- Check Products table
IF EXISTS (SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('Products') AND name = 'name_en')
    PRINT '✓ Products.name_en exists'
ELSE
    PRINT '✗ ERROR: Products.name_en missing'

IF EXISTS (SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('Products') AND name = 'description_en')
    PRINT '✓ Products.description_en exists'
ELSE
    PRINT '✗ ERROR: Products.description_en missing'

IF EXISTS (SELECT *
FROM sys.columns
WHERE object_id = OBJECT_ID('Products') AND name = 'category_en')
    PRINT '✓ Products.category_en exists'
ELSE
    PRINT '✗ ERROR: Products.category_en missing'

GO

-- =====================================================
-- PART 5: Summary
-- =====================================================

PRINT ''
PRINT '=== Migration Complete ==='
PRINT ''
PRINT 'Features added:'
PRINT '  1. Password Recovery (Users table)'
PRINT '  2. User Language Preference (Users table)'
PRINT '  3. Internationalization (Products table)'
PRINT ''
PRINT 'Next steps:'
PRINT '  1. Restart your application'
PRINT '  2. Test password recovery at /forgot-password'
PRINT '  3. Test language switching with the dropdown'
PRINT '  4. Login - your language choice will be saved automatically'
GO

-- =====================================================
-- PART 6: Address Book Feature
-- =====================================================

PRINT 'Creating Provinces table...'
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Provinces') AND type = 'U')
BEGIN
    CREATE TABLE Provinces (
        id       INT           IDENTITY(1,1) PRIMARY KEY,
        nameVi   NVARCHAR(100) NOT NULL,
        nameEn   NVARCHAR(100) NOT NULL,
        isActive BIT           NOT NULL DEFAULT 1
    );
    PRINT N'✓ Provinces table created'
END
ELSE
    PRINT N'⚠ Provinces table already exists - skipping'
GO

PRINT 'Creating UserAddresses table...'
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'UserAddresses') AND type = 'U')
BEGIN
    CREATE TABLE UserAddresses (
        id            INT           IDENTITY(1,1) PRIMARY KEY,
        userId        INT           NOT NULL REFERENCES Users(userId) ON DELETE CASCADE,
        fullName      NVARCHAR(100) NOT NULL,
        phone         NVARCHAR(15)  NOT NULL,
        provinceId    INT           NOT NULL REFERENCES Provinces(id),
        district      NVARCHAR(100) NOT NULL,
        ward          NVARCHAR(100) NOT NULL,
        addressDetail NVARCHAR(255) NOT NULL,
        isDefault     BIT           NOT NULL DEFAULT 0,
        createdAt     DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE)
    );
    PRINT N'✓ UserAddresses table created'
END
ELSE
    PRINT N'⚠ UserAddresses table already exists - skipping'
GO

PRINT 'Adding shipping snapshot columns to Orders table...'
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Orders') AND name = 'shippingFullName')
BEGIN
    ALTER TABLE Orders ADD
        shippingFullName NVARCHAR(100) NULL,
        shippingPhone    NVARCHAR(15)  NULL,
        shippingProvince NVARCHAR(100) NULL,
        shippingDistrict NVARCHAR(100) NULL,
        shippingWard     NVARCHAR(100) NULL,
        shippingAddress  NVARCHAR(255) NULL;
    PRINT N'✓ Shipping snapshot columns added to Orders'
END
ELSE
    PRINT N'⚠ Shipping snapshot columns already exist - skipping'
GO

PRINT 'Seeding 63 provinces of Vietnam...'
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM Provinces)
BEGIN
    INSERT INTO Provinces (nameVi, nameEn) VALUES
    (N'An Giang',                   N'An Giang'),
    (N'Bà Rịa - Vũng Tàu',         N'Ba Ria - Vung Tau'),
    (N'Bắc Giang',                  N'Bac Giang'),
    (N'Bắc Kạn',                    N'Bac Kan'),
    (N'Bạc Liêu',                   N'Bac Lieu'),
    (N'Bắc Ninh',                   N'Bac Ninh'),
    (N'Bến Tre',                     N'Ben Tre'),
    (N'Bình Định',                   N'Binh Dinh'),
    (N'Bình Dương',                  N'Binh Duong'),
    (N'Bình Phước',                  N'Binh Phuoc'),
    (N'Bình Thuận',                  N'Binh Thuan'),
    (N'Cà Mau',                      N'Ca Mau'),
    (N'Cần Thơ',                     N'Can Tho'),
    (N'Cao Bằng',                    N'Cao Bang'),
    (N'Thành phố Đà Nẵng',          N'Da Nang City'),
    (N'Đắk Lắk',                    N'Dak Lak'),
    (N'Đắk Nông',                   N'Dak Nong'),
    (N'Điện Biên',                   N'Dien Bien'),
    (N'Đồng Nai',                   N'Dong Nai'),
    (N'Đồng Tháp',                  N'Dong Thap'),
    (N'Gia Lai',                    N'Gia Lai'),
    (N'Hà Giang',                   N'Ha Giang'),
    (N'Hà Nam',                     N'Ha Nam'),
    (N'Thành phố Hà Nội',           N'Hanoi City'),
    (N'Hà Tĩnh',                    N'Ha Tinh'),
    (N'Hải Dương',                  N'Hai Duong'),
    (N'Thành phố Hải Phòng',        N'Hai Phong City'),
    (N'Hậu Giang',                  N'Hau Giang'),
    (N'Hòa Bình',                   N'Hoa Binh'),
    (N'Hưng Yên',                   N'Hung Yen'),
    (N'Khánh Hòa',                  N'Khanh Hoa'),
    (N'Kiên Giang',                 N'Kien Giang'),
    (N'Kon Tum',                    N'Kon Tum'),
    (N'Lai Châu',                   N'Lai Chau'),
    (N'Lâm Đồng',                   N'Lam Dong'),
    (N'Lạng Sơn',                   N'Lang Son'),
    (N'Lào Cai',                    N'Lao Cai'),
    (N'Long An',                    N'Long An'),
    (N'Nam Định',                   N'Nam Dinh'),
    (N'Nghệ An',                    N'Nghe An'),
    (N'Ninh Bình',                  N'Ninh Binh'),
    (N'Ninh Thuận',                 N'Ninh Thuan'),
    (N'Phú Thọ',                    N'Phu Tho'),
    (N'Phú Yên',                    N'Phu Yen'),
    (N'Quảng Bình',                 N'Quang Binh'),
    (N'Quảng Nam',                  N'Quang Nam'),
    (N'Quảng Ngãi',                 N'Quang Ngai'),
    (N'Quảng Ninh',                 N'Quang Ninh'),
    (N'Quảng Trị',                  N'Quang Tri'),
    (N'Sóc Trăng',                  N'Soc Trang'),
    (N'Sơn La',                     N'Son La'),
    (N'Tây Ninh',                   N'Tay Ninh'),
    (N'Thái Bình',                  N'Thai Binh'),
    (N'Thái Nguyên',                N'Thai Nguyen'),
    (N'Thanh Hóa',                  N'Thanh Hoa'),
    (N'Thừa Thiên Huế',             N'Thua Thien Hue'),
    (N'Tiền Giang',                 N'Tien Giang'),
    (N'Thành phố Hồ Chí Minh',     N'Ho Chi Minh City'),
    (N'Trà Vinh',                   N'Tra Vinh'),
    (N'Tuyên Quang',                N'Tuyen Quang'),
    (N'Vĩnh Long',                  N'Vinh Long'),
    (N'Vĩnh Phúc',                  N'Vinh Phuc'),
    (N'Yên Bái',                    N'Yen Bai');
    PRINT N'✓ 63 provinces seeded'
END
ELSE
    PRINT N'⚠ Provinces already seeded - skipping'
GO

PRINT N'=== Address Book Migration Complete ==='
PRINT N'  - Provinces table'
PRINT N'  - UserAddresses table'
PRINT N'  - Orders.shipping* snapshot columns'
PRINT N'  - 63 provinces of Vietnam (if empty)'
PRINT '  5. Test multilingual emails (password reset, verification)'
PRINT ''
PRINT 'For more information, see:'
PRINT '  - NEW_FEATURES_README.md'
PRINT '  - IMPLEMENTATION_GUIDE.md'
PRINT '  - I18N_ENHANCEMENT_GUIDE.md'
PRINT ''
GO
