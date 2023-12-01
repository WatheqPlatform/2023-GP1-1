<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php"); 
}

include("../dbConnection.php");


// Retrieve the job provider's email from the session
$jobProviderEmail = $_SESSION['JPEmail'];

// Query to retrieve job offers history for the logged-in job provider
$sql = "SELECT OfferID, JobTitle, JobDescription, Date, Status FROM joboffer WHERE JPEmail = ? ORDER BY OfferID DESC";

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
        $Date = $row["Date"];

        // Separate job offers based on their status
        if ($status === "Active") {
            $availableOffers[] = array("OfferID" => $offerID, "JobTitle" => $jobTitle, "JobDescription" => $jobDescription, "Status" => $status, "Date" => $Date );
        } elseif ($status === "Closed") {
            $closedOffers[] = array("OfferID" => $offerID, "JobTitle" => $jobTitle, "JobDescription" => $jobDescription, "Status" => $status,"Date" => $Date );
        }
    }
}

$stmt->close();
$conn->close();
?>
