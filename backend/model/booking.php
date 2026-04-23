<?php
class Booking {
    private $conn;
    private $table = "bookings";

    public $id;
    public $user_id;
    public $movie_id;
    public $showtime_id;
    public $seat;
    public $status;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Create booking
    public function create() {
        $query = "INSERT INTO " . $this->table . " 
                  (user_id, movie_id, showtime_id, seat, status)
                  VALUES (?, ?, ?, ?, 'pending')";

        $stmt = $this->conn->prepare($query);
        $stmt->bind_param("iiis",
            $this->user_id,
            $this->movie_id,
            $this->showtime_id,
            $this->seat
        );

        if ($stmt->execute()) {
            $this->id = $stmt->insert_id;
            return true;
        }

        return false;
    }
}
