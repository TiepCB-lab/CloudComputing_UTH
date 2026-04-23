<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Credentials: true");

include_once "../auth/check_admin.php";
include_once "../../config/database.php";

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));

if(!empty($data->id)) {
    $query = "DELETE FROM showtimes WHERE id = ?";
    $stmt = $db->prepare($query);
    if($stmt->execute([$data->id])) {
        echo json_encode(["message" => "Đã xóa suất chiếu."]);
    } else {
        http_response_code(503);
        echo json_encode(["message" => "Lỗi khi xóa."]);
    }
}
?>