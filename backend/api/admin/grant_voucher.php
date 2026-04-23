<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Credentials: true");

include_once "../auth/check_admin.php";
include_once "../../config/database.php";

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));

// Kiểm tra dữ liệu: user_id và mảng voucher_ids
if (!empty($data->user_id) && !empty($data->voucher_ids) && is_array($data->voucher_ids)) {
    
    $successCount = 0;
    $alreadyOwnedCount = 0;

    // Chuẩn bị câu lệnh Insert
    $insertQuery = "INSERT INTO user_vouchers (user_id, voucher_id) VALUES (?, ?)";
    $stmtInsert = $db->prepare($insertQuery);

    // Chuẩn bị câu lệnh Check (tránh tặng trùng)
    $checkQuery = "SELECT id FROM user_vouchers WHERE user_id = ? AND voucher_id = ? AND is_used = 0";
    $stmtCheck = $db->prepare($checkQuery);

    foreach ($data->voucher_ids as $vId) {
        // 1. Kiểm tra xem khách đã có voucher này chưa
        $stmtCheck->execute([$data->user_id, $vId]);
        
        if ($stmtCheck->rowCount() > 0) {
            $alreadyOwnedCount++;
            continue; // Bỏ qua, sang voucher tiếp theo
        }

        // 2. Thực hiện tặng
        if ($stmtInsert->execute([$data->user_id, $vId])) {
            $successCount++;
        }
    }

    if ($successCount > 0) {
        $msg = "Đã tặng thành công $successCount voucher!";
        if ($alreadyOwnedCount > 0) {
            $msg .= " (Bỏ qua $alreadyOwnedCount voucher khách đã có).";
        }
        echo json_encode(["message" => $msg]);
    } else {
        if ($alreadyOwnedCount > 0) {
            http_response_code(409);
            echo json_encode(["message" => "Khách hàng đã sở hữu tất cả các voucher bạn chọn!"]);
        } else {
            http_response_code(503);
            echo json_encode(["message" => "Lỗi hệ thống, không thể tặng."]);
        }
    }

} else {
    http_response_code(400);
    echo json_encode(["message" => "Dữ liệu không hợp lệ. Vui lòng chọn ít nhất 1 voucher."]);
}
?>