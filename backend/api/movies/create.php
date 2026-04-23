<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once "../../config/database.php";
include_once "../../model/movie.php";

$database = new Database();
$db = $database->getConnection();
$movie = new Movie($db);

$data = json_decode(file_get_contents("php://input"));

if (
    !empty($data->title) &&
    !empty($data->poster)
) {
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

    if ($movie->create()) {
        http_response_code(201);
        echo json_encode(["message" => "Phim đã được tạo."]);
    } else {
        http_response_code(503);
        echo json_encode(["message" => "Không thể tạo phim."]);
    }
} else {
    http_response_code(400);
    echo json_encode(["message" => "Dữ liệu không đầy đủ."]);
}
?>