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

    // Prepare and execute the SQL query to close the offer
    $sqlCloseOffer = "UPDATE joboffer SET Status = 'Closed' WHERE offerID = ?";
    $stmtCloseOffer = $conn->prepare($sqlCloseOffer);
    $stmtCloseOffer->bind_param("i", $offerId);
    $stmtCloseOffer->execute();

    // Check if the query to close the offer was successful
    if ($stmtCloseOffer->affected_rows > 0) {
       // echo "Offer closed successfully.";

        // Prepare and execute the SQL query to update application status
        $sqlUpdateApplications = "UPDATE application SET Status = 'Rejected' WHERE offerID = ? AND Status = 'Pending';";
        $stmtUpdateApplications = $conn->prepare($sqlUpdateApplications);
        $stmtUpdateApplications->bind_param("i", $offerId);
        $stmtUpdateApplications->execute();

        // Check if the query to update applications was successful
        if ($stmtUpdateApplications->affected_rows > 0) {
            echo "Applications associated with the closed offer are updated to 'Rejected'.";
        } else {
            echo "No applications associated with the closed offer.";
        }

        // Close the statement for updating applications
        $stmtUpdateApplications->close();
    } else {
        echo "Failed to close the offer.";
    }

    // Close the statement for closing the offer
    $stmtCloseOffer->close();
}

// Close the database connection
$conn->close();
?>