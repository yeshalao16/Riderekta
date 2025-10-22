<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'db_connect.php';

$sql = "SELECT c.id, c.name, c.surname, c.email, c.message, c.created_at, u.id AS user_id
        FROM contact_messages c
        LEFT JOIN users u ON c.user_id = u.id
        ORDER BY c.created_at DESC";

$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $contacts = [];
    while ($row = $result->fetch_assoc()) {
        $contacts[] = $row;
    }
    echo json_encode(["success" => true, "contacts" => $contacts]);
} else {
    echo json_encode(["success" => false, "message" => "No contact messages found."]);
}

$conn->close();
?>
