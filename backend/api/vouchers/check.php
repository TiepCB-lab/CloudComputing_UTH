<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");

include_once "../../config/database.php";
include_once "../../model/voucher.php";

$database = new Database();
$db = $database->getConnection();

$voucher = new Voucher($db);

// Lấy mã từ URL (VD: check.php?code=GIAM10K)
$code = isset($_GET['code']) ? $_GET['code'] : "";

if(!empty($code)) {
    $stmt = $voucher->checkValid($code);
    
    if($stmt->rowCount() > 0) {
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        
        // Xử lý giá trị giảm giá (Số tiền hoặc Phần trăm)
        $discount_value = $row['giam_gia'];
        $is_percent = false;

        // Nếu chuỗi chứa dấu %, ví dụ "10%"
        if (strpos($discount_value, '%') !== false) {
            $is_percent = true;
            $discount_value = (float)str_replace('%', '', $discount_value);
        } else {
            // Nếu là số tiền cố định, ví dụ "10000"
            $discount_value = (int)$discount_value;
        }

        echo json_encode([
            "valid" => true,
            "message" => "Áp dụng mã thành công!",
            "discount_value" => $discount_value,
            "is_percent" => $is_percent,
            "desc" => $row['mo_ta']
        ]);
    } else {
        echo json_encode([
            "valid" => false, 
            "message" => "Mã không tồn tại hoặc đã hết hạn."
        ]);
    }
} else {
    echo json_encode(["valid" => false, "message" => "Vui lòng nhập mã."]);
}
?>