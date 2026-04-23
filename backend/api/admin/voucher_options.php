<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Credentials: true");

include_once "../auth/check_admin.php";
include_once "../../config/database.php";

$db = (new Database())->getConnection();

// Lấy voucher còn hạn sử dụng
$query = "SELECT id, noi_dung, mo_ta, giam_gia FROM voucher WHERE han_su_dung >= CURDATE()";
$stmt = $db->prepare($query);
$stmt->execute();
$vouchers = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($vouchers);
?>