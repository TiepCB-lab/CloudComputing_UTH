<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Credentials: true");

include_once "../auth/check_admin.php";
include_once "../../config/database.php";

$db = (new Database())->getConnection();
$data = json_decode(file_get_contents("php://input"));

if(
    !empty($data->movie_id) && 
    !empty($data->room_id) && 
    !empty($data->show_date) && 
    !empty($data->show_time)
) {
    // Kiểm tra trùng lịch (Cơ bản: Cùng phòng, cùng giờ)
    // Logic thực tế cần phức tạp hơn (cộng thời lượng phim), nhưng ở mức cơ bản thì check exact match là ổn
    $checkQuery = "SELECT id FROM showtimes WHERE room_id = ? AND show_date = ? AND show_time = ?";
    $stmtCheck = $db->prepare($checkQuery);
    $stmtCheck->execute([$data->room_id, $data->show_date, $data->show_time]);
    
    if($stmtCheck->rowCount() > 0) {
        http_response_code(409);
        echo json_encode(["message" => "Phòng này đã có suất chiếu vào giờ đó!"]);
        exit;
    }

    $query = "INSERT INTO showtimes (movie_id, room_id, show_date, show_time, price) VALUES (?, ?, ?, ?, ?)";
    $stmt = $db->prepare($query);
    $price = !empty($data->price) ? $data->price : 75000;

    if($stmt->execute([$data->movie_id, $data->room_id, $data->show_date, $data->show_time, $price])) {
        http_response_code(201);
        echo json_encode(["message" => "Thêm suất chiếu thành công!"]);
    } else {
        http_response_code(503);
        echo json_encode(["message" => "Lỗi hệ thống."]);
    }
} else {
    http_response_code(400);
    echo json_encode(["message" => "Thiếu dữ liệu."]);
}
?>