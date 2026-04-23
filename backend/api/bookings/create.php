<?php
// Cấu hình Session & Headers
session_set_cookie_params([
    'lifetime' => 0, 'path' => '/', 'secure' => false, 'httponly' => true, 'samesite' => 'Lax'
]);
session_start();

header("Access-Control-Allow-Origin: http://localhost");
header("Access-Control-Allow-Credentials: true");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, OPTIONS");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(200); exit; }

include_once "../../config/database.php";

// 1. Kiểm tra đăng nhập
if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(["message" => "Vui lòng đăng nhập để đặt vé!"]);
    exit;
}

// 2. Nhận dữ liệu JSON từ Frontend
$data = json_decode(file_get_contents("php://input"));

// Validate dữ liệu
if (empty($data->showtime_id) || empty($data->seats) || !is_array($data->seats)) {
    http_response_code(400);
    echo json_encode(["message" => "Dữ liệu vé không hợp lệ."]);
    exit;
}

$db = (new Database())->getConnection();

try {
    $db->beginTransaction();

    // 3. Kiểm tra ghế trùng (Logic cũ - giữ nguyên để an toàn)
    $placeholders = implode(',', array_fill(0, count($data->seats), '?'));
    $checkSql = "SELECT bs.seat_id 
                 FROM booking_seats bs
                 JOIN bookings b ON bs.booking_id = b.id
                 WHERE b.showtime_id = ? 
                 AND bs.seat_id IN ($placeholders)
                 AND b.status IN ('success', 'pending')";
    $checkStmt = $db->prepare($checkSql);
    $params = array_merge([$data->showtime_id], $data->seats);
    $checkStmt->execute($params);

    if ($checkStmt->rowCount() > 0) {
        throw new Exception("Ghế bạn chọn vừa có người khác đặt. Vui lòng chọn lại.");
    }

    // 4. ⭐ LẤY THÔNG TIN PHIM VÀ PHÒNG CHIẾU TỪ SHOWTIME_ID ⭐
    // (Để lưu cứng vào lịch sử, sau này in vé không cần join bảng)
    $infoSql = "SELECT m.title as movie_title, r.name as room_name 
                FROM showtimes s
                JOIN movies m ON s.movie_id = m.id
                JOIN rooms r ON s.room_id = r.id
                WHERE s.id = ? LIMIT 1";
    $infoStmt = $db->prepare($infoSql);
    $infoStmt->execute([$data->showtime_id]);
    $showInfo = $infoStmt->fetch(PDO::FETCH_ASSOC);

    if (!$showInfo) {
        throw new Exception("Suất chiếu không tồn tại.");
    }

    // Tạo mã đơn hàng ngẫu nhiên (VD: CGV837291)
    $booking_code = 'GF' . rand(100000, 999999);
    
    // Lấy chuỗi ghế từ frontend gửi lên (VD: "A1, A2") hoặc để trống
    $seat_list_str = isset($data->seat_labels) ? $data->seat_labels : "Đang cập nhật";

    // Lấy voucher
    $voucher_code = isset($data->voucher_code) ? $data->voucher_code : null;
    $discount_amount = isset($data->discount_amount) ? $data->discount_amount : 0;

    // 5. ⭐ INSERT VÀO BOOKINGS VỚI ĐẦY ĐỦ THÔNG TIN ⭐
    $sql = "INSERT INTO bookings 
            (user_id, booking_code, movie_title, cinema_room, seat_list, showtime_id, customer_name, customer_phone, total_amount, voucher_code, discount_amount, status) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'success')";

    $stmt = $db->prepare($sql);
    $stmt->execute([
        $_SESSION['user_id'],
        $booking_code,
        $showInfo['movie_title'], // Tên phim
        $showInfo['room_name'],   // Tên phòng
        $seat_list_str,           // Danh sách ghế (VD: A1, A2)
        $data->showtime_id,
        $data->customer_name ?? 'Khách hàng',
        $data->customer_phone ?? '',
        $data->total_amount,
        $voucher_code,
        $discount_amount
    ]);
    
    $booking_id = $db->lastInsertId();

    // 6. Lưu chi tiết ghế (ID) vào bảng phụ booking_seats (để check trùng ghế)
    $stmtSeat = $db->prepare("INSERT INTO booking_seats (booking_id, seat_id) VALUES (?, ?)");
    foreach ($data->seats as $seat_id) {
        $stmtSeat->execute([$booking_id, $seat_id]);
    }

    $db->commit();

    http_response_code(201);
    echo json_encode([
        "message" => "Đặt vé thành công!", 
        "booking_id" => $booking_id,
        "booking_code" => $booking_code
    ]);

} catch (Exception $e) {
    $db->rollBack();
    http_response_code(500);
    echo json_encode(["message" => "Lỗi: " . $e->getMessage()]);
}
?>