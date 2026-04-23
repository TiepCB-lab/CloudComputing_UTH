<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Credentials: true");

include_once "../auth/check_admin.php";
include_once "../../config/database.php";

$db = (new Database())->getConnection();

// Lấy danh sách suất chiếu sắp tới, kèm tên phim và tên phòng
$query = "
    SELECT s.id, s.show_date, s.show_time, s.price, 
           m.title as movie_title, 
           r.name as room_name
    FROM showtimes s
    JOIN movies m ON s.movie_id = m.id
    JOIN rooms r ON s.room_id = r.id
    ORDER BY s.show_date DESC, s.show_time ASC
";

$stmt = $db->prepare($query);
$stmt->execute();
$showtimes = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($showtimes);
?>