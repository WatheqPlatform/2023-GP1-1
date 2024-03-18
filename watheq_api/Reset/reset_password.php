<?php

include("../../dbConnection.php");
header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] === "PUT") {
  $data = json_decode(file_get_contents("php://input"), true);    
       
session_id($data['session_id']); 
session_start();

    if (!isset($data["email"]) || !isset($data["password"])) {
        echo json_encode(["error" => "Email and password are required." ]);
        exit;
    }

    $email = $data["email"];
    $password = $data["password"];

    if (isset($_SESSION['reset_token'], $_SESSION['token_timestamp']) &&
        (time() - $_SESSION['token_timestamp']) <= (3 * 60)) {

        $hashed_password = password_hash($password, PASSWORD_DEFAULT);
        $update_stmt = $conn->prepare("UPDATE jobseeker SET password = ? WHERE JobSeekerEmail = ?");
        $update_stmt->bind_param("ss", $hashed_password, $email);
        $update_stmt->execute();

        //unset($_SESSION['reset_token'], $_SESSION['token_timestamp']);
        echo json_encode(["message" => "Password reset successful."]);
    } else {
        echo json_encode(["error" => "Invalid or expired token."]);
    }
} else {
    echo json_encode(["error" => "Invalid request method."]);
}
?>
