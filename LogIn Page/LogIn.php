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
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $hashedPassword = $row["Password"];

        // Verify the entered password against the hashed password
        if (password_verify($password, $hashedPassword)) {
            // Password is correct, set the session variable and redirect
            $_SESSION['JPEmail'] = $email; // Set the session variable
            header("Location: ../Home Page/Home.php");
            exit();
        } else {
            echo "<script>alert('Incorrect Email or password. Please try again.');</script>";
            echo '<script>window.location.href = "LogIn.html?email=' . urlencode($email) . '";</script>';
        }
    } else {
        echo "<script>alert('Incorrect Email or password. Please try again.');</script>";
        echo '<script>window.location.href = "LogIn.html?email=' . urlencode($email) . '";</script>';
    }
}

$conn->close(); // Close the database connection

?>


