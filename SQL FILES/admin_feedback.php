<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

include 'db_connect.php';

// ✅ Change this to your computer's LAN IP (not localhost)
$server_ip = "192.168.254.116"; // ← replace with your real local IP
$base_url = "http://$server_ip/riderekta/uploads/";

$sql = "SELECT id, message, attachment, created_at FROM feedback ORDER BY id DESC";
$result = $conn->query($sql);

$feedback = [];

if ($result && $result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        if (!empty($row['attachment'])) {
            // ✅ Build a full accessible URL for each attachment
            $row['attachment'] = $base_url . basename($row['attachment']);
        }
        $feedback[] = $row;
    }

    echo json_encode([
        "success" => true,
        "feedback" => $feedback
    ]);
} else {
    echo json_encode([
        "success" => true,
        "feedback" => []
    ]);
}

$conn->close();
?>