<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit; 
}

include("../dbConnection.php");

// Query to retrieve job applications along with CV details for the specified job offer
$sql = 'SELECT Application.*, cv.CV_ID, cv.FirstName, cv.LastName, cv.ContactEmail, cv.PhoneNumber, cv.Summary
        FROM application
        INNER JOIN cv ON application.JobSeekerEmail = cv.JobSeekerEmail
        WHERE application.OfferID = ? ORDER BY Application.ApplicationID DESC';

// Prepare and execute the query
$stmt = $conn->prepare($sql);

$offerID = (int) $_GET["ID"];
$_SESSION['OfferID'] = $offerID;
$stmt->bind_param("i", $offerID);

$stmt->execute();

$result = $stmt->get_result();

// Initialize arrays for job applications
$AcceptedApplications = array();
$PendingApplicationsDESC = array();
$RejectedApplications = array();

// Check if there are any job applications
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $ApplicationID = $row["ApplicationID"];
        $CVID = $row["CV_ID"];
        $ContactEmail = $row["ContactEmail"];
        $JobSeekerName = $row["FirstName"] . " <br>" . $row["LastName"];
        $JobSeekerPhone = $row["PhoneNumber"];
        $Status = $row["Status"];
        $Summary = $row["Summary"];

        // Create an application array
        $applicationArray = array(
            "ApplicationID" => $ApplicationID,
            "CVID" => $CVID,
            "ContactEmail" => $ContactEmail,
            "Name" => $JobSeekerName,
            "PhoneNumber" => $JobSeekerPhone,
            "Summary" => $Summary,
            "Status" => $Status
        );

        // Separate applications based on their status
        if ($Status === "Pending") {
            $PendingApplications[] = $applicationArray;
        } elseif ($Status === "Accepted") {
            $AcceptedApplications[] = $applicationArray;
        } elseif ($Status === "Rejected") {
            $RejectedApplications[] = $applicationArray;
        }
    }
}
$stmt->close();
$conn->close();
?>
