<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");

// ⏱ Track execution time (for debugging)
$start = microtime(true);

include 'db_connect.php';

// Set upload and execution limits
ini_set('upload_max_filesize', '10M');
ini_set('post_max_size', '12M');
ini_set('max_execution_time', '30');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    // Collect form data safely
    $user_name = trim($_POST['user_name'] ?? '');
    $email     = trim($_POST['email'] ?? '');
    $message   = trim($_POST['message'] ?? '');
    $attachment = '';

    // 🧩 Validate message
    if (empty($message)) {
        echo json_encode(["success" => false, "message" => "Message cannot be empty"]);
        exit;
    }

    // 🖼 Handle file upload if provided
    if (!empty($_FILES['attachment']['name'])) {
        $targetDir = __DIR__ . "/uploads/"; // use absolute path for reliability
        if (!file_exists($targetDir)) mkdir($targetDir, 0777, true);

        // Clean filename and generate unique name
        $fileName = time() . "_" . preg_replace("/[^A-Za-z0-9._-]/", "_", basename($_FILES["attachment"]["name"]));
        $targetFilePath = $targetDir . $fileName;

        // Move uploaded file
        if (move_uploaded_file($_FILES["attachment"]["tmp_name"], $targetFilePath)) {
            // Save only the relative path in DB
            $attachment = $fileName;
        } else {
            echo json_encode(["success" => false, "message" => "Failed to upload attachment"]);
            exit;
        }
    }

    // 🧩 Save feedback to database
    $stmt = $conn->prepare("INSERT INTO feedback (user_name, email, message, attachment) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("ssss", $user_name, $email, $message, $attachment);
    $success = $stmt->execute();

    $stmt->close();
    $conn->close();

    // ⏱ Measure total execution time
    $end = microtime(true);
    $executionTime = round(($end - $start), 3);

    // 🟢 Respond
    ob_clean();
    echo json_encode([
        "success" => $success,
        "message" => $success ? "Feedback submitted successfully" : "Database insert failed",
        "execution_time" => $executionTime
    ]);
    flush();
} else {
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}
?>
