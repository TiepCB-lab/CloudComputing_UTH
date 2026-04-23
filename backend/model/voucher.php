<?php
class Voucher {
    private $conn;
    private $table = "voucher"; // Tên bảng trong SQL mới của bạn là 'voucher' (số ít)

    public $noi_dung; // Mã code (VD: GIAM10K)
    public $giam_gia; // Giá trị giảm (VD: 10000 hoặc 10%)
    public $han_su_dung;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Kiểm tra mã voucher có tồn tại và còn hạn không
    public function checkValid($code) {
        $query = "SELECT * FROM " . $this->table . " 
                  WHERE noi_dung = ? 
                  AND han_su_dung >= CURDATE() 
                  LIMIT 1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $code);
        $stmt->execute();

        return $stmt;
    }
}
?>