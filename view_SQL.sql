
---1: View Thông tin giáo viên
	CREATE VIEW TTGiaovien
	AS 
	SELECT GV_SDT.sMaGV, sTenGV, dNgaySinh, sGioiTinh,sDiaChi, sSDT FROM dbo.GIAOVIEN ,dbo.GV_SDT
	WHERE dbo.GIAOVIEN.sMaGV=dbo.GV_SDT.sMaGV
	
---2: View hiện thông tin đề tài lĩnh vực công nghệ
	CREATE VIEW TTdetaiCN
	AS
    SELECT *FROM dbo.DETAI
	WHERE sMaCD LIKE 'CD02'
	WITH CHECK OPTION
---3: View công việc của giảng viên của đề tài "Nghiên cứu yếu tố điểm kém của sinh viên"
	CREATE VIEW cvDTNCSVien
	AS 
	SELECT iSTT,sTenCV,dNgayBD,dNgayKT FROM dbo.CONGVIEC
	WHERE sMaDT LIKE 'DT02'
	WITH CHECK OPTION 
---4: View số giảng viên viên mỗi Bộ môn
	CREATE VIEW soGVBommon
	AS 
	SELECT dbo.BOMON.sMaBM, sTenBM,COUNT(dbo.GIAOVIEN.sMaGV) AS [Số lượng giảng viên]
	FROM dbo.BOMON,dbo.GIAOVIEN
	WHERE dbo.GIAOVIEN.sMaBM=dbo.BOMON.sMaBM 
	GROUP BY dbo.BOMON.sMaBM,sTenBM
--- 5 : Xuất ds tên đề tài và giáo viên tham gia đề tài năm 2020

  CREATE VIEW dstenDT_2019
  AS
   SELECT DISTINCT sTenCD,YEAR(dNgayBD) AS[Năm]
   FROM dbo.CONGVIEC,dbo.DETAI,dbo.CHUDE
   WHERE dbo.CONGVIEC.sMaDT=dbo.DETAI.sMaDT
   AND dbo.CHUDE.sMaCD=dbo.DETAI.sMaCD
   AND YEAR(dbo.CONGVIEC.dNgayBD)=2019
   
---6:tính tổng tiền theo chủ đề 
	CREATE VIEW tongtienCD
	AS
    SELECT sTenCD, SUM(fKinhPhi) AS[tổng chi phí] 
	FROM dbo.CHUDE,dbo.DETAI
	WHERE dbo.DETAI.sMaCD=dbo.CHUDE.sMaCD
	GROUP BY sTenCD
   
---7: View ds mã bộ môn , tuổi tb của GV,sắp xếp tăng dần
 CREATE VIEW Montuoitb
AS 
SELECT TOP 100 PERCENT
dbo.BOMON.sMaBM,sTenBM,
Avg(Year(Getdate())-Year(dNgaySinh)) AS TuoiTB

FROM dbo.BOMON LEFT JOIN dbo.GIAOVIEN

ON dbo.BOMON.sMaBM=dbo.GIAOVIEN.sMaBM

GROUP BY dbo.BOMON.sMaBM, sTenBM
ORDER BY TuoiTB ASC
---8: Đếm số đề tài của mỗi chủ đề
 CREATE VIEW solDT
 AS 
 SELECT dbo.CHUDE.sMaCD,sTenCD,COUNT(sMaDT) AS[Số lượng đề tài]
 FROM dbo.CHUDE,dbo.DETAI
 WHERE dbo.CHUDE.sMaCD=dbo.DETAI.sMaCD
 GROUP BY dbo.CHUDE.sMaCD,dbo.CHUDE.sTenCD
---9: Đếm số lượng giáo viên mỗi khoa
 CREATE VIEW solGV
 AS
 SELECT BOMON.sMaKH,sTenKH,COUNT(sMaGV) AS [Tổng giáo viên]
 FROM dbo.KHOA,dbo.BOMON,dbo.GIAOVIEN
 WHERE dbo.GIAOVIEN.sMaBM=dbo.BOMON.sMaBM
 AND dbo.KHOA.sMaKH=dbo.BOMON.sMaKH
 GROUP BY BOMON.sMaKH,sTenKH
---10: Tổng lương tb của mỗi khoa
CREATE  VIEW luongTBK
AS
SELECT BOMON.sMaKH,sTenKH,AVG(fLuong) AS [Lương trung bình]
FROM dbo.KHOA,dbo.BOMON,dbo.GIAOVIEN
 WHERE dbo.GIAOVIEN.sMaBM=dbo.BOMON.sMaBM
 AND dbo.KHOA.sMaKH=dbo.BOMON.sMaKH
 GROUP BY BOMON.sMaKH,sTenKH
 ---11Tăng lương cho giảng viên trưởng bộ môn
 CREATE VIEW luongTBM
 AS 
 SELECT BOMON.sMaBM,sTruongBM,sTenGV,(fLuong*0.1+fLuong )AS [Lương trưởng bộ môn]
 FROM dbo.GIAOVIEN,dbo.BOMON
 WHERE dbo.GIAOVIEN.sMaGV=dbo.BOMON.sTruongBM
 --- đếm công việc của từng giáo viên
 CREATE VIEW sol_CV_GV
 AS
 SELECT dbo.THAMGIADETAI.sMaGV,sTenGV,COUNT(iSTT) AS [Số lượng]
 FROM dbo.GIAOVIEN,dbo.THAMGIADETAI
 WHERE dbo.GIAOVIEN.sMaGV=dbo.THAMGIADETAI.sMaGV
 GROUP BY dbo.THAMGIADETAI.sMaGV,sTenGV
 --- ds thông tin của trưởng đề tài cấp trường
 CREATE VIEW TTGVCNDT
 AS 
 SELECT sTenGV,sTenDT,
 FROM dbo.GIAOVIEN,dbo.DETAI
 WHERE dbo.GIAOVIEN.sMaGV=dbo.DETAI.sGVCNDT
 AND sCapQL = N'Trường'
