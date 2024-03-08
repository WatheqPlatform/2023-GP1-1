<?php 

session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit; 
}

include("../dbConnection.php");

// Check if the request is an AJAX request
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email=$_SESSION['JPEmail'];

    $updateQuery = "UPDATE notification SET isSeen = 1 WHERE Details REGEXP '^[0-9]+$' AND JPEmail = '$email'";
    $result = $conn->query($updateQuery);

    // Close the database connection
    $conn->close();

    if ($result) {
        echo 'Success';
    } else {
        echo 'Error';
    }
}