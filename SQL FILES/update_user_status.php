<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'db_connect.php';

// Handle preflight (CORS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

// Read JSON input
$input = file_get_contents("php://input");
$data = json_decode($input, true);

if (!isset($data['id']) || !isset($data['isActive'])) {
    echo json_encode([
        "success" => false,
        "error" => "Missing or invalid 'id' or 'isActive' parameter.",
        "received" => $datas
    ]);
    exit;
}

$id = intval($data['id']);
$isActive = intval($data['isActive']);

$stmt = $conn->prepare("UPDATE users SET isActive = ? WHERE id = ?");
$stmt->bind_param("ii", $isActive, $id);

if ($stmt->execute()) {
    echo json_encode([
        "success" => true,
        "message" => "User status updated successfully.",
        "id" => $id,
        "newStatus" => $isActive
    ]);
} else {
    echo json_encode([
        "success" => false,
        "error" => $stmt->error
    ]);
}

$stmt->close();
$conn->close();
?>
