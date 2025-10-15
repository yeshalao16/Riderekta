<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");

include 'db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data["id"]) && isset($data["reply"])) {
    $id = intval($data["id"]);
    $reply = $conn->real_escape_string($data["reply"]);

    $sql = "UPDATE contact_messages SET reply = '$reply' WHERE id = $id";

    if ($conn->query($sql)) {
        echo json_encode(["success" => true, "message" => "Reply sent successfully!"]);
    } else {
        echo json_encode(["success" => false, "message" => "Failed to send reply."]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request data."]);
}

$conn->close();
?>
