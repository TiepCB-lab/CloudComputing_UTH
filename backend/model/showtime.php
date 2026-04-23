<?php
class Showtime {
    private $conn;
    private $table = "showtimes";

    public function __construct($db) {
        $this->conn = $db;
    }

    // Lấy suất chiếu theo phim và ngày
    public function readByMovie($movie_id, $date) {
        // Join bảng rooms để lấy tên phòng
        $query = "SELECT s.id, s.show_date, s.show_time, s.price, r.name as room_name 
                  FROM " . $this->table . " s
                  JOIN rooms r ON s.room_id = r.id
                  WHERE s.movie_id = ? AND s.show_date = ?
                  ORDER BY s.show_time ASC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $movie_id);
        $stmt->bindParam(2, $date);
        $stmt->execute();
        return $stmt;
    }

    // Lấy danh sách ID ghế đã được đặt của suất chiếu này
    public function getBookedSeats($showtime_id) {
        // Truy vấn từ bảng booking_seats kết hợp bookings
        // Chỉ lấy ghế của các vé có trạng thái 'pending' hoặc 'success'
        $query = "SELECT bs.seat_id 
                  FROM booking_seats bs
                  JOIN bookings b ON bs.booking_id = b.id
                  WHERE b.showtime_id = ? 
                  AND b.status IN ('pending', 'success')";
                  
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $showtime_id);
        $stmt->execute();
        return $stmt;
    }
}
?>