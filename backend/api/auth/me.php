<?php

session_set_cookie_params([
    'lifetime' => 0, 'path' => '/', 'secure' => false,
    'httponly' => true, 'samesite' => 'Lax'
]);
session_start();

header("Access-Control-Allow-Origin: http://localhost");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(200);
    exit;
}

if (!isset($_SESSION['user_id'])) {
    http_response_code(401);
    echo json_encode(["message" => "Chưa đăng nhập."]);
    exit;
}

// *** CẬP NHẬT LOGIC ***
// Lấy thông tin chi tiết của user
include_once "../../config/database.php";
include_once "../../model/user.php";

$database = new Database();
$db = $database->getConnection();
$user = new User($db);

$stmt = $user->findById($_SESSION['user_id']);
if ($stmt->rowCount() > 0) {
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    http_response_code(200);
    // Trả về đầy đủ thông tin user
    echo json_encode([
        "id" => $row['id'],
        "username" => $row['username'],
        "email" => $row['email'],
        "role" => $row['role']
    ]);
} else {
    // Lỗi: có session nhưng không tìm thấy user
    http_response_code(404);
    echo json_encode(["message" => "Không tìm thấy người dùng."]);
}
?>