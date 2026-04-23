<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../config/database.php";

$db = (new Database())->getConnection();

// Lấy ID suất chiếu từ URL
$showtime_id = isset($_GET['id']) ? $_GET['id'] : 0;

// Query lấy tất cả ghế đã bán của suất này
$query = "SELECT bs.seat_id 
          FROM booking_seats bs
          JOIN bookings b ON bs.booking_id = b.id
          WHERE b.showtime_id = ? AND b.status = 'success'";

$stmt = $db->prepare($query);
$stmt->execute([$showtime_id]);

$booked_seats = [];
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $booked_seats[] = (int)$row['seat_id'];
}

echo json_encode($booked_seats);
?>