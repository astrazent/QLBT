-- Tạo Database
USE QL_BANTHUOC;
GO

-- Xóa các bảng nếu có trước khi thực thi
DROP TABLE IF EXISTS HoaDonBanThuoc;
DROP TABLE IF EXISTS HoaDonNhapThuoc;
DROP TABLE IF EXISTS SoLuongThuocChiNhanh;
DROP TABLE IF EXISTS KhachHang;
DROP TABLE IF EXISTS DuocSi;
DROP TABLE IF EXISTS NhanVienKho;
DROP TABLE IF EXISTS Thuoc;
DROP TABLE IF EXISTS DanhMucThuoc;
DROP TABLE IF EXISTS ChiNhanh;

-- 1. Chi nhánh
CREATE TABLE ChiNhanh (
    maChiNhanh NVARCHAR(10) PRIMARY KEY,
    tenChiNhanh NVARCHAR(100),
    diaChi NVARCHAR(200)
);
GO

-- 2. Danh mục thuốc
CREATE TABLE DanhMucThuoc (
    maDanhMuc NVARCHAR(10) PRIMARY KEY,
    tenDanhMuc NVARCHAR(100)
);
GO

-- 3. Khách hàng
CREATE TABLE KhachHang (
    maKhachHang NVARCHAR(10) PRIMARY KEY,
    tenKhachHang NVARCHAR(100),
    gioiTinh NVARCHAR(10),
    ngaySinh DATE,
    soDienThoai NVARCHAR(15),
    diaChi NVARCHAR(200),
    maChiNhanh NVARCHAR(10) NOT NULL,
    FOREIGN KEY (maChiNhanh) REFERENCES ChiNhanh(maChiNhanh)
);
GO

-- 4. Dược sĩ
CREATE TABLE DuocSi (
    maDuocSi NVARCHAR(10) PRIMARY KEY,
    tenDuocSi NVARCHAR(100),
    gioiTinh NVARCHAR(10),  -- Chuyển cột giới tính xuống sau tên
    soDienThoai NVARCHAR(15),
    diaChi NVARCHAR(200),
    capBac NVARCHAR(10),
    maChiNhanh NVARCHAR(10) NOT NULL,
    FOREIGN KEY (maChiNhanh) REFERENCES ChiNhanh(maChiNhanh)
);

-- 5. Nhân viên kho
CREATE TABLE NhanVienKho (
    maNhanVien NVARCHAR(10) PRIMARY KEY,
    tenNhanVien NVARCHAR(100),
    gioiTinh NVARCHAR(10),
    soDienThoai NVARCHAR(15),
    diaChi NVARCHAR(200),
    luong INT,
    maChiNhanh NVARCHAR(10) NOT NULL,
    FOREIGN KEY (maChiNhanh) REFERENCES ChiNhanh(maChiNhanh)
);

-- 6. Thuốc
CREATE TABLE Thuoc (
    maThuoc NVARCHAR(10) PRIMARY KEY,
    tenThuoc NVARCHAR(100),
    thanhPhan NVARCHAR(150),
    giaBan INT,
    maDanhMuc NVARCHAR(10) NOT NULL,
    FOREIGN KEY (maDanhMuc) REFERENCES DanhMucThuoc(maDanhMuc)
);
GO

-- 7. Số lượng thuốc tại chi nhánh
CREATE TABLE SoLuongThuocChiNhanh (
    maChiNhanh NVARCHAR(10) NOT NULL,
    maThuoc NVARCHAR(10) NOT NULL,
    soLuong INT,
    FOREIGN KEY (maChiNhanh) REFERENCES ChiNhanh(maChiNhanh),
    FOREIGN KEY (maThuoc) REFERENCES Thuoc(maThuoc)
);
GO

-- 8. Hóa đơn bán thuốc
CREATE TABLE HoaDonBanThuoc (
    maHoaDon NVARCHAR(10) PRIMARY KEY,
    ngayLap DATE,
    soLuongThuoc INT,
    maKhachHang NVARCHAR(10) NOT NULL,
    maThuoc NVARCHAR(10) NOT NULL,
    maDuocSi NVARCHAR(10) NOT NULL,
    FOREIGN KEY (maKhachHang) REFERENCES KhachHang(maKhachHang),
    FOREIGN KEY (maThuoc) REFERENCES Thuoc(maThuoc),
    FOREIGN KEY (maDuocSi) REFERENCES DuocSi(maDuocSi)
);
GO

-- 9. Hóa đơn nhập thuốc
CREATE TABLE HoaDonNhapThuoc (
    maHoaDon NVARCHAR(10) PRIMARY KEY,
    ngayLap DATE,
    soLuongThuoc INT,
    maThuoc NVARCHAR(10) NOT NULL,
    maNhanVien NVARCHAR(10) NOT NULL,
    FOREIGN KEY (maThuoc) REFERENCES Thuoc(maThuoc),
    FOREIGN KEY (maNhanVien) REFERENCES NhanVienKho(maNhanVien)
);
GO

-- Thêm dữ liệu chi nhánh
INSERT INTO ChiNhanh (maChiNhanh, tenChiNhanh, diaChi) VALUES
(N'CNQ1', N'Chi nhánh Quận 1', N'Số 10, Đường Nguyễn Huệ, Phường Bến Nghé, Quận 1, TP.HCM'),
(N'CNQ3', N'Chi nhánh Quận 3', N'Số 12, Đường Cách Mạng Tháng 8, Phường 10, Quận 3, TP.HCM'),
(N'CNQ5', N'Chi nhánh Quận 5', N'Số 15, Đường Trần Hưng Đạo, Phường 5, Quận 5, TP.HCM'),
(N'CNQ7', N'Chi nhánh Quận 7', N'Số 20, Đường Nguyễn Thị Thập, Phường Tân Phú, Quận 7, TP.HCM'),
(N'CNQ10', N'Chi nhánh Quận 10', N'Số 25, Đường Sư Vạn Hạnh, Phường 12, Quận 10, TP.HCM'),
(N'CNQ12', N'Chi nhánh Quận 12', N'Số 30, Đường Lê Văn Khương, Phường Hiệp Thành, Quận 12, TP.HCM');
GO

-- Thêm dữ liệu nhân viên kho
INSERT INTO NhanVienKho (maNhanVien, tenNhanVien, gioiTinh, soDienThoai, diaChi, luong, maChiNhanh) VALUES
(N'Q5NV001',  N'Trần Hữu Thành',     N'Nam', '0903123456', N'Quận 5, TP.HCM',     10000000, N'CNQ5'),
(N'Q3NV001',  N'Nguyễn Minh Hòa',    N'Nam', '0912345678', N'Quận 3, TP.HCM',     11000000, N'CNQ3'),
(N'Q10NV001', N'Lê Thanh Bình',      N'Nam', '0923456789', N'Quận 10, TP.HCM',    9500000,  N'CNQ10'),
(N'Q7NV001',  N'Phan Bảo Ngọc',      N'Nữ', '0934567890', N'Quận 7, TP.HCM',     12000000, N'CNQ7'),
(N'Q12NV001', N'Hoàng Thiện Nhân',   N'Nam', '0945678901', N'Quận 12, TP.HCM',    11500000, N'CNQ12'),
(N'Q1NV001',  N'Trương Thị Kim',     N'Nữ', '0978901234', N'Quận 1, TP.HCM',     10200000, N'CNQ1');
GO

-- Thêm dữ liệu danh mục thuốc
INSERT INTO DanhMucThuoc (maDanhMuc, tenDanhMuc)
VALUES
    ('TC01', N'Thuốc chống dị ứng'),
    ('TC02', N'Thuốc giảm đau cơ'),
    ('TC03', N'Thuốc điều trị cảm cúm'),
    ('TC04', N'Thuốc trị ho khan'),
    ('TC05', N'Thuốc hỗ trợ tiêu hóa'),
    ('TC06', N'Thuốc bổ sung canxi'),
    ('TC07', N'Thuốc hạ huyết áp'),
    ('TC08', N'Thuốc trị viêm gan'),
    ('TC09', N'Thuốc bổ não'),
    ('TC10', N'Thuốc trị mụn trứng cá');
GO

-- Thêm dữ liệu thuốc
INSERT INTO Thuoc (maThuoc, tenThuoc, thanhPhan, giaBan, maDanhMuc)
VALUES
-- Thuốc chống dị ứng (TC01)
('T001', N'Loratadin', N'Loratadin', 140000, 'TC01'),
('T002', N'Cetirizin', N'Cetirizine hydrochloride', 150000, 'TC01'),
('T003', N'Telfast', N'Fexofenadine', 160000, 'TC01'),

-- Thuốc giảm đau cơ (TC02)
('T004', N'Mydocalm', N'Tolperisone', 180000, 'TC02'),
('T005', N'Diclofenac', N'Diclofenac sodium', 190000, 'TC02'),
('T006', N'Eperisone', N'Eperisone hydrochloride', 185000, 'TC02'),

-- Thuốc điều trị cảm cúm (TC03)
('T007', N'Decolgen', N'Paracetamol, Phenylephrine, Chlorpheniramine', 120000, 'TC03'),
('T008', N'Tiffy', N'Paracetamol, Chlorpheniramine', 110000, 'TC03'),
('T009', N'Fervex', N'Paracetamol, Pheniramine, Ascorbic acid', 130000, 'TC03'),

-- Thuốc trị ho khan (TC04)
('T010', N'Codepect', N'Dextromethorphan, Guaifenesin', 125000, 'TC04'),
('T011', N'Terpin Codein', N'Terpin hydrate, Codein', 135000, 'TC04'),
('T012', N'Bromhexin', N'Bromhexine hydrochloride', 140000, 'TC04'),

-- Thuốc hỗ trợ tiêu hóa (TC05)
('T013', N'Mezyme', N'Pancreatin', 150000, 'TC05'),
('T014', N'Motilium', N'Domperidone', 155000, 'TC05'),
('T015', N'Smecta', N'Diosmectite', 160000, 'TC05'),

-- Thuốc bổ sung canxi (TC06)
('T016', N'Calcium Corbiere', N'Calcium gluconolactate, Vitamin C', 170000, 'TC06'),
('T017', N'Calcium D', N'Calcium carbonate, Vitamin D3', 175000, 'TC06'),
('T018', N'Oscal', N'Calcium carbonate', 180000, 'TC06'),

-- Thuốc hạ huyết áp (TC07)
('T019', N'Losartan', N'Losartan potassium', 190000, 'TC07'),
('T020', N'Amlor', N'Amlodipine besylate', 200000, 'TC07'),
('T021', N'Lisinopril', N'Lisinopril', 195000, 'TC07'),

-- Thuốc trị viêm gan (TC08)
('T022', N'Entecavir', N'Entecavir', 210000, 'TC08'),
('T023', N'Tenofovir', N'Tenofovir disoproxil fumarate', 220000, 'TC08'),
('T024', N'Sofosbuvir', N'Sofosbuvir', 230000, 'TC08'),

-- Thuốc bổ não (TC09)
('T025', N'Piracetam', N'Piracetam', 150000, 'TC09'),
('T026', N'Ginkgo Biloba', N'Chiết xuất bạch quả', 160000, 'TC09'),
('T027', N'Citicoline', N'Citicoline sodium', 170000, 'TC09'),

-- Thuốc trị mụn trứng cá (TC10)
('T028', N'Acnotin', N'Isotretinoin', 250000, 'TC10'),
('T029', N'Duac Gel', N'Clindamycin, Benzoyl Peroxide', 260000, 'TC10'),
('T030', N'Adapalene', N'Adapalene', 240000, 'TC10');

-- Thêm dữ liệu dược sĩ 
-- Dữ liệu chi nhánh Quận 1
-- Dữ liệu chi nhánh Quận 1
INSERT INTO DuocSi (maDuocSi, tenDuocSi, gioiTinh, diaChi, soDienThoai, capBac, maChiNhanh) VALUES
(N'CNQ1DS001', N'Nguyễn Minh Tuấn', N'Nam', N'Số 1, Đường Lê Thị Hồng Gấm, Quận 1, TP.HCM', '0909123456', 1, N'CNQ1'),
(N'CNQ1DS002', N'Lê Thiên Hương', N'Nữ', N'Số 2, Đường Nguyễn Huệ, Quận 1, TP.HCM', '0912234567', 2, N'CNQ1'),
(N'CNQ1DS003', N'Vũ Thị Mỹ Linh', N'Nữ', N'Số 3, Đường Phạm Ngọc Thạch, Quận 1, TP.HCM', '0907345678', 3, N'CNQ1'),
(N'CNQ1DS004', N'Phan Hải Đăng', N'Nam', N'Số 4, Đường Đồng Khởi, Quận 1, TP.HCM', '0918345679', 5, N'CNQ1'),
(N'CNQ1DS005', N'Nguyễn Thị Lan Anh', N'Nữ', N'Số 5, Đường Pasteur, Quận 1, TP.HCM', '0921122334', 4, N'CNQ1');

-- Dữ liệu chi nhánh Quận 3
INSERT INTO DuocSi (maDuocSi, tenDuocSi, gioiTinh, diaChi, soDienThoai, capBac, maChiNhanh) VALUES
(N'CNQ3DS001', N'Nguyễn Hoàng Nam', N'Nam', N'Số 10, Đường Trường Sa, Quận 3, TP.HCM', '0932323456', 1, N'CNQ3'),
(N'CNQ3DS002', N'Phan Hoàng Yến', N'Nữ', N'Số 20, Đường Cao Thắng, Quận 3, TP.HCM', '0909234567', 2, N'CNQ3'),
(N'CNQ3DS003', N'Lê Minh Khánh', N'Nam', N'Số 15, Đường Nguyễn Thông, Quận 3, TP.HCM', '0917345678', 3, N'CNQ3'),
(N'CNQ3DS004', N'Vũ Thanh Bình', N'Nam', N'Số 25, Đường Võ Thị Sáu, Quận 3, TP.HCM', '0923456789', 5, N'CNQ3'),
(N'CNQ3DS005', N'Hoàng Thị Thuý', N'Nữ', N'Số 30, Đường Cách Mạng Tháng 8, Quận 3, TP.HCM', '0934567890', 4, N'CNQ3');

-- Dữ liệu chi nhánh Quận 5
INSERT INTO DuocSi (maDuocSi, tenDuocSi, gioiTinh, diaChi, soDienThoai, capBac, maChiNhanh) VALUES
(N'CNQ5DS001', N'Nguyễn Quốc Tuấn', N'Nam', N'Số 40, Đường Trần Hưng Đạo, Quận 5, TP.HCM', '0945123456', 1, N'CNQ5'),
(N'CNQ5DS002', N'Lê Thị Hải Yến', N'Nữ', N'Số 50, Đường Nguyễn Trãi, Quận 5, TP.HCM', '0906324567', 2, N'CNQ5'),
(N'CNQ5DS003', N'Vũ Tuấn Anh', N'Nam', N'Số 55, Đường Lý Thường Kiệt, Quận 5, TP.HCM', '0912123456', 4, N'CNQ5'),
(N'CNQ5DS004', N'Phan Minh Hoàng', N'Nam', N'Số 60, Đường Nguyễn Thị Nhỏ, Quận 5, TP.HCM', '0923456789', 5, N'CNQ5'),
(N'CNQ5DS005', N'Hoàng Thi Thanh', N'Nữ', N'Số 65, Đường Hùng Vương, Quận 5, TP.HCM', '0901234567', 3, N'CNQ5');

-- Dữ liệu chi nhánh Quận 7
INSERT INTO DuocSi (maDuocSi, tenDuocSi, gioiTinh, diaChi, soDienThoai, capBac, maChiNhanh) VALUES
(N'CNQ7DS001', N'Nguyễn Quốc Hưng', N'Nam', N'Số 70, Đường Nguyễn Thị Thập, Quận 7, TP.HCM', '0912345678', 1, N'CNQ7'),
(N'CNQ7DS002', N'Lê Thi Hồng', N'Nữ', N'Số 80, Đường Phạm Hữu Lầu, Quận 7, TP.HCM', '0923345678', 2, N'CNQ7'),
(N'CNQ7DS003', N'Vũ Tuấn Kiệt', N'Nam', N'Số 90, Đường Lê Văn Lương, Quận 7, TP.HCM', '0912345679', 4, N'CNQ7'),
(N'CNQ7DS004', N'Phan Thi Ngọc', N'Nữ', N'Số 100, Đường Nguyễn Thị Thập, Quận 7, TP.HCM', '0923456780', 5, N'CNQ7'),
(N'CNQ7DS005', N'Hoàng Hữu Quân', N'Nam', N'Số 110, Đường Nguyễn Lương Bằng, Quận 7, TP.HCM', '0934567891', 3, N'CNQ7');

-- Dữ liệu chi nhánh Quận 10
INSERT INTO DuocSi (maDuocSi, tenDuocSi, gioiTinh, diaChi, soDienThoai, capBac, maChiNhanh) VALUES
(N'CNQ10DS001', N'Nguyễn Văn Linh', N'Nam', N'Số 120, Đường Sư Vạn Hạnh, Quận 10, TP.HCM', '0934567890', 1, N'CNQ10'),
(N'CNQ10DS002', N'Lê Thanh Tâm', N'Nữ', N'Số 130, Đường Lý Thường Kiệt, Quận 10, TP.HCM', '0923456780', 2, N'CNQ10'),
(N'CNQ10DS003', N'Vũ Thị Lan', N'Nữ', N'Số 140, Đường Cách Mạng Tháng 8, Quận 10, TP.HCM', '0901234568', 4, N'CNQ10'),
(N'CNQ10DS004', N'Phan Minh Đức', N'Nam', N'Số 150, Đường Lê Hồng Phong, Quận 10, TP.HCM', '0912345679', 5, N'CNQ10'),
(N'CNQ10DS005', N'Hoàng Thanh Hoài', N'Nữ', N'Số 160, Đường 3 Tháng 2, Quận 10, TP.HCM', '0935678901', 3, N'CNQ10');

-- Dữ liệu chi nhánh Quận 12
INSERT INTO DuocSi (maDuocSi, tenDuocSi, gioiTinh, diaChi, soDienThoai, capBac, maChiNhanh) VALUES
(N'CNQ12DS001', N'Nguyễn Thị Kim Lan', N'Nữ', N'Số 15, Đường Nguyễn Văn Cừ, Quận 12, TP.HCM', '0901234567', 1, N'CNQ12'),
(N'CNQ12DS002', N'Lê Văn Cường', N'Nam', N'Số 20, Đường Lê Văn Lương, Quận 12, TP.HCM', '0912345678', 2, N'CNQ12'),
(N'CNQ12DS003', N'Phan Thiên Hương', N'Nữ', N'Số 30, Đường Trường Chinh, Quận 12, TP.HCM', '0923456789', 4, N'CNQ12'),
(N'CNQ12DS004', N'Vũ Tiến Duy', N'Nam', N'Số 40, Đường Ngô Chí Quốc, Quận 12, TP.HCM', '0934567890', 5, N'CNQ12'),
(N'CNQ12DS005', N'Hoàng Minh Duy', N'Nam', N'Số 50, Đường Thạnh Lộc, Quận 12, TP.HCM', '0945678901', 3, N'CNQ12');

-- Thêm dữ liệu khách hàng
-- Dữ liệu chi nhánh Quận 1
INSERT INTO KhachHang (maKhachHang, tenKhachHang, gioiTinh, ngaySinh, soDienThoai, diaChi, maChiNhanh) VALUES
('Q1KH0001', N'Nguyễn Văn Phúc', N'Nam', '1985-01-15', '0901122334', N'12 Nguyễn Huệ, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0002', N'Lê Thị Hồng', N'Nữ', '1990-03-22', '0912345678', N'45 Lê Lợi, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0003', N'Trần Minh Huy', N'Nam', '1982-07-08', '0923456789', N'78 Pasteur, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0004', N'Phạm Thị Mai', N'Nữ', '1979-10-10', '0934567890', N'123 Đồng Khởi, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0005', N'Đặng Văn Toàn', N'Nam', '1988-06-05', '0945678901', N'56 Nguyễn Du, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0006', N'Huỳnh Thị Lan', N'Nữ', '1995-09-17', '0956789012', N'89 Lý Tự Trọng, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0007', N'Ngô Văn Thành', N'Nam', '1975-12-25', '0967890123', N'34 Tôn Thất Thiệp, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0008', N'Lý Thị Kim', N'Nữ', '1983-04-12', '0978901234', N'67 Trần Hưng Đạo, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0009', N'Bùi Minh Khang', N'Nam', '1991-08-30', '0989012345', N'23 Nguyễn Trãi, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0010', N'Tống Thị Yến', N'Nữ', '1986-05-19', '0990123456', N'10 Cách Mạng Tháng 8, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0011', N'Trịnh Văn Long', N'Nam', '1993-11-11', '0902233445', N'101 Nam Kỳ Khởi Nghĩa, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0012', N'Dương Thị Hòa', N'Nữ', '1987-02-02', '0913344556', N'22 Võ Thị Sáu, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0013', N'Phan Văn Lộc', N'Nam', '1980-06-18', '0924455667', N'33 Lý Tự Trọng, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0014', N'Hoàng Thị Ngọc', N'Nữ', '1978-09-09', '0935566778', N'44 Nguyễn Thái Học, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0015', N'Nguyễn Hoàng Sơn', N'Nam', '1996-07-01', '0946677889', N'55 Nguyễn Văn Bình, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0016', N'Võ Thị Tuyết', N'Nữ', '1990-03-14', '0957788990', N'66 Phạm Ngũ Lão, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0017', N'Đoàn Văn Khoa', N'Nam', '1984-12-24', '0968899001', N'77 Đinh Tiên Hoàng, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0018', N'Phạm Thị Hạnh', N'Nữ', '1982-08-08', '0979900112', N'88 Hai Bà Trưng, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0019', N'Nguyễn Văn Cường', N'Nam', '1976-10-15', '0980011223', N'99 Nguyễn Đình Chiểu, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0020', N'Lê Thị Bích', N'Nữ', '1989-04-07', '0991122334', N'11 Nguyễn Công Trứ, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0021', N'Trần Văn Duy', N'Nam', '1985-01-28', '0903344556', N'17 Nguyễn Bỉnh Khiêm, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0022', N'Ngô Thị Hà', N'Nữ', '1992-06-20', '0914455667', N'19 Nguyễn Hữu Cảnh, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0023', N'Hồ Văn Minh', N'Nam', '1981-03-11', '0925566778', N'25 Tôn Đức Thắng, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0024', N'Bùi Thị Trang', N'Nữ', '1979-07-23', '0936677889', N'29 Nguyễn Phi Khanh, Quận 1, TP.HCM', 'CNQ1'),
('Q1KH0025', N'Phan Văn Hùng', N'Nam', '1994-09-09', '0947788990', N'31 Nguyễn Văn Giai, Quận 1, TP.HCM', 'CNQ1');

-- Dữ liệu chi nhánh Quận 3
INSERT INTO KhachHang (maKhachHang, tenKhachHang, gioiTinh, ngaySinh, soDienThoai, diaChi, maChiNhanh) VALUES
('Q3KH0001', N'Nguyễn Văn Khánh', N'Nam', '1980-05-12', '0901122334', N'15 Lê Văn Sỹ, P.1, Q3, TP.HCM', 'CNQ3'),
('Q3KH0002', N'Hoàng Thị Mai', N'Nữ', '1992-09-20', '0912233445', N'23 Cách Mạng Tháng 8, P.2, Q3, TP.HCM', 'CNQ3'),
('Q3KH0003', N'Lê Văn Thịnh', N'Nam', '1985-03-15', '0903344556', N'89 Nguyễn Đình Chiểu, P.3, Q3, TP.HCM', 'CNQ3'),
('Q3KH0004', N'Trần Thị Bích', N'Nữ', '1990-07-22', '0932233445', N'45 Kỳ Đồng, P.4, Q3, TP.HCM', 'CNQ3'),
('Q3KH0005', N'Phạm Văn Duy', N'Nam', '1978-11-10', '0944556677', N'19 Trần Quốc Thảo, P.5, Q3, TP.HCM', 'CNQ3'),
('Q3KH0006', N'Lý Thị Hà', N'Nữ', '1996-01-25', '0956677889', N'55 Lý Chính Thắng, P.6, Q3, TP.HCM', 'CNQ3'),
('Q3KH0007', N'Ngô Văn Hải', N'Nam', '1987-09-30', '0911223344', N'67 Nguyễn Thượng Hiền, P.7, Q3, TP.HCM', 'CNQ3'),
('Q3KH0008', N'Vũ Thị Yến', N'Nữ', '1989-08-08', '0967788990', N'78 Võ Thị Sáu, P.8, Q3, TP.HCM', 'CNQ3'),
('Q3KH0009', N'Đặng Văn Bình', N'Nam', '1983-12-19', '0978899001', N'88 Rạch Bùng Binh, P.9, Q3, TP.HCM', 'CNQ3'),
('Q3KH0010', N'Nguyễn Thị Lan', N'Nữ', '1993-04-17', '0989001122', N'91 Cao Thắng, P.10, Q3, TP.HCM', 'CNQ3'),
('Q3KH0011', N'Trịnh Văn Phúc', N'Nam', '1986-06-09', '0901234567', N'101 Bàn Cờ, P.11, Q3, TP.HCM', 'CNQ3'),
('Q3KH0012', N'Hoàng Thị Xuân', N'Nữ', '1991-07-05', '0912345678', N'111 Nguyễn Thiện Thuật, P.12, Q3, TP.HCM', 'CNQ3'),
('Q3KH0013', N'Lâm Văn Quang', N'Nam', '1984-02-18', '0923456789', N'121 Nguyễn Phúc Nguyên, P.13, Q3, TP.HCM', 'CNQ3'),
('Q3KH0014', N'Phan Thị Hương', N'Nữ', '1995-10-11', '0934567890', N'131 Kỳ Đồng, P.14, Q3, TP.HCM', 'CNQ3'),
('Q3KH0015', N'Tống Văn Huy', N'Nam', '1979-11-22', '0945678901', N'141 Nguyễn Thông, P.1, Q3, TP.HCM', 'CNQ3'),
('Q3KH0016', N'Trần Thị Tuyết', N'Nữ', '1988-01-19', '0956789012', N'151 Bàn Cờ, P.2, Q3, TP.HCM', 'CNQ3'),
('Q3KH0017', N'Nguyễn Văn An', N'Nam', '1990-03-27', '0967890123', N'161 Nguyễn Sơn Hà, P.3, Q3, TP.HCM', 'CNQ3'),
('Q3KH0018', N'Trương Thị Nhàn', N'Nữ', '1982-12-05', '0978901234', N'171 Trần Văn Đang, P.4, Q3, TP.HCM', 'CNQ3'),
('Q3KH0019', N'Đoàn Văn Kiên', N'Nam', '1994-06-14', '0989012345', N'181 Nguyễn Thị Minh Khai, P.5, Q3, TP.HCM', 'CNQ3'),
('Q3KH0020', N'Nguyễn Thị Hòa', N'Nữ', '1981-09-21', '0990123456', N'191 Trương Định, P.6, Q3, TP.HCM', 'CNQ3'),
('Q3KH0021', N'Lê Văn Toàn', N'Nam', '1993-08-10', '0901122566', N'201 Lý Chính Thắng, P.7, Q3, TP.HCM', 'CNQ3'),
('Q3KH0022', N'Bùi Thị Nga', N'Nữ', '1986-10-23', '0912233677', N'211 Nguyễn Đình Chiểu, P.8, Q3, TP.HCM', 'CNQ3'),
('Q3KH0023', N'Tạ Văn Trường', N'Nam', '1987-05-01', '0923344788', N'221 Võ Văn Tần, P.9, Q3, TP.HCM', 'CNQ3'),
('Q3KH0024', N'Nguyễn Thị Hạnh', N'Nữ', '1992-03-30', '0934455899', N'231 Trần Quang Diệu, P.10, Q3, TP.HCM', 'CNQ3'),
('Q3KH0025', N'Trần Văn Minh', N'Nam', '1985-04-12', '0945566900', N'241 Huỳnh Tịnh Của, P.11, Q3, TP.HCM', 'CNQ3'),
('Q3KH0026', N'Lê Thị Huệ', N'Nữ', '1990-06-16', '0956677011', N'251 Nguyễn Sơn Hà, P.12, Q3, TP.HCM', 'CNQ3'),
('Q3KH0027', N'Đinh Văn Trung', N'Nam', '1989-08-08', '0967788122', N'261 Lý Thái Tổ, P.13, Q3, TP.HCM', 'CNQ3'),
('Q3KH0028', N'Phạm Thị Thanh', N'Nữ', '1997-07-25', '0978899233', N'271 Trương Quyền, P.14, Q3, TP.HCM', 'CNQ3'),
('Q3KH0029', N'Huỳnh Văn Cường', N'Nam', '1983-11-14', '0989900344', N'281 Nguyễn Thiện Thuật, P.1, Q3, TP.HCM', 'CNQ3'),
('Q3KH0030', N'Trịnh Thị Hoa', N'Nữ', '1984-02-28', '0990011455', N'291 Cách Mạng Tháng 8, P.2, Q3, TP.HCM', 'CNQ3');

-- Dữ liệu chi nhánh Quận 5
INSERT INTO KhachHang (maKhachHang, tenKhachHang, gioiTinh, ngaySinh, soDienThoai, diaChi, maChiNhanh) VALUES
('Q5KH0001', N'Nguyễn Thị Lan', N'Nữ', '1987-02-14', '0902233445', N'12 Lý Thường Kiệt, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0002', N'Trần Minh Tuấn', N'Nam', '1990-06-21', '0913344556', N'34 Nguyễn Văn Cừ, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0003', N'Phạm Thị Mỹ Dung', N'Nữ', '1985-09-15', '0924455667', N'56 An Dương Vương, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0004', N'Ngô Thị Kim Chi', N'Nữ', '1992-03-07', '0935566778', N'78 Châu Văn Liêm, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0005', N'Huỳnh Minh Tâm', N'Nam', '1980-10-03', '0946677889', N'90 Trần Hưng Đạo, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0006', N'Lê Ngọc Quân', N'Nam', '1988-11-30', '0957788990', N'101 Lê Hồng Phong, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0007', N'Bùi Thị Thu', N'Nữ', '1994-08-17', '0968899001', N'112 Võ Văn Kiệt, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0008', N'Võ Văn Khải', N'Nam', '1983-05-22', '0979900112', N'123 Nguyễn Tri Phương, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0009', N'Trịnh Thị Hạnh', N'Nữ', '1991-12-01', '0980011223', N'145 Lê Đại Hành, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0010', N'Phan Thanh Sơn', N'Nam', '1986-04-18', '0991122334', N'167 Ba Tháng Hai, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0011', N'Nguyễn Thị Yến', N'Nữ', '1993-07-20', '0902233445', N'178 Nguyễn Trãi, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0012', N'Ngô Thị Thảo', N'Nữ', '1984-05-03', '0913344556', N'189 Cư Xá Phú Lâm, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0013', N'Lê Minh Tuấn', N'Nam', '1987-02-25', '0924455667', N'210 Lý Thường Kiệt, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0014', N'Bùi Ngọc Mai', N'Nữ', '1990-11-10', '0935566778', N'222 Trần Bình Trọng, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0015', N'Hoàng Văn Thái', N'Nam', '1982-08-17', '0946677889', N'234 Nguyễn Tri Phương, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0016', N'Trần Thị Cẩm', N'Nữ', '1995-05-25', '0957788990', N'245 Hòa Bình, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0017', N'Nguyễn Đình Hưng', N'Nam', '1989-10-05', '0968899001', N'256 Cách Mạng Tháng 8, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0018', N'Trần Thị Lan', N'Nữ', '1992-01-13', '0979900112', N'267 Châu Văn Liêm, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0019', N'Phan Thiên An', N'Nam', '1983-06-23', '0980011223', N'278 Tân Hòa Đông, Quận 5, TP.HCM', 'CNQ5'),
('Q5KH0020', N'Lê Hoàng Minh', N'Nam', '1994-02-14', '0991122334', N'289 Trần Hưng Đạo, Quận 5, TP.HCM', 'CNQ5');

-- Dữ liệu chi nhánh Quận 7
INSERT INTO KhachHang (maKhachHang, tenKhachHang, gioiTinh, ngaySinh, soDienThoai, diaChi, maChiNhanh) VALUES
('Q7KH0001', N'Nguyễn Thị Lan', N'Nữ', '1985-01-15', '0902233445', N'12 Nguyễn Thị Thập, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0002', N'Trần Minh Tuấn', N'Nam', '1990-06-21', '0913344556', N'34 Nguyễn Văn Linh, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0003', N'Phạm Thị Mỹ Dung', N'Nữ', '1985-09-15', '0924455667', N'56 Lê Văn Lương, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0004', N'Ngô Thị Kim Chi', N'Nữ', '1992-03-07', '0935566778', N'78 Nguyễn Hữu Thọ, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0005', N'Huỳnh Minh Tâm', N'Nam', '1980-10-03', '0946677889', N'90 Đào Trí, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0006', N'Lê Ngọc Quân', N'Nam', '1988-11-30', '0957788990', N'101 Tân Hương, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0007', N'Bùi Thị Thu', N'Nữ', '1994-08-17', '0968899001', N'112 Đinh Tiên Hoàng, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0008', N'Võ Văn Khải', N'Nam', '1983-05-22', '0979900112', N'123 Nguyễn Tri Phương, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0009', N'Trịnh Thị Hạnh', N'Nữ', '1991-12-01', '0980011223', N'145 Ba Tháng Hai, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0010', N'Phan Thanh Sơn', N'Nam', '1986-04-18', '0991122334', N'167 Nguyễn Văn Cừ, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0011', N'Nguyễn Thị Yến', N'Nữ', '1993-07-20', '0902233445', N'178 Nguyễn Thị Thập, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0012', N'Ngô Thị Thảo', N'Nữ', '1984-05-03', '0913344556', N'189 Nguyễn Hữu Thọ, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0013', N'Lê Minh Tuấn', N'Nam', '1987-02-25', '0924455667', N'210 Đào Trí, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0014', N'Bùi Ngọc Mai', N'Nữ', '1990-11-10', '0935566778', N'222 Nguyễn Văn Linh, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0015', N'Hoàng Văn Thái', N'Nam', '1982-08-17', '0946677889', N'234 Lê Văn Lương, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0016', N'Trần Thị Cẩm', N'Nữ', '1995-05-25', '0957788990', N'245 Đinh Tiên Hoàng, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0017', N'Nguyễn Đình Hưng', N'Nam', '1989-10-05', '0968899001', N'256 Nguyễn Hữu Thọ, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0018', N'Trần Thị Lan', N'Nữ', '1992-01-13', '0979900112', N'267 Nguyễn Tri Phương, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0019', N'Phan Thiên An', N'Nam', '1983-06-23', '0980011223', N'278 Tân Kiên, Quận 7, TP.HCM', 'CNQ7'),
('Q7KH0020', N'Lê Hoàng Minh', N'Nam', '1994-02-14', '0991122334', N'289 Lê Thị Thập, Quận 7, TP.HCM', 'CNQ7');

-- Dữ liệu chi nhánh Quận 10
INSERT INTO KhachHang (maKhachHang, tenKhachHang, gioiTinh, ngaySinh, soDienThoai, diaChi, maChiNhanh) VALUES
('Q10KH0001', N'Nguyễn Thanh Tâm', N'Nam', '1985-04-25', '0901122334', N'12 Lý Thường Kiệt, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0002', N'Bùi Thị Mai', N'Nữ', '1990-03-10', '0912233445', N'34 Hòa Hưng, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0003', N'Trần Thị Lan', N'Nữ', '1988-07-15', '0923344556', N'56 Nguyễn Lâm, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0004', N'Phạm Văn Quang', N'Nam', '1995-01-20', '0934455667', N'78 Cách Mạng Tháng 8, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0005', N'Nguyễn Hoàng Sơn', N'Nam', '1982-09-11', '0945566778', N'90 Lê Hồng Phong, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0006', N'Võ Thị Kim', N'Nữ', '1991-12-25', '0956677889', N'101 Sư Vạn Hạnh, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0007', N'Ngô Thanh Mai', N'Nữ', '1987-06-05', '0967788990', N'112 Ngô Gia Tự, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0008', N'Lê Quang Minh', N'Nam', '1989-08-22', '0978899001', N'123 Lý Chính Thắng, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0009', N'Trần Minh Duy', N'Nam', '1994-04-14', '0989001122', N'134 Nguyễn Thị Nhỏ, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0010', N'Phan Thiện Ngọc', N'Nam', '1980-01-18', '0990112233', N'145 Ba Tháng Hai, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0011', N'Nguyễn Kim Tuyến', N'Nữ', '1993-02-11', '0902233445', N'156 Lý Thái Tổ, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0012', N'Bùi Hữu Thế', N'Nam', '1986-11-23', '0913344556', N'167 Nguyễn Thị Minh Khai, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0013', N'Võ Thị Bình', N'Nữ', '1992-05-29', '0924455667', N'178 Phạm Ngọc Thạch, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0014', N'Hoàng Minh Tuấn', N'Nam', '1984-03-03', '0935566778', N'189 Trần Quang Diệu, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0015', N'Lê Thị Mai', N'Nữ', '1995-06-12', '0946677889', N'190 Nguyễn Thái Học, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0016', N'Nguyễn Văn Lâm', N'Nam', '1987-10-10', '0957788990', N'201 Hòa Hưng, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0017', N'Phan Thanh Thúy', N'Nữ', '1991-08-25', '0968899001', N'212 Trường Chinh, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0018', N'Ngô Thiện Minh', N'Nam', '1983-02-17', '0979900112', N'223 Lý Thường Kiệt, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0019', N'Võ Thị Thu', N'Nữ', '1990-12-30', '0980011223', N'234 Nguyễn Văn Quá, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0020', N'Phan Văn Sơn', N'Nam', '1994-07-22', '0991122334', N'245 Ba Tháng Hai, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0021', N'Nguyễn Thị Lan', N'Nữ', '1987-05-18', '0902233445', N'256 Lê Hồng Phong, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0022', N'Bùi Thanh Quang', N'Nam', '1993-09-05', '0913344556', N'267 Sư Vạn Hạnh, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0023', N'Võ Quang Hòa', N'Nam', '1985-12-02', '0924455667', N'278 Nguyễn Tri Phương, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0024', N'Nguyễn Hữu Duy', N'Nam', '1991-06-14', '0935566778', N'289 Cách Mạng Tháng 8, Quận 10, TP.HCM', 'CNQ10'),
('Q10KH0025', N'Phan Thị Thu Hồng', N'Nữ', '1992-01-29', '0946677889', N'300 Trần Phú, Quận 10, TP.HCM', 'CNQ10');

-- Dữ liệu chi nhánh Quận 12
INSERT INTO KhachHang (maKhachHang, tenKhachHang, gioiTinh, ngaySinh, soDienThoai, diaChi, maChiNhanh) VALUES
('Q12KH0001', N'Nguyễn Thị Lan', N'Nữ', '1987-02-28', '0902233445', N'12 Nguyễn Văn Quá, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0002', N'Trần Minh Quang', N'Nam', '1990-03-10', '0913344556', N'34 Trường Chinh, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0003', N'Ngô Hữu Quý', N'Nam', '1989-04-15', '0924455667', N'56 Quốc Lộ 1A, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0004', N'Phạm Thị Hồng', N'Nữ', '1985-01-22', '0935566778', N'78 Nguyễn Thị Kiều, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0005', N'Bùi Minh Khôi', N'Nam', '1992-11-03', '0946677889', N'90 Tô Ký, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0006', N'Võ Thị Lan', N'Nữ', '1994-05-10', '0957788990', N'101 Ngô Chí Quốc, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0007', N'Hoàng Minh Đức', N'Nam', '1991-10-28', '0968899001', N'112 Lê Thị Riêng, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0008', N'Nguyễn Hoàng Nam', N'Nam', '1986-06-11', '0979900112', N'123 Nguyễn Văn Khối, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0009', N'Lê Thi Thanh', N'Nữ', '1990-12-02', '0980011223', N'134 Nguyễn Sơn, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0010', N'Phan Thị Thanh', N'Nữ', '1995-02-20', '0991122334', N'145 Hà Huy Giáp, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0011', N'Trần Minh Thiện', N'Nam', '1983-11-30', '0902233445', N'156 Cầu Sơn, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0012', N'Ngô Thi Tuyết', N'Nữ', '1992-07-17', '0913344556', N'167 Đường Bờ Bao, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0013', N'Bùi Minh Lâm', N'Nam', '1988-03-22', '0924455667', N'178 Đường Đinh Tiên Hoàng, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0014', N'Lê Ngọc Trân', N'Nữ', '1991-09-05', '0935566778', N'189 Nguyễn Thị Tính, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0015', N'Nguyễn Hoàng Sơn', N'Nam', '1994-06-12', '0946677889', N'190 Tân Chánh Hiệp, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0016', N'Phan Thanh Quang', N'Nam', '1986-07-18', '0957788990', N'201 Quốc Lộ 1A, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0017', N'Võ Thi Quân', N'Nữ', '1990-08-03', '0968899001', N'212 Thạnh Xuân, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0018', N'Nguyễn Thị Bích', N'Nữ', '1983-04-25', '0979900112', N'223 Đặng Thị Rành, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0019', N'Lê Minh Tâm', N'Nam', '1995-12-12', '0980011223', N'234 Thạnh Lộc, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0020', N'Hoàng Thị Mỹ Lan', N'Nữ', '1990-04-05', '0991122334', N'245 Tân Thới Hiệp, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0021', N'Nguyễn Thi Ngọc', N'Nữ', '1992-06-29', '0902233445', N'256 Trường Sơn, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0022', N'Võ Văn Khoa', N'Nam', '1984-02-14', '0913344556', N'267 Tân Hưng, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0023', N'Trần Thi Khánh', N'Nữ', '1991-10-19', '0924455667', N'278 Phan Hòa, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0024', N'Phan Thi Tuyết', N'Nữ', '1993-08-08', '0935566778', N'289 Lê Trọng Tấn, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0025', N'Nguyễn Minh Đức', N'Nam', '1989-11-16', '0946677889', N'300 Bến Chương Dương, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0026', N'Bùi Thị Kim', N'Nữ', '1992-07-25', '0957788990', N'311 Thạnh Quận, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0027', N'Lê Thi Mộng', N'Nữ', '1994-12-12', '0968899001', N'322 Lương Quý, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0028', N'Nguyễn Thị Thị', N'Nữ', '1985-03-30', '0979900112', N'333 Tân Trụ, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0029', N'Võ Quang Hòa', N'Nam', '1990-08-10', '0980011223', N'344 Lê Văn Lương, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0030', N'Trần Thanh Quyền', N'Nam', '1983-05-07', '0991122334', N'355 Phú Thọ, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0031', N'Phan Thi An', N'Nữ', '1989-10-12', '0902233445', N'366 Quốc Lộ 1, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0032', N'Nguyễn Thị Bảo', N'Nữ', '1994-01-18', '0913344556', N'377 Nguyễn Thị Quý, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0033', N'Võ Thiết Bảo', N'Nam', '1987-06-04', '0924455667', N'388 Trần Văn Ngọ, Quận 12, TP.HCM', 'CNQ12'),
('Q12KH0034', N'Nguyễn Hương Thảo', N'Nữ', '1991-11-19', '0935566778', N'399 Lê Trọng Tấn, Quận 12, TP.HCM', 'CNQ12');

-- Thêm dữ liệu thông tin số lượng
-- Dữ liệu chi nhánh Quận 1
INSERT INTO SoLuongThuocChiNhanh (maChiNhanh, maThuoc, soLuong)
VALUES
('CNQ1', 'T001', 45),
('CNQ1', 'T002', 36),
('CNQ1', 'T003', 80),
('CNQ1', 'T004', 79),
('CNQ1', 'T005', 20),
('CNQ1', 'T006', 24),
('CNQ1', 'T007', 82),
('CNQ1', 'T008', 71),
('CNQ1', 'T009', 82),
('CNQ1', 'T010', 2),
('CNQ1', 'T011', 17),
('CNQ1', 'T012', 47),
('CNQ1', 'T013', 81),
('CNQ1', 'T014', 60),
('CNQ1', 'T015', 94),
('CNQ1', 'T016', 71),
('CNQ1', 'T017', 20),
('CNQ1', 'T018', 44),
('CNQ1', 'T019', 36),
('CNQ1', 'T020', 13),
('CNQ1', 'T021', 34),
('CNQ1', 'T022', 15),
('CNQ1', 'T023', 97),
('CNQ1', 'T024', 94),
('CNQ1', 'T025', 28),
('CNQ1', 'T026', 76),
('CNQ1', 'T027', 72),
('CNQ1', 'T028', 66),
('CNQ1', 'T029', 52),
('CNQ1', 'T030', 36);

-- Dữ liệu chi nhánh Quận 3
INSERT INTO SoLuongThuocChiNhanh (maChiNhanh, maThuoc, soLuong)
VALUES
('CNQ3', 'T001', 29),
('CNQ3', 'T002', 58),
('CNQ3', 'T003', 4),
('CNQ3', 'T004', 24),
('CNQ3', 'T005', 90),
('CNQ3', 'T006', 24),
('CNQ3', 'T007', 36),
('CNQ3', 'T008', 7),
('CNQ3', 'T009', 25),
('CNQ3', 'T010', 76),
('CNQ3', 'T011', 9),
('CNQ3', 'T012', 23),
('CNQ3', 'T013', 50),
('CNQ3', 'T014', 86),
('CNQ3', 'T015', 89),
('CNQ3', 'T016', 83),
('CNQ3', 'T017', 19),
('CNQ3', 'T018', 41),
('CNQ3', 'T019', 28),
('CNQ3', 'T020', 75),
('CNQ3', 'T021', 60),
('CNQ3', 'T022', 77),
('CNQ3', 'T023', 20),
('CNQ3', 'T024', 71),
('CNQ3', 'T025', 65),
('CNQ3', 'T026', 27),
('CNQ3', 'T027', 48),
('CNQ3', 'T028', 66),
('CNQ3', 'T029', 56),
('CNQ3', 'T030', 65);

-- Dữ liệu chi nhánh Quận 5
INSERT INTO SoLuongThuocChiNhanh (maChiNhanh, maThuoc, soLuong)
VALUES
('CNQ5', 'T001', 6),
('CNQ5', 'T002', 7),
('CNQ5', 'T003', 51),
('CNQ5', 'T004', 1),
('CNQ5', 'T005', 95),
('CNQ5', 'T006', 87),
('CNQ5', 'T007', 99),
('CNQ5', 'T008', 97),
('CNQ5', 'T009', 65),
('CNQ5', 'T010', 19),
('CNQ5', 'T011', 51),
('CNQ5', 'T012', 17),
('CNQ5', 'T013', 49),
('CNQ5', 'T014', 35),
('CNQ5', 'T015', 25),
('CNQ5', 'T016', 4),
('CNQ5', 'T017', 10),
('CNQ5', 'T018', 58),
('CNQ5', 'T019', 35),
('CNQ5', 'T020', 19),
('CNQ5', 'T021', 53),
('CNQ5', 'T022', 46),
('CNQ5', 'T023', 91),
('CNQ5', 'T024', 10),
('CNQ5', 'T025', 11),
('CNQ5', 'T026', 48),
('CNQ5', 'T027', 62),
('CNQ5', 'T028', 85),
('CNQ5', 'T029', 99),
('CNQ5', 'T030', 80);

-- Dữ liệu chi nhánh Quận 10
INSERT INTO SoLuongThuocChiNhanh (maChiNhanh, maThuoc, soLuong)
VALUES
('CNQ10', 'T001', 16),
('CNQ10', 'T002', 57),
('CNQ10', 'T003', 41),
('CNQ10', 'T004', 94),
('CNQ10', 'T005', 13),
('CNQ10', 'T006', 66),
('CNQ10', 'T007', 88),
('CNQ10', 'T008', 69),
('CNQ10', 'T009', 32),
('CNQ10', 'T010', 41),
('CNQ10', 'T011', 77),
('CNQ10', 'T012', 43),
('CNQ10', 'T013', 49),
('CNQ10', 'T014', 61),
('CNQ10', 'T015', 33),
('CNQ10', 'T016', 48),
('CNQ10', 'T017', 40),
('CNQ10', 'T018', 78),
('CNQ10', 'T019', 64),
('CNQ10', 'T020', 83),
('CNQ10', 'T021', 91),
('CNQ10', 'T022', 56),
('CNQ10', 'T023', 74),
('CNQ10', 'T024', 17),
('CNQ10', 'T025', 15),
('CNQ10', 'T026', 81),
('CNQ10', 'T027', 63),
('CNQ10', 'T028', 80),
('CNQ10', 'T029', 91),
('CNQ10', 'T030', 38);

-- Dữ liệu chi nhánh Quận 12
INSERT INTO SoLuongThuocChiNhanh (maChiNhanh, maThuoc, soLuong)
VALUES
('CNQ12', 'T001', 72),
('CNQ12', 'T002', 48),
('CNQ12', 'T003', 64),
('CNQ12', 'T004', 84),
('CNQ12', 'T005', 91),
('CNQ12', 'T006', 43),
('CNQ12', 'T007', 67),
('CNQ12', 'T008', 82),
('CNQ12', 'T009', 70),
('CNQ12', 'T010', 19),
('CNQ12', 'T011', 61),
('CNQ12', 'T012', 47),
('CNQ12', 'T013', 16),
('CNQ12', 'T014', 72),
('CNQ12', 'T015', 61),
('CNQ12', 'T016', 32),
('CNQ12', 'T017', 83),
('CNQ12', 'T018', 15),
('CNQ12', 'T019', 34),
('CNQ12', 'T020', 64),
('CNQ12', 'T021', 52),
('CNQ12', 'T022', 75),
('CNQ12', 'T023', 23),
('CNQ12', 'T024', 93),
('CNQ12', 'T025', 28),
('CNQ12', 'T026', 99),
('CNQ12', 'T027', 37),
('CNQ12', 'T028', 58),
('CNQ12', 'T029', 49),
('CNQ12', 'T030', 92);

-- Thêm dữ liệu thông tin hoá đơn nhập
-- Dữ liệu chi nhánh Quận 1
INSERT INTO HoaDonNhapThuoc (maHoaDon, ngayLap, soLuongThuoc, maThuoc, maNhanVien) 
VALUES
('Q1HDN001', '2025-01-01', 45, 'T001', 'Q1NV001'),
('Q1HDN002', '2025-01-02', 50, 'T002', 'Q1NV001'),
('Q1HDN003', '2025-01-03', 37, 'T003', 'Q1NV001'),
('Q1HDN004', '2025-01-04', 62, 'T004', 'Q1NV001'),
('Q1HDN005', '2025-01-05', 48, 'T005', 'Q1NV001'),
('Q1HDN006', '2025-01-06', 55, 'T006', 'Q1NV001'),
('Q1HDN007', '2025-01-07', 43, 'T007', 'Q1NV001'),
('Q1HDN008', '2025-01-08', 59, 'T008', 'Q1NV001'),
('Q1HDN009', '2025-01-09', 66, 'T009', 'Q1NV001'),
('Q1HDN010', '2025-01-10', 52, 'T010', 'Q1NV001'),
('Q1HDN011', '2025-01-11', 60, 'T011', 'Q1NV001'),
('Q1HDN012', '2025-01-12', 58, 'T012', 'Q1NV001'),
('Q1HDN013', '2025-01-13', 41, 'T013', 'Q1NV001'),
('Q1HDN014', '2025-01-14', 49, 'T014', 'Q1NV001'),
('Q1HDN015', '2025-01-15', 53, 'T015', 'Q1NV001'),
('Q1HDN016', '2025-01-16', 64, 'T016', 'Q1NV001'),
('Q1HDN017', '2025-01-17', 39, 'T017', 'Q1NV001'),
('Q1HDN018', '2025-01-18', 70, 'T018', 'Q1NV001'),
('Q1HDN019', '2025-01-19', 44, 'T019', 'Q1NV001'),
('Q1HDN020', '2025-01-20', 51, 'T020', 'Q1NV001'),
('Q1HDN021', '2025-01-21', 47, 'T021', 'Q1NV001'),
('Q1HDN022', '2025-01-22', 63, 'T022', 'Q1NV001'),
('Q1HDN023', '2025-01-23', 46, 'T023', 'Q1NV001'),
('Q1HDN024', '2025-01-24', 56, 'T024', 'Q1NV001'),
('Q1HDN025', '2025-01-25', 42, 'T025', 'Q1NV001'),
('Q1HDN026', '2025-01-26', 54, 'T026', 'Q1NV001'),
('Q1HDN027', '2025-01-27', 38, 'T027', 'Q1NV001'),
('Q1HDN028', '2025-01-28', 61, 'T028', 'Q1NV001'),
('Q1HDN029', '2025-01-29', 40, 'T029', 'Q1NV001'),
('Q1HDN030', '2025-01-30', 57, 'T030', 'Q1NV001');

-- Dữ liệu chi nhánh Quận 3
INSERT INTO HoaDonNhapThuoc (maHoaDon, ngayLap, soLuongThuoc, maThuoc, maNhanVien) 
VALUES
('Q3HDN001', '2025-04-02', 52, 'T001', 'Q3NV001'),
('Q3HDN002', '2025-04-03', 40, 'T002', 'Q3NV001'),
('Q3HDN003', '2025-04-04', 63, 'T003', 'Q3NV001'),
('Q3HDN004', '2025-04-05', 35, 'T004', 'Q3NV001'),
('Q3HDN005', '2025-04-06', 58, 'T005', 'Q3NV001'),
('Q3HDN006', '2025-04-07', 41, 'T006', 'Q3NV001'),
('Q3HDN007', '2025-04-08', 66, 'T007', 'Q3NV001'),
('Q3HDN008', '2025-04-09', 38, 'T008', 'Q3NV001'),
('Q3HDN009', '2025-04-10', 45, 'T009', 'Q3NV001'),
('Q3HDN010', '2025-04-11', 60, 'T010', 'Q3NV001'),
('Q3HDN011', '2025-04-12', 43, 'T011', 'Q3NV001'),
('Q3HDN012', '2025-04-13', 56, 'T012', 'Q3NV001'),
('Q3HDN013', '2025-04-14', 34, 'T013', 'Q3NV001'),
('Q3HDN014', '2025-04-15', 68, 'T014', 'Q3NV001'),
('Q3HDN015', '2025-04-16', 39, 'T015', 'Q3NV001'),
('Q3HDN016', '2025-04-17', 49, 'T016', 'Q3NV001'),
('Q3HDN017', '2025-04-18', 54, 'T017', 'Q3NV001'),
('Q3HDN018', '2025-04-19', 61, 'T018', 'Q3NV001'),
('Q3HDN019', '2025-04-20', 36, 'T019', 'Q3NV001'),
('Q3HDN020', '2025-04-21', 59, 'T020', 'Q3NV001'),
('Q3HDN021', '2025-04-22', 42, 'T021', 'Q3NV001'),
('Q3HDN022', '2025-04-23', 65, 'T022', 'Q3NV001'),
('Q3HDN023', '2025-04-24', 44, 'T023', 'Q3NV001'),
('Q3HDN024', '2025-04-25', 47, 'T024', 'Q3NV001'),
('Q3HDN025', '2025-04-26', 53, 'T025', 'Q3NV001'),
('Q3HDN026', '2025-04-27', 33, 'T026', 'Q3NV001'),
('Q3HDN027', '2025-04-28', 64, 'T027', 'Q3NV001'),
('Q3HDN028', '2025-04-29', 48, 'T028', 'Q3NV001'),
('Q3HDN029', '2025-04-30', 67, 'T029', 'Q3NV001'),
('Q3HDN030', '2025-05-01', 50, 'T030', 'Q3NV001');

-- Dữ liệu chi nhánh Quận 5
INSERT INTO HoaDonNhapThuoc (maHoaDon, ngayLap, soLuongThuoc, maThuoc, maNhanVien) 
VALUES
('Q5HDN001', '2025-05-02', 38, 'T001', 'Q5NV001'),
('Q5HDN002', '2025-05-03', 55, 'T002', 'Q5NV001'),
('Q5HDN003', '2025-05-04', 43, 'T003', 'Q5NV001'),
('Q5HDN004', '2025-05-05', 62, 'T004', 'Q5NV001'),
('Q5HDN005', '2025-05-06', 41, 'T005', 'Q5NV001'),
('Q5HDN006', '2025-05-07', 59, 'T006', 'Q5NV001'),
('Q5HDN007', '2025-05-08', 36, 'T007', 'Q5NV001'),
('Q5HDN008', '2025-05-09', 60, 'T008', 'Q5NV001'),
('Q5HDN009', '2025-05-10', 45, 'T009', 'Q5NV001'),
('Q5HDN010', '2025-05-11', 50, 'T010', 'Q5NV001'),
('Q5HDN011', '2025-05-12', 48, 'T011', 'Q5NV001'),
('Q5HDN012', '2025-05-13', 53, 'T012', 'Q5NV001'),
('Q5HDN013', '2025-05-14', 47, 'T013', 'Q5NV001'),
('Q5HDN014', '2025-05-15', 67, 'T014', 'Q5NV001'),
('Q5HDN015', '2025-05-16', 39, 'T015', 'Q5NV001'),
('Q5HDN016', '2025-05-17', 58, 'T016', 'Q5NV001'),
('Q5HDN017', '2025-05-18', 35, 'T017', 'Q5NV001'),
('Q5HDN018', '2025-05-19', 66, 'T018', 'Q5NV001'),
('Q5HDN019', '2025-05-20', 42, 'T019', 'Q5NV001'),
('Q5HDN020', '2025-05-21', 64, 'T020', 'Q5NV001'),
('Q5HDN021', '2025-05-22', 46, 'T021', 'Q5NV001'),
('Q5HDN022', '2025-05-23', 63, 'T022', 'Q5NV001'),
('Q5HDN023', '2025-05-24', 49, 'T023', 'Q5NV001'),
('Q5HDN024', '2025-05-25', 40, 'T024', 'Q5NV001'),
('Q5HDN025', '2025-05-26', 52, 'T025', 'Q5NV001'),
('Q5HDN026', '2025-05-27', 37, 'T026', 'Q5NV001'),
('Q5HDN027', '2025-05-28', 61, 'T027', 'Q5NV001'),
('Q5HDN028', '2025-05-29', 44, 'T028', 'Q5NV001'),
('Q5HDN029', '2025-05-30', 57, 'T029', 'Q5NV001'),
('Q5HDN030', '2025-05-31', 51, 'T030', 'Q5NV001');

-- Dữ liệu chi nhánh Quận 7
INSERT INTO HoaDonNhapThuoc (maHoaDon, ngayLap, soLuongThuoc, maThuoc, maNhanVien) 
VALUES
('Q7HDN001', '2025-08-01', 56, 'T001', 'Q7NV001'),
('Q7HDN002', '2025-08-02', 39, 'T002', 'Q7NV001'),
('Q7HDN003', '2025-08-03', 47, 'T003', 'Q7NV001'),
('Q7HDN004', '2025-08-04', 63, 'T004', 'Q7NV001'),
('Q7HDN005', '2025-08-05', 40, 'T005', 'Q7NV001'),
('Q7HDN006', '2025-08-06', 58, 'T006', 'Q7NV001'),
('Q7HDN007', '2025-08-07', 34, 'T007', 'Q7NV001'),
('Q7HDN008', '2025-08-08', 61, 'T008', 'Q7NV001'),
('Q7HDN009', '2025-08-09', 45, 'T009', 'Q7NV001'),
('Q7HDN010', '2025-08-10', 53, 'T010', 'Q7NV001'),
('Q7HDN011', '2025-08-11', 49, 'T011', 'Q7NV001'),
('Q7HDN012', '2025-08-12', 64, 'T012', 'Q7NV001'),
('Q7HDN013', '2025-08-13', 42, 'T013', 'Q7NV001'),
('Q7HDN014', '2025-08-14', 67, 'T014', 'Q7NV001'),
('Q7HDN015', '2025-08-15', 35, 'T015', 'Q7NV001'),
('Q7HDN016', '2025-08-16', 51, 'T016', 'Q7NV001'),
('Q7HDN017', '2025-08-17', 38, 'T017', 'Q7NV001'),
('Q7HDN018', '2025-08-18', 66, 'T018', 'Q7NV001'),
('Q7HDN019', '2025-08-19', 44, 'T019', 'Q7NV001'),
('Q7HDN020', '2025-08-20', 60, 'T020', 'Q7NV001'),
('Q7HDN021', '2025-08-21', 37, 'T021', 'Q7NV001'),
('Q7HDN022', '2025-08-22', 62, 'T022', 'Q7NV001'),
('Q7HDN023', '2025-08-23', 41, 'T023', 'Q7NV001'),
('Q7HDN024', '2025-08-24', 59, 'T024', 'Q7NV001'),
('Q7HDN025', '2025-08-25', 36, 'T025', 'Q7NV001'),
('Q7HDN026', '2025-08-26', 65, 'T026', 'Q7NV001'),
('Q7HDN027', '2025-08-27', 50, 'T027', 'Q7NV001'),
('Q7HDN028', '2025-08-28', 43, 'T028', 'Q7NV001'),
('Q7HDN029', '2025-08-29', 55, 'T029', 'Q7NV001'),
('Q7HDN030', '2025-08-30', 46, 'T030', 'Q7NV001');

-- Dữ liệu chi nhánh Quận 10
INSERT INTO HoaDonNhapThuoc (maHoaDon, ngayLap, soLuongThuoc, maThuoc, maNhanVien) 
VALUES
('Q10HDN001', '2025-02-01', 61, 'T001', 'Q10NV001'),
('Q10HDN002', '2025-02-02', 48, 'T002', 'Q10NV001'),
('Q10HDN003', '2025-02-03', 57, 'T003', 'Q10NV001'),
('Q10HDN004', '2025-02-04', 42, 'T004', 'Q10NV001'),
('Q10HDN005', '2025-02-05', 50, 'T005', 'Q10NV001'),
('Q10HDN006', '2025-02-06', 65, 'T006', 'Q10NV001'),
('Q10HDN007', '2025-02-07', 33, 'T007', 'Q10NV001'),
('Q10HDN008', '2025-02-08', 59, 'T008', 'Q10NV001'),
('Q10HDN009', '2025-02-09', 46, 'T009', 'Q10NV001'),
('Q10HDN010', '2025-02-10', 70, 'T010', 'Q10NV001'),
('Q10HDN011', '2025-02-11', 53, 'T011', 'Q10NV001'),
('Q10HDN012', '2025-02-12', 41, 'T012', 'Q10NV001'),
('Q10HDN013', '2025-02-13', 60, 'T013', 'Q10NV001'),
('Q10HDN014', '2025-02-14', 39, 'T014', 'Q10NV001'),
('Q10HDN015', '2025-02-15', 47, 'T015', 'Q10NV001'),
('Q10HDN016', '2025-02-16', 55, 'T016', 'Q10NV001'),
('Q10HDN017', '2025-02-17', 62, 'T017', 'Q10NV001'),
('Q10HDN018', '2025-02-18', 38, 'T018', 'Q10NV001'),
('Q10HDN019', '2025-02-19', 51, 'T019', 'Q10NV001'),
('Q10HDN020', '2025-02-20', 44, 'T020', 'Q10NV001'),
('Q10HDN021', '2025-02-21', 67, 'T021', 'Q10NV001'),
('Q10HDN022', '2025-02-22', 49, 'T022', 'Q10NV001'),
('Q10HDN023', '2025-02-23', 58, 'T023', 'Q10NV001'),
('Q10HDN024', '2025-02-24', 45, 'T024', 'Q10NV001'),
('Q10HDN025', '2025-02-25', 66, 'T025', 'Q10NV001'),
('Q10HDN026', '2025-02-26', 34, 'T026', 'Q10NV001'),
('Q10HDN027', '2025-02-27', 52, 'T027', 'Q10NV001'),
('Q10HDN028', '2025-02-28', 68, 'T028', 'Q10NV001'),
('Q10HDN029', '2025-03-01', 36, 'T029', 'Q10NV001'),
('Q10HDN030', '2025-03-02', 63, 'T030', 'Q10NV001');

-- Dữ liệu chi nhánh Quận 12
INSERT INTO HoaDonNhapThuoc (maHoaDon, ngayLap, soLuongThuoc, maThuoc, maNhanVien) 
VALUES
('Q12HDN001', '2025-03-03', 46, 'T001', 'Q12NV001'),
('Q12HDN002', '2025-03-04', 60, 'T002', 'Q12NV001'),
('Q12HDN003', '2025-03-05', 43, 'T003', 'Q12NV001'),
('Q12HDN004', '2025-03-06', 55, 'T004', 'Q12NV001'),
('Q12HDN005', '2025-03-07', 39, 'T005', 'Q12NV001'),
('Q12HDN006', '2025-03-08', 70, 'T006', 'Q12NV001'),
('Q12HDN007', '2025-03-09', 48, 'T007', 'Q12NV001'),
('Q12HDN008', '2025-03-10', 66, 'T008', 'Q12NV001'),
('Q12HDN009', '2025-03-11', 34, 'T009', 'Q12NV001'),
('Q12HDN010', '2025-03-12', 59, 'T010', 'Q12NV001'),
('Q12HDN011', '2025-03-13', 42, 'T011', 'Q12NV001'),
('Q12HDN012', '2025-03-14', 65, 'T012', 'Q12NV001'),
('Q12HDN013', '2025-03-15', 38, 'T013', 'Q12NV001'),
('Q12HDN014', '2025-03-16', 50, 'T014', 'Q12NV001'),
('Q12HDN015', '2025-03-17', 64, 'T015', 'Q12NV001'),
('Q12HDN016', '2025-03-18', 37, 'T016', 'Q12NV001'),
('Q12HDN017', '2025-03-19', 53, 'T017', 'Q12NV001'),
('Q12HDN018', '2025-03-20', 45, 'T018', 'Q12NV001'),
('Q12HDN019', '2025-03-21', 68, 'T019', 'Q12NV001'),
('Q12HDN020', '2025-03-22', 40, 'T020', 'Q12NV001'),
('Q12HDN021', '2025-03-23', 62, 'T021', 'Q12NV001'),
('Q12HDN022', '2025-03-24', 44, 'T022', 'Q12NV001'),
('Q12HDN023', '2025-03-25', 56, 'T023', 'Q12NV001'),
('Q12HDN024', '2025-03-26', 41, 'T024', 'Q12NV001'),
('Q12HDN025', '2025-03-27', 58, 'T025', 'Q12NV001'),
('Q12HDN026', '2025-03-28', 35, 'T026', 'Q12NV001'),
('Q12HDN027', '2025-03-29', 61, 'T027', 'Q12NV001'),
('Q12HDN028', '2025-03-30', 47, 'T028', 'Q12NV001'),
('Q12HDN029', '2025-03-31', 67, 'T029', 'Q12NV001'),
('Q12HDN030', '2025-04-01', 36, 'T030', 'Q12NV001');

-- Thêm dữ liệu thông tin hoá đơn bán
-- Dữ liệu chi nhánh Quận 1
INSERT INTO HoaDonBanThuoc (maHoaDon, soLuongThuoc, ngayLap, maKhachHang, maThuoc, maDuocSi) VALUES
('Q1HDB001', 2, '2023-01-01', 'Q1KH0001', 'T001', 'CNQ1DS001'),
('Q1HDB002', 4, '2023-01-02', 'Q1KH0002', 'T002', 'CNQ1DS002'),
('Q1HDB003', 3, '2023-01-03', 'Q1KH0003', 'T003', 'CNQ1DS003'),
('Q1HDB004', 1, '2023-01-04', 'Q1KH0004', 'T004', 'CNQ1DS004'),
('Q1HDB005', 5, '2023-01-05', 'Q1KH0005', 'T005', 'CNQ1DS005'),
('Q1HDB006', 2, '2023-01-06', 'Q1KH0006', 'T006', 'CNQ1DS001'),
('Q1HDB007', 3, '2023-01-07', 'Q1KH0007', 'T007', 'CNQ1DS002'),
('Q1HDB008', 4, '2023-01-08', 'Q1KH0008', 'T008', 'CNQ1DS003'),
('Q1HDB009', 2, '2023-01-09', 'Q1KH0009', 'T009', 'CNQ1DS004'),
('Q1HDB010', 1, '2023-01-10', 'Q1KH0010', 'T010', 'CNQ1DS005'),
('Q1HDB011', 5, '2023-01-11', 'Q1KH0011', 'T011', 'CNQ1DS001'),
('Q1HDB012', 3, '2023-01-12', 'Q1KH0012', 'T012', 'CNQ1DS002'),
('Q1HDB013', 4, '2023-01-13', 'Q1KH0013', 'T013', 'CNQ1DS003'),
('Q1HDB014', 2, '2023-01-14', 'Q1KH0014', 'T014', 'CNQ1DS004'),
('Q1HDB015', 3, '2023-01-15', 'Q1KH0015', 'T015', 'CNQ1DS005'),
('Q1HDB016', 1, '2023-01-16', 'Q1KH0016', 'T016', 'CNQ1DS001'),
('Q1HDB017', 4, '2023-01-17', 'Q1KH0017', 'T017', 'CNQ1DS002'),
('Q1HDB018', 2, '2023-01-18', 'Q1KH0018', 'T018', 'CNQ1DS003'),
('Q1HDB019', 3, '2023-01-19', 'Q1KH0019', 'T019', 'CNQ1DS004'),
('Q1HDB020', 5, '2023-01-20', 'Q1KH0020', 'T020', 'CNQ1DS005'),
('Q1HDB021', 2, '2023-01-21', 'Q1KH0021', 'T021', 'CNQ1DS001'),
('Q1HDB022', 3, '2023-01-22', 'Q1KH0022', 'T022', 'CNQ1DS002'),
('Q1HDB023', 4, '2023-01-23', 'Q1KH0023', 'T023', 'CNQ1DS003'),
('Q1HDB024', 1, '2023-01-24', 'Q1KH0024', 'T024', 'CNQ1DS004'),
('Q1HDB025', 5, '2023-01-25', 'Q1KH0025', 'T025', 'CNQ1DS005'),
('Q1HDB026', 2, '2023-01-26', 'Q1KH0001', 'T026', 'CNQ1DS001'),
('Q1HDB027', 4, '2023-01-27', 'Q1KH0002', 'T027', 'CNQ1DS002'),
('Q1HDB028', 3, '2023-01-28', 'Q1KH0003', 'T028', 'CNQ1DS003'),
('Q1HDB029', 2, '2023-01-29', 'Q1KH0004', 'T029', 'CNQ1DS004'),
('Q1HDB030', 1, '2023-01-30', 'Q1KH0005', 'T030', 'CNQ1DS005');


-- Dữ liệu chi nhánh Quận 3
INSERT INTO HoaDonBanThuoc (maHoaDon, soLuongThuoc, ngayLap, maKhachHang, maThuoc, maDuocSi) VALUES
('Q3HDB001', 2, '2023-01-01', 'Q3KH0001', 'T001', 'CNQ3DS001'),
('Q3HDB002', 4, '2023-01-02', 'Q3KH0002', 'T002', 'CNQ3DS002'),
('Q3HDB003', 3, '2023-01-03', 'Q3KH0003', 'T003', 'CNQ3DS003'),
('Q3HDB004', 1, '2023-01-04', 'Q3KH0004', 'T004', 'CNQ3DS004'),
('Q3HDB005', 5, '2023-01-05', 'Q3KH0005', 'T005', 'CNQ3DS005'),
('Q3HDB006', 2, '2023-01-06', 'Q3KH0006', 'T006', 'CNQ3DS001'),
('Q3HDB007', 3, '2023-01-07', 'Q3KH0007', 'T007', 'CNQ3DS002'),
('Q3HDB008', 4, '2023-01-08', 'Q3KH0008', 'T008', 'CNQ3DS003'),
('Q3HDB009', 2, '2023-01-09', 'Q3KH0009', 'T009', 'CNQ3DS004'),
('Q3HDB010', 1, '2023-01-10', 'Q3KH0010', 'T010', 'CNQ3DS005'),
('Q3HDB011', 5, '2023-01-11', 'Q3KH0011', 'T011', 'CNQ3DS001'),
('Q3HDB012', 3, '2023-01-12', 'Q3KH0012', 'T012', 'CNQ3DS002'),
('Q3HDB013', 4, '2023-01-13', 'Q3KH0013', 'T013', 'CNQ3DS003'),
('Q3HDB014', 2, '2023-01-14', 'Q3KH0014', 'T014', 'CNQ3DS004'),
('Q3HDB015', 3, '2023-01-15', 'Q3KH0015', 'T015', 'CNQ3DS005'),
('Q3HDB016', 1, '2023-01-16', 'Q3KH0016', 'T016', 'CNQ3DS001'),
('Q3HDB017', 4, '2023-01-17', 'Q3KH0017', 'T017', 'CNQ3DS002'),
('Q3HDB018', 2, '2023-01-18', 'Q3KH0018', 'T018', 'CNQ3DS003'),
('Q3HDB019', 3, '2023-01-19', 'Q3KH0019', 'T019', 'CNQ3DS004'),
('Q3HDB020', 5, '2023-01-20', 'Q3KH0020', 'T020', 'CNQ3DS005'),
('Q3HDB021', 2, '2023-01-21', 'Q3KH0021', 'T021', 'CNQ3DS001'),
('Q3HDB022', 3, '2023-01-22', 'Q3KH0022', 'T022', 'CNQ3DS002'),
('Q3HDB023', 4, '2023-01-23', 'Q3KH0023', 'T023', 'CNQ3DS003'),
('Q3HDB024', 1, '2023-01-24', 'Q3KH0024', 'T024', 'CNQ3DS004'),
('Q3HDB025', 5, '2023-01-25', 'Q3KH0025', 'T025', 'CNQ3DS005'),
('Q3HDB026', 2, '2023-01-26', 'Q3KH0026', 'T026', 'CNQ3DS001'),
('Q3HDB027', 4, '2023-01-27', 'Q3KH0027', 'T027', 'CNQ3DS002'),
('Q3HDB028', 3, '2023-01-28', 'Q3KH0028', 'T028', 'CNQ3DS003'),
('Q3HDB029', 2, '2023-01-29', 'Q3KH0029', 'T029', 'CNQ3DS004'),
('Q3HDB030', 1, '2023-01-30', 'Q3KH0030', 'T030', 'CNQ3DS005');

-- Dữ liệu chi nhánh Quận 5
INSERT INTO HoaDonBanThuoc (maHoaDon, soLuongThuoc, ngayLap, maKhachHang, maThuoc, maDuocSi) VALUES
('Q5HDB001', 2, '2023-01-01', 'Q5KH0001', 'T001', 'CNQ5DS001'),
('Q5HDB002', 4, '2023-01-02', 'Q5KH0002', 'T002', 'CNQ5DS002'),
('Q5HDB003', 3, '2023-01-03', 'Q5KH0003', 'T003', 'CNQ5DS003'),
('Q5HDB004', 1, '2023-01-04', 'Q5KH0004', 'T004', 'CNQ5DS004'),
('Q5HDB005', 5, '2023-01-05', 'Q5KH0005', 'T005', 'CNQ5DS005'),
('Q5HDB006', 2, '2023-01-06', 'Q5KH0006', 'T006', 'CNQ5DS001'),
('Q5HDB007', 3, '2023-01-07', 'Q5KH0007', 'T007', 'CNQ5DS002'),
('Q5HDB008', 4, '2023-01-08', 'Q5KH0008', 'T008', 'CNQ5DS003'),
('Q5HDB009', 2, '2023-01-09', 'Q5KH0009', 'T009', 'CNQ5DS004'),
('Q5HDB010', 1, '2023-01-10', 'Q5KH0010', 'T010', 'CNQ5DS005'),
('Q5HDB011', 5, '2023-01-11', 'Q5KH0011', 'T011', 'CNQ5DS001'),
('Q5HDB012', 3, '2023-01-12', 'Q5KH0012', 'T012', 'CNQ5DS002'),
('Q5HDB013', 4, '2023-01-13', 'Q5KH0013', 'T013', 'CNQ5DS003'),
('Q5HDB014', 2, '2023-01-14', 'Q5KH0014', 'T014', 'CNQ5DS004'),
('Q5HDB015', 3, '2023-01-15', 'Q5KH0015', 'T015', 'CNQ5DS005'),
('Q5HDB016', 1, '2023-01-16', 'Q5KH0016', 'T016', 'CNQ5DS001'),
('Q5HDB017', 4, '2023-01-17', 'Q5KH0017', 'T017', 'CNQ5DS002'),
('Q5HDB018', 2, '2023-01-18', 'Q5KH0018', 'T018', 'CNQ5DS003'),
('Q5HDB019', 3, '2023-01-19', 'Q5KH0019', 'T019', 'CNQ5DS004'),
('Q5HDB020', 5, '2023-01-20', 'Q5KH0020', 'T020', 'CNQ5DS005'),
('Q5HDB021', 2, '2023-01-21', 'Q5KH0001', 'T021', 'CNQ5DS001'),
('Q5HDB022', 3, '2023-01-22', 'Q5KH0002', 'T022', 'CNQ5DS002'),
('Q5HDB023', 4, '2023-01-23', 'Q5KH0003', 'T023', 'CNQ5DS003'),
('Q5HDB024', 1, '2023-01-24', 'Q5KH0004', 'T024', 'CNQ5DS004'),
('Q5HDB025', 5, '2023-01-25', 'Q5KH0005', 'T025', 'CNQ5DS005'),
('Q5HDB026', 2, '2023-01-26', 'Q5KH0006', 'T026', 'CNQ5DS001'),
('Q5HDB027', 4, '2023-01-27', 'Q5KH0007', 'T027', 'CNQ5DS002'),
('Q5HDB028', 3, '2023-01-28', 'Q5KH0008', 'T028', 'CNQ5DS003'),
('Q5HDB029', 2, '2023-01-29', 'Q5KH0009', 'T029', 'CNQ5DS004'),
('Q5HDB030', 1, '2023-01-30', 'Q5KH0010', 'T030', 'CNQ5DS005');

-- Dữ liệu chi nhánh Quận 7
INSERT INTO HoaDonBanThuoc (maHoaDon, soLuongThuoc, ngayLap, maKhachHang, maThuoc, maDuocSi) VALUES
('Q7HDB001', 2, '2023-01-01', 'Q7KH0001', 'T001', 'CNQ7DS001'),
('Q7HDB002', 4, '2023-01-02', 'Q7KH0002', 'T002', 'CNQ7DS002'),
('Q7HDB003', 3, '2023-01-03', 'Q7KH0003', 'T003', 'CNQ7DS003'),
('Q7HDB004', 1, '2023-01-04', 'Q7KH0004', 'T004', 'CNQ7DS004'),
('Q7HDB005', 5, '2023-01-05', 'Q7KH0005', 'T005', 'CNQ7DS005'),
('Q7HDB006', 2, '2023-01-06', 'Q7KH0006', 'T006', 'CNQ7DS001'),
('Q7HDB007', 3, '2023-01-07', 'Q7KH0007', 'T007', 'CNQ7DS002'),
('Q7HDB008', 4, '2023-01-08', 'Q7KH0008', 'T008', 'CNQ7DS003'),
('Q7HDB009', 2, '2023-01-09', 'Q7KH0009', 'T009', 'CNQ7DS004'),
('Q7HDB010', 1, '2023-01-10', 'Q7KH0010', 'T010', 'CNQ7DS005'),
('Q7HDB011', 5, '2023-01-11', 'Q7KH0011', 'T011', 'CNQ7DS001'),
('Q7HDB012', 3, '2023-01-12', 'Q7KH0012', 'T012', 'CNQ7DS002'),
('Q7HDB013', 4, '2023-01-13', 'Q7KH0013', 'T013', 'CNQ7DS003'),
('Q7HDB014', 2, '2023-01-14', 'Q7KH0014', 'T014', 'CNQ7DS004'),
('Q7HDB015', 3, '2023-01-15', 'Q7KH0015', 'T015', 'CNQ7DS005'),
('Q7HDB016', 1, '2023-01-16', 'Q7KH0016', 'T016', 'CNQ7DS001'),
('Q7HDB017', 4, '2023-01-17', 'Q7KH0017', 'T017', 'CNQ7DS002'),
('Q7HDB018', 2, '2023-01-18', 'Q7KH0018', 'T018', 'CNQ7DS003'),
('Q7HDB019', 3, '2023-01-19', 'Q7KH0019', 'T019', 'CNQ7DS004'),
('Q7HDB020', 5, '2023-01-20', 'Q7KH0020', 'T020', 'CNQ7DS005'),
('Q7HDB021', 2, '2023-01-21', 'Q7KH0001', 'T021', 'CNQ7DS001'),
('Q7HDB022', 3, '2023-01-22', 'Q7KH0002', 'T022', 'CNQ7DS002'),
('Q7HDB023', 4, '2023-01-23', 'Q7KH0003', 'T023', 'CNQ7DS003'),
('Q7HDB024', 1, '2023-01-24', 'Q7KH0004', 'T024', 'CNQ7DS004'),
('Q7HDB025', 5, '2023-01-25', 'Q7KH0005', 'T025', 'CNQ7DS005'),
('Q7HDB026', 2, '2023-01-26', 'Q7KH0006', 'T026', 'CNQ7DS001'),
('Q7HDB027', 4, '2023-01-27', 'Q7KH0007', 'T027', 'CNQ7DS002'),
('Q7HDB028', 3, '2023-01-28', 'Q7KH0008', 'T028', 'CNQ7DS003'),
('Q7HDB029', 2, '2023-01-29', 'Q7KH0009', 'T029', 'CNQ7DS004'),
('Q7HDB030', 1, '2023-01-30', 'Q7KH0010', 'T030', 'CNQ7DS005');

-- Dữ liệu chi nhánh Quận 10
INSERT INTO HoaDonBanThuoc (maHoaDon, soLuongThuoc, ngayLap, maKhachHang, maThuoc, maDuocSi) VALUES
('Q10HDB001', 2, '2023-01-01', 'Q10KH0001', 'T001', 'CNQ10DS001'),
('Q10HDB002', 4, '2023-01-02', 'Q10KH0002', 'T002', 'CNQ10DS002'),
('Q10HDB003', 3, '2023-01-03', 'Q10KH0003', 'T003', 'CNQ10DS003'),
('Q10HDB004', 1, '2023-01-04', 'Q10KH0004', 'T004', 'CNQ10DS004'),
('Q10HDB005', 5, '2023-01-05', 'Q10KH0005', 'T005', 'CNQ10DS005'),
('Q10HDB006', 2, '2023-01-06', 'Q10KH0006', 'T006', 'CNQ10DS001'),
('Q10HDB007', 3, '2023-01-07', 'Q10KH0007', 'T007', 'CNQ10DS002'),
('Q10HDB008', 4, '2023-01-08', 'Q10KH0008', 'T008', 'CNQ10DS003'),
('Q10HDB009', 2, '2023-01-09', 'Q10KH0009', 'T009', 'CNQ10DS004'),
('Q10HDB010', 1, '2023-01-10', 'Q10KH0010', 'T010', 'CNQ10DS005'),
('Q10HDB011', 5, '2023-01-11', 'Q10KH0011', 'T011', 'CNQ10DS001'),
('Q10HDB012', 3, '2023-01-12', 'Q10KH0012', 'T012', 'CNQ10DS002'),
('Q10HDB013', 4, '2023-01-13', 'Q10KH0013', 'T013', 'CNQ10DS003'),
('Q10HDB014', 2, '2023-01-14', 'Q10KH0014', 'T014', 'CNQ10DS004'),
('Q10HDB015', 3, '2023-01-15', 'Q10KH0015', 'T015', 'CNQ10DS005'),
('Q10HDB016', 1, '2023-01-16', 'Q10KH0016', 'T016', 'CNQ10DS001'),
('Q10HDB017', 4, '2023-01-17', 'Q10KH0017', 'T017', 'CNQ10DS002'),
('Q10HDB018', 2, '2023-01-18', 'Q10KH0018', 'T018', 'CNQ10DS003'),
('Q10HDB019', 3, '2023-01-19', 'Q10KH0019', 'T019', 'CNQ10DS004'),
('Q10HDB020', 5, '2023-01-20', 'Q10KH0020', 'T020', 'CNQ10DS005'),
('Q10HDB021', 2, '2023-01-21', 'Q10KH0021', 'T021', 'CNQ10DS001'),
('Q10HDB022', 3, '2023-01-22', 'Q10KH0022', 'T022', 'CNQ10DS002'),
('Q10HDB023', 4, '2023-01-23', 'Q10KH0023', 'T023', 'CNQ10DS003'),
('Q10HDB024', 1, '2023-01-24', 'Q10KH0024', 'T024', 'CNQ10DS004'),
('Q10HDB025', 5, '2023-01-25', 'Q10KH0025', 'T025', 'CNQ10DS005'),
('Q10HDB026', 2, '2023-01-26', 'Q10KH0001', 'T026', 'CNQ10DS001'),
('Q10HDB027', 4, '2023-01-27', 'Q10KH0002', 'T027', 'CNQ10DS002'),
('Q10HDB028', 3, '2023-01-28', 'Q10KH0003', 'T028', 'CNQ10DS003'),
('Q10HDB029', 2, '2023-01-29', 'Q10KH0004', 'T029', 'CNQ10DS004'),
('Q10HDB030', 1, '2023-01-30', 'Q10KH0005', 'T030', 'CNQ10DS005');

-- Dữ liệu chi nhánh Quận 12
INSERT INTO HoaDonBanThuoc (maHoaDon, soLuongThuoc, ngayLap, maKhachHang, maThuoc, maDuocSi) VALUES
('Q12HDB001', 2, '2023-01-01', 'Q12KH0001', 'T001', 'CNQ12DS001'),
('Q12HDB002', 4, '2023-01-02', 'Q12KH0002', 'T002', 'CNQ12DS002'),
('Q12HDB003', 3, '2023-01-03', 'Q12KH0003', 'T003', 'CNQ12DS003'),
('Q12HDB004', 1, '2023-01-04', 'Q12KH0004', 'T004', 'CNQ12DS004'),
('Q12HDB005', 5, '2023-01-05', 'Q12KH0005', 'T005', 'CNQ12DS005'),
('Q12HDB006', 2, '2023-01-06', 'Q12KH0006', 'T006', 'CNQ12DS001'),
('Q12HDB007', 3, '2023-01-07', 'Q12KH0007', 'T007', 'CNQ12DS002'),
('Q12HDB008', 4, '2023-01-08', 'Q12KH0008', 'T008', 'CNQ12DS003'),
('Q12HDB009', 2, '2023-01-09', 'Q12KH0009', 'T009', 'CNQ12DS004'),
('Q12HDB010', 1, '2023-01-10', 'Q12KH0010', 'T010', 'CNQ12DS005'),
('Q12HDB011', 5, '2023-01-11', 'Q12KH0011', 'T011', 'CNQ12DS001'),
('Q12HDB012', 3, '2023-01-12', 'Q12KH0012', 'T012', 'CNQ12DS002'),
('Q12HDB013', 4, '2023-01-13', 'Q12KH0013', 'T013', 'CNQ12DS003'),
('Q12HDB014', 2, '2023-01-14', 'Q12KH0014', 'T014', 'CNQ12DS004'),
('Q12HDB015', 3, '2023-01-15', 'Q12KH0015', 'T015', 'CNQ12DS005'),
('Q12HDB016', 1, '2023-01-16', 'Q12KH0016', 'T016', 'CNQ12DS001'),
('Q12HDB017', 4, '2023-01-17', 'Q12KH0017', 'T017', 'CNQ12DS002'),
('Q12HDB018', 2, '2023-01-18', 'Q12KH0018', 'T018', 'CNQ12DS003'),
('Q12HDB019', 3, '2023-01-19', 'Q12KH0019', 'T019', 'CNQ12DS004'),
('Q12HDB020', 5, '2023-01-20', 'Q12KH0020', 'T020', 'CNQ12DS005'),
('Q12HDB021', 2, '2023-01-21', 'Q12KH0021', 'T021', 'CNQ12DS001'),
('Q12HDB022', 3, '2023-01-22', 'Q12KH0022', 'T022', 'CNQ12DS002'),
('Q12HDB023', 4, '2023-01-23', 'Q12KH0023', 'T023', 'CNQ12DS003'),
('Q12HDB024', 1, '2023-01-24', 'Q12KH0024', 'T024', 'CNQ12DS004'),
('Q12HDB025', 5, '2023-01-25', 'Q12KH0025', 'T025', 'CNQ12DS005'),
('Q12HDB026', 2, '2023-01-26', 'Q12KH0026', 'T026', 'CNQ12DS001'),
('Q12HDB027', 4, '2023-01-27', 'Q12KH0027', 'T027', 'CNQ12DS002'),
('Q12HDB028', 3, '2023-01-28', 'Q12KH0028', 'T028', 'CNQ12DS003'),
('Q12HDB029', 2, '2023-01-29', 'Q12KH0029', 'T029', 'CNQ12DS004'),
('Q12HDB030', 1, '2023-01-30', 'Q12KH0030', 'T030', 'CNQ12DS005'),
('Q12HDB031', 4, '2023-01-31', 'Q12KH0031', 'T001', 'CNQ12DS001'),
('Q12HDB032', 3, '2023-02-01', 'Q12KH0032', 'T002', 'CNQ12DS002'),
('Q12HDB033', 2, '2023-02-02', 'Q12KH0033', 'T003', 'CNQ12DS003'),
('Q12HDB034', 5, '2023-02-03', 'Q12KH0034', 'T004', 'CNQ12DS004');

