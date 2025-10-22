<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include 'db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['id']) || !isset($data['name']) || !isset($data['email']) || !isset($data['mobile'])) {
    echo json_encode(["success" => false, "error" => "Missing parameters", "received" => $data]);
    exit;
}

$id = intval($data['id']);
$name = trim($data['name']);
$email = trim($data['email']);
$mobile = trim($data['mobile']);

$stmt = $conn->prepare("UPDATE users SET name = ?, email = ?, mobile = ? WHERE id = ?");
$stmt->bind_param("sssi", $name, $email, $mobile, $id);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "User updated successfully"]);
} else {
    echo json_encode(["success" => false, "error" => $stmt->error]);
}

$stmt->close();
$conn->close();
?>
