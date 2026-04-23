<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../config/database.php";
include_once "../../model/movie.php";

$database = new Database();
$db = $database->getConnection();
$movie = new Movie($db);

$movie->id = isset($_GET['id']) ? $_GET['id'] : die();

$stmt = $movie->readSingle();

if ($stmt->rowCount() > 0) {
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    
    $movie_arr = [
        "id" => $row['id'],
        "title" => $row['title'],
        "description" => $row['description'],
        "imageUrl" => $row['poster'],
        "bannerUrl" => $row['banner'],
        "trailerUrl" => $row['trailer_url'],
        "year" => date('Y', strtotime($row['release_date'])),
        "duration" => $row['duration'] . " phút",
        "release_date" => $row['release_date'], // Trả về ngày gốc để điền vào form
        "rating" => $row['rating'],
        "genre" => $row['category'],
        
        // ⭐ QUAN TRỌNG: Thêm 2 dòng này để Frontend biết trạng thái ⭐
        "is_new" => $row['is_new'],
        "is_trending" => $row['is_trending'],

        // Kiểm tra nếu cột tồn tại (tránh lỗi nếu DB thiếu cột)
        "director" => isset($row['director']) ? $row['director'] : "",
        "cast" => isset($row['cast']) ? $row['cast'] : ""
    ];
    
    http_response_code(200);
    echo json_encode($movie_arr);
} else {
    http_response_code(404);
    echo json_encode(["message" => "Không tìm thấy phim."]);
}
?>