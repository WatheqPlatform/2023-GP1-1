<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php"); 
}

include("../dbConnection.php");


// Query to retrieve job applications for the specified job offer
$sql = 'SELECT Application.*, JobSeeker.Name 
        FROM Application 
        INNER JOIN JobSeeker ON Application.JobSeekerEmail = JobSeeker.JobSeekerEmail 
        WHERE OfferID = ?';

// Prepare and execute the query
$stmt = $conn->prepare($sql);
if ($stmt === false) {
    die("Error in prepare statement: " . $conn->error);
}

$offerID = (int) $_GET["ID"];
$stmt->bind_param("i", $offerID);

$stmt->execute();
$result = $stmt->get_result();

// Initialize arrays for job applications
$AcceptedApplications = array();
$PendingApplications = array();
$RejectedApplications = array();


// Check if there are any job applications
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $ApplicationID = $row["ApplicationID"];
        $JobSeekerEmail = $row["JobSeekerEmail"];
        $JobSeekerName = $row["Name"]; 
        $Status = $row["Status"];

        // Separate applications based on their status
        if ($Status === "Pending") {
            $PendingApplications[] = array("ApplicationID" => $ApplicationID, "JobSeekerEmail" => $JobSeekerEmail, "Name" => $JobSeekerName, "Status" => $Status);
        } elseif ($Status === "Accepted") {
            $AcceptedApplications[] = array("ApplicationID" => $ApplicationID, "JobSeekerEmail" => $JobSeekerEmail, "Name" => $JobSeekerName, "Status" => $Status);
        } elseif ($Status === "Rejected") {
            $RejectedApplications[] = array("ApplicationID" => $ApplicationID, "JobSeekerEmail" => $JobSeekerEmail, "Name" => $JobSeekerName, "Status" => $Status);
        }
    }
}

$stmt->close();
$conn->close();
?>
