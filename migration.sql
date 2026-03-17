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
PRINT '  2. Internationalization (Products table)'
PRINT ''
PRINT 'Next steps:'
PRINT '  1. Restart your application'
PRINT '  2. Test password recovery at /forgot-password'
PRINT '  3. Test multilingual product fields if needed'
PRINT '  4. Test multilingual emails (password reset, verification)'
PRINT ''
PRINT 'For more information, see:'
PRINT '  - NEW_FEATURES_README.md'
PRINT '  - IMPLEMENTATION_GUIDE.md'
PRINT '  - I18N_ENHANCEMENT_GUIDE.md'
PRINT ''
GO
