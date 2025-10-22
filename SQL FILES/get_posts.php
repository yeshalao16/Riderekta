<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

include 'db_connect.php';

$result = $conn->query("SELECT * FROM posts ORDER BY created_at DESC");

$posts = [];
while ($row = $result->fetch_assoc()) {
    $posts[] = $row;
}

echo json_encode([
    "success" => true,
    "posts" => $posts
]);

$conn->close();
?>
