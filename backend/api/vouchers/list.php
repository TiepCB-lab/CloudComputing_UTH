<?php
// Cấu hình Session
session_set_cookie_params(['lifetime' => 0, 'path' => '/', 'secure' => false, 'httponly' => true, 'samesite' => 'Lax']);
session_start();

header("Access-Control-Allow-Origin: http://localhost");
header("Access-Control-Allow-Credentials: true");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../config/database.php";
$db = (new Database())->getConnection();

// Kiểm tra user đã đăng nhập chưa
$user_id = isset($_SESSION['user_id']) ? $_SESSION['user_id'] : 0;

if ($user_id == 0) {
    // Nếu chưa đăng nhập, trả về danh sách rỗng (không hiện gì)
    echo json_encode([]);
    exit;
}

// 1. Lấy danh sách các mã voucher mà User này ĐÃ DÙNG trong booking
// (Để kiểm tra trạng thái "Đã sử dụng")
$used_codes = [];
$check_query = "SELECT DISTINCT voucher_code FROM bookings WHERE user_id = ? AND status = 'success' AND voucher_code IS NOT NULL";
$stmt_check = $db->prepare($check_query);
$stmt_check->execute([$user_id]);
while ($row = $stmt_check->fetch(PDO::FETCH_ASSOC)) {
    $used_codes[] = $row['voucher_code'];
}

// 2. ⭐ LOGIC MỚI: Chỉ lấy Voucher nằm trong bảng user_vouchers
// Sử dụng INNER JOIN để lọc: Chỉ voucher nào có trong user_vouchers của user này mới được lấy ra
$query = "
    SELECT v.*, uv.is_used as gift_status
    FROM voucher v
    INNER JOIN user_vouchers uv ON v.id = uv.voucher_id
    WHERE uv.user_id = ?
    ORDER BY uv.granted_date DESC
";

$stmt = $db->prepare($query);
$stmt->execute([$user_id]);

$vouchers = [];
$today = date("Y-m-d");

while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $code = $row['noi_dung'];
    
    // Kiểm tra hết hạn
    $is_expired = ($row['han_su_dung'] < $today);
    
    // Kiểm tra đã dùng: 
    // 1. Có trong bảng bookings (đã đặt vé thành công)
    // 2. Hoặc trạng thái trong bảng user_vouchers đã set là dùng (nếu có logic update sau này)
    $is_used = in_array($code, $used_codes) || ($row['gift_status'] == 1);

    // Tính toán trạng thái hợp lệ
    $is_valid = (!$is_expired && !$is_used);

    $vouchers[] = [
        "code" => $code,
        "desc" => $row['mo_ta'],
        "discount" => $row['giam_gia'],
        "exp" => date("d/m/Y", strtotime($row['han_su_dung'])),
        "is_valid" => $is_valid,     // Để frontend biết hiển thị màu sắc
        "is_used" => $is_used,       // Để frontend hiện chữ "Đã sử dụng"
        "is_expired" => $is_expired  // Để frontend hiện chữ "Hết hạn"
    ];
}

echo json_encode($vouchers);
?>