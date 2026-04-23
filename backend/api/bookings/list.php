<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Access-Control-Allow-Credentials: true");
header("Content-Type: application/json; charset=UTF-8");

session_set_cookie_params(['lifetime' => 0, 'path' => '/', 'secure' => false, 'httponly' => true, 'samesite' => 'Lax']);
session_start();

include_once "../../config/database.php";

if (!isset($_SESSION['user_id'])) {
    echo json_encode([]); 
    exit;
}

$db = (new Database())->getConnection();

// Query mới: Lấy thông tin trực tiếp từ bảng bookings
$query = "
    SELECT 
        b.id,
        b.booking_code,
        b.movie_title,
        b.cinema_room,
        b.seat_list,
        b.total_amount,
        b.status,
        b.created_at,
        s.show_time,
        s.show_date
    FROM bookings b
    JOIN showtimes s ON b.showtime_id = s.id
    WHERE b.user_id = ?
    ORDER BY b.created_at DESC
";

$stmt = $db->prepare($query);
$stmt->execute([$_SESSION['user_id']]);

$history = [];
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    $history[] = [
        "id" => $row['id'],
        "booking_code" => $row['booking_code'] ? $row['booking_code'] : ('CGV' . $row['id']),
        "movie_title" => $row['movie_title'],
        "cinema_room" => $row['cinema_room'],
        "seats" => $row['seat_list'],
        "show_time" => date('H:i d/m/Y', strtotime($row['show_date'] . ' ' . $row['show_time'])),
        "created_at" => date('d/m/Y', strtotime($row['created_at'])),
        "total" => number_format($row['total_amount'], 0, ',', '.') . " đ",
        "status" => $row['status']
    ];
}

echo json_encode($history);
?>