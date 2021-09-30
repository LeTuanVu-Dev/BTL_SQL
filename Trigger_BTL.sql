USE BTL_SQLSever_QUANLYDETAIGIAOVIEN
GO 
---
/*
Viết các Trigger cho phép kiểm soát ràng buộc dữ liệu, đồng bộ dữ liệu:
đơn giản, phức tạp, IF_UPDATE (ít nhất 10 trigger). Viết lệnh kích hoạt
các Trigger
*/
/* 1 Tạo trigger : thêm cột iSodt vào bảng khoa là tổng số giáo viên trong khoa sẽ tăng lên */
ALTER TABLE dbo.KHOA 
ADD isoGV INT 
UPDATE dbo.KHOA
SET isoGV = A.tong
FROM dbo.KHOA
INNER JOIN (
    SELECT KHOA.sMaKH, COUNT(sMaGV) AS tong
	FROM dbo.GIAOVIEN
	INNER JOIN dbo.BOMON ON BOMON.sMaBM = GIAOVIEN.sMaBM
	INNER JOIN dbo.KHOA ON KHOA.sMaKH = BOMON.sMaKH
	GROUP BY KHOA.sMaKH
) AS A ON A.sMaKH = dbo.KHOA.sMaKH
GO 
ALTER TRIGGER TongGV ON dbo.GIAOVIEN	
after insert , update
as
begin
	UPDATE dbo.KHOA
	SET isoGV = isoGV + A.tong
	FROM dbo.KHOA
	INNER JOIN (
		SELECT KHOA.sMaKH, COUNT(sMaGV) AS tong
		FROM inserted
		INNER JOIN dbo.BOMON ON BOMON.sMaBM = inserted.sMaBM
		INNER JOIN dbo.KHOA ON KHOA.sMaKH = BOMON.sMaKH
		GROUP BY KHOA.sMaKH
	) AS A ON A.sMaKH = dbo.KHOA.sMaKH
END 
----
SELECT * FROM dbo.KHOA
INSERT INTO dbo.GIAOVIEN
VALUES
(   'GV18',        -- sMaGV - varchar(10)
    N'tran ngoc trinh',       -- sTenGV - nvarchar(30)
    '19820103', -- dNgaySinh - date
    N'dinh cong , ha noi',       -- sDiaChi - nvarchar(30)
    15000000,       -- fLuong - float
    N'Nam',       -- sGioiTinh - nvarchar(5)
    N'Toan cao cap',       -- sChuyenNganh - nvarchar(30)
    'BM11'         -- sMaBM - varchar(10)
    )
GO 
--2. Tạo trigger : xóa 1 giáo viên thì isoGV ở bảng khoa sẽ giảm đi  */
CREATE TRIGGER DL_XOAGV ON dbo.GIAOVIEN
AFTER DELETE
AS
BEGIN
    UPDATE dbo.KHOA SET isoGV = isoGV - A.xoa
	FROM dbo.KHOA INNER JOIN
	(
	SELECT KHOA.sMaKH, COUNT(sMaGV) AS xoa
		FROM Deleted
		INNER JOIN dbo.BOMON ON BOMON.sMaBM = Deleted.sMaBM
		INNER JOIN dbo.KHOA ON KHOA.sMaKH = BOMON.sMaKH
		GROUP BY KHOA.sMaKH
	) AS A ON A.sMaKH = KHOA.sMaKH
END
DELETE dbo.GIAOVIEN WHERE sMaGV = 'GV18'
GO 

--3. tạo trigger. thêm 1 công việc cho bảng công việc thì tổng số công việc của đề tài đó tăng lên

ALTER TABLE dbo.DETAI ADD isoCV INT 

UPDATE dbo.DETAI SET isoCV = A.tong
FROM dbo.DETAI INNER JOIN
(
SELECT dbo.DETAI.sMaDT,COUNT(iSTT) AS tong FROM dbo.DETAI
INNER JOIN dbo.CONGVIEC ON CONGVIEC.sMaDT = DETAI.sMaDT
GROUP BY dbo.DETAI.sMaDT
) AS A ON A.sMaDT = DETAI.sMaDT
GO 

ALTER TRIGGER TongCV ON dbo.congviec 
AFTER INSERT , UPDATE 
AS 
BEGIN
    UPDATE dbo.DETAI SET isoCV = isoCV + 
(
SELECT COUNT(iSTT) AS tong FROM Inserted
INNER JOIN dbo.DETAI ON DETAI.sMaDT = Inserted.sMaDT
)
FROM dbo.DETAI INNER JOIN Inserted ON Inserted.sMaDT = DETAI.sMaDT
END
INSERT INTO dbo.CONGVIEC
VALUES
(   'DT07',        -- sMaDT - varchar(10)
    6,         -- iSTT - int
    N'thu hoạch',       -- sTenCV - nvarchar(30)
    '20200603', -- dNgayBD - date
    '20200903'  -- dNgayKT - date
    )

GO 

---4.xóa 1 công việc cho bảng công việc thì tổng số công việc của đề tài đó giảm xuống

CREATE TRIGGER XoaCV ON dbo.congviec 
AFTER DELETE 
AS 
BEGIN
    UPDATE dbo.DETAI SET isoCV = isoCV - 
(
SELECT COUNT(iSTT) AS tong FROM Deleted
INNER JOIN dbo.DETAI ON DETAI.sMaDT = Deleted.sMaDT
)
FROM dbo.DETAI INNER JOIN Deleted ON Deleted.sMaDT = DETAI.sMaDT
END
GO
-- thử nghiệm trigger
DELETE dbo.CONGVIEC WHERE sMaDT = 'DT07' AND iSTT = 6
-- truy vấn thay đổi ktra ở 2 bảng
SELECT * FROM dbo.DETAI
SELECT * FROM dbo.CONGVIEC

-----------

--5. thêm 1 giáo viên thì tổng số giáo viên dạy bộ môn đó sẽ tăng

ALTER TABLE dbo.BOMON ADD iGVTGBM INT 
UPDATE dbo.BOMON SET iGVTGBM = A.tong FROM dbo.BOMON INNER JOIN
(
SELECT BOMON.sMaBM,COUNT(sMaGV) AS tong FROM dbo.BOMON INNER JOIN dbo.GIAOVIEN ON GIAOVIEN.sMaBM = BOMON.sMaBM
GROUP BY BOMON.sMaBM
) AS A ON A.sMaBM = BOMON.sMaBM
GO 

CREATE TRIGGER TongGVBM ON dbo.GIAOVIEN
AFTER INSERT , UPDATE
AS 
BEGIN
    UPDATE dbo.BOMON SET iGVTGBM = iGVTGBM +
(
SELECT COUNT(sMaGV) AS tong FROM Inserted INNER JOIN dbo.BOMON ON BOMON.sMaBM = Inserted.sMaBM
) FROM dbo.BOMON INNER JOIN Inserted ON Inserted.sMaBM = BOMON.sMaBM
END
GO 
-- test trigger
INSERT INTO dbo.GIAOVIEN
VALUES
(   'GV18',        -- sMaGV - varchar(10)
    N'tran ngoc trinh',       -- sTenGV - nvarchar(30)
    '19820103', -- dNgaySinh - date
    N'dinh cong , ha noi',       -- sDiaChi - nvarchar(30)
    15000000,       -- fLuong - float
    N'Nam',       -- sGioiTinh - nvarchar(5)
    N'Toan cao cap',       -- sChuyenNganh - nvarchar(30)
    'BM11'         -- sMaBM - varchar(10)
    )
-- ktra thay đổi
SELECT * FROM dbo.BOMON
GO 
--6. xóa 1 giáo viên thì tổng số giáo viên dạy bộ môn tương ứng sẽ giảm
CREATE TRIGGER XoaGVBM ON dbo.GIAOVIEN
AFTER DELETE 
AS 
BEGIN
    UPDATE dbo.BOMON SET iGVTGBM = iGVTGBM -
(
SELECT COUNT(sMaGV) AS tong FROM Deleted INNER JOIN dbo.BOMON ON BOMON.sMaBM = Deleted.sMaBM
) FROM dbo.BOMON INNER JOIN Deleted ON Deleted.sMaBM = BOMON.sMaBM
END
--kiểm thử
DELETE dbo.GIAOVIEN WHERE sMaGV = 'GV18'
-- kết quả (thành công )
SELECT * FROM dbo.BOMON
 
 GO 

--7. ngày kết thúc phải lớn hơn ngày bắt đầu đề tài
CREATE TRIGGER RB_time ON dbo.CONGVIEC
AFTER UPDATE ,INSERT
AS 
IF UPDATE(dNgayBD)
BEGIN
    Declare @nbd DATE, @nkt DATE
SELECT @nbd= Inserted.dNgayBD from inserted;
SELECT @nkt= Inserted.dNgayKT from inserted;
if(@nbd >= @nkt)
begin
print N'Ngày kết thúc phải sau ngày bắt đầu'
rollback tran
end
END

ALTER TABLE dbo.CONGVIEC NOCHECK CONSTRAINT ALL ;
ALTER TABLE dbo.CONGVIEC WITH CHECK CHECK CONSTRAINT ALL;


INSERT INTO dbo.CONGVIEC
VALUES
(   'DT07',        -- sMaDT - varchar(10)
    6,         -- iSTT - int
    N'Thu Hoạch',       -- sTenCV - nvarchar(30)
    '20210909', -- dNgayBD - date
    '20210909'  -- dNgayKT - date
    )
--DELETE dbo.CONGVIEC WHERE sMaDT = 'DT07'
	SELECT * FROM dbo.CONGVIEC

GO 

-- 8. năm kết thúc nhiệm kì của bộ môn phải bằng năm bắt đầu + 4.
ALTER TRIGGER RB_nhiemki ON dbo.BOMON
AFTER UPDATE , INSERT
AS 
BEGIN
    UPDATE dbo.BOMON SET iKTNhiemKy =  DATEADD(YEAR , 4 , iBDNhiemKy)
END

SELECT * FROM dbo.BOMON

GO 

---9. nếu ngày kết thúc đề tài chưa kết thúc thì không được ghi kết quả vào bảng tham gia đề tài
CREATE TRIGGER Check_KQ on dbo.THAMGIADETAI
	AFTER UPDATE, INSERT
AS
	IF UPDATE(sKetQua)
BEGIN
	DECLARE @nkt DATE,@kq varchar(30)
	SELECT @nkt= dNgayKT FROM dbo.CONGVIEC INNER JOIN inserted 
	on dbo.CONGVIEC.sMaDT=inserted.sMaDT
	SELECT @kq= sKetQua FROM inserted
IF(@nkt >= GETDATE() AND @kq!=' ' OR @kq = 'NULL' )
	BEGIN
		PRINT N'Ngày kết thúc phải kết thúc mới có kết quả'
		ROLLBACK TRAN
	END
endGO 
--test trigger ( thành công )
INSERT INTO dbo.CONGVIEC
VALUES
(   'DT01',        -- sMaDT - varchar(10)
    1,         -- iSTT - int
    N'khảo sát thị trường',       -- sTenCV - nvarchar(30)
    '20210202', -- dNgayBD - date
    '20220202'  -- dNgayKT - date
    )

	INSERT INTO dbo.THAMGIADETAI
	VALUES
	(   'GV17', -- sMaGV - varchar(10)
	    'DT01', -- sMaDT - varchar(10)
	    1,  -- iSTT - int
	    N'Đạt' -- sKetQua - nvarchar(30)
   )

SELECT * FROM dbo.KHOA

--- 10. tạo trigger check ràng buộc nhiệm kì của trưởng khoa phải là 5 năm .. ( ngày kết thúc hơn BĐ 5 năm )
CREATE TRIGGER CHECK_RBKH ON khoa 
AFTER UPDATE , INSERT
AS 
BEGIN
    UPDATE dbo.KHOA SET iKTNhiemKy = DATEADD(YEAR , 5 , iBDNhiemKy)
END









































































































































