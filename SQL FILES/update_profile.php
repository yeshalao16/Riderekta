<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $email = $_POST['email'] ?? '';
    $mobile = $_POST['mobile'] ?? '';
    $password = $_POST['password'] ?? '';

    // Check if the user exists
    $checkUser = $conn->prepare("SELECT * FROM users WHERE email = ?");
    $checkUser->bind_param("s", $email);
    $checkUser->execute();
    $result = $checkUser->get_result();

    if ($result->num_rows === 0) {
        echo json_encode(["success" => false, "message" => "User not found"]);
        exit;
    }

    // Update user info
    $update = $conn->prepare("UPDATE users SET mobile = ?, password = ? WHERE email = ?");
    $update->bind_param("sss", $mobile, $password, $email);

    if ($update->execute()) {
        echo json_encode(["success" => true, "message" => "Profile updated successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Failed to update profile"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request"]);
}
?>
