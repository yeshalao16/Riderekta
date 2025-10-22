<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

include 'db_connect.php'; // assumes $conn (MySQLi connection)

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Clean inputs
    $name = htmlspecialchars(trim($_POST['name'] ?? ''));
    $surname = htmlspecialchars(trim($_POST['surname'] ?? ''));
    $email = htmlspecialchars(trim($_POST['email'] ?? ''));
    $message = htmlspecialchars(trim($_POST['message'] ?? ''));

    // Validation
    if (empty($name) || empty($surname) || empty($email) || empty($message)) {
        echo json_encode(["success" => false, "message" => "All fields are required."]);
        exit;
    }

    // 🧩 Check if the email exists in users table
    $userQuery = $conn->prepare("SELECT id FROM users WHERE email = ?");
    $userQuery->bind_param("s", $email);
    $userQuery->execute();
    $userResult = $userQuery->get_result();

    if ($userResult->num_rows === 0) {
        echo json_encode(["success" => false, "message" => "Email not registered in users table."]);
        $userQuery->close();
        $conn->close();
        exit;
    }

    // Get user ID
    $user = $userResult->fetch_assoc();
    $user_id = $user['id'];
    $userQuery->close();

    // 🧱 Insert message into contact_messages table
    $stmt = $conn->prepare("
        INSERT INTO contact_messages (user_id, name, surname, email, message)
        VALUES (?, ?, ?, ?, ?)
    ");
    $stmt->bind_param("issss", $user_id, $name, $surname, $email, $message);
    $success = $stmt->execute();

    if ($success) {
        echo json_encode(["success" => true, "message" => "Message received successfully."]);
    } else {
        echo json_encode(["success" => false, "message" => "Failed to save message."]);
    }

    $stmt->close();
    $conn->close();

} else {
    echo json_encode(["success" => false, "message" => "Invalid request method."]);
}
?>
