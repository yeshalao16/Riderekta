<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

include 'db_connect.php';

$query = "SELECT r.id, u.email, r.startName, r.endName, r.distance, r.duration, r.timestamp
          FROM route_history r
          LEFT JOIN users u ON r.user_id = u.id
          ORDER BY r.id DESC";

$result = $conn->query($query);

$routes = [];
while ($row = $result->fetch_assoc()) {
    $routes[] = $row;
}

echo json_encode([
    "success" => true,
    "routes" => $routes
]);

$conn->close();
?>
