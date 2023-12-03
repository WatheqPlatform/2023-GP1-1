<?php 

include("../../dbConnection.php");

$email = $_POST["email"];
$offerId = $_POST["offerId"];
$status = "Pending";

// Check if the user exists in the cv table
$stmt = $conn->prepare("SELECT * FROM cv WHERE JobSeekerEmail = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    // Check for an existing application
    $stmtCheck = $conn->prepare("SELECT * FROM application WHERE JobSeekerEmail = ? AND OfferID = ?");
    $stmtCheck->bind_param("ss", $email, $offerId);
    $stmtCheck->execute();
    $checkResult = $stmtCheck->get_result();

    if ($checkResult->num_rows > 0) {
        // Delete the existing application
        $deleteStmt = $conn->prepare("DELETE FROM application WHERE JobSeekerEmail = ? AND OfferID = ?");
        $deleteStmt->bind_param("ss", $email, $offerId);
        $deleteStmt->execute();
    }

    // Insert the new application
    $stmtApply = $conn->prepare("INSERT INTO application (OfferID, JobSeekerEmail, Status) VALUES (?, ?, ?)");
    $stmtApply->bind_param("sss", $offerId, $email, $status);
    $stmtApply->execute();

    echo json_encode(1); 
} else {
    echo json_encode(0); 
}


 $stmt->close();
 $stmtCheck->close();
 $deleteStmt->close();
 $stmtApply->close();
 $conn->close();


?>
