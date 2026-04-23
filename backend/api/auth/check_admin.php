<?php
// File này dùng để include vào đầu các API cần quyền Admin
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

if (!isset($_SESSION['user_id']) || !isset($_SESSION['role']) || $_SESSION['role'] !== 'admin') {
    http_response_code(403); // Forbidden
    echo json_encode(["message" => "Truy cập bị từ chối. Bạn không phải Admin."]);
    exit;
}
?>