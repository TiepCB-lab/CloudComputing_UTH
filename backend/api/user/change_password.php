<?php
session_start();

header("Access-Control-Allow-Origin: http://localhost");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER["REQUEST_METHOD"] === "OPTIONS") {
    http_response_code(200);
    exit;
}

if (!isset($_SESSION["user_id"])) {
    http_response_code(401);
    echo json_encode(["success" => false, "message" => "Chưa đăng nhập"]);
    exit;
}

require_once "../../config/database.php";
$database = new Database();
$db = $database->getConnection();

$data = json_decode(file_get_contents("php://input"));

$old = $data->old ?? "";
$new = $data->new ?? "";

if (empty($old) || empty($new)) {
    echo json_encode(["success" => false, "message" => "Vui lòng nhập đầy đủ thông tin"]);
    exit;
}

// 1. Lấy mật khẩu cũ từ DB
$query = "SELECT password_hash FROM users WHERE id = :id";
$stmt = $db->prepare($query);
$stmt->bindParam(":id", $_SESSION["user_id"]);
$stmt->execute();

$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    echo json_encode(["success" => false, "message" => "Không tìm thấy người dùng"]);
    exit;
}

// 2. Kiểm tra mật khẩu cũ
if (!password_verify($old, $user["password_hash"])) {
    echo json_encode(["success" => false, "message" => "Mật khẩu cũ không đúng"]);
    exit;
}

// 3. Hash mật khẩu mới
$newHash = password_hash($new, PASSWORD_DEFAULT);

// 4. Update DB
$update = "UPDATE users SET password_hash = :newHash WHERE id = :id";
$stmt = $db->prepare($update);
$stmt->bindParam(":newHash", $newHash);
$stmt->bindParam(":id", $_SESSION["user_id"]);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Đổi mật khẩu thành công"]);
} else {
    echo json_encode(["success" => false, "message" => "Lỗi server"]);
}
