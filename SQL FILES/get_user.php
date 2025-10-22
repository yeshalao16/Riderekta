<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'] ?? '';

    $stmt = $conn->prepare("SELECT email, mobile, password FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        echo json_encode([
            "success" => true,
            "user" => $row
        ]);
    } else {
        echo json_encode(["success" => false, "message" => "User not found"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request"]);
}
?>
