<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php"); 
}

include("../dbConnection.php");


// Include this logic file in job-offers-history.php using require_once


// Retrieve the job provider's email from the session
$jobProviderEmail = $_SESSION['JPEmail'];

// Query to retrieve job offers history for the logged-in job provider
$sql = "SELECT OfferID, JobTitle, JobDescription, Status FROM joboffer WHERE JPEmail = ?";

// Prepare and execute the query
$stmt = $conn->prepare($sql);
if ($stmt === false) {
    die("Error in prepare statement: " . $conn->error);
}

$stmt->bind_param("s", $jobProviderEmail);

$stmt->execute();
$result = $stmt->get_result();

// Initialize arrays for available and closed job offers
$availableOffers = array();
$closedOffers = array();

// Check if there are any job offers
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $offerID = $row["OfferID"];
        $jobTitle = $row["JobTitle"];
        $jobDescription = $row["JobDescription"];
        $status = $row["Status"];

        // Separate job offers based on their status
        if ($status === "Active") {
            $availableOffers[] = array("OfferID" => $offerID, "JobTitle" => $jobTitle, "JobDescription" => $jobDescription, "Status" => $status);
        } elseif ($status === "Closed") {
            $closedOffers[] = array("JobTitle" => $jobTitle, "JobDescription" => $jobDescription, "Status" => $status);
        }
    }
}

$stmt->close();
$conn->close();
?>
