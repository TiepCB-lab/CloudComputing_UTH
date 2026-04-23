<?php
class User {
  private $conn;
  private $table_name = "users";

  public $id;
  public $username;
  public $email;
  public $password_hash;
  public $role;

  public function __construct($db) {
    $this->conn = $db;
  }

  // Tìm user theo email
  public function findByEmail($email) {
    $query = "SELECT * FROM " . $this->table_name . " WHERE email = :email LIMIT 1";
    $stmt = $this->conn->prepare($query);
    $stmt->bindParam(":email", $email);
    $stmt->execute();
    return $stmt;
  }

  // Thêm user mới
  public function register() {
    $query = "INSERT INTO " . $this->table_name . " (username, email, password_hash) VALUES (:username, :email, :password)";
    $stmt = $this->conn->prepare($query);
    $stmt->bindParam(":username", $this->username);
    $stmt->bindParam(":email", $this->email);
    $stmt->bindParam(":password", $this->password_hash);
    return $stmt->execute();
  }

  public function findById($id) {
    $query = "SELECT id, username, email, role FROM " . $this->table_name . " WHERE id = :id LIMIT 1";
    $stmt = $this->conn->prepare($query);
    $stmt->bindParam(":id", $id);
    $stmt->execute();
    return $stmt;
  }
}
?>
