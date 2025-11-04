<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Read raw input (Flutter sends JSON)
$raw = file_get_contents("php://input");
$input = json_decode($raw, true);

// Validate input
if (!$input || !isset($input["lat"]) || !isset($input["lon"])) {
    echo json_encode(["success" => false, "error" => "Missing coordinates or invalid JSON input."]);
    exit;
}

$lat = $input["lat"];
$lon = $input["lon"];
$message = $input["message"] ?? "";
$type = $input["type"] ?? "suggestions";

// ✅ Your OpenAI API key here
$api_key = "sk-your-openai-key";

// Build prompt
if ($type === "suggestions") {
    $prompt = "You are an e-bike safety assistant. Current location: ($lat, $lon). 
    Provide 3 short, location-based route safety tips. Each tip must be one sentence.";
} else {
    $prompt = "You are an AI e-bike route safety assistant. Current location: ($lat, $lon). 
    The user says: '$message'. Respond with helpful, natural e-bike safety advice.";
}

// Prepare request to OpenAI API
$ch = curl_init("https://api.openai.com/v1/chat/completions");
curl_setopt_array($ch, [
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => [
        "Content-Type: application/json",
        "Authorization: Bearer $api_key"
    ],
    CURLOPT_POSTFIELDS => json_encode([
        "model" => "gpt-4o-mini",
        "messages" => [
            ["role" => "system", "content" => "You are a helpful e-bike route safety assistant."],
            ["role" => "user", "content" => $prompt],
        ],
    ]),
]);

$response = curl_exec($ch);

// Catch cURL errors
if (curl_errno($ch)) {
    echo json_encode(["success" => false, "error" => curl_error($ch)]);
    curl_close($ch);
    exit;
}

curl_close($ch);

// Return OpenAI response directly
echo $response;
?>
