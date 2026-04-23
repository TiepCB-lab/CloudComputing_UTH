<?php
session_start();
header("Access-Control-Allow-Origin: http://localhost");
header("Access-Control-Allow-Credentials: true");
header("Content-Type: application/json; charset=UTF-8");

session_unset();
session_destroy();

echo json_encode(["message" => "Đã đăng xuất."]);
?>
