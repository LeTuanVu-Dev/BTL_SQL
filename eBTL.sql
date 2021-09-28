USE BTL_SQLSever_QUANLYDETAIGIAOVIEN
GO
/*
Tạo các Stored Procedure với các tùy chọn khác nhau: Parameter,
OUTPUT, RETURN (ít nhất 20 thủ tục) để thêm, sửa, xóa, trích lọc dữ
liệu. Gọi thực thi các Stored Procedure đã tạo*
*/
---1. ds gv không tham gia đề tài .. với cấp quản lý là tham số truyền vào
CREATE PROC DSGV_KOTHAMGIA
@capQL NVARCHAR(30)
AS 
SELECT sMaGV FROM dbo.GIAOVIEN WHERE sMaGV NOT IN 
(
SELECT DISTINCT  sMaGV FROM dbo.THAMGIADETAI INNER JOIN dbo.DETAI ON DETAI.sMaDT = THAMGIADETAI.sMaDT WHERE sCapQL =@capQL
)

EXEC dbo.DSGV_KOTHAMGIA @capQL = N'Trường' -- nvarchar(30)

---2 ds các giáo viên tham gia đề tài với cấp quản lí là tham số truyền vào

CREATE PROC DSGV_THAMGIA
@capQL NVARCHAR(30)
AS 
SELECT sMaGV FROM dbo.GIAOVIEN WHERE sMaGV IN 
(
SELECT DISTINCT  sMaGV FROM dbo.THAMGIADETAI INNER JOIN dbo.DETAI ON DETAI.sMaDT = THAMGIADETAI.sMaDT WHERE sCapQL =@capQL
)
EXEC DSGV_THAMGIA @capQL = N'Nhà Nước'


--- 3.  tạo proc hiện all tên giao viên thuộc chuyên ngành nào với chuyên ngành là tham số truyền vào
CREATE PROC GVCN
@chuyennganh NVARCHAR(100)
AS 
SELECT * FROM dbo.GIAOVIEN WHERE sChuyenNganh = @chuyennganh

EXEC GVCN @chuyennganh = N'Công nghệ phần mềm'

---4. tìm tất cả giáo viên dạy môn học gì với tên môn học là tham số truyền vào
CREATE PROC DS_GVBM
@tenmon NVARCHAR(100)
AS 
SELECT sTenGV  FROM dbo.BOMON INNER JOIN dbo.GIAOVIEN ON GIAOVIEN.sMaBM = BOMON.sMaBM WHERE sTenBM = @tenmon

EXEC DS_GVBM @tenmon = N'đa phương tiện'


--- 5. thủ tục với output tìm số lượng giáo viên tham gia đề tài với tên đề tài là tham số truyền vào và số lượng giáo viên là output
ALTER PROC out_sumGV
@sumgv INT OUTPUT,
@tendt NVARCHAR(500)
AS 
SELECT @sumgv = COUNT(sMaGV) FROM dbo.GIAOVIEN WHERE sMaGV IN 
(SELECT dbo.THAMGIADETAI.sMaGV FROM dbo.THAMGIADETAI INNER JOIN dbo.DETAI ON DETAI.sMaDT = THAMGIADETAI.sMaDT 
WHERE sTenDT = @tendt)
DECLARE @sum INT
EXEC out_sumGV @sumgv = @sum output , @tendt =  N'Ứng dung Caso Sức khỏe người già' 
SELECT @sum AS [số giáo viên tham gia]

----- 6. dùng proc để insert thêm 1 giáo viên nam vào bảng giáo viên


CREATE PROC insert_GVNam
@magv VARCHAR(20),
@tengv NVARCHAR(50),
@date DATE ,
@diachi NVARCHAR(200),
@luong FLOAT,
@sex NVARCHAR(5),
@CN NVARCHAR(200),
@maBM varCHAR(20) 
AS 
IF EXISTS (SELECT * FROM dbo.BOMON WHERE sMaBM = @maBM) AND @sex = N'Nam' AND @magv NOT IN (SELECT sMaGV FROM dbo.GIAOVIEN)
	BEGIN
		INSERT INTO dbo.GIAOVIEN VALUES (@magv,@tengv,@date,@diachi,@luong,@sex,@CN,@maBM)
	END
ELSE
	BEGIN
	    PRINT N'nếu bạn thấy dòng này nghĩa là bạn sai
		ràng buộc bộ môn ko có trong bảng bộ môn or giới tính khác nam or mã GV trùng'
	END

EXEC insert_GVNam
@magv = 'GV16' ,@tengv = N'Nguyễn Thanh Hóa' ,@date = '19830105'  ,
@diachi = N'Bìa Rịa,Vũng Tàu' ,@luong = 13000000 ,@sex = N'Nam',@CN = N'Anh Văn CN' ,@maBM = 'BM10'

SELECT * FROM dbo.GIAOVIEN

---- 7.dùng proc để insert thêm 1 giáo viên nữ vào bảng giáo viên
ALTER  PROC insert_GVNu @magv VARCHAR(20),@tengv NVARCHAR(50),@date DATE ,@diachi NVARCHAR(200),@luong FLOAT,
@sex NVARCHAR(5),@CN NVARCHAR(200),@maBM varCHAR(20) 
AS 
IF EXISTS (SELECT * FROM dbo.BOMON WHERE sMaBM = @maBM) AND @sex = N'Nữ' AND @magv NOT IN (SELECT sMaGV FROM dbo.GIAOVIEN)
	BEGIN
		INSERT INTO dbo.GIAOVIEN VALUES (@magv,@tengv,@date,@diachi,@luong,@sex,@CN,@maBM)
	END
ELSE
	BEGIN
	    PRINT N'nếu bạn thấy dòng này nghĩa là bạn sai ràng buộc giới tính khác nữ or mã GV trùng'
	END

EXEC insert_GVNu
@magv = 'GV17' ,@tengv = N'Nguyễn Thị Dần' ,@date = '19800105'  ,
@diachi = N'Đống Đa ,Hà Nội' ,@luong = 13500000 ,@sex = N'Nữ',@CN = N'Toán' , @maBM = 'BM10'

SELECT * FROM dbo.GIAOVIEN

---8. thêm 1 bộ môn có tên là Toán Cao Cấp dùng proc
ALTER PROC them_BM
@maBM VARCHAR(10),
@tenBN NVARCHAR(100),
@Phong nVARCHAR(10),
@TruongBM VARCHAR(10),
@maK VARCHAR(10),
@BDNK INT,
@KTNK INT
AS 
IF EXISTS (SELECT * FROM dbo.KHOA WHERE sMaKH = @maK) AND EXISTS (SELECT *FROM dbo.GIAOVIEN WHERE sMaGV = @TruongBM)
AND @BDNK <= 2021 AND @maBM NOT IN (SELECT sMaBM FROM dbo.BOMON)
	BEGIN
		INSERT INTO dbo.BOMON VALUES ( @maBM, @tenBN,@Phong,@TruongBM,@maK, @BDNK ,@KTNK )
	END
ELSE
BEGIN
PRINT N'lỗi do vi phạm ràng buộc. vui lòng kiểm tra lại !'
END

EXEC them_BM @maBM = 'BM11', @tenBN = N'Toán Cao Cấp',@Phong = 'D13',@TruongBM = 'GV15',@maK = 'KH01', @BDNK = 2020 ,@KTNK = 2024

----9. update trong bảng GV những ai dạy toán thì đổi mã bộ môn = BM11
CREATE PROC UPDATE_GV
AS 
UPDATE dbo.GIAOVIEN SET sMaBM = 'BM11' WHERE sChuyenNganh LIKE N'%Toán%'

EXEC UPDATE_GV
SELECT * FROM dbo.GIAOVIEN

--- 10. proc output số lượng giáo viên nam và nữ . return tổng
ALTER PROC tongSV_Nam
@nam INT  OUTPUT,
@nu INT  OUTPUT
AS
SET @nam = 0
SET @nu = 0
	SELECT @nam = COUNT(*) FROM dbo.GIAOVIEN WHERE sGioiTinh = N'Nam';
	SELECT @nu = COUNT(*) FROM dbo.GIAOVIEN WHERE sGioiTinh = N'nữ';
RETURN  @nam + @nu -- tổng gv

DECLARE @t INT , @a INT , @b INT
	EXEC @t = tongSV_Nam 
	@nam = @a output , @nu = @b OUTPUT 
SELECT @a AS [nam] ,@b AS [ nữ] , @t AS [tổng GV]

---11.  tim tuoi cao nhat cua giao vien
ALTER PROC tuoicaonhat_GV
AS 
BEGIN 
DECLARE @maxtuoi INT 
SELECT @maxtuoi = MAX(YEAR(GETDATE()) - YEAR(dNgaySinh)) FROM dbo.GIAOVIEN
RETURN @maxtuoi
END 
-- gọi proc
DECLARE @a INT
EXEC @a = tuoicaonhat_GV
SELECT @a AS [tuổi cao nhất]

---12. tổng số công việc của đề tài với tên đề tài là tham số truyền vào
ALTER PROC SLCV
@slcv INT OUTPUT,
@tendt NVARCHAR(500)
AS
BEGIN
SELECT @slcv = COUNT(*) FROM dbo.CONGVIEC INNER JOIN dbo.DETAI ON DETAI.sMaDT = CONGVIEC.sMaDT
WHERE DETAI.sTenDT = @tendt
END
-- gọi proc
DECLARE @tongCV INT   
EXEC SLCV @slcv = @tongCV OUTPUT , @tendt = N'Nghiên cứu yếu tố điểm kém của sinh viên' 
SELECT @tongCV AS [số lượng CV]

---13. đưa vào tên đề tài và hiện ra đề tài đó đã được thực thi ( công việc ) hay chưa
CREATE PROC CV 
@tendt NVARCHAR(500)
AS 
IF NOT EXISTS  (SELECT sTenDT = @tendt FROM dbo.CONGVIEC INNER JOIN dbo.DETAI ON DETAI.sMaDT = CONGVIEC.sMaDT )
PRINT N'đề tài này chưa được thực thi'
ELSE
PRINT N'đề tài này đã thực thi'

EXEC CV @tendt = N'Nghiên cứu yếu tố điểm kém của sinh viên'

--- 14. tìm ds giáo viên chưa tham gia đề tài nào
CREATE PROC DS_KTG
AS
SELECT sTenGV ,sChuyenNganh FROM dbo.GIAOVIEN WHERE sMaGV NOT IN (SELECT sMaGV FROM dbo.THAMGIADETAI)
-- gọi hàm
EXEC DS_KTG


----15.tìm ds giáo viên đã tham gia đề tài 

CREATE PROC DSTG
AS
SELECT sTenGV ,sChuyenNganh FROM dbo.GIAOVIEN WHERE sMaGV  IN (SELECT sMaGV FROM dbo.THAMGIADETAI)
-- gọi hàm
EXEC DSTG

----16. với mã giáo viên là tham số truyền vào kiểm tra xem giáo viên đó đã tham gia đề tài hay chưa

CREATE PROC timGV
@magv VARCHAR(10)
AS 
IF @magv IN (SELECT sMaGV FROM dbo.THAMGIADETAI)
	BEGIN
	   PRINT N'đã tham gia'
	 END
ELSE
 BEGIN
      PRINT N'chưa tham gia'
 END
 -- gọi hàm
 EXEC timGV @magv = 'GV01'

 ----17.tìm tất cả giáo viên  thuộc khoa với tên khoa là tham số truyền vào

 ALTER PROC tongGV_khoa
 @SL INT OUTPUT,
 @tenkhoa NVARCHAR(200)
 AS
 SELECT @SL = COUNT(*) FROM dbo.GIAOVIEN WHERE sMaBM IN 
 (SELECT sMaBM FROM dbo.BOMON INNER JOIN dbo.KHOA ON KHOA.sMaKH = BOMON.sMaKH WHERE sTenKH LIKE @tenkhoa)
 -- goi hàm
 DECLARE @sl int
 EXEC tongGV_khoa  @SL = @sl OUTPUT , @tenkhoa = N'công nghệ thông tin' 
 SELECT @sl AS[số GV]

 ---18. tìm tổng bộ môn thuộc khoa . với tên khoa là tham số truyền vào và tổng môn là output

 CREATE PROC tongmon_khoa
 @tongmon INT OUTPUT,
@tenKH NVARCHAR(100)
AS 
SELECT @tongmon = COUNT(*) FROM dbo.BOMON INNER JOIN dbo.KHOA ON KHOA.sMaKH = BOMON.sMaKH WHERE sTenKH LIKE @tenKH
-- gọi hàm

DECLARE @tong INT 
EXEC tongmon_khoa @tongmon = @tong OUTPUT , @tenKH = N'công nghệ thông tin'
SELECT @tong AS [tổng số môn]


---- 19.hiện tất cả tên công việc thuộc chủ đề NCKH với tên chủ đề tham số truyền vào
CREATE PROC CV_NCKH
@tenCD NVARCHAR(200)
AS
SELECT sTenCV FROM dbo.CONGVIEC INNER JOIN dbo.DETAI ON DETAI.sMaDT = CONGVIEC.sMaDT INNER JOIN dbo.CHUDE
ON CHUDE.sMaCD = DETAI.sMaCD WHERE sTenCD = @tenCD
--gọi hàm
EXEC CV_NCKH @tenCD = N'Ứng dụng & Công nghệ'

---20. xóa đi 1 giáo viên có mã GV100 với mã gv là tham số truyền vào
ALTER PROC DELETE_GV
@magv VARCHAR(10)
AS 
	IF @magv IN (SELECT sMaGV FROM dbo.GIAOVIEN )
		BEGIN
			DELETE dbo.GIAOVIEN WHERE sMaGV = @magv
			PRINT N'xóa thành công !'
		END
	ELSE
PRINT N'mã giáo viên không khớp . vui lòng thử lại !!!'
-- gọi hàm
EXEC DELETE_GV @magv = 'GV100'

---21. thêm 1 giáo viên với mã giáo viên ,mã bộ môn là tham số truyền vào ...chưa chạy

CREATE PROC themGV
@maGV VARCHAR(10),
@maBM VARCHAR(10)
AS
IF @maGV IN (SELECT * FROM dbo.GIAOVIEN) AND @maBM IN (SELECT sMaBM FROM dbo.BOMON)
BEGIN
    INSERT INTO dbo.GIAOVIEN
    VALUES
    (   @maGV,        -- sMaGV - varchar(10)
        N'Nguyễn Thái Thịnh',       -- sTenGV - nvarchar(30)
        '19760122', -- dNgaySinh - date
        N'Bến Tre',       -- sDiaChi - nvarchar(30)
        17500000,       -- fLuong - float
        N'Nam',       -- sGioiTinh - nvarchar(5)
        N'Toán Cao Cấp',       -- sChuyenNganh - nvarchar(30)
        @maBM         -- sMaBM - varchar(10)
        )
END
ELSE
PRINT N'lỗi ! vui lòng kiểm tra lại .'
--gọi hàm
EXEC themGV @MaGV = 'GV18' , @maBM = 'BM11'

--- 22. đổi tên bm ở bảng bộ môn với tên môn là tham số truyền vào

CREATE PROC doitenmon
@tenmon NVARCHAR(100),
@tendoi NVARCHAR(100)
AS 
IF @tenmon IN (SELECT sTenBM FROM dbo.BOMON)
	BEGIN
		UPDATE dbo.BOMON SET sTenBM = @tendoi WHERE sTenBM like @tenmon
	END
ELSE
PRINT N'tên môn không có trong bảng !'
--gọi hàm
EXEC doitenmon @tenmon = N'đa phương tiện' , @tendoi = N'Thiết Kế Web'
EXEC doitenmon @tenmon = N'Toán Cao Cấp' , @tendoi = N'Giải Tích 1'

SELECT * FROM dbo.BOMON






































SELECT * FROM dbo.THAMGIADETAI
SELECT * FROM dbo.CONGVIEC
SELECT * FROM dbo.DETAI
SELECT * FROM dbo.GIAOVIEN
SELECT * FROM dbo.BOMON
SELECT * FROM dbo.KHOA
SELECT * FROM dbo.CHUDE



















































































