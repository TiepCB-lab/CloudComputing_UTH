<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Access-Control-Allow-Credentials: true");
header("Content-Type: application/json; charset=UTF-8");


include_once "../../config/database.php";
include_once "../../model/user.php";

$database = new Database();
$db = $database->getConnection();
$user = new User($db);

// Lấy dữ liệu JSON từ body request
$data = json_decode(file_get_contents("php://input"));

// Kiểm tra dữ liệu
if (empty($data->username) || empty($data->email) || empty($data->password)) {
  http_response_code(400);
  echo json_encode(["message" => "Thiếu dữ liệu."]);
  exit;
}

// Kiểm tra email đã tồn tại chưa
$check = $user->findByEmail($data->email);
if ($check->rowCount() > 0) {
  http_response_code(409);
  echo json_encode(["message" => "Email đã được sử dụng."]);
  exit;
}

// Tạo user mới
$user->username = htmlspecialchars(strip_tags($data->username));
$user->email = htmlspecialchars(strip_tags($data->email));
$user->password_hash = password_hash($data->password, PASSWORD_DEFAULT);

if ($user->register()) {
  http_response_code(201);
  echo json_encode(["message" => "Đăng ký thành công!"]);
} else {
  http_response_code(500);
  echo json_encode(["message" => "Lỗi khi tạo tài khoản."]);
}
?>
