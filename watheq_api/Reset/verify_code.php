<?php

header("Content-Type: application/json");

$response = [];

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $data = json_decode(file_get_contents("php://input"), true);
    
    
session_id($data['session_id']); 
session_start();

    if (!isset($data["email"]) || !isset($data["code"])) {
        $response["error"] = "Email and code are required.";
    } else {
        $enteredCode = $data["code"];

        if (isset($_SESSION['reset_token'], $_SESSION['token_timestamp'])) {
            $time_elapsed = time() - $_SESSION['token_timestamp'];
            if ($enteredCode === $_SESSION['reset_token'] && $time_elapsed <= (3 * 60)) {
                $response["message"] = "Code is valid. You can reset your password now.";
            } else {
                $response["error"] = "Invalid or expired code. Please request a new code.";
            }
        } else {
            $response["error"] = "No reset token available!!. Please request a new one.";
        }
    }
} else {
    $response["error"] = "Invalid request method.";
}

echo json_encode($response);
?>
