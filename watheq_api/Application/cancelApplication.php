<?php
include("../../dbConnection.php");

$email = $_POST["email"];
$OfferID = $_POST["OfferID"];
$status = "Cancelled";


$stmt = $conn->prepare("UPDATE application SET Status = ? WHERE JobSeekerEmail = ? AND OfferID = ?");
$stmt->bind_param("sss", $status, $email, $OfferID);

if ($stmt->execute()) {

    if ($stmt->affected_rows > 0) {
        echo json_encode(1); // Success
    } else {
        echo json_encode(0); 
    }
} else {
    echo json_encode(0); // Error in execution
}

$stmt->close();
$conn->close();

 
  


?>