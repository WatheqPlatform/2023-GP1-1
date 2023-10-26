<?php

include("../dbConnection.php");


// Start a session (if not already started)
session_start();

// Form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST["email"];
    $password = $_POST["password"];

    // Prepare and execute a SQL query to retrieve the hashed password for the given email
    $getPasswordQuery = "SELECT Password FROM jobprovider WHERE JobProviderEmail = ?";
    $stmt = $conn->prepare($getPasswordQuery);
    $stmt->bind_param("s", $email);

    if($stmt->execute()){
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $row = $result->fetch_assoc();
            $hashedPassword = $row["Password"];
            // Verify the entered password against the hashed password
            if (password_verify($password, $hashedPassword)) {
                // Password is correct, set the session variable and redirect
                $_SESSION['JPEmail'] = $email; // Set the session variable
                echo "success";
                exit();  
            } else {
                echo "failure2";//Print the message
                exit();             
            }
        } else {
            echo "failure3"; //Print the message   
            exit();        
        }
        // Send success message to JavaScript
    }else {
        echo "error";
        exit(); 
    }
    
}

$conn->close(); // Close the database connection

?>


