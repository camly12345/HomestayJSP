-- CSDL Núi Homestay (Java Web MVC)
-- Phiên bản tối ưu theo workflow thực tế:
-- 1. Giữ guest_name & guest_phone trong bookings để khách không cần tài khoản vẫn đặt phòng được.
-- 2. Giữ room_type_id trong bookings để luôn biết khách muốn loại phòng nào ngay cả khi chưa phân phòng vật lý.
-- 3. Rút gọn: bỏ size, cột bed chuyển thành INT (số lượng giường).
-- 4. Thêm bảng payments lưu vết giao dịch.

CREATE DATABASE IF NOT EXISTS `homestay` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `homestay`;

SET NAMES 'utf8mb4';
SET CHARACTER SET utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Xóa các bảng cũ
DROP TABLE IF EXISTS `payments`;
DROP TABLE IF EXISTS `support_requests`;
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `bookings`;
DROP TABLE IF EXISTS `rooms`;
DROP TABLE IF EXISTS `room_types`;
DROP TABLE IF EXISTS `users`;

-- 2. Bảng Users (Khách hàng, Lễ tân, Quản trị viên)
CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `phone` VARCHAR(20) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `role` VARCHAR(20) NOT NULL DEFAULT 'customer',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Bảng Room Types (Loại phòng - đã rút gọn bỏ size, bed là INT)
CREATE TABLE `room_types` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT,
  `price` DOUBLE NOT NULL DEFAULT 0,
  `capacity` INT NOT NULL DEFAULT 1,
  `bed` INT NOT NULL DEFAULT 1,
  `image` VARCHAR(255) DEFAULT 'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Bảng Rooms (Phòng vật lý thực tế)
CREATE TABLE `rooms` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(20) NOT NULL UNIQUE,
  `room_type_id` INT NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1: active, 0: inactive',
  FOREIGN KEY (`room_type_id`) REFERENCES `room_types`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Bảng Bookings (Đơn đặt phòng tối ưu)
CREATE TABLE `bookings` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(20) NOT NULL UNIQUE,
  `user_id` INT NULL,
  `room_id` INT NULL,
  `room_type_id` INT NOT NULL,
  `guest_name` VARCHAR(100) NOT NULL,
  `guest_phone` VARCHAR(20) NOT NULL,
  `guest_email` VARCHAR(100) DEFAULT '',
  `address` VARCHAR(255) DEFAULT '',
  `check_in` DATE NOT NULL,
  `check_out` DATE NOT NULL,
  `guests` INT NOT NULL DEFAULT 1,
  `total_price` DOUBLE NOT NULL DEFAULT 0,
  `pay_status` VARCHAR(20) NOT NULL DEFAULT 'unpaid',
  `pay_method` VARCHAR(20) NOT NULL DEFAULT 'cash',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending',
  `note` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`room_id`) REFERENCES `rooms`(`id`) ON DELETE SET NULL,
  FOREIGN KEY (`room_type_id`) REFERENCES `room_types`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Bảng Payments (Lưu giao dịch thanh toán)
CREATE TABLE `payments` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `id_booking` INT NOT NULL,
  `method` VARCHAR(20) NOT NULL DEFAULT 'cash',
  `transactioncode` VARCHAR(50) NOT NULL,
  `amount` DOUBLE NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`id_booking`) REFERENCES `bookings`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- DỮ LIỆU MẪU (Sample Data)
-- Mật khẩu mặc định: 123456 (MD5: e10adc3949ba59abbe56e057f20f883e)
INSERT INTO `users` (`name`, `email`, `phone`, `password`, `role`) VALUES
('Quản trị viên', 'admin@homestay.com', '0353566001', 'e10adc3949ba59abbe56e057f20f883e', 'admin'),
('Lễ tân Núi Homestay', 'reception@homestay.com', '0353566002', 'e10adc3949ba59abbe56e057f20f883e', 'receptionist'),
('Nguyễn Văn An', 'khachhang@gmail.com', '0912345678', 'e10adc3949ba59abbe56e057f20f883e', 'customer'),
('Trần Hoàng Nam', 'nam.th@gmail.com', '0933112233', 'e10adc3949ba59abbe56e057f20f883e', 'customer'),
('Phạm Quỳnh Nga', 'nga.pq@gmail.com', '0944556677', 'e10adc3949ba59abbe56e057f20f883e', 'customer');

-- Loại phòng (bed kiểu số nguyên)
INSERT INTO `room_types` (`name`, `description`, `price`, `capacity`, `bed`, `image`) VALUES
('Phòng đơn', 'Phòng tiêu chuẩn ấm cúng, view vườn xanh mát, trang bị đầy đủ tiện nghi điều hòa, nóng lạnh, wifi tốc độ cao.', 450000, 1, 1, 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=1000'),
('Phòng đôi', 'Không gian thoáng đãng với ban công rộng nhìn ra đồi thông, thích hợp cho các cặp đôi tận hưởng kỳ nghỉ yên tĩnh.', 650000, 2, 1, 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=1000'),
('Phòng gia đình', 'Phòng lớn 2 giường đôi, không gian sinh hoạt chung rộng rãi, lý tưởng cho gia đình 4 người hoặc nhóm bạn.', 950000, 4, 2, 'https://images.unsplash.com/photo-1582719508461-905c673771fd?w=1000'),
('Phòng VIP 1', 'Căn nhà gỗ biệt lập giữa rừng cây, thiết kế phong cách mộc mạc đậm chất cố đô, mang lại trải nghiệm nghỉ dưỡng thư thái.', 1200000, 3, 2, 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=1000');

-- Phòng thực tế (status: 1 = active, 0 = inactive)
INSERT INTO `rooms` (`code`, `room_type_id`, `status`) VALUES
('P101', 1, 1),
('P102', 1, 1),
('P103', 1, 0), -- inactive: kiểm tra lọc phòng hoạt động / vô hiệu
('P201', 2, 1),
('P202', 2, 1),
('P203', 2, 1),
('P301', 3, 1),
('P302', 3, 1),
('P305', 3, 1),
('BG01', 4, 1),
('BG02', 4, 1),
('BG03', 4, 0); -- inactive: kiểm tra hiển thị bảo trì

-- Đơn đặt phòng mẫu với đủ trạng thái: pending, confirmed, checkedin, checkedout, cancelled
INSERT INTO `bookings` (`code`, `user_id`, `room_id`, `room_type_id`, `guest_name`, `guest_phone`, `guest_email`, `check_in`, `check_out`, `guests`, `total_price`, `pay_status`, `pay_method`, `status`, `note`) VALUES
('BK1001', 3, 4, 2, 'Trần Minh Tuấn', '0987654321', 'tuan.tm@gmail.com', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 2, 1300000, 'paid', 'transfer', 'checkedin', 'Nhận phòng sớm nếu có thể'),
('BK1002', NULL, 1, 1, 'Lê Thị Thu', '0978112233', 'thule@gmail.com', DATE_ADD(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 3 DAY), 1, 900000, 'unpaid', 'cash', 'confirmed', 'Khách đến lúc 14h'),
('BK2001', 4, 3, 2, 'Trần Hoàng Nam', '0933112233', 'nam.th@gmail.com', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 2, 1300000, 'paid', 'transfer', 'checkedin', 'Khách yêu cầu thêm 1 gối'),
('BK2002', 5, NULL, 1, 'Phạm Quỳnh Nga', '0944556677', 'nga.pq@gmail.com', DATE_ADD(CURDATE(), INTERVAL 3 DAY), DATE_ADD(CURDATE(), INTERVAL 5 DAY), 1, 900000, 'unpaid', 'cash', 'pending', 'Cần phòng tầng 1 yên tĩnh'),
('BK2003', NULL, 7, 3, 'Vũ Đình Trọng', '0988776655', 'trong.vd@gmail.com', DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 4, 2850000, 'paid', 'cash', 'checkedout', 'Gia đình có 2 trẻ nhỏ'),
('BK2004', 3, NULL, 4, 'Nguyễn Văn An', '0912345678', 'khachhang@gmail.com', DATE_ADD(CURDATE(), INTERVAL 7 DAY), DATE_ADD(CURDATE(), INTERVAL 9 DAY), 2, 2400000, 'unpaid', 'transfer', 'cancelled', 'Khách hủy vì đổi lịch');

-- Giao dịch thanh toán mẫu
INSERT INTO `payments` (`id_booking`, `method`, `transactioncode`, `amount`) VALUES
(1, 'transfer', '10018899', 1300000),
(3, 'transfer', 'VNPAY_BK2001_8899', 1300000),
(5, 'cash', 'CASH_BK2003_001', 2850000);

SET FOREIGN_KEY_CHECKS = 1;
