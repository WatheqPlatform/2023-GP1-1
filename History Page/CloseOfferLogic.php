<?php

session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php"); 
}

include("../dbConnection.php");
//include('HistoryLogic.php');

// Check if the Close button is clicked and confirmation is received
if (isset($_POST['offerId']) && isset($_POST['confirmClose']) && $_POST['confirmClose'] === 'true') {
    $offerId = $_POST['offerId'];

    // Prepare and execute the SQL query
    $sql = "UPDATE joboffer SET Status = 'Closed' WHERE offerID = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $offerId);
    $stmt->execute();

    // Check if the query was successful
    if ($stmt->affected_rows > 0) {
        echo "Offer closed successfully.";
    } else {
        echo "Failed to close the offer.";
    }

    // Close the statement 
    $stmt->close();
}

// Close the database connection
$conn->close();
?>