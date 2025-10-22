<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

include 'db_connect.php';

$result = $conn->query("SELECT id, name, email, mobile, isActive FROM users");

$users = [];
while ($row = $result->fetch_assoc()) {
    // ✅ Cast to integers instead of strings
    $row['id'] = (int)$row['id'];
    $row['isActive'] = (int)$row['isActive'];
    $users[] = $row;
}

echo json_encode($users);
$conn->close();
?>
