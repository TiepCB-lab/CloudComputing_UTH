-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th10 23, 2025 lúc 06:36 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `cinema_db`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `booking_code` varchar(50) NOT NULL,
  `movie_title` varchar(255) NOT NULL,
  `cinema_room` varchar(100) NOT NULL,
  `seat_list` varchar(255) NOT NULL COMMENT 'Lưu chuỗi ghế: A1, A2',
  `user_id` int(11) NOT NULL,
  `showtime_id` int(11) NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_phone` varchar(20) NOT NULL,
  `total_amount` int(11) NOT NULL,
  `status` enum('pending','success','cancelled') DEFAULT 'pending',
  `voucher_code` varchar(50) DEFAULT NULL,
  `discount_amount` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `bookings`
--

INSERT INTO `bookings` (`id`, `booking_code`, `movie_title`, `cinema_room`, `seat_list`, `user_id`, `showtime_id`, `customer_name`, `customer_phone`, `total_amount`, `status`, `voucher_code`, `discount_amount`, `created_at`) VALUES
(1, 'CGVOLD1', 'Phim (Đơn cũ)', 'Phòng 1', 'Ghế thường', 6, 24, 'Tâm Phú', '113', 529000, 'success', NULL, 0, '2025-11-23 14:16:02'),
(2, 'CGV205326', 'Lật Mặt 7: Một Điều Ước', 'Phòng 2', 'A1, A2, A3, A4, A5', 6, 26, 'Tâm Phú', '113', 539000, 'success', 'GIAM10K', 10000, '2025-11-23 14:44:45'),
(3, 'CGV124995', 'Lật Mặt 7: Một Điều Ước', 'Phòng 2', 'C12, C11, C10', 6, 26, 'Công An Xã', '113', 184500, 'success', 'SALE50', 184500, '2025-11-23 15:03:17');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `booking_seats`
--

CREATE TABLE `booking_seats` (
  `id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `seat_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `booking_seats`
--

INSERT INTO `booking_seats` (`id`, `booking_id`, `seat_id`) VALUES
(1, 1, 63),
(2, 1, 62),
(3, 1, 61),
(4, 1, 64),
(5, 1, 65),
(6, 2, 1),
(7, 2, 2),
(8, 2, 3),
(9, 2, 4),
(10, 2, 5),
(11, 3, 36),
(12, 3, 35),
(13, 3, 34);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `movies`
--

CREATE TABLE `movies` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `poster` varchar(500) DEFAULT NULL,
  `banner` varchar(500) DEFAULT NULL,
  `trailer_url` varchar(500) DEFAULT NULL,
  `release_date` date DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `director` varchar(255) DEFAULT NULL,
  `cast` text DEFAULT NULL,
  `rating` varchar(10) DEFAULT 'P',
  `is_trending` tinyint(1) DEFAULT 0,
  `is_new` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `movies`
--

INSERT INTO `movies` (`id`, `title`, `description`, `poster`, `banner`, `trailer_url`, `release_date`, `duration`, `category`, `director`, `cast`, `rating`, `is_trending`, `is_new`, `created_at`, `updated_at`) VALUES
(1, 'Mưa Đỏ', 'Lấy bối cảnh 81 ngày đêm khốc liệt tại Thành Cổ Quảng Trị năm 1972, Mưa Đỏ là câu chuyện hư cấu, theo chân một tiểu đội gồm những người lính trẻ tuổi, đầy nhiệt huyết, chiến đấu và bám trụ tại trận địa lịch sử này.', 'https://imgchinhsachcuocsong.vnanet.vn/MediaUpload/Org/2025/07/23/204219-z6833331728306_9920591c2fadf96b8ec838e4967f44a4.jpg', 'https://imgchinhsachcuocsong.vnanet.vn/MediaUpload/Org/2025/07/23/204219-z6833331728306_9920591c2fadf96b8ec838e4967f44a4.jpg', 'https://www.youtube.com/embed/BD6PoZJdt_M', '2025-01-01', 120, 'Chiến tranh, Lịch sử', 'Nguyễn Quang Dũng', 'Nhiều diễn viên trẻ', 'T18', 0, 1, '2025-11-19 02:55:44', '2025-11-23 13:49:32'),
(2, 'Lật Mặt 7: Một Điều Ước', 'Phim xoay quanh câu chuyện của bà Hai (Thanh Hiền) và bốn người con. Khi bà Hai không may gặp nạn, cần người chăm sóc, bốn người con đùn đẩy nhau. Câu chuyện đặt ra câu hỏi về lòng hiếu thảo và tình cảm gia đình.', 'https://photo-baomoi.bmcdn.me/w700_r1/2024_03_13_17_48553023/057ac6914bdda283fbcc.jpg', 'https://photo-baomoi.bmcdn.me/w700_r1/2024_03_13_17_48553023/057ac6914bdda283fbcc.jpg', 'https://www.youtube.com/embed/d1ZHdosjNX8', '2025-01-01', 138, 'Gia đình, Chính kịch', 'Lý Hải', 'Thanh Hiền, Trương Minh Cường, Đinh Y Nhung, Quách Ngọc Tuyên', 'T13', 0, 1, '2025-11-19 02:57:27', '2025-11-23 17:00:44'),
(3, 'Gặp Lại Chị Bầu', 'Phúc, một thanh niên có quá khứ bất hảo, cùng bạn bè lập nghiệp ở xóm trọ. Anh gặp Huyền, một cô gái tốt bụng. Tình yêu của họ nảy nở giữa những khó khăn, và bí mật về quá khứ của Huyền dần được hé lộ.', 'https://tse3.mm.bing.net/th/id/OIP.xrGKhbdzKrWVQ2urtnnk-AHaK_?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://tse3.mm.bing.net/th/id/OIP.xrGKhbdzKrWVQ2urtnnk-AHaK_?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://www.youtube.com/embed/8WS_CiekZLc', '2025-01-01', 110, 'Hài, Tình cảm', 'Nhất Trung', 'Anh Tú, Diệu Nhi, Lê Giang, Ngọc Phước', 'T16', 0, 1, '2025-11-19 02:57:27', '2025-11-23 17:01:02'),
(4, 'Nhà Gia Tiên', 'Câu chuyện về một gia đình gốc Việt tại Mỹ và những xung đột thế hệ. Phim khám phá sự khác biệt văn hóa, kỳ vọng của cha mẹ và ước mơ của con cái trong bối cảnh hiện đại.', 'https://st.download.com.vn/data/image/2025/02/14/nha-gia-tien.jpg', 'https://st.download.com.vn/data/image/2025/02/14/nha-gia-tien.jpg', 'https://www.youtube.com/embed/aR2lnpCLqUk', '2025-01-01', 95, 'Gia đình, Hài', 'Trần Hữu Tấn', 'Lê Khanh, Hồng Đào, Thái Hòa, Tuấn Trần', 'T13', 0, 1, '2025-11-19 02:57:27', '2025-11-23 13:49:32'),
(5, 'Thám Tử Kiên: Kỳ Án Không Đầu', 'Một thám tử tư tài ba nhưng lập dị điều tra một vụ án mạng bí ẩn nơi nạn nhân bị mất đầu. Anh phải chạy đua với thời gian để tìm ra hung thủ trước khi hắn ra tay lần nữa.', 'https://tse1.mm.bing.net/th/id/OIP.4HedOsPiqdgGJBNfuEHYUQHaKl?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://tse1.mm.bing.net/th/id/OIP.4HedOsPiqdgGJBNfuEHYUQHaKl?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://www.youtube.com/embed/QiXNbEKF3U0', '2025-01-01', 115, 'Trinh thám, Kinh dị', 'Victor Vũ', 'Hứa Vĩ Văn, Trúc Anh, Kaity Nguyễn', 'T18', 0, 1, '2025-11-19 02:57:27', '2025-11-23 13:49:32'),
(6, 'Nhà Bà Nữ', 'Phim xoay quanh gia đình bà Nữ, chủ một quán bánh canh cua, và những mâu thuẫn thế hệ gay gắt. Câu chuyện khai thác áp lực gia đình, tình yêu và sự tha thứ.', 'https://th.bing.com/th/id/R.4484bb72cef55c45590763e3d98772ed?rik=KN1P4v1nfCF6sA&pid=ImgRaw&r=0', 'https://th.bing.com/th/id/R.4484bb72cef55c45590763e3d98772ed?rik=KN1P4v1nfCF6sA&pid=ImgRaw&r=0', 'https://www.youtube.com/embed/4peQFKutH34', '2023-01-01', 135, 'Chính kịch, Gia đình', 'Trấn Thành', 'Trấn Thành, Lê Giang, Uyển Ân, Song Luân', 'T16', 0, 1, '2025-11-19 02:57:27', '2025-11-23 13:49:32'),
(7, 'Lật Mặt 6: Tấm Vé Định Mệnh', 'Một nhóm bạn thân trúng số độc đắc. Tấm vé đã thay đổi cuộc đời họ, nhưng cũng kéo theo những âm mưu, sự phản bội và cái chết. Tình bạn của họ bị thử thách bởi lòng tham.', 'https://tse3.mm.bing.net/th/id/OIP.gwUCRkCrlItYPT7oEALsKAHaLH?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://tse3.mm.bing.net/th/id/OIP.gwUCRkCrlItYPT7oEALsKAHaLH?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://www.youtube.com/embed/ns9f92mR6bM', '2023-01-01', 132, 'Hành động, Giật gân', 'Lý Hải', 'Quốc Cường, Trung Dũng, Huy Khánh, Thanh Thức', 'T18', 1, 0, '2025-11-19 02:57:27', '2025-11-23 13:49:32'),
(8, 'Đất Rừng Phương Nam', 'Phiên bản điện ảnh kể về hành trình phiêu lưu của cậu bé An đi tìm cha qua các tỉnh miền Tây Nam Bộ trong thời kỳ kháng chiến chống Pháp. Phim tái hiện vẻ đẹp hùng vĩ của thiên nhiên và con người nơi đây.', 'https://tse1.mm.bing.net/th/id/OIP.fAgqmbugm7Fvfh9qY37GkwHaJQ?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://tse1.mm.bing.net/th/id/OIP.fAgqmbugm7Fvfh9qY37GkwHaJQ?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://www.youtube.com/embed/D0_w81Q-P3M', '2023-01-01', 110, 'Phiêu lưu, Gia đình', 'Nguyễn Quang Dũng', 'Hạo Khang, Trấn Thành, Tuấn Trần, Hồng Ánh', 'T13', 1, 0, '2025-11-19 02:57:27', '2025-11-23 13:49:32'),
(9, 'Em và Trịnh', 'Bộ phim tái hiện cuộc đời và những mối tình của nhạc sĩ Trịnh Công Sơn. Phim là bức tranh lãng mạn về âm nhạc, tình yêu và những nàng thơ đã đi qua cuộc đời ông.', 'https://tintuc-divineshop.cdn.vccloud.vn/wp-content/uploads/2022/06/review-em-va-trinh_62a329726ea9a.jpeg', 'https://tintuc-divineshop.cdn.vccloud.vn/wp-content/uploads/2022/06/review-em-va-trinh_62a329726ea9a.jpeg', 'https://www.youtube.com/embed/zzik4JB9D1Q', '2022-01-01', 136, 'Tiểu sử, Lãng mạn', 'Phan Gia Nhật Linh', 'Avin Lu, Bùi Lan Hương, Hoàng Hà, Lan Thy', 'T13', 1, 0, '2025-11-19 02:57:27', '2025-11-23 13:49:32'),
(10, 'Con Nhót Mót Chồng', 'Câu chuyện hài hước và cảm động về Nhót, một người phụ nữ quá lứa sống cùng người cha nghiện rượu. Hành trình tìm chồng của Nhót cũng là hành trình cô hàn gắn tình cảm với cha mình.', 'https://tse1.explicit.bing.net/th/id/OIP.ycZsFjfDFuRrzw-EGbeosAHaJQ?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://tse1.explicit.bing.net/th/id/OIP.ycZsFjfDFuRrzw-EGbeosAHaJQ?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://www.youtube.com/embed/e7KHOQ-alqY', '2023-01-01', 90, 'Hài, Gia đình', 'Vũ Ngọc Đãng', 'Thu Trang, Thái Hòa, Tiến Luật', 'T16', 1, 0, '2025-11-19 02:57:27', '2025-11-23 13:49:32'),
(11, 'Siêu Lừa Gặp Siêu Lầy', 'Khoa, một tên lừa đảo, đến Phú Quốc với ý định lừa đảo. Anh gặp Tú, một tên lừa đảo lầy lội khác. Cả hai hợp tác trong nhiều phi vụ dở khóc dở cười trước khi đối mặt với một đối thủ lớn.', 'https://tse1.mm.bing.net/th/id/OIP.wqDOC6JOXfblf2BIRrMLlQHaK4?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://tse1.mm.bing.net/th/id/OIP.wqDOC6JOXfblf2BIRrMLlQHaK4?rs=1&pid=ImgDetMain&o=7&rm=3', 'https://www.youtube.com/embed/oNqD2HxBUq4', '2023-01-01', 112, 'Hài, Hành động', 'Võ Thanh Hòa', 'Anh Tú, Mạc Văn Khoa, Ngọc Phước', 'T16', 1, 0, '2025-11-19 02:57:27', '2025-11-23 13:49:32');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `rooms`
--

CREATE TABLE `rooms` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `rooms`
--

INSERT INTO `rooms` (`id`, `name`) VALUES
(1, 'Phòng 1'),
(2, 'Phòng 2');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `seats`
--

CREATE TABLE `seats` (
  `id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `seat_code` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `seats`
--

INSERT INTO `seats` (`id`, `room_id`, `seat_code`) VALUES
(1, 1, 'A1'),
(2, 1, 'A2'),
(3, 1, 'A3'),
(4, 1, 'A4'),
(5, 1, 'A5'),
(6, 1, 'A6'),
(7, 1, 'A7'),
(8, 1, 'A8'),
(9, 1, 'A9'),
(10, 1, 'A10'),
(11, 1, 'A11'),
(12, 1, 'A12'),
(13, 1, 'B1'),
(14, 1, 'B2'),
(15, 1, 'B3'),
(16, 1, 'B4'),
(17, 1, 'B5'),
(18, 1, 'B6'),
(19, 1, 'B7'),
(20, 1, 'B8'),
(21, 1, 'B9'),
(22, 1, 'B10'),
(23, 1, 'B11'),
(24, 1, 'B12'),
(25, 1, 'C1'),
(26, 1, 'C2'),
(27, 1, 'C3'),
(28, 1, 'C4'),
(29, 1, 'C5'),
(30, 1, 'C6'),
(31, 1, 'C7'),
(32, 1, 'C8'),
(33, 1, 'C9'),
(34, 1, 'C10'),
(35, 1, 'C11'),
(36, 1, 'C12'),
(37, 1, 'D1'),
(38, 1, 'D2'),
(39, 1, 'D3'),
(40, 1, 'D4'),
(41, 1, 'D5'),
(42, 1, 'D6'),
(43, 1, 'D7'),
(44, 1, 'D8'),
(45, 1, 'D9'),
(46, 1, 'D10'),
(47, 1, 'D11'),
(48, 1, 'D12'),
(49, 1, 'E1'),
(50, 1, 'E2'),
(51, 1, 'E3'),
(52, 1, 'E4'),
(53, 1, 'E5'),
(54, 1, 'E6'),
(55, 1, 'E7'),
(56, 1, 'E8'),
(57, 1, 'E9'),
(58, 1, 'E10'),
(59, 1, 'E11'),
(60, 1, 'E12'),
(61, 1, 'F1'),
(62, 1, 'F2'),
(63, 1, 'F3'),
(64, 1, 'F4'),
(65, 1, 'F5'),
(66, 1, 'F6'),
(67, 1, 'F7'),
(68, 1, 'F8'),
(69, 1, 'F9'),
(70, 1, 'F10'),
(71, 1, 'F11'),
(72, 1, 'F12'),
(73, 1, 'G1'),
(74, 1, 'G2'),
(75, 1, 'G3'),
(76, 1, 'G4'),
(77, 1, 'G5'),
(78, 1, 'G6'),
(79, 1, 'G7'),
(80, 1, 'G8'),
(81, 1, 'G9'),
(82, 1, 'G10'),
(83, 1, 'G11'),
(84, 1, 'G12'),
(85, 1, 'H1'),
(86, 1, 'H2'),
(87, 1, 'H3'),
(88, 1, 'H4'),
(89, 1, 'H5'),
(90, 1, 'H6'),
(91, 1, 'H7'),
(92, 1, 'H8'),
(93, 1, 'H9'),
(94, 1, 'H10'),
(95, 1, 'H11'),
(96, 1, 'H12'),
(97, 1, 'I1'),
(98, 1, 'I2'),
(99, 1, 'I3'),
(100, 1, 'I4'),
(101, 1, 'I5'),
(102, 1, 'I6'),
(103, 1, 'I7'),
(104, 1, 'I8'),
(105, 1, 'I9'),
(106, 1, 'I10'),
(107, 1, 'I11'),
(108, 1, 'I12'),
(109, 1, 'J1'),
(110, 1, 'J2'),
(111, 1, 'J3'),
(112, 1, 'J4'),
(113, 1, 'J5'),
(114, 1, 'J6'),
(115, 1, 'J7'),
(116, 1, 'J8'),
(117, 1, 'J9'),
(118, 1, 'J10'),
(119, 1, 'J11'),
(120, 1, 'J12');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `showtimes`
--

CREATE TABLE `showtimes` (
  `id` int(11) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `show_date` date NOT NULL,
  `show_time` time NOT NULL,
  `price` int(11) NOT NULL DEFAULT 75000,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `showtimes`
--

INSERT INTO `showtimes` (`id`, `movie_id`, `room_id`, `show_date`, `show_time`, `price`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2025-11-24', '08:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(2, 1, 2, '2025-11-24', '14:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(3, 2, 2, '2025-11-24', '09:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(4, 2, 1, '2025-11-24', '15:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(5, 3, 1, '2025-11-24', '10:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(6, 3, 2, '2025-11-24', '16:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(7, 4, 2, '2025-11-24', '11:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(8, 4, 1, '2025-11-24', '17:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(9, 5, 1, '2025-11-24', '12:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(10, 5, 2, '2025-11-24', '18:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(11, 6, 2, '2025-11-24', '13:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(12, 6, 1, '2025-11-24', '19:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(13, 7, 1, '2025-11-24', '14:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(14, 7, 2, '2025-11-24', '20:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(15, 8, 2, '2025-11-24', '15:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(16, 8, 1, '2025-11-24', '21:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(17, 9, 1, '2025-11-24', '16:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(18, 9, 2, '2025-11-24', '22:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(19, 10, 2, '2025-11-24', '17:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(20, 10, 1, '2025-11-24', '22:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(21, 11, 1, '2025-11-24', '18:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(22, 11, 2, '2025-11-24', '23:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(23, 1, 2, '2025-11-25', '10:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(24, 1, 1, '2025-11-25', '18:30:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(25, 2, 1, '2025-11-25', '08:30:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(26, 2, 2, '2025-11-25', '19:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(27, 3, 2, '2025-11-25', '11:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(28, 3, 1, '2025-11-25', '20:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(29, 4, 1, '2025-11-25', '12:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(30, 4, 2, '2025-11-25', '20:30:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(31, 5, 2, '2025-11-25', '13:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(32, 5, 1, '2025-11-25', '21:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(33, 6, 1, '2025-11-25', '14:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(34, 6, 2, '2025-11-25', '21:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(35, 7, 2, '2025-11-25', '15:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(36, 7, 1, '2025-11-25', '09:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(37, 8, 1, '2025-11-25', '16:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(38, 8, 2, '2025-11-25', '09:30:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(39, 9, 2, '2025-11-25', '17:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(40, 9, 1, '2025-11-25', '10:30:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(41, 10, 1, '2025-11-25', '18:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(42, 10, 2, '2025-11-25', '11:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(43, 11, 2, '2025-11-25', '19:30:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(44, 11, 1, '2025-11-25', '13:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(45, 1, 1, '2025-11-26', '11:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(46, 1, 2, '2025-11-26', '17:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(47, 2, 2, '2025-11-26', '12:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(48, 2, 1, '2025-11-26', '18:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(49, 3, 1, '2025-11-26', '13:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(50, 3, 2, '2025-11-26', '19:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(51, 4, 2, '2025-11-26', '14:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(52, 4, 1, '2025-11-26', '20:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(53, 5, 1, '2025-11-26', '15:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(54, 5, 2, '2025-11-26', '21:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(55, 6, 2, '2025-11-26', '16:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(56, 6, 1, '2025-11-26', '09:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(57, 7, 1, '2025-11-26', '17:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(58, 7, 2, '2025-11-26', '10:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(59, 8, 2, '2025-11-26', '18:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(60, 8, 1, '2025-11-26', '10:30:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(61, 9, 1, '2025-11-26', '19:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(62, 9, 2, '2025-11-26', '11:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(63, 10, 2, '2025-11-26', '20:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(64, 10, 1, '2025-11-26', '12:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(65, 11, 1, '2025-11-26', '21:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(66, 11, 2, '2025-11-26', '13:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(67, 1, 2, '2025-11-27', '09:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(68, 1, 1, '2025-11-27', '19:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(69, 2, 1, '2025-11-27', '10:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(70, 2, 2, '2025-11-27', '20:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(71, 3, 2, '2025-11-27', '11:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(72, 3, 1, '2025-11-27', '21:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(73, 4, 1, '2025-11-27', '12:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(74, 4, 2, '2025-11-27', '18:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(75, 5, 2, '2025-11-27', '13:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(76, 5, 1, '2025-11-27', '19:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(77, 6, 1, '2025-11-27', '14:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(78, 6, 2, '2025-11-27', '09:30:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(79, 7, 2, '2025-11-27', '15:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(80, 7, 1, '2025-11-27', '10:30:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(81, 8, 1, '2025-11-27', '16:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(82, 8, 2, '2025-11-27', '11:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(83, 9, 2, '2025-11-27', '17:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(84, 9, 1, '2025-11-27', '12:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(85, 10, 1, '2025-11-27', '18:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(86, 10, 2, '2025-11-27', '13:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(87, 11, 2, '2025-11-27', '21:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(88, 11, 1, '2025-11-27', '14:30:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(89, 1, 1, '2025-11-28', '19:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(90, 1, 2, '2025-11-28', '22:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(91, 2, 2, '2025-11-28', '18:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(92, 2, 1, '2025-11-28', '21:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(93, 3, 1, '2025-11-28', '18:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(94, 3, 2, '2025-11-28', '10:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(95, 4, 2, '2025-11-28', '17:30:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(96, 4, 1, '2025-11-28', '11:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(97, 5, 1, '2025-11-28', '20:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(98, 5, 2, '2025-11-28', '12:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(99, 6, 2, '2025-11-28', '20:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(100, 6, 1, '2025-11-28', '13:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(101, 7, 1, '2025-11-28', '21:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(102, 7, 2, '2025-11-28', '14:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(103, 8, 2, '2025-11-28', '21:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(104, 8, 1, '2025-11-28', '15:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(105, 9, 1, '2025-11-28', '22:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(106, 9, 2, '2025-11-28', '16:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(107, 10, 2, '2025-11-28', '19:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(108, 10, 1, '2025-11-28', '09:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(109, 11, 1, '2025-11-28', '20:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(110, 11, 2, '2025-11-28', '15:30:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(111, 1, 2, '2025-11-29', '09:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(112, 1, 1, '2025-11-29', '20:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(113, 2, 1, '2025-11-29', '10:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(114, 2, 2, '2025-11-29', '21:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(115, 3, 2, '2025-11-29', '11:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(116, 3, 1, '2025-11-29', '22:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(117, 4, 1, '2025-11-29', '12:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(118, 4, 2, '2025-11-29', '18:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(119, 5, 2, '2025-11-29', '13:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(120, 5, 1, '2025-11-29', '19:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(121, 6, 1, '2025-11-29', '14:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(122, 6, 2, '2025-11-29', '19:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(123, 7, 2, '2025-11-29', '15:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(124, 7, 1, '2025-11-29', '20:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(125, 8, 1, '2025-11-29', '16:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(126, 8, 2, '2025-11-29', '21:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(127, 9, 2, '2025-11-29', '17:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(128, 9, 1, '2025-11-29', '22:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(129, 10, 1, '2025-11-29', '18:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(130, 10, 2, '2025-11-29', '09:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(131, 11, 2, '2025-11-29', '22:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(132, 11, 1, '2025-11-29', '10:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(133, 1, 1, '2025-11-30', '08:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(134, 1, 2, '2025-11-30', '19:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(135, 2, 2, '2025-11-30', '09:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(136, 2, 1, '2025-11-30', '20:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(137, 3, 1, '2025-11-30', '10:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(138, 3, 2, '2025-11-30', '21:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(139, 4, 2, '2025-11-30', '11:30:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(140, 4, 1, '2025-11-30', '18:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(141, 5, 1, '2025-11-30', '12:30:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(142, 5, 2, '2025-11-30', '19:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(143, 6, 2, '2025-11-30', '13:30:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(144, 6, 1, '2025-11-30', '20:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(145, 7, 1, '2025-11-30', '14:30:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(146, 7, 2, '2025-11-30', '21:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(147, 8, 2, '2025-11-30', '15:30:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(148, 8, 1, '2025-11-30', '22:00:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(149, 9, 1, '2025-11-30', '16:30:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(150, 9, 2, '2025-11-30', '10:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(151, 10, 2, '2025-11-30', '17:30:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(152, 10, 1, '2025-11-30', '11:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(153, 11, 1, '2025-11-30', '21:30:00', 95000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(154, 11, 2, '2025-11-30', '14:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(155, 1, 1, '2025-12-01', '10:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(156, 1, 2, '2025-12-01', '19:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(157, 2, 2, '2025-12-01', '11:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(158, 2, 1, '2025-12-01', '20:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(159, 3, 1, '2025-12-01', '12:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(160, 3, 2, '2025-12-01', '21:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(161, 4, 2, '2025-12-01', '13:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(162, 4, 1, '2025-12-01', '18:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(163, 5, 1, '2025-12-01', '14:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(164, 5, 2, '2025-12-01', '19:30:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(165, 6, 2, '2025-12-01', '15:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(166, 6, 1, '2025-12-01', '20:30:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(167, 7, 1, '2025-12-01', '16:00:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(168, 7, 2, '2025-12-01', '09:00:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(169, 8, 2, '2025-12-01', '17:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(170, 8, 1, '2025-12-01', '09:30:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(171, 9, 1, '2025-12-01', '18:00:00', 85000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(172, 9, 2, '2025-12-01', '10:30:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(173, 10, 2, '2025-12-01', '21:30:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(174, 10, 1, '2025-12-01', '11:30:00', 75000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(175, 11, 1, '2025-12-01', '22:00:00', 90000, '2025-11-23 14:13:14', '2025-11-23 14:13:14'),
(176, 11, 2, '2025-12-01', '13:30:00', 80000, '2025-11-23 14:13:14', '2025-11-23 14:13:14');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `role`, `created_at`) VALUES
(1, 'hienminh7383', 'hienminh7383@gmail.com', '$2y$10$X31kJINyzwSVX32ZlAc.ae284jw0HvKm6z5q8cLhS171AqwnIExvm', 'admin', '2025-11-13 11:46:05'),
(2, 'admin', 'admin123@gmail.com', '$2y$10$MTPlin8WcMhdbMl/ahkWDOrKiJrrTeP5k1AXZNKhgBbOpocR0E5Zy', 'user', '2025-11-14 03:13:48'),
(4, 'Bá Thành', 'huynhbathanh2110200@gmail.com', '$2y$10$6emhsr.f9MWtmQHOQGFUh.GB8R6mxJvDUhzkdKGFGuFVJYkBR.tfy', 'user', '2025-11-21 12:05:56'),
(5, 'Bá Thành', 'huynhbathanh21102005@gmail.com', '$2y$10$YSjdfdg4x8S33GfYDcNR8OCn8VE9eIdM8DcLptwaptRhpdA4wYd9q', 'user', '2025-11-21 12:06:19'),
(6, 'Tâm Phú', 'phu@gmail.com', '$2y$10$5lpLDkdAKEX7ljsd9o6rdehwjA8loaueTs8Oc9QcZC9r1iTOsCsda', 'user', '2025-11-23 14:14:38'),
(7, 'Admin', 'admin@gmail.com', '$2y$10$S/x1cl2FmEZx229MOvGfA.blF3UoOO4v4iD3xZF1vm07TGNAkqCBK', 'admin', '2025-11-23 16:35:23');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `voucher`
--

CREATE TABLE `voucher` (
  `id` int(11) NOT NULL,
  `noi_dung` varchar(255) NOT NULL,
  `mo_ta` text DEFAULT NULL,
  `han_su_dung` date NOT NULL,
  `giam_gia` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `voucher`
--

INSERT INTO `voucher` (`id`, `noi_dung`, `mo_ta`, `han_su_dung`, `giam_gia`) VALUES
(1, 'GIAM10K', 'Giảm giá 10,000 VND cho đơn đặt vé bất kỳ', '2025-12-31', '10000'),
(2, 'GIAM20K', 'Giảm giá 20,000 VND cho đơn đặt vé trên 100,000 VND', '2025-12-31', '20000'),
(3, 'GIAM30K', 'Giảm giá 30,000 VND cho đơn đặt vé trên 150,000 VND', '2025-12-31', '30000'),
(4, 'GIAM40K', 'Giảm giá 40,000 VND cho đơn đặt vé trên 200,000 VND', '2025-12-31', '40000'),
(5, 'GIAM50K', 'Giảm giá 50,000 VND cho đơn đặt vé trên 250,000 VND', '2025-12-31', '50000'),
(6, 'SALE10', 'Giảm 10% cho mọi loại vé', '2025-12-31', '10%'),
(7, 'SALE15', 'Giảm 15% cho vé xem phim 2D hoặc 3D', '2025-12-31', '15%'),
(8, 'SALE20', 'Giảm 20% cho vé đôi hoặc vé combo', '2025-12-31', '20%'),
(9, 'SALE30', 'Giảm 30% cho hóa đơn trên 300,000 VND', '2025-12-31', '30%'),
(10, 'SALE50', 'Giảm 50% cho hóa đơn trên 500,000 VND (voucher cao nhất)', '2025-12-31', '50%');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `showtime_id` (`showtime_id`);

--
-- Chỉ mục cho bảng `booking_seats`
--
ALTER TABLE `booking_seats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_id` (`booking_id`),
  ADD KEY `seat_id` (`seat_id`);

--
-- Chỉ mục cho bảng `movies`
--
ALTER TABLE `movies`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `seats`
--
ALTER TABLE `seats`
  ADD PRIMARY KEY (`id`),
  ADD KEY `room_id` (`room_id`);

--
-- Chỉ mục cho bảng `showtimes`
--
ALTER TABLE `showtimes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `movie_id` (`movie_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Chỉ mục cho bảng `voucher`
--
ALTER TABLE `voucher`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `booking_seats`
--
ALTER TABLE `booking_seats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `movies`
--
ALTER TABLE `movies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `rooms`
--
ALTER TABLE `rooms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `seats`
--
ALTER TABLE `seats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=121;

--
-- AUTO_INCREMENT cho bảng `showtimes`
--
ALTER TABLE `showtimes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=178;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `voucher`
--
ALTER TABLE `voucher`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`showtime_id`) REFERENCES `showtimes` (`id`);

--
-- Các ràng buộc cho bảng `booking_seats`
--
ALTER TABLE `booking_seats`
  ADD CONSTRAINT `booking_seats_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `booking_seats_ibfk_2` FOREIGN KEY (`seat_id`) REFERENCES `seats` (`id`);

--
-- Các ràng buộc cho bảng `seats`
--
ALTER TABLE `seats`
  ADD CONSTRAINT `seats_ibfk_1` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`);

--
-- Các ràng buộc cho bảng `showtimes`
--
ALTER TABLE `showtimes`
  ADD CONSTRAINT `showtimes_ibfk_1` FOREIGN KEY (`movie_id`) REFERENCES `movies` (`id`),
  ADD CONSTRAINT `showtimes_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
