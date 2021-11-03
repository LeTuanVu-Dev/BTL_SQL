/* a. Tạo database*/
CREATE DATABASE BTL_SQLSever_QUANLYDETAIGIAOVIEN
ON (
	 NAME = 'BTL_SQLSever_QUANLYDETAIGIAOVIEN',
	 FILENAME = 'D:\SQL\zBTL\BAI TAP LON\BTL_SQLSever_QUANLYDETAIGIAOVIEN.mdf',
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
	sTruongKhoa VARCHAR(10) UNIQUE NOT NULL,
	dBDNhiemKy date ,
	dKTNhiemKy date
)	
ALTER TABLE dbo.KHOA ADD CONSTRAINT PK_Khoa PRIMARY KEY(sMaKH)
ALTER TABLE dbo.KHOA ADD CONSTRAINT CK_nhiemky CHECK (YEAR(dBDNhiemKy) < YEAR(dKTNhiemKy))

-- Tạo bảng Bộ môn
CREATE TABLE BOMON
(
	sMaBM VARCHAR(10) NOT NULL,
	sTenBM NVARCHAR(30) NOT NULL,
	sPhong NVARCHAR(10),
	sTruongBM VARCHAR(10) UNIQUE NOT NULL,
	sMaKH VARCHAR(10) ,
	dBDNhiemKy DATE ,
	dKTNhiemKy DATE
	
)
ALTER TABLE dbo.BOMON ADD CONSTRAINT PK_Bomon PRIMARY KEY(sMaBM)
ALTER TABLE dbo.BOMON ADD CONSTRAINT CK_Bomon CHECK (YEAR(dBDNhiemKy) < YEAR(dKTNhiemKy))
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
	
)
ALTER TABLE dbo.CONGVIEC ADD CONSTRAINT PK_congviec PRIMARY KEY(sMaDT,iSTT)

-- Tạo bảng giáo viên
CREATE TABLE GIAOVIEN
(
	sMaGV VARCHAR(10) NOT NULL,
	sTenGV NVARCHAR(30) NOT NULL,
	fLuong FLOAT,
	sGioiTinh NVARCHAR(3),
	sMaBM VARCHAR(10),

)
ALTER TABLE dbo.GIAOVIEN ADD CONSTRAINT PK_giaovien PRIMARY KEY(sMaGV)
ALTER TABLE dbo.GIAOVIEN ADD CONSTRAINT CK_GioiTinh CHECK ( sGioiTinh = N'Nam' OR sGioiTinh = N'Nữ')


-- Tạo bảng tham gia đề tài
CREATE TABLE THAMGIADETAI
(
	sMaGV VARCHAR(10) NOT NULL,
	sMaDT VARCHAR(10) NOT NULL,
	iSTT INT NOT NULL ,
	sKetQua NVARCHAR(30),
	
)
ALTER TABLE dbo.THAMGIADETAI ADD CONSTRAINT PK_thamgiadetai PRIMARY KEY(sMaGV,sMaDT,iSTT)
ALTER TABLE dbo.THAMGIADETAI  ADD CONSTRAINT CK_KQ CHECK (sKetQua LIKE N'%chua dat%')

-- b. Tạo Khóa ngoại
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
CREATE SYNONYM tram2gv FOR LINK.CSDLPHANTANBTL.dbo.GIAOVIEN

ALTER PROC addGV
 @sMaGV VARCHAR(10),
	@sTenGV NVARCHAR(30),
	@dNgaySinh DATE ,
	@sDiaChi NVARCHAR(30),
	@fLuong FLOAT,
	@sGioiTinh NVARCHAR(3) ,
	@sChuyenNganh NVARCHAR(30),
	@sMaBM VARCHAR(10),
	@sSDT CHAR(12)
	AS 
BEGIN
    IF NOT EXISTS (SELECT * FROM dbo.GIAOVIEN WHERE @sMaGV = sMaGV)
		BEGIN
		    INSERT INTO dbo.GIAOVIEN VALUES
		    (@sMaGV, @sTenGV,@fLuong, @sGioiTinh,@sMaBM )
			INSERT INTO tram2gv VALUES
		    (@sMaGV, @sDiaChi,@sChuyenNganh, @sSDT ,@dNgaySinh )
		END
		ELSE
		PRINT N'đã có mã tồn tại!'
END

 /* Nhập dữ liệu cho bảng giáo viên */


EXEC addGV @sMaGV = 'GV01', @sTenGV= N'Trần Văn Dũng', @dNgaySinh= '19730215',@sDiaChi= N'Long Biên,Hà Nội',@fLuong= 9500000,@sGioiTinh= N'Nam',@sChuyenNganh=N'Công nghệ phần mềm',@sSDT='0329635463' ,@sMaBM= NULL

EXEC addGV @sMaGV = 'GV02', @sTenGV= N'Nguyễn Thùy Linh',@dNgaySinh=  '19770319',@sDiaChi= N'Thanh Xuân,Hà Nội',@fLuong= 9000000,@sGioiTinh= N'Nữ',@sChuyenNganh=N'Truyền Thông Đa PT',@sSDT='0329635159' ,@sMaBM= NULL

EXEC addGV @sMaGV ='GV03', @sTenGV= N'Dương Chí Bằng', @dNgaySinh= '19700919', @sDiaChi=N'Mỹ Đình,Hà Nội',@fLuong=9000000,@sGioiTinh= N'Nam',@sChuyenNganh=N'Truyền Thông Đa PT',@sSDT='0989635111' ,@sMaBM= NULL

EXEC addGV  @sMaGV ='GV04', @sTenGV= N'Trần Hoàng Nam', @dNgaySinh= '19901105', @sDiaChi=N'Đống Đa,Hà Nội',@fLuong= 9500000,@sGioiTinh= N'Nam',@sChuyenNganh=N'Hệ Thống Thông Tin',@sSDT='0969635321' ,@sMaBM= NULL

EXEC addGV @sMaGV = 'GV05', @sTenGV= N'Trần Thanh Sơn', @dNgaySinh= '19850503',@sDiaChi= N'Đông Anh,Hà Nội',@fLuong= 9500000,@sGioiTinh= N'Nam',@sChuyenNganh=N'An Toàn Thông Tin',@sSDT='0889963136' ,@sMaBM= NULL

EXEC addGV @sMaGV ='GV06', @sTenGV= N'Phạm Thanh Nam', @dNgaySinh= '19600916',@sDiaChi= N'Thường Tín,Hà Nội', @fLuong=8500000,@sGioiTinh= N'Nam',@sChuyenNganh=N'Kinh Tế Quản Lý',@sSDT='098696314' ,@sMaBM= NULL

EXEC addGV @sMaGV = 'GV07', @sTenGV= N'Lưu Lan Anh',  @dNgaySinh='19600918',@sDiaChi= N'Long Biên,Hà Nội', @fLuong=9000000,@sGioiTinh= N'Nữ',@sChuyenNganh=N'Quản Trị Kinh Doanh',@sSDT='0999966663' ,@sMaBM= NULL

EXEC addGV @sMaGV = 'GV08', @sTenGV= N'Nguyễn Thu Thủy',  @dNgaySinh='19821020',@sDiaChi= N'Thanh Trì,Hà Nội',@fLuong= 9500000,@sGioiTinh= N'Nữ',@sChuyenNganh=N'Thương Mại Điện Tử',@sSDT='012396654' ,@sMaBM= NULL

EXEC addGV  @sMaGV ='GV09', @sTenGV= N'Trần Huyền Trang',@dNgaySinh=  '19770601',@sDiaChi= N'Hai Bà Trưng,Hà Nội',@fLuong= 9000000,@sGioiTinh= N'Nữ',@sChuyenNganh=N'Quản Lý Tài Nguyên MT',@sSDT='0339669696' ,@sMaBM= NULL

EXEC addGV  @sMaGV ='GV10', @sTenGV= N'Nguyễn Thị Tươi', @dNgaySinh= '19750206',@sDiaChi= N'Thanh Xuân,Hà Nội', @fLuong=9000000,@sGioiTinh= N'Nữ',@sChuyenNganh=N'Khảo sát môi trường',@sSDT='0969644522' ,@sMaBM= NULL

EXEC addGV @sMaGV = 'GV11', @sTenGV= N'Hoàng Phạm An', @dNgaySinh= '19931101',@sDiaChi= N'Long Biên,Hà Nội', @fLuong=9000000,@sGioiTinh= N'Nam',@sChuyenNganh=N'Quản Lý Đất Đai',@sSDT='0963696321' ,@sMaBM= NULL

EXEC addGV @sMaGV = 'GV12', @sTenGV= N'Trần Thị Huế', @dNgaySinh= '19890209',@sDiaChi= N'Cầu Giấy,Hà Nội', @fLuong=8500000,@sGioiTinh= N'Nữ',@sChuyenNganh=N'Anh Văn 1',@sSDT='0989696644' ,@sMaBM= NULL

EXEC addGV @sMaGV = 'GV13', @sTenGV= N'Nguyễn Ngâm Trâm', @dNgaySinh= '19800823', @sDiaChi=N'Chương Mĩ,Hà Nội',@fLuong= 8500000,@sGioiTinh= N'Nam',@sChuyenNganh=N'Anh Văn 2',@sSDT='0972635219' ,@sMaBM= NULL

EXEC addGV  @sMaGV ='GV14', @sTenGV= N'Nguyễn Thị Lan', @dNgaySinh= '19790609', @sDiaChi=N'Thanh Xuân,Hà Nội',@fLuong= 8500000,@sGioiTinh= N'Nữ',@sChuyenNganh=N'Anh Văn 3' ,@sSDT='0989635444',@sMaBM= NULL

EXEC addGV  @sMaGV ='GV15', @sTenGV= N'Hoàng Thanh Toàn', @dNgaySinh= '19770205',@sDiaChi= N'Sơn Tây,Hà Nội', @fLuong=9500000,@sGioiTinh= N'Nam',@sChuyenNganh=N'Toán Cao Cấp',@sSDT='0989999999',@sMaBM= NULL
 
 SELECT * FROM dbo.GIAOVIEN
 SELECT * FROM tram2gv

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



 /*Nhập dữ liệu cho bảng công viêc */
 CREATE SYNONYM tram2cv FOR LINK.CSDLPHANTANBTL.dbo.CONGVIEC
CREATE PROC addCV
	@sMaDT VARCHAR(10),
	@iSTT INT,
	@sTenCV NVARCHAR(30),
	@dNgayBD DATE,
	@dNgayKT DATE
AS 
	BEGIN
	    IF EXISTS (SELECT * FROM dbo.DETAI WHERE @sMaDT = sMaDT) 
			BEGIN
			    INSERT INTO dbo.CONGVIEC VALUES(@sMaDT,@iSTT,@sTenCV)
				INSERT INTO tram2cv VALUES (@sMaDT,@iSTT,@dNgayBD,@dNgayKT)
			END
	END
-- nhập dl bảng công việc
EXEC addCV   @sMaDT='DT02',@iSTT= 1, @sTenCV=N'Khảo sát thưc nghiệm',@dNgayBD='20190410',@dNgayKT= '20190415' 
EXEC addCV  @sMaDT= 'DT02',@iSTT= 2,@sTenCV= N'Xác định nguyên nhân',@dNgayBD='20190420',@dNgayKT= '20190428' 
EXEC addCV  @sMaDT='DT02',@iSTT= 3,@sTenCV= N'NC tâm lý sinh viên',@dNgayBD='20190502',@dNgayKT= '20190510' 
EXEC addCV  @sMaDT='DT02',@iSTT= 4,@sTenCV= N'Đề xuất phương án',@dNgayBD='20190520',@dNgayKT= '20190602' 


EXEC addCV  @sMaDT= 'DT05', @iSTT=1,@sTenCV= N'Khởi tạo lập kế hoạch',@dNgayBD='20180904', @dNgayKT='20180914' 
EXEC addCV   @sMaDT='DT05',@iSTT= 2,@sTenCV= N'Xác định yêu cầu',@dNgayBD='20180915', @dNgayKT='20180920' 
EXEC addCV   @sMaDT='DT05',@iSTT= 3,@sTenCV= N'Phân tích hệ thống',@dNgayBD='20180921', @dNgayKT='20181001' 
EXEC addCV   @sMaDT= 'DT05',@iSTT= 4, @sTenCV=N'Thiết kế hệ thống',@dNgayBD='20181005', @dNgayKT='20181205' 
EXEC addCV  @sMaDT= 'DT05',@iSTT= 5,@sTenCV= N'cài đặt kiểm thử',@dNgayBD='20181206', @dNgayKT='20181228' 

EXEC addCV   @sMaDT= 'DT07', @iSTT=1,@sTenCV= N'Khảo sát thưc nghiệm',@dNgayBD='20200410',@dNgayKT= '20200415' 
EXEC addCV   @sMaDT= 'DT07',@iSTT= 2,@sTenCV= N'Thu nhập mẫu ô nhiễm',@dNgayBD='20200420',@dNgayKT= '20200428' 
EXEC addCV  @sMaDT= 'DT07', @iSTT=3, @sTenCV=N'Xd múc độ ảnh hưởng',@dNgayBD='20200502',@dNgayKT= '20200510' 
EXEC addCV  @sMaDT=  'DT07',@iSTT= 4,@sTenCV= N'phương án giải quyết',@dNgayBD='20200520',@dNgayKT= '20200602' 
EXEC addCV   @sMaDT= 'DT07',@iSTT= 5,@sTenCV= N'Nghiệm thu',@dNgayBD='20200603',@dNgayKT= '20200903' 
  
 SELECT * FROM dbo.CONGVIEC
 -- tgdt
 CREATE SYNONYM tram2tgdt FOR LINK.CSDLPHANTANBTL.dbo.THAMGIADETAIDAT
 SELECT * FROM tram2tgdt

ALTER PROC addTGDT
 @sMaGV VARCHAR(10),
	@sMaDT VARCHAR(10) ,
	@iSTT INT ,
	@sKetQua NVARCHAR(30)
AS 
BEGIN
    IF EXISTS (SELECT * FROM dbo.GIAOVIEN WHERE @sMaGV = sMaGV) AND EXISTS (SELECT * FROM dbo.DETAI WHERE @sMaDT = sMaDT)
		AND @iSTT IN (SELECT iSTT FROM dbo.CONGVIEC )
		BEGIN
			IF @sKetQua like N'%chua dat%'
				INSERT INTO dbo.THAMGIADETAI VALUES  ( @sMaGV,@sMaDT,@iSTT, @sKetQua )		
			ELSE 
				INSERT INTO tram2tgdt VALUES (@sMaGV,@sMaDT,@iSTT, @sKetQua )	
		END
END
-- gội

 /* Nhập dữ liệu cho bảng Tham gia đề tài */
EXEC addTGDT @sMaGV= 'GV12',   @sMaDT='DT02',  @iSTT= 1,  @sKetQua= N'dat' 

EXEC addTGDT @sMaGV='GV12',  @sMaDT= 'DT02',  @iSTT= 2,  @sKetQua= N'dat' 
EXEC addTGDT @sMaGV='GV13',  @sMaDT= 'DT02',  @iSTT= 3, @sKetQua=  N'dat' 
EXEC addTGDT @sMaGV='GV14',  @sMaDT= 'DT02', @iSTT=  4,  @sKetQua= N'dat' 
EXEC addTGDT @sMaGV='GV01',  @sMaDT= 'DT05', @iSTT=  1,@sKetQua=   N'dat' 
EXEC addTGDT @sMaGV='GV02',  @sMaDT= 'DT05',  @iSTT= 2,  @sKetQua= N'dat' 
EXEC addTGDT @sMaGV= 'GV03',  @sMaDT= 'DT05', @iSTT=  3,  @sKetQua= N'dat' 
EXEC addTGDT @sMaGV='GV03',  @sMaDT= 'DT05', @iSTT=  4, @sKetQua=  N'dat' 
EXEC addTGDT @sMaGV= 'GV04',@sMaDT='DT05', @iSTT=  5, @sKetQua=  N'dat' 

EXEC addTGDT @sMaGV='GV09',   @sMaDT='DT07',  @iSTT= 1, @sKetQua=  N'dat' 
EXEC addTGDT @sMaGV='GV10',   @sMaDT='DT07',   @iSTT=2, @sKetQua=  N'dat'
EXEC addTGDT @sMaGV='GV10',  @sMaDT= 'DT07',  @iSTT= 3, @sKetQua=  N'dat' 
EXEC addTGDT @sMaGV='GV10',   @sMaDT='DT07',  @iSTT= 4, @sKetQua=  N'dat'

EXEC addTGDT @sMaGV= 'GV11',   @sMaDT='DT07', @iSTT=  5, @sKetQua=  N'chua dat' 

 /* Nhập dữ liệu cho bảng khoa */
 INSERT INTO dbo.KHOA ( sMaKH, sTenKH, iNamTL,sToaNha,sSDT,sTruongKhoa, dBDNhiemKy,dKTNhiemKy)
 VALUES (   'KH01',N'Công Nghệ Thông Tin',1993, N'A1','0923647509', 'GV01','20180206', '20230609'   )
  INSERT INTO dbo.KHOA ( sMaKH, sTenKH, iNamTL,sToaNha,sSDT,sTruongKhoa, dBDNhiemKy,dKTNhiemKy)
 VALUES (   'KH02',N'Kinh Tế',1977, N'C2','0384857839', 'GV08','20200203', '20250203'   )
  INSERT INTO dbo.KHOA ( sMaKH, sTenKH, iNamTL,sToaNha,sSDT,sTruongKhoa, dBDNhiemKy,dKTNhiemKy)
 VALUES (   'KH03',N'QL Tài Nguyên & Môi Trường',1975, N'B3','0983746685', 'GV09','20170606', '20220606'   )
  INSERT INTO dbo.KHOA ( sMaKH, sTenKH, iNamTL,sToaNha,sSDT,sTruongKhoa, dBDNhiemKy,dKTNhiemKy)
 VALUES (   'KH04',N'Ngôn Ngữ Anh',1993, N'D4','0388477679', 'GV14','20211021', '20261021'   )


 SELECT * FROM dbo.GIAOVIEN

  /* Nhập dữ liệu cho bảng Bộ môn */
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,dBDNhiemKy,dKTNhiemKy)
 VALUES( 'BM01',  N'Đa Phương Tiện', N'A31', 'GV02', 'KH01','20180903', '20231001' )
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,dBDNhiemKy,dKTNhiemKy)
 VALUES( 'BM02',  N'Phần Mền', N'A51', 'GV01', 'KH01','20210806', '20260505')
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,dBDNhiemKy,dKTNhiemKy)
 VALUES( 'BM03',  N'HTTT', N'A41', 'GV04', 'KH01','20201102', '20251201' )

 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,dBDNhiemKy,dKTNhiemKy)
 VALUES( 'BM04',  N'Kinh tế quản trị', N'C25', 'GV06', 'KH02','20200906', '20261001' )
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,dBDNhiemKy,dKTNhiemKy)
 VALUES( 'BM05',  N'Kinh tế vĩ mô', N'C12', 'GV08', 'KH02','20181001', '20231001' )
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,dBDNhiemKy,dKTNhiemKy)
 VALUES( 'BM06',  N'Kinh tế quốc dân', N'C21', 'GV07', 'KH02','20211101', '20261001' )

 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,dBDNhiemKy,dKTNhiemKy)
 VALUES( 'BM07',  N'Thống kế Môi Trường', N'B52', 'GV10', 'KH03','20201001', '20261001' )
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,dBDNhiemKy,dKTNhiemKy)
 VALUES( 'BM08',  N'Quản lý Môi Trường', N'B12', 'GV11', 'KH03','20180303', '20230303' )

 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,dBDNhiemKy,dKTNhiemKy)
 VALUES( 'BM09',  N'Anh cơ bản', N'D21', 'GV13', 'KH04','20201207', '20251207' )
 INSERT INTO dbo.BOMON (sMaBM,sTenBM, sPhong, sTruongBM,sMaKH,dBDNhiemKy,dKTNhiemKy)
 VALUES( 'BM10',  N'Anh chuyên ngành', N'D12', 'GV14', 'KH04','20210712', '20260712' )

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
SELECT * FROM dbo.CHUDE
