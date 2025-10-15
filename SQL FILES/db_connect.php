<?php
$servername = "127.0.0.1";
$username = "root";
$password = "";
$dbname = "riderekta_db";
$port = 3307;

$conn = new mysqli($servername, $username, $password, $dbname, $port);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Database connection failed."]));
}
?>