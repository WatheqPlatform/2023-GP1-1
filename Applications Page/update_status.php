<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php"); 
}

include("../dbConnection.php");

// Get the application ID and status from the AJAX request
$applicationId = $_POST['applicationId'];
$status = $_POST['status'];
$email =$_POST['email'];
$JPEmail = $_SESSION['JPEmail'];
$offerID =  $_SESSION['OfferID'];

// Sanitize and validate the application ID and status values
$applicationId = mysqli_real_escape_string($conn, $applicationId);
$status = mysqli_real_escape_string($conn, $status);
$email = mysqli_real_escape_string($conn, $email);

// Update the application status in the database
$sqlUpdate = "UPDATE application SET Status = '$status' WHERE ApplicationID = '$applicationId'";   
    $applicationStatus = ($status === "Accepted") ? 1 : 0;
    $date =date("Y-m-d"); 
    $details = "application:$offerID:$applicationStatus";    
    $insertQuery = $conn->prepare("INSERT INTO notification (JSEMAIL, Details, JPEmail, Date) VALUES (?, ?, ?, ?) ");
    $insertQuery->bind_param("ssss", $email, $details, $JPEmail, $date); 
    $insertQuery->execute();

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