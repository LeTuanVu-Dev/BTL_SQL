USE BTL_SQLSever_QUANLYDETAIGIAOVIEN
GO 
---
/*
Viết các Trigger cho phép kiểm soát ràng buộc dữ liệu, đồng bộ dữ liệu:
đơn giản, phức tạp, IF_UPDATE (ít nhất 10 trigger). Viết lệnh kích hoạt
các Trigger
*/
/* 1 Tạo trigger : thêm cột iSodt vào bảng giảng viên là tổng đề
tài của giáo viên đó quản lí ,tạo trigger cho phép insert một đề
tài thì tổng số đề tài của giáo viên đc tăng lên */
ALTER TABLE dbo.KHOA 
ADD isoGV INT 
UPDATE dbo.KHOA SET isoGV = (
SELECT COUNT(sMaGV) FROM dbo.GIAOVIEN INNER JOIN dbo.BOMON ON BOMON.sMaBM = GIAOVIEN.sMaBM INNER JOIN dbo.KHOA 
ON KHOA.sMaKH = BOMON.sMaKH )

SELECT * FROM dbo.CONGVIEC

--2. tạo trigger. thêm 1 công việc cho bảng công việc thì tổng số công việc của đề tài đó tăng lên
--3. xóa giáo viên thì số lượng giáo viên của khoa sẽ giảm 
--4. xóa công việc thì số lượng công việc của đề tài sẽ giảm
--5. ngày kết thúc phải lớn hơn ngày bắt đầu đề tài
--6. năm kết thúc nhiệm kì phải bằng năm bắt đầu + 4.
---7. nếu ngày kết thúc đề tài chưa kết thúc thì không được ghi kết quả vào bảng tham gia đề tài
--8. thêm giáo viên tham gia đề tài thì số lượng thành viên nhóm tăng lên
--9.. thêm 1 giáo viên thì tổng số giáo viên dạy bộ môn đó sẽ tăng
--10. xóa 1 giáo viên thì tổng số giáo viên dạy bộ môn tương ứng sẽ giảm

















































































































































