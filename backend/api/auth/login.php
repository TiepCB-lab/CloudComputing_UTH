<?php

// ⭐ FIX QUAN TRỌNG: CHO PHÉP COOKIE HOẠT ĐỘNG VỚI FETCH() + CREDENTIALS
session_set_cookie_params([
    'lifetime' => 0,
    'path' => '/',
    // 'domain' => 'localhost',  <-- XÓA HOẶC COMMENT DÒNG NÀY ĐI
    'secure' => false,
    'httponly' => true,
    'samesite' => 'Lax'
]);
session_start();

// ⭐ CORS CHUẨN CHO SESSION
header("Access-Control-Allow-Origin: http://localhost");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");

// XỬ LÝ OPTIONS (browser gửi trước mỗi POST có credentials)
if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(200);
    exit;
}

include_once "../../config/database.php";
include_once "../../model/user.php";

$database = new Database();
$db = $database->getConnection();
$user = new User($db);

$data = json_decode(file_get_contents("php://input"));

if (empty($data->email) || empty($data->password)) {
    http_response_code(400);
    echo json_encode(["message" => "Thiếu thông tin đăng nhập."]);
    exit;
}

// Tìm user
$stmt = $user->findByEmail($data->email);
if ($stmt->rowCount() == 0) {
    http_response_code(401);
    echo json_encode(["message" => "Email không tồn tại."]);
    exit;
}

$row = $stmt->fetch(PDO::FETCH_ASSOC);

// Kiểm mật khẩu
if (password_verify($data->password, $row['password_hash'])) {

    $_SESSION['user_id'] = $row['id'];
    $_SESSION['role'] = $row['role'];

    http_response_code(200);
    echo json_encode([
        "message" => "Đăng nhập thành công!",
        "user" => [
            "id" => $row['id'],
            "username" => $row['username'],
            "email" => $row['email'],
            "role" => $row['role']
        ]
    ]);

} else {
    http_response_code(401);
    echo json_encode(["message" => "Sai mật khẩu."]);
}
?>
