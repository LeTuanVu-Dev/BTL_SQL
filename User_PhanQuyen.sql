USE BTL_SQLSever_QUANLYDETAIGIAOVIEN
GO 
-- user và phân quyền
-- có 4 thành viên thế nên là có 4 tài khoản login
--tài khoản 1 
CREATE LOGIN HAITRIEU
WITH PASSWORD = '123456'

GO
 -- user cho tk đó
 CREATE USER USER_HAITRIEU
FOR LOGIN HAITRIEU
WITH DEFAULT_SCHEMA = BTL;
GO

-- phân quyền
GRANT SELECT , DELETE ON dbo.GIAOVIEN 
TO USER_HAITRIEU
GO 
-- ktra phân quyền không đc phép
UPDATE dbo.GIAOVIEN SET sMaBM = 'BM10' WHERE sMaGV = 'GV17'

-- KTRA DDOC PHÉP
SELECT * FROM dbo.GIAOVIEN

---------------------------------------------------------------------------
-- tài khoản 2
CREATE LOGIN PHAMPHIEN
WITH PASSWORD = '123456'

GO 
-- user tk2
CREATE USER USER_PHAMPHIEM 
FOR LOGIN PHAMPHIEN
WITH DEFAULT_SCHEMA = BTL
GO

-- phân quyền
GRANT INSERT , UPDATE ON dbo.GIAOVIEN
TO USER_PHAMPHIEM
GO 

-- ktra phân quyền không ddoc phép
SELECT * FROM dbo.GIAOVIEN

-- KTRA PHÂN QUYỀN HỢP LỆ
INSERT INTO dbo.GIAOVIEN
VALUES
(   'GV18',        -- sMaGV - varchar(10)
    N'TRẦN THỊ ÁNH DƯƠNG',       -- sTenGV - nvarchar(30)
    '19810911', -- dNgaySinh - date
    N'Hải Dương',       -- sDiaChi - nvarchar(30)
    20000000,       -- fLuong - float
    N'Nữ',       -- sGioiTinh - nvarchar(5)
    N'Toán Cao Cấp',       -- sChuyenNganh - nvarchar(30)
    'BM11'         -- sMaBM - varchar(10)
    )
-------------------------------------------------
--tài khoản 3
CREATE LOGIN THEKHAI
WITH PASSWORD = '123456'

GO 
-- user tk3
CREATE USER USER_THEKHAI
FOR LOGIN THEKHAI
WITH DEFAULT_SCHEMA = BTL

GO

--- PHÂN QUYỀN
GRANT SELECT , UPDATE ON dbo.BOMON
TO USER_THEKHAI
GO 

-- KTRA PHÂN QUYỀN ĐƯỢC PHÉP
SELECT * FROM dbo.BOMON

-----------------------------------------------
-- TÀI KHOẢN 4 
CREATE LOGIN TUANVU
WITH PASSWORD = '123456'

GO
-- USER TK4 
CREATE USER USER_TUANVU
FOR LOGIN TUANVU
WITH DEFAULT_SCHEMA = BTL

GO 
-- PHÂN QUYỀN
GRANT ALL ON dbo.KHOA
TO USER_TUANVU
GO

-- KTRA PHÂN QUYỀN HỢP LỆ
SELECT * FROM dbo.KHOA

-- KTRA KHÔNG HỢP LỆ
SELECT * FROM dbo.BOMON

































