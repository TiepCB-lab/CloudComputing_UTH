<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST"); // Dùng POST hoặc DELETE
header("Access-Control-Allow-Credentials: true");

// 1. Kiểm tra quyền Admin trước
include_once "../auth/check_admin.php"; 

include_once "../../config/database.php";
include_once "../../model/movie.php";

$database = new Database();
$db = $database->getConnection();

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->id)) {
    // Logic xóa phim (Bạn cần thêm hàm delete vào model Movie)
    $query = "DELETE FROM movies WHERE id = :id";
    $stmt = $db->prepare($query);
    $stmt->bindParam(':id', $data->id);

    if($stmt->execute()) {
        echo json_encode(["message" => "Đã xóa phim thành công."]);
    } else {
        http_response_code(503);
        echo json_encode(["message" => "Lỗi khi xóa phim."]);
    }
} else {
    http_response_code(400);
    echo json_encode(["message" => "Thiếu ID phim."]);
}
?>