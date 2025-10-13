<?php
include 'db_connect.php';

$result = $conn->query("SELECT id, title, content, author, likes, comments FROM posts ORDER BY id DESC");

$posts = [];
while ($row = $result->fetch_assoc()) {
    $posts[] = $row;
}

echo json_encode([
    "success" => true,
    "posts" => $posts
]);
?>
