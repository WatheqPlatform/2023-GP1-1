<?php

include("../../dbConnection.php");

$email = $_POST['email']; 


$sql = $conn->prepare("SELECT n.OfferID, n.Score, n.Date, jo.JobTitle, jp.CompanyName, n.isSeen
                       FROM notification AS n
                       JOIN jobseeker AS js ON n.JSEMAIL = js.JobSeekerEmail
                       JOIN joboffer AS jo ON n.OfferID = jo.OfferID
                       JOIN jobprovider AS jp ON jo.JPEmail = jp.JobProviderEmail
                       WHERE js.JobSeekerEmail = ?");

$sql->bind_param("s", $email);
$sql->execute();

// Get result set from the prepared statement
$result = $sql->get_result();

$data = array();
while($row = $result->fetch_assoc()){
    $data[] = $row;   
}

echo json_encode($data);

$conn->close();
?>
