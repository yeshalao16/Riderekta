<?php
header('Content-Type: application/json');
require 'db_connect.php';

// Get raw POST body
$raw = file_get_contents('php://input');
file_put_contents('debug_save_route.log', date('Y-m-d H:i:s') . " RAW: $raw\n", FILE_APPEND);

$data = json_decode($raw, true);

if ($data === null) {
    file_put_contents('debug_save_route.log', "⚠️ JSON decode failed\n", FILE_APPEND);
    echo json_encode(['success' => false, 'message' => 'Invalid JSON']);
    exit;
}

$email = $data['email'] ?? '';
$startName = $data['startName'] ?? '';
$endName = $data['endName'] ?? '';
$distance = $data['distance'] ?? '';
$duration = $data['duration'] ?? '';
$timestamp = $data['timestamp'] ?? '';
$startLat = $data['startLat'] ?? '';
$startLon = $data['startLon'] ?? '';
$endLat = $data['endLat'] ?? '';
$endLon = $data['endLon'] ?? '';

if (!$email) {
    echo json_encode(['success' => false, 'message' => 'Email is required']);
    exit;
}

// Get user_id
$query = "SELECT id FROM users WHERE email = ?";
$stmt = $conn->prepare($query);
if (!$stmt) {
    file_put_contents('debug_save_route.log', "❌ Prepare failed: ".$conn->error."\n", FILE_APPEND);
    echo json_encode(['success' => false, 'message' => 'DB prepare failed']);
    exit;
}
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

if (!$user) {
    echo json_encode(['success' => false, 'message' => 'User not found']);
    exit;
}

$user_id = $user['id'];

// Insert route
$insertQuery = "INSERT INTO route_history 
(user_id, startName, endName, distance, duration, timestamp, startLat, startLon, endLat, endLon) 
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($insertQuery);
if (!$stmt) {
    file_put_contents('debug_save_route.log', "❌ Insert prepare failed: ".$conn->error."\n", FILE_APPEND);
    echo json_encode(['success' => false, 'message' => 'DB insert prepare failed']);
    exit;
}

$stmt->bind_param(
    "issssssddd",
    $user_id,
    $startName,
    $endName,
    $distance,
    $duration,
    $timestamp,
    $startLat,
    $startLon,
    $endLat,
    $endLon
);

if ($stmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Route saved successfully']);
} else {
    file_put_contents('debug_save_route.log', "❌ Execute failed: ".$stmt->error."\n", FILE_APPEND);
    echo json_encode(['success' => false, 'message' => $stmt->error]);
}
?>
