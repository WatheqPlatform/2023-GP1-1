<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php"); 
}

include("../dbConnection.php");

// Get the application ID and status from the AJAX request
$applicationId = $_POST['applicationId'];
$status = $_POST['status'];

// Sanitize and validate the application ID and status values
$applicationId = mysqli_real_escape_string($conn, $applicationId);
$status = mysqli_real_escape_string($conn, $status);

// Update the application status in the database
$sqlUpdate = "UPDATE Application SET Status = '$status' WHERE ApplicationID = '$applicationId'";

// Execute the update query
if ($conn->query($sqlUpdate) === TRUE) {
    // Update successful
    echo "Application status updated successfully";
} else {
    // Update failed
    echo "Error updating application status: ";
}

// Close the database connection
$conn->close();
?>