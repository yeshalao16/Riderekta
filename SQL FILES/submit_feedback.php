<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");
include 'db_connect.php';

// ⏱ For debugging (optional)
$start = microtime(true);

// Set reasonable upload limits (InfinityFree allows ~10MB)
ini_set('upload_max_filesize', '10M');
ini_set('post_max_size', '12M');
ini_set('max_execution_time', '30');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // 🧩 Collect and sanitize input
    $user_name = trim($_POST['user_name'] ?? '');
    $email     = trim($_POST['email'] ?? '');
    $message   = trim($_POST['message'] ?? '');
    $attachment = '';

    if (empty($message)) {
        echo json_encode(["success" => false, "message" => "Message cannot be empty"]);
        exit;
    }

    // 🖼 Handle file upload
    if (!empty($_FILES['attachment']['name'])) {
        // ✅ Make sure your uploads folder exists on InfinityFree:
        // /htdocs/riderekta/uploads/
        $targetDir = __DIR__ . "/uploads/";
        if (!file_exists($targetDir)) mkdir($targetDir, 0777, true);

        // Clean and unique file name
        $fileName = time() . "_" . preg_replace("/[^A-Za-z0-9._-]/", "_", basename($_FILES["attachment"]["name"]));
        $targetFilePath = $targetDir . $fileName;

        // Move uploaded file
        if (move_uploaded_file($_FILES["attachment"]["tmp_name"], $targetFilePath)) {
            $attachment = $fileName;
        } else {
            echo json_encode(["success" => false, "message" => "Failed to upload file"]);
            exit;
        }
    }

    // 🧩 Save feedback to the database
	$stmt = $conn->prepare("INSERT INTO feedback (message, attachment) VALUES (?, ?)");
	$stmt->bind_param("ss", $message, $attachment);
    $success = $stmt->execute();

    // ✅ Close resources
    $stmt->close();
    $conn->close();

    // ⏱ Debugging info
    $end = microtime(true);
    $executionTime = round(($end - $start), 3);

    // ✅ Response
    echo json_encode([
        "success" => $success,
        "message" => $success ? "Feedback submitted successfully" : "Database insert failed",
        "execution_time" => $executionTime
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}
?>
