<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Credentials: true");

include_once "../auth/check_admin.php";
include_once "../../config/database.php";

$db = (new Database())->getConnection();

// Lấy danh sách user và thống kê chi tiêu
$query = "
    SELECT 
        u.id, 
        u.username, 
        u.email, 
        u.role,
        COUNT(b.id) as total_bookings,
        COALESCE(SUM(b.total_amount), 0) as total_spent
    FROM users u
    LEFT JOIN bookings b ON u.id = b.user_id AND b.status = 'success'
    WHERE u.role = 'user' 
    GROUP BY u.id
    ORDER BY total_spent DESC
";

$stmt = $db->prepare($query);
$stmt->execute();
$users = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($users);
?>