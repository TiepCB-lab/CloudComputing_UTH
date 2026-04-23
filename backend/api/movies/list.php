<?php
header("Access-Control-Allow-Origin: http://localhost");
header("Content-Type: application/json; charset=UTF-8");

include_once "../../config/database.php";
include_once "../../model/movie.php";

$database = new Database();
$db = $database->getConnection();
$movie = new Movie($db);

// Lọc theo loại (new/trending)
$type = isset($_GET['type']) ? $_GET['type'] : null;

$stmt = $movie->read($type);
$num = $stmt->rowCount();

$movies_arr = [];
if ($num > 0) {
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);
        $movie_item = [
            "id" => $id,
            "title" => $title,
            "description" => $description,
            "imageUrl" => $poster, // Frontend dùng key imageUrl
            "bannerUrl" => $banner,
            "trailerUrl" => $trailer_url,
            "duration" => $duration . " phút",
            "release_date" => $release_date,
            "rating" => $rating,
            "genre" => $category
        ];
        array_push($movies_arr, $movie_item);
    }
}
echo json_encode($movies_arr);
?>