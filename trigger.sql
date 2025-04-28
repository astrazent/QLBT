-- Xóa các trigger cũ nếu tồn tại
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TRIG_KhachHang_Capitalize_Insert')
BEGIN
    DROP TRIGGER TRIG_KhachHang_Capitalize_Insert;
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TRIG_HoaDonBanThuoc_CheckDate_Insert')
BEGIN
    DROP TRIGGER TRIG_HoaDonBanThuoc_CheckDate_Insert;
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TRIG_HoaDonBanThuoc_SLThuoc_Insert')
BEGIN
    DROP TRIGGER TRIG_HoaDonBanThuoc_SLThuoc_Insert;
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TRIG_DuocSi_CheckMaDuocSi_Insert')
BEGIN
    DROP TRIGGER TRIG_DuocSi_CheckMaDuocSi_Insert;
END
GO

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'TRIG_HoaDonNhapThuoc_CheckMaHoaDonAndFK_Insert')
BEGIN
    DROP TRIGGER TRIG_HoaDonNhapThuoc_CheckMaHoaDonAndFK_Insert;
END
GO


-- Trìgger kiểm tra số điện thoại có 10 chữ số
CREATE TRIGGER Check_Insert_KhachHang_SoDienThoai
ON [dbo].[KhachHang]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE soDienThoai NOT LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
    )
    BEGIN
        RAISERROR ('Số điện thoại phải có đúng 10 chữ số!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- Viết hoa tên của khách hàng
CREATE TRIGGER TRIG_KhachHang_Capitalize_Insert
ON [dbo].[KhachHang]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE [dbo].[KhachHang]
    SET tenKhachHang = 
        (
            SELECT STRING_AGG(
                UPPER(LEFT(value, 1)) + LOWER(SUBSTRING(value, 2, LEN(value))),
                ' '
            )
            FROM STRING_SPLIT(i.tenKhachHang, ' ')
        )
    FROM inserted i
    WHERE [dbo].[KhachHang].rowguid = i.rowguid;
END;
GO

-- Kiểm tra ngày insert hợp lệ của hoá đơn bán thuốc
CREATE TRIGGER TRIG_HoaDonBanThuoc_CheckDate_Insert
ON [dbo].[HoaDonBanThuoc]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE ngayLap > GETDATE()
    )
    BEGIN
        RAISERROR ('Ngày lập hóa đơn bán thuốc không được là ngày trong tương lai!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Kiểm tra số lượng thuốc bán ra
CREATE TRIGGER TRIG_HoaDonBanThuoc_SLThuoc_Insert
ON [dbo].[HoaDonBanThuoc]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN [dbo].[SoLuongThuocChiNhanh] t ON i.maThuoc = t.maThuoc
        WHERE i.soLuongThuoc > t.soLuong
    )
    BEGIN
        RAISERROR ('Số lượng thuốc bán ra không được lớn hơn số lượng thuốc tồn kho!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Kiểm tra mã dược sĩ 
CREATE TRIGGER TRIG_DuocSi_CheckMaDuocSi_Insert
ON [dbo].[DuocSi]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE maDuocSi NOT LIKE 'CNQ12DS[0-9][0-9][0-9]'
    )
    BEGIN
        RAISERROR ('Mã dược sĩ phải có định dạng CNQ12DSXXX (XXX là 3 chữ số)!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Kiểm tra định dạng mã hoá đơn
CREATE TRIGGER TRIG_HoaDonNhapThuoc_CheckMaHoaDonAndFK_Insert   
ON [dbo].[HoaDonNhapThuoc]
AFTER INSERT
AS
BEGIN
    -- Kiểm tra định dạng mã hóa đơn (maHoaDon)
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE maHoaDon NOT LIKE 'Q12HDN[0-9][0-9][0-9]'
    )
    BEGIN
        RAISERROR ('Mã hóa đơn nhập thuốc phải có định dạng Q12HDNXXX (XXX là 3 chữ số)!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO
