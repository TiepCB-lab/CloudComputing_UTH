<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST"); // Hoặc PUT
header("Access-Control-Allow-Credentials: true");

// 1. Check quyền Admin
include_once "../auth/check_admin.php";

include_once "../../config/database.php";
include_once "../../model/movie.php";

$database = new Database();
$db = $database->getConnection();
$movie = new Movie($db);

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->id) && !empty($data->title)) {
    // Gán dữ liệu
    $movie->id = $data->id;
    $movie->title = $data->title;
    $movie->description = $data->description;
    $movie->poster = $data->poster;
    $movie->banner = $data->banner;
    $movie->trailer_url = $data->trailer_url;
    $movie->release_date = $data->release_date;
    $movie->duration = $data->duration;
    $movie->category = $data->category;
    $movie->rating = $data->rating;
    $movie->is_trending = $data->is_trending ?? 0;
    $movie->is_new = $data->is_new ?? 0;
    $movie->director = $data->director ?? '';
    $movie->cast = $data->cast ?? '';

    if ($movie->update()) {
        echo json_encode(["message" => "Cập nhật phim thành công."]);
    } else {
        http_response_code(503);
        echo json_encode(["message" => "Lỗi khi cập nhật phim."]);
    }
} else {
    http_response_code(400);
    echo json_encode(["message" => "Thiếu dữ liệu."]);
}
?>