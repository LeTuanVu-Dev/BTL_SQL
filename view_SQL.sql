


/*Câu D : Tạo 10 view */

 -- Câu 1 : Tạo view Thông tin và thông tin liên lạc giáo viên
 --          và giáo viên đó đang ở khoa nào
 CREATE VIEW view_TTgiaovien
 AS
 SELECT sTenGV,sGioiTinh,dNgaySinh,fLuong,GV_SDT.sSDT,sTenKH FROM dbo.GIAOVIEN , dbo.GV_SDT,dbo.KHOA,dbo.BOMON
 WHERE GIAOVIEN.sMaGV = GV_SDT.sMaGV
 AND GIAOVIEN.sMaBM = BOMON.sMaBM
 AND BOMON.sMaKH = KHOA.sMaKH
 GO
 
 SELECT * FROM view_TTgiaovien
 GO
 -- Câu 2 : Tạo view tổng lương của mỗi khoa
 CREATE VIEW view_TongtienLuongKhoa
 as
 SELECT KHOA.sTenKH,SUM(fLuong) AS [Tổng tiền lương] FROM dbo.KHOA , dbo.view_TTgiaovien
 WHERE KHOA.sTenKH = view_TTgiaovien.sTenKH
 GROUP BY KHOA.sTenKH
 GO
 
 SELECT * FROM dbo.view_TongtienLuongKhoa
 GO
 
 -- Câu 3: Tạo view  tên đề tài đã thực hiện và công việc các giáo viên tham gia có kết quả đạt
 CREATE VIEW view_DTketQuaDat
 as
 SELECT sTenDT,GIAOVIEN.sMaGV,sTenGV,THAMGIADETAI.iSTT AS [Thứ tự công việc],sTenCV,sKetQua FROM dbo.DETAI 
 JOIN dbo.CONGVIEC
 ON CONGVIEC.sMaDT = DETAI.sMaDT
 JOIN dbo.THAMGIADETAI
 ON THAMGIADETAI.sMaDT = CONGVIEC.sMaDT AND THAMGIADETAI.iSTT = CONGVIEC.iSTT
 JOIN dbo.GIAOVIEN
 ON GIAOVIEN.sMaGV = THAMGIADETAI.sMaGV
 WHERE sKetQua = N'Đạt'
 GO

 SELECT * FROM dbo.view_DTketQuaDat
 GO
 

 -- Câu 4: Tạo view biết thông tin giáo viên chưa tham gia đề tài nào
 CREATE VIEW view_GiaovienKhongThamGiaDT
 as
 SELECT * FROM dbo.GIAOVIEN
 WHERE sMaGV NOT IN (
						SELECT sMaGV FROM dbo.view_DTketQuaDat
						)
 GO
 
 -- Câu 5: Tạo view thông kê số lượng giáo viên và tổng lương của từng bộ môn
 CREATE VIEW view_SoluongTongluongBM
 AS 
 SELECT sTenBM,COUNT(sMaGV) AS [Số lượng giáo viên] , SUM(fLuong) AS [Tổng lương bộ môn] 
 FROM dbo.GIAOVIEN
 JOIN dbo.BOMON
 ON BOMON.sMaBM = GIAOVIEN.sMaBM
 GROUP BY BOMON.sMaBM,sTenBM
 GO

 SELECT * FROM dbo.view_SoluongTongluongBM
 GO
 
 -- Câu 6: tạo view tên giáo viên tham gia đề tài năm 2018
 CREATE VIEW view_yearGVthamgia_DT
 AS
 SELECT DISTINCT sTenGV AS [Giáo viên tham gia] FROM dbo.DETAI
 JOIN dbo.CONGVIEC
 ON CONGVIEC.sMaDT = DETAI.sMaDT
 JOIN dbo.THAMGIADETAI
 ON THAMGIADETAI.sMaDT = CONGVIEC.sMaDT AND THAMGIADETAI.iSTT = CONGVIEC.iSTT
 JOIN dbo.GIAOVIEN
 ON GIAOVIEN.sMaGV = THAMGIADETAI.sMaGV
 WHERE YEAR(dNgayBD) = 2018
 GO
 
 SELECT * FROM dbo.view_yearGVthamgia_DT
 GO
 

 -- Câu 7: tạo view họ tên giáo viên đảm nhiệm ít nhất 2 công việc trong 1 đề tài
 CREATE VIEW view_Giaovienthamgia2congviec
 AS
 SELECT sTenGV,sTenDT, COUNT(CONGVIEC.iSTT) AS [Số lượng công việc đảm nhiệm] FROM dbo.GIAOVIEN
 JOIN dbo.THAMGIADETAI
 ON THAMGIADETAI.sMaGV = GIAOVIEN.sMaGV
 JOIN dbo.CONGVIEC
 ON CONGVIEC.sMaDT = THAMGIADETAI.sMaDT AND CONGVIEC.iSTT = THAMGIADETAI.iSTT
 JOIN dbo.DETAI
 ON DETAI.sMaDT = CONGVIEC.sMaDT
 GROUP BY sTenGV,sTenDT
 HAVING COUNT(CONGVIEC.iSTT) >=2
 GO
 
 SELECT * FROM dbo.view_Giaovienthamgia2congviec
 GO
 
 -- câu 8: tạo view Thống kê số lượng giáo viên của từng khoa
 CREATE VIEW view_SoluonggiaovienKHoa
 AS
 SELECT sTenKH,COUNT(sMaGV) AS [Số lượng giáo viên] FROM dbo.KHOA
 JOIN dbo.BOMON
 ON BOMON.sMaKH = KHOA.sMaKH
 JOIN dbo.GIAOVIEN 
 ON GIAOVIEN.sMaBM = BOMON.sMaBM
 GROUP BY sTenKH
 GO

 SELECT * FROM view_SoluonggiaovienKHoa
 GO
 
 -- Câu 9 : tạo view tên giáo viên chủ nhiệm đề tài cấp quản lý nhà nước
 CREATE VIEW VIEW_Truongdetai
 as
 SELECT sTenGV,sTenDT
 FROM dbo.GIAOVIEN,dbo.DETAI
 WHERE dbo.GIAOVIEN.sMaGV=dbo.DETAI.sGVCNDT
 AND sCapQL = N'Nhà nước'
 GO

 SELECT * FROM dbo.VIEW_Truongdetai
 GO
 
 -- Câu 10 : tạo view thống kê số lượng đề tài của chủ đề
 CREATE VIEW view_SoluongdetaiChude
 AS 
 SELECT sTenCD,COUNT(sMaDT) AS[Số lượng đề tài]
 FROM dbo.CHUDE,dbo.DETAI
 WHERE dbo.CHUDE.sMaCD=dbo.DETAI.sMaCD
 GROUP BY dbo.CHUDE.sTenCD
 GO
 
 SELECT * FROM dbo.view_SoluongdetaiChude