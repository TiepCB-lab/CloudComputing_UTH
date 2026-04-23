<?php
session_start();

header("Access-Control-Allow-Origin: http://localhost");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: DELETE, OPTIONS");
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

$query = "DELETE FROM users WHERE id = :id";
$stmt = $db->prepare($query);
$stmt->bindParam(":id", $_SESSION["user_id"]);

if ($stmt->execute()) {
    session_destroy();
    echo json_encode(["success" => true, "message" => "Xóa tài khoản thành công"]);
} else {
    http_response_code(500);
    echo json_encode(["success" => false, "message" => "Không thể xóa tài khoản"]);
}
