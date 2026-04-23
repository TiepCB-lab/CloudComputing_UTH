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
    echo json_encode(["message" => "Chưa đăng nhập"]);
    exit;
}

require_once "../../config/database.php";
$database = new Database();
$db = $database->getConnection();

$data = json_decode(file_get_contents("php://input"));

$newUsername = trim($data->username ?? "");
$newPhone = trim($data->phone ?? "");
$newDob = trim($data->dob ?? "");

// Convert dob nếu có
if (!empty($newDob)) {
    $newDob = date('Y-m-d', strtotime($newDob));
}

// --- LẤY THÔNG TIN HIỆN TẠI CỦA USER ---
$query = "SELECT username, phone, dob FROM users WHERE id = :id";
$stmt = $db->prepare($query);
$stmt->bindParam(":id", $_SESSION["user_id"]);
$stmt->execute();
$current = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$current) {
    echo json_encode(["success" => false, "message" => "User không tồn tại"]);
    exit;
}

// Nếu input trống thì giữ nguyên giá trị cũ
if ($newUsername === "") $newUsername = $current["username"];
if ($newPhone === "") $newPhone = $current["phone"];
if ($newDob === "" || $newDob === null) $newDob = $current["dob"];

// --- UPDATE ---
$updateQuery = "UPDATE users 
                SET username = :username, phone = :phone, dob = :dob
                WHERE id = :id";

$updateStmt = $db->prepare($updateQuery);
$updateStmt->bindParam(":username", $newUsername);
$updateStmt->bindParam(":phone", $newPhone);
$updateStmt->bindParam(":dob", $newDob);
$updateStmt->bindParam(":id", $_SESSION["user_id"]);

if ($updateStmt->execute()) {
    echo json_encode(["success" => true, "message" => "Cập nhật thành công"]);
} else {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Lỗi server"]);
}
