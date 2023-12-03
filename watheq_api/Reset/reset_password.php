<?php

include("../../dbConnection.php");


// Handle PUT request to reset the password
if ($_SERVER["REQUEST_METHOD"] === "PUT") {
    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data["email"]) || !isset($data["password"])) {
        echo json_encode(["error" => "email and password are required."]);
        exit;
    }
  

    $email = $data["email"];
    $password = $data["password"];
    $passwordRegex = "/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()\-_=+{};:,<.>])(?!.*\s).{8,}$/";

    if (!preg_match($passwordRegex, $password)) {
        echo json_encode(["error" => "Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character."]);
        return;
    }


    // Verify the token and ensure it's not expired
    $stmt = $conn->prepare("SELECT  Timestamp FROM seekerresettoken WHERE Email =  ? ");
     
      $stmt->bind_param("s", $email);
   
     if($stmt->execute()){

       $result = $stmt->get_result();
    }

    if ($result->num_rows > 0) {
        
        $row = $result->fetch_assoc();
        $timestamp = $row["Timestamp"];

        // Check if the token is still valid (e.g., not expired)
        $expirationTime = 3 * 60; // Token expires after 3 minutes 
        if (time() - $timestamp < $expirationTime) {

            $hashed_password = password_hash($password, PASSWORD_DEFAULT);

            $update_sql = "UPDATE jobseeker SET password = ? WHERE JobSeekerEmail = ?";
            $update_stmt = $conn->prepare($update_sql);
            $update_stmt->bind_param("ss", $hashed_password, $email);
            $update_stmt->execute();
    
            echo json_encode(["message" => "Password reset successful."]);
        } else {
            echo json_encode(["error" => "Invalid or expired code, Please request a new code."]);
        }
    }
       

    // Close the database connection
    $stmt->close();
    $update_stmt->close();
    $conn->close();
} else {
    echo json_encode(["error" => "Invalid request method."]);
}
?>