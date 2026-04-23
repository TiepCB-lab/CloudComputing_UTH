<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Credentials: true");

include_once "../auth/check_admin.php"; // Chỉ admin mới xem được
include_once "../../config/database.php";

$db = (new Database())->getConnection();

// 1. Tổng doanh thu
$stmt = $db->query("SELECT SUM(total_amount) as revenue FROM bookings WHERE status = 'success'");
$revenue = $stmt->fetch(PDO::FETCH_ASSOC)['revenue'] ?? 0;

// 2. Tổng vé bán ra
$stmt = $db->query("SELECT COUNT(*) as total_tickets FROM bookings WHERE status = 'success'");
$tickets = $stmt->fetch(PDO::FETCH_ASSOC)['total_tickets'] ?? 0;

// 3. Tổng số phim đang chiếu
$stmt = $db->query("SELECT COUNT(*) as total_movies FROM movies");
$movies = $stmt->fetch(PDO::FETCH_ASSOC)['total_movies'] ?? 0;

// 4. Top 5 phim doanh thu cao nhất
$query = "
    SELECT m.title, SUM(b.total_amount) as total
    FROM bookings b
    JOIN showtimes s ON b.showtime_id = s.id
    JOIN movies m ON s.movie_id = m.id
    WHERE b.status = 'success'
    GROUP BY m.id
    ORDER BY total DESC
    LIMIT 5
";
$stmt = $db->prepare($query);
$stmt->execute();
$top_movies = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode([
    "revenue" => $revenue,
    "tickets" => $tickets,
    "total_movies" => $movies,
    "top_movies" => $top_movies
]);
?>