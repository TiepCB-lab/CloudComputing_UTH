<?php
session_start();
require_once "../../config/database.php";

$user_id = $_SESSION['user_id'];
$booking_id = $_GET['id'];

$stmt = $conn->prepare("SELECT * FROM bookings WHERE id = ? AND user_id = ?");
$stmt->bind_param("ii", $booking_id, $user_id);
$stmt->execute();
$result = $stmt->get_result();

echo json_encode($result->fetch_assoc());
