-- Xoá thủ tục nếu tồn tại: SP_DemSLThuocHoaDonNhapThuoc
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'SP_DemSLThuocHoaDonNhapThuoc')
BEGIN
    DROP PROCEDURE SP_DemSLThuocHoaDonNhapThuoc;
END;
GO

-- Tạo thủ tục: SP_DemSLThuocHoaDonNhapThuoc
CREATE PROCEDURE SP_DemSLThuocHoaDonNhapThuoc
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        h.ngayLap,
        h.maThuoc,
        SUM(h.soLuongThuoc) AS TongSoLuongThuoc
    FROM [dbo].[HoaDonNhapThuoc] h  -- Đặt alias cho bảng
    GROUP BY h.ngayLap, h.maThuoc
    ORDER BY h.ngayLap;
END;
GO


-- Xoá thủ tục nếu tồn tại: SP_DemNhanVienKhoChiNhanh
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'SP_DemNhanVienKhoChiNhanh')
BEGIN
    DROP PROCEDURE SP_DemNhanVienKhoChiNhanh;
END;
GO

-- Tạo thủ tục: SP_DemNhanVienKhoChiNhanh
CREATE PROCEDURE SP_DemNhanVienKhoChiNhanh
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        c.maChiNhanh,
        c.tenChiNhanh,
        COUNT(n.maNhanVien) AS SoLuongNhanVienKho
    FROM [dbo].[ChiNhanh] c
    LEFT JOIN [dbo].[NhanVienKho] n ON c.maChiNhanh = n.maChiNhanh
    GROUP BY c.maChiNhanh, c.tenChiNhanh
    ORDER BY c.maChiNhanh;
END;
GO


-- Xoá thủ tục nếu tồn tại: SP_DemHoaDonBanThuocDuocSi
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'SP_DemHoaDonBanThuocDuocSi')
BEGIN
    DROP PROCEDURE SP_DemHoaDonBanThuocDuocSi;
END;
GO

-- Tạo thủ tục: SP_DemHoaDonBanThuocDuocSi
CREATE PROCEDURE SP_DemHoaDonBanThuocDuocSi
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        d.maDuocSi,
        d.tenDuocSi,
        COUNT(h.rowguid) AS SoLuongHoaDon
    FROM [dbo].[DuocSi] d
    LEFT JOIN [dbo].[HoaDonBanThuoc] h ON d.maDuocSi = h.maDuocSi
    GROUP BY d.maDuocSi, d.tenDuocSi
    ORDER BY d.maDuocSi;
END;
GO


-- Xoá thủ tục nếu tồn tại: SP_DemKhachHangChiNhanh
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'SP_DemKhachHangChiNhanh')
BEGIN
    DROP PROCEDURE SP_DemKhachHangChiNhanh;
END;
GO

-- Tạo thủ tục: SP_DemKhachHangChiNhanh
CREATE PROCEDURE SP_DemKhachHangChiNhanh
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        c.maChiNhanh,
        c.tenChiNhanh,
        COUNT(DISTINCT h.maKhachHang) AS SoLuongKhachHang
    FROM [dbo].[ChiNhanh] c
    LEFT JOIN [dbo].[DuocSi] d ON c.maChiNhanh = d.maChiNhanh
    LEFT JOIN [dbo].[HoaDonBanThuoc] h ON d.maDuocSi = h.maDuocSi
    GROUP BY c.maChiNhanh, c.tenChiNhanh
    ORDER BY c.maChiNhanh;
END;
GO

-- Thống kê tổng tiền và số lượng của hoá đơn bán thuốc
CREATE PROCEDURE SP_ThongKeHoaDonBanThuoc
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        COUNT(h.rowguid) AS SoLuongHoaDon,
        SUM(h.soLuongThuoc * t.luong) AS TongTien
    FROM dbo.HoaDonBanThuoc h
    JOIN dbo.Thuoc t ON h.maThuoc = t.maThuoc;
END;

-- Thống kê tổng số lượng hoá nhập nhập và tổng tiền của hoá đơn nhập thuốc
CREATE PROCEDURE SP_ThongKeHoaDonNhapThuoc
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
        COUNT(h.rowguid) AS SoLuongHoaDonNhap,
        SUM(h.soLuongThuoc * t.giaBan) AS TongTien
    FROM dbo.HoaDonNhapThuoc h
    JOIN dbo.Thuoc t ON h.maThuoc = t.maThuoc;
END;


