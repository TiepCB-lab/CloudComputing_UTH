<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../config/database.php";
include_once "../../model/showtime.php";

$database = new Database();
$db = $database->getConnection();
$showtime = new Showtime($db);

$movie_id = isset($_GET['movie_id']) ? $_GET['movie_id'] : die();
$date = isset($_GET['date']) ? $_GET['date'] : date('Y-m-d');

$stmt = $showtime->readByMovie($movie_id, $date);
$showtimes_arr = [];

while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    extract($row);
    // Format giờ cho đẹp (bỏ giây)
    $time_formatted = date('H:i', strtotime($show_time));
    
    $showtimes_arr[] = [
        "id" => $id,
        "show_date" => $show_date,
        "show_time" => $time_formatted,
        "price" => $price,
        "room" => $room_name
    ];
}
echo json_encode($showtimes_arr);
?>