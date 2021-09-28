
CREATE DATABASE BTL_SQLSever_QUANLYDETAIGIAOVIEN
ON (
	 NAME = 'BTL_SQLSever_QUANLYDETAIGIAOVIEN',
	 FILENAME = 'D:\BTL\BTL_SQLSever_QUANLYDETAIGIAOVIEN.mdf',
	 MAXSIZE = UNLIMITED
)
GO

USE BTL_SQLSever_QUANLYDETAIGIAOVIEN
GO

-- 2. Tạo bảng & Khóa chính
-- Tạo Bảng Khoa
CREATE TABLE KHOA
(
	sMaKH VARCHAR(10) NOT NULL,
	sTenKH NVARCHAR(50),
	iNamTL INT ,
	sToaNha NVARCHAR(20) ,
	sSDT CHAR (12),
	sTruongKhoa VARCHAR(10) NULL,
	iBDNhiemKy INT ,
	iKTNhiemKy INT
)	
ALTER TABLE dbo.KHOA ADD CONSTRAINT PK_Khoa PRIMARY KEY(sMaKH)
ALTER TABLE dbo.KHOA ADD CONSTRAINT CK_nhiemky CHECK (iKTNhiemKy >iBDNhiemKy )

-- Tạo bảng Bộ môn
CREATE TABLE BOMON
(
	sMaBM VARCHAR(10) NOT NULL,
	sTenBM NVARCHAR(30) NOT NULL,
	sPhong NVARCHAR(10),
	sTruongBM VARCHAR(10) NULL,
	sMaKH VARCHAR(10) ,
	iBDNhiemKy INT ,
	iKTNhiemKy INT
	
)
ALTER TABLE dbo.BOMON ADD CONSTRAINT PK_Bomon PRIMARY KEY(sMaBM)
ALTER TABLE dbo.BOMON ADD CONSTRAINT CK_Bomon CHECK (iKTNhiemKy >iBDNhiemKy )
------------------------------------------
-- Tạo bảng chủ đề
CREATE TABLE CHUDE
(
	sMaCD VARCHAR(10) NOT NULL,
	sTenCD NVARCHAR(30)
	
)
ALTER TABLE dbo.CHUDE ADD CONSTRAINT PK_Chude PRIMARY KEY(sMaCD)

-- Tạo bảng đề tài
CREATE TABLE DETAI
(
	sMaDT VARCHAR(10) NOT NULL,
	sTenDT NVARCHAR(50) NOT NULL,
	sCapQL NVARCHAR(30),
	fKinhPhi FLOAT,
	sGVCNDT VARCHAR(10),
	sMaCD VARCHAR(10),
)
ALTER TABLE dbo.DETAI ADD CONSTRAINT PK_detai PRIMARY KEY(sMaDT)

-- Tạo bảng công việc
CREATE TABLE CONGVIEC 
(
	sMaDT VARCHAR(10) NOT NULL,
	iSTT INT NOT NULL,
	sTenCV NVARCHAR(30),
	dNgayBD DATE,
	dNgayKT DATE,
	
)
ALTER TABLE dbo.CONGVIEC ADD CONSTRAINT PK_congviec PRIMARY KEY(sMaDT,iSTT)
-- Tạo bảng giáo viên
CREATE TABLE GIAOVIEN
(
	sMaGV VARCHAR(10) NOT NULL,
	sTenGV NVARCHAR(30) NOT NULL,
	dNgaySinh DATE ,
	sDiaChi NVARCHAR(30),
	fLuong FLOAT,
	sGioiTinh NVARCHAR(5) CHECK ( sGioiTinh = N'Nam' OR sGioiTinh = N'Nữ'),
	sChuyenNganh NVARCHAR(30),
	sMaBM VARCHAR(10)

	
)
ALTER TABLE dbo.GIAOVIEN ADD CONSTRAINT PK_giaovien PRIMARY KEY(sMaGV)
ALTER TABLE dbo.GIAOVIEN ADD CONSTRAINT CK_GioiTinh CHECK ( sGioiTinh = N'Nam' OR sGioiTinh = N'Nữ')
ALTER TABLE dbo.GIAOVIEN ADD CONSTRAINT CK_tuoiGV CHECK ( YEAR(GETDATE()) - YEAR(dNgaySinh) >=22)

-- Tạo bảng Giáo viên-Số diện thoại
CREATE TABLE GV_SDT
(
	sMaGV VARCHAR(10) NOT NULL,
	sSDT CHAR(12) NOT NULL,
	
)
ALTER TABLE dbo.GV_SDT ADD CONSTRAINT Pk_gv_sdt PRIMARY KEY(sMaGV,sSDT)

-- Tạo bảng tham gia đề tài
CREATE TABLE THAMGIADETAI
(
	sMaGV VARCHAR(10) NOT NULL,
	sMaDT VARCHAR(10) NOT NULL,
	iSTT INT NOT NULL ,
	sKetQua NVARCHAR(30),
	
)
ALTER TABLE dbo.THAMGIADETAI ADD CONSTRAINT PK_thamgiadetai PRIMARY KEY(sMaGV,sMaDT,iSTT)

-- 3. Tạo Khóa ngoại
--      khóa ngoại ở bảng khoa
ALTER TABLE dbo.KHOA 
ADD CONSTRAINT FK_khoa_giaovien 
FOREIGN KEY(sTruongKhoa) REFERENCES dbo.GIAOVIEN(sMaGV)

--      khóa ngoại ở bộ môn
ALTER TABLE dbo.BOMON ADD CONSTRAINT FK_bomon_khoa 
FOREIGN KEY(sMaKH) REFERENCES dbo.KHOA(sMaKH)

ALTER TABLE dbo.BOMON ADD CONSTRAINT FK_bomon_giaovien
FOREIGN KEY(sTruongBM) REFERENCES dbo.GIAOVIEN(sMaGV)

--      Khóa ngoại ở giáo viên
ALTER TABLE dbo.GIAOVIEN 
ADD CONSTRAINT FK_giaovien_bomon 
FOREIGN KEY(sMaBM) REFERENCES dbo.BOMON(sMaBM)

--      Khóa ngoại ở GV-SDT
ALTER TABLE dbo.GV_SDT 
ADD CONSTRAINT FK_GV_SDT 
FOREIGN KEY(sMaGV) REFERENCES dbo.GIAOVIEN(sMaGV)

--      Khóa ngoại ở bảng đề tài
ALTER TABLE dbo.DETAI 
ADD CONSTRAINT FK_detai_chude 
FOREIGN KEY(sMaCD) REFERENCES dbo.CHUDE(sMaCD)


ALTER TABLE DETAI 
ADD CONSTRAINT FK_detai_giao 
FOREIGN KEY (sGVCNDT)REFERENCES GIAOVIEN (sMaGV)

--      Khóa ngoại ở bảng Công việc
ALTER TABLE dbo.CONGVIEC 
ADD CONSTRAINT FK_congviec_detai 
FOREIGN KEY(sMaDT) REFERENCES dbo.DETAI(sMaDT)

--      Khóa ngoại ở bảng tham gia đề tài
ALTER TABLE dbo.THAMGIADETAI 
ADD CONSTRAINT FK_thamgiaDT_giaovien 
FOREIGN KEY(sMaGV) REFERENCES dbo.GIAOVIEN(sMaGV)

ALTER TABLE dbo.THAMGIADETAI
add CONSTRAINT FK_thamgiaDT_detai 
FOREIGN KEY(sMaDT,iSTT) REFERENCES dbo.CONGVIEC(sMaDT,iSTT)

-- Thêm dữ liệu
 /*Thêm dữ liệu bảng chủ đề */
 INSERT INTO dbo.CHUDE ( sMaCD,  sTenCD)
 VALUES  ('CD01',  N'Quản lý giáo dục')
 INSERT INTO dbo.CHUDE ( sMaCD,  sTenCD)
 VALUES  ('CD02',  N'Ứng dụng & Công nghệ')
 INSERT INTO dbo.CHUDE ( sMaCD,  sTenCD)
 VALUES  ('CD03',  N'Nghiên cứu khoa học môi trường')
 SELECT * FROM dbo.CHUDE

 /* Nhập dữ liệu cho bảng giáo viên */
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV01',  N'Trần Văn Dũng',  '19730215', N'Long Biên,Hà Nội', 9500000, N'Nam',N'Công nghệ phần mềm' )
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV02',  N'Nguyễn Thùy Linh',  '19770319', N'Thanh Xuân,Hà Nội', 9000000, N'Nữ',N'Truyền Thông Đa PT' )
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV03',  N'Dương Chí Bằng',  '19700919', N'Mỹ Đình,Hà Nội', 9000000, N'Nam',N'Truyền Thông Đa PT' )
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV04',  N'Trần Hoàng Nam',  '19901105', N'Đống Đa,Hà Nội', 9500000, N'Nam',N'Hệ Thống Thông Tin' )
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV05',  N'Trần Thanh Sơn',  '19850503', N'Đông Anh,Hà Nội', 9500000, N'Nam',N'An Toàn Thông Tin' )
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV06',  N'Phạm Thanh Nam',  '19600916', N'Thường Tín,Hà Nội', 8500000, N'Nam',N'Kinh Tế Quản Lý' )
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV07',  N'Lưu Lan Anh',  '19600918', N'Long Biên,Hà Nội', 9000000, N'Nữ',N'Quản Trị Kinh Doanh' )
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV08',  N'Nguyễn Thu Thủy',  '19821020', N'Thanh Trì,Hà Nội', 9500000, N'Nữ',N'Thương Mại Điện Tử' )
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV09',  N'Trần Huyền Trang',  '19770601', N'Hai Bà Trưng,Hà Nội', 9000000, N'Nữ',N'Quản Lý Tài Nguyên MT' )
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV10',  N'Nguyễn Thị Tươi',  '19750206', N'Thanh Xuân,Hà Nội', 9000000, N'Nữ',N'Khảo sát môi trường' )
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV11',  N'Hoàng Phạm An',  '19931101', N'Long Biên,Hà Nội', 9000000, N'Nam',N'Quản Lý Đất Đai' )
 INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV12',  N'Trần Thị Huế',  '19890209', N'Cầu Giấy,Hà Nội', 8500000, N'Nữ',N'Anh Văn 1' )
  INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV13',  N'Nguyễn Ngâm Trâm',  '19800823', N'Chương Mĩ,Hà Nội', 8500000, N'Nam',N'Anh Văn 2' )
  INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV14',  N'Nguyễn Thị Lan',  '19790609', N'Thanh Xuân,Hà Nội', 8500000, N'Nữ',N'Anh Văn 3' )
  INSERT INTO dbo.GIAOVIEN (sMaGV, sTenGV,dNgaySinh,sDiaChi, fLuong, sGioiTinh,sChuyenNganh)
 VALUES (  'GV15',  N'Hoàng Thanh Toàn',  '19770205', N'Sơn Tây,Hà Nội', 9500000, N'Nam',N'Toán Cao Cấp' )

 SELECT * FROM dbo.GIAOVIEN

 /* Nhập dữ liệu cho đề tài*/
 INSERT INTO dbo.DETAI (sMaDT,sTenDT,sCapQL,fKinhPhi,sGVCNDT,sMaCD)
 VALUES(  'DT01',   N'Giáo dục nghề nghiệp hiện nay', N'Trường', 4000000, 'GV12',  N'CD01'  )
 INSERT INTO dbo.DETAI (sMaDT,sTenDT,sCapQL,fKinhPhi,sGVCNDT,sMaCD)
 VALUES(  'DT02',   N'Nghiên cứu yếu tố điểm kém của sinh viên', N'Trường', 5000000, 'GV14',  N'CD01'  )
 INSERT INTO dbo.DETAI (sMaDT,sTenDT,sCapQL,fKinhPhi,sGVCNDT,sMaCD)
 VALUES(  'DT03',   N'NC  phát triển các mô hình GD Stem cho HS THPT', N'Bộ', 6000000, 'GV13',  N'CD01'  )
 INSERT INTO dbo.DETAI (sMaDT,sTenDT,sCapQL,fKinhPhi,sGVCNDT,sMaCD)
 VALUES(  'DT04',   N'Nghiên cứu, thiết kế và chế tạo robot và IOT', N'Trường', 4000000, 'GV03',  N'CD02'  )
 INSERT INTO dbo.DETAI (sMaDT,sTenDT,sCapQL,fKinhPhi,sGVCNDT,sMaCD)
 VALUES(  'DT05',   N'Ứng dung Caso Sức khỏe người già', N'Trường', 5500000, 'GV01',  N'CD02'  )
 INSERT INTO dbo.DETAI (sMaDT,sTenDT,sCapQL,fKinhPhi,sGVCNDT,sMaCD)
 VALUES(  'DT06',   N'Nghiên cứu ứng dụng công nghệ Blockchain', N'Nhà nước', 8000000, 'GV05',  N'CD02'  )
 INSERT INTO dbo.DETAI (sMaDT,sTenDT,sCapQL,fKinhPhi,sGVCNDT,sMaCD)
 VALUES(  'DT07',   N'NC và TH các biện pháp chống xâm nhập mặn', N'Nhà nước', 6000000, 'GV09',  N'CD03'  )
 INSERT INTO dbo.DETAI (sMaDT,sTenDT,sCapQL,fKinhPhi,sGVCNDT,sMaCD)
 VALUES(  'DT08',   N'NC, ĐG tình trạng nước thải tại khu vực thị xã', N'Nhà nước', 6000000, 'GV10',  N'CD03'  )
  INSERT INTO dbo.DETAI (sMaDT,sTenDT,sCapQL,fKinhPhi,sGVCNDT,sMaCD)
 VALUES(  'DT09',   N'NCMH tiết kiệm năng lượng & năng lượng sạch', N'Nhà nước', 8000000, 'GV11',  N'CD03'  )

/*Nhập dữ liệu cho bảng giáo viên SDT */
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV01', '0973252678'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV02', '0389256276'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV03', '0387593859'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV04', '0937485999'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV05', '0345692884'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV06', '0934648933'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV07', '0904985039'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV08', '0389257398'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV09', '0903057304'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV10', '0948302099'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV11', '0309283909'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV12', '0308493922'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV13', '0904858999'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV14', '0384940285'  )
INSERT INTO dbo.GV_SDT (sMaGV, sSDT)
VALUES (  'GV15', '0349589282'  )

 /*Nhập dữ liệu cho bảng công viêc */

 INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT02', 1, N'Khảo sát thưc nghiệm','20190410', '20190415' )
  INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT02', 2, N'Xác định nguyên nhân','20190420', '20190428' )
  INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT02', 3, N'NC tâm lý sinh viên','20190502', '20190510' )
  INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT02', 4, N'Đề xuất phương án','20190520', '20190602' )


 INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT05', 1, N'Khởi tạo lập kế hoạch','20180904', '20180914' )
  INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT05', 2, N'Xác định yêu cầu','20180915', '20180920' )
  INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT05', 3, N'Phân tích hệ thống','20180921', '20181001' )
  INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT05', 4, N'Thiết kế hệ thống','20181005', '20181205' )
  INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT05', 5, N'cài đặt kiểm thử','20181206', '20181228' )

 INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT07', 1, N'Khảo sát thưc nghiệm','20200410', '20200415' )
  INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT07', 2, N'Thu nhập mẫu ô nhiễm','20200420', '20200428' )
  INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT07', 3, N'Xd múc độ ảnh hưởng','20200502', '20200510' )
  INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT07', 4, N'phương án giải quyết','20200520', '20200602' )
 INSERT INTO dbo.CONGVIEC ( sMaDT, iSTT, sTenCV, dNgayBD, dNgayKT)
 VALUES (   'DT07', 5, N'Nghiệm thu','20200603', '20200903' )
  
 SELECT * FROM dbo.CONGVIEC

 /* Nhập dữ liệu cho bảng Tham gia đề tài */
 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV12',   'DT02',   1,   N'Đạt' )
 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV12',   'DT02',   2,   N'Đạt' )
 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV13',   'DT02',   3,   N'Đạt' )
 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV14',   'DT02',   4,   N'Đạt' )

 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV01',   'DT05',   1,   N'Đạt' )
 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV02',   'DT05',   2,   N'Đạt' )
 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV03',   'DT05',   3,   N'Đạt' )
 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV03',   'DT05',   4,   N'Đạt' )
  INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV04',   'DT05',   5,   N'Đạt' )

 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV09',   'DT07',   1,   N'Đạt' )
 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV10',   'DT07',   2,   N'Đạt' )
 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV10',   'DT07',   3,   N'Đạt' )
 INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV10',   'DT07',   4,   N'Đạt' )
  INSERT INTO dbo.THAMGIADETAI ( sMaGV,sMaDT, iSTT, sKetQua)
 VALUES (   'GV11',   'DT07',   5,   N'Chưa Đạt' )

 -- test : chọn ra những giáo viên tham gia đề tài : caso người già
 SELECT sTenGV,cv.sTenCV,cv.iSTT AS [Thứ tự làm việc] FROM dbo.THAMGIADETAI AS Tg
 JOIN dbo.CONGVIEC AS cv
 ON cv.sMaDT = Tg.sMaDT AND cv.iSTT = Tg.iSTT
 JOIN dbo.GIAOVIEN
 ON GIAOVIEN.sMaGV = Tg.sMaGV
 JOIN dbo.DETAI AS dt
 ON dt.sMaDT = cv.sMaDT
 WHERE dt.sTenDT like N'%Caso%'


 /* Nhập dữ liệu cho bảng khoa */
 INSERT INTO dbo.KHOA ( sMaKH, sTenKH, iNamTL,sToaNha,sSDT,sTruongKhoa, iBDNhiemKy,iKTNhiemKy)
 VALUES (   'KH01',N'Công Nghệ Thông Tin',1993, N'A1','0923647509', 'GV01',2018, 2022   )
  INSERT INTO dbo.KHOA ( sMaKH, sTenKH, iNamTL,sToaNha,sSDT,sTruongKhoa, iBDNhiemKy,iKTNhiemKy)
 VALUES (   'KH02',N'Kinh Tế',1977, N'C2','0384857839', 'GV08',2020, 2024   )
  INSERT INTO dbo.KHOA ( sMaKH, sTenKH, iNamTL,sToaNha,sSDT,sTruongKhoa, iBDNhiemKy,iKTNhiemKy)
 VALUES (   'KH03',N'QL Tài Nguyên & Môi Trường',1975, N'B3','0983746685', 'GV09',2018, 2022   )
  INSERT INTO dbo.KHOA ( sMaKH, sTenKH, iNamTL,sToaNha,sSDT,sTruongKhoa, iBDNhiemKy,iKTNhiemKy)
 VALUES (   'KH04',N'Ngôn Ngữ Anh',1993, N'D4','0388477679', 'GV14',2021, 2025   )


 SELECT * FROM dbo.GIAOVIEN
  /* Nhập dữ liệu cho bảng Bộ môn */
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,iBDNhiemKy,iKTNhiemKy)
 VALUES( 'BM01',  N'Đa Phương Tiện', N'A31', 'GV02', 'KH01',2018, 2022 )
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,iBDNhiemKy,iKTNhiemKy)
 VALUES( 'BM02',  N'Phần Mền', N'A51', 'GV01', 'KH01',2018, 2022 )
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,iBDNhiemKy,iKTNhiemKy)
 VALUES( 'BM03',  N'HTTT', N'A41', 'GV04', 'KH01',2019, 2023 )

 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,iBDNhiemKy,iKTNhiemKy)
 VALUES( 'BM04',  N'Kinh tế quản trị', N'C25', 'GV06', 'KH02',2020, 2024 )
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,iBDNhiemKy,iKTNhiemKy)
 VALUES( 'BM05',  N'Kinh tế vĩ mô', N'C12', 'GV08', 'KH02',2018, 2022 )
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,iBDNhiemKy,iKTNhiemKy)
 VALUES( 'BM06',  N'Kinh tế quốc dân', N'C21', 'GV07', 'KH02',2017, 2021 )

 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,iBDNhiemKy,iKTNhiemKy)
 VALUES( 'BM07',  N'Thống kế Môi Trường', N'B52', 'GV10', 'KH03',2020, 2024 )
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,iBDNhiemKy,iKTNhiemKy)
 VALUES( 'BM08',  N'Quản lý Môi Trường', N'B12', 'GV11', 'KH03',2018, 2022 )

 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,iBDNhiemKy,iKTNhiemKy)
 VALUES( 'BM09',  N'Anh cơ bản', N'D21', 'GV13', 'KH04',2020, 2024 )
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,iBDNhiemKy,iKTNhiemKy)
 VALUES( 'BM10',  N'Anh chuyên ngành', N'D12', 'GV14', 'KH04',2021, 2025 )

 /*Cập nhật dữ liệu bộ môn cho bảng giáo viên */
 SELECT * FROM dbo.GIAOVIEN
 SELECT * FROM dbo.BOMON
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM02' WHERE sMaGV = 'GV01'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM01' WHERE sMaGV = 'GV02'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM01' WHERE sMaGV = 'GV03'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM03' WHERE sMaGV = 'GV04'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM03' WHERE sMaGV = 'GV05'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM04' WHERE sMaGV = 'GV06'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM05' WHERE sMaGV = 'GV07'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM04' WHERE sMaGV = 'GV08'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM07' WHERE sMaGV = 'GV09'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM08' WHERE sMaGV = 'GV10'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM08' WHERE sMaGV = 'GV11'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM09' WHERE sMaGV = 'GV12'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM09' WHERE sMaGV = 'GV13'
 UPDATE dbo.GIAOVIEN SET sMaBM = 'BM10' WHERE sMaGV = 'GV14'


SELECT * FROM dbo.BOMON
SELECT * FROM dbo.KHOA
SELECT * FROM dbo.GIAOVIEN
SELECT * FROM dbo.DETAI
SELECT * FROM dbo.THAMGIADETAI
SELECT * FROM dbo.CONGVIEC
SELECT * FROM dbo.GV_SDT
SELECT * FROM dbo.CHUDE