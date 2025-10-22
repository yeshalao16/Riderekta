<?php
header('Content-Type: application/json');
include 'db_connect.php';

$query = $conn->query("SELECT * FROM content LIMIT 1");
if ($query && $row = $query->fetch_assoc()) {
  echo json_encode($row);
} else {
  echo json_encode(["error" => "No content found"]);
}
?>
