<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $author = $_POST['author'] ?? 'Anonymous';
    $title = $_POST['title'] ?? '';
    $content = $_POST['content'] ?? '';

    if (empty($title) || empty($content)) {
        echo json_encode(["success" => false, "message" => "All fields are required"]);
        exit;
    }

    $stmt = $conn->prepare("INSERT INTO posts (author, title, content) VALUES (?, ?, ?)");
    $stmt->bind_param("sss", $author, $title, $content);

    if ($stmt->execute()) {
        echo json_encode(["success" => true, "message" => "Post created successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Database error"]);
    }

    $stmt->close();
    $conn->close();
}
?>
