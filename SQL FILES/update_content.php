<?php
header('Content-Type: application/json');
include 'db_connect.php';

$about_title = $_POST['about_title'] ?? '';
$about_subtitle = $_POST['about_subtitle'] ?? '';
$about_text1 = $_POST['about_text1'] ?? '';
$about_text2 = $_POST['about_text2'] ?? '';
$about_footer = $_POST['about_footer'] ?? '';
$team_text = $_POST['team_text'] ?? '';
$benefits_intro = $_POST['benefits_intro'] ?? '';
$benefits_highlights = $_POST['benefits_highlights'] ?? '';

$stmt = $conn->prepare("UPDATE content SET 
  about_title=?, 
  about_subtitle=?, 
  about_text1=?, 
  about_text2=?, 
  about_footer=?, 
  team_text=?, 
  benefits_intro=?, 
  benefits_highlights=? 
  WHERE id=1
");

$stmt->bind_param(
  "ssssssss",
  $about_title,
  $about_subtitle,
  $about_text1,
  $about_text2,
  $about_footer,
  $team_text,
  $benefits_intro,
  $benefits_highlights
);

if ($stmt->execute()) {
  echo json_encode(["status" => "success"]);
} else {
  echo json_encode(["status" => "error", "message" => $conn->error]);
}
?>
