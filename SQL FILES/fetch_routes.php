<?php
header('Content-Type: application/json');
require 'db_connect.php'; // your database connection

$email = $_POST['email'] ?? '';

if (!$email) {
    echo json_encode(['success' => false, 'message' => 'Email is required']);
    exit;
}

// 1️⃣ Get user_id from email
$query = "SELECT id FROM users WHERE email = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

if (!$user) {
    echo json_encode(['success' => false, 'message' => 'User not found']);
    exit;
}

$user_id = $user['id'];

// 2️⃣ Fetch routes from route_history
$fetchQuery = "SELECT id, startName, endName, distance, duration, timestamp, startLat, startLon, endLat, endLon
               FROM route_history
               WHERE user_id = ?
               ORDER BY id DESC"; // latest routes first

$stmt = $conn->prepare($fetchQuery);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$routes = [];
while ($row = $result->fetch_assoc()) {
    // Convert numeric strings to float
    $row['startLat'] = floatval($row['startLat']);
    $row['startLon'] = floatval($row['startLon']);
    $row['endLat'] = floatval($row['endLat']);
    $row['endLon'] = floatval($row['endLon']);
    $routes[] = $row;
}

echo json_encode(['success' => true, 'routes' => $routes]);
?>
