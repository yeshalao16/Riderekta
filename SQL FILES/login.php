<?php
// Enable error visibility during development
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Make sure output is JSON
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include 'db_connect.php'; // Assuming this sets up $conn (mysqli connection)

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';

    if (empty($email) || empty($password)) {
        echo json_encode(["success" => false, "message" => "Email and password required"]);
        exit;
    }

    // Fetch user by email ONLY (don't include password in WHERE clause)
    $stmt = $conn->prepare("SELECT id, name, email, mobile, password FROM users WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        // Don't reveal if email exists (security)
        echo json_encode(["success" => false, "message" => "Invalid credentials"]);
        $stmt->close();
        $conn->close();
        exit;
    }

    // Get the user row (including plain text password)
    $user = $result->fetch_assoc();

    // WARNING: Comparing plain text passwords is a major security risk!
    // In a real application, ALWAYS use password hashing and verification (e.g., password_verify()).
    // This is only for testing or educational purposes.

    // Verify plain password against stored plain text password
    if ($password === $user['password']) {
        // Success! Remove password from response for security
        unset($user['password']);
        echo json_encode([
            "success" => true, 
            "message" => "Login successful",
            "user" => $user // Optional: Send back user details (id, name, etc.) for your app
        ]);
    } else {
        echo json_encode(["success" => false, "message" => "Invalid credentials"]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}
?>