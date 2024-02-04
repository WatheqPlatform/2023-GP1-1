<?php

include("../dbConnection.php");


// Form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $companyName = $_POST["companyName"];
    $email = $_POST["email"];
    $password = $_POST["password"];
    $passwordConfirm = $_POST["passwordInput2"];

    // Validate password requirements
    $passwordRegex = "/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()\-_=+{};:,<.>])(?!.*\s).{8,}$/";
    if (!preg_match($passwordRegex, $password)) {
        echo "failure2";
        exit();
    }
    
    $emailRegex = "/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/";

if (!preg_match($emailRegex, $email)) {
      echo "failure5";
        exit();
} 

 

    // Check if email already exists
    $checkEmailQuery = "SELECT * FROM jobprovider WHERE JobProviderEmail = ?";
    $stmt = $conn->prepare($checkEmailQuery);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();
    
    if ($result->num_rows > 0) {
        echo "failure3";
        exit();
    }
    
    

    // If no errors, insert the user into the database
    if (!isset($error)) {
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT); // Hash the password

        $insertQuery = "INSERT INTO jobprovider (CompanyName, JobProviderEmail, Password) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($insertQuery);
        $stmt->bind_param("sss", $companyName, $email, $hashedPassword);

        if ($stmt->execute()) {
            echo "success";
            exit(); 
        } else {
            echo "error";
            exit(); 
        }
    }
}
?>

<?php
$conn->close(); // Close the database connection
?>
