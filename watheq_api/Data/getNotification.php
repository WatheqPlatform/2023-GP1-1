<?php

include("../../dbConnection.php");

$email = $_POST['email']; 

$sql = $conn->prepare("SELECT n.Details, n.Date, jp.CompanyName, n.isSeen, n.JPEmail
                       FROM notification AS n
                       JOIN jobseeker AS js ON n.JSEMAIL = js.JobSeekerEmail
                       JOIN jobprovider AS jp ON n.JPEmail = jp.JobProviderEmail
                       WHERE js.JobSeekerEmail = ? AND n.Details LIKE '%:%'");

$sql->bind_param("s", $email);
$sql->execute();

// Get result set from the prepared statement
$result = $sql->get_result();

$data = array();
while($row = $result->fetch_assoc()){
    // Extract offerID from Details
    $detailsParts = explode(':', $row['Details']);
    $offerId = isset($detailsParts[1]) ? $detailsParts[1] : null;

    if ($offerId) {
        // Fetch Job Title using offerID
        $jobTitleQuery = $conn->prepare("SELECT JobTitle FROM joboffer WHERE OfferID = ?");
        $jobTitleQuery->bind_param("i", $offerId);
        $jobTitleQuery->execute();
        $jobTitleResult = $jobTitleQuery->get_result();

        if($jobTitleRow = $jobTitleResult->fetch_assoc()){
            $row['JobTitle'] = $jobTitleRow['JobTitle'];
        } 

        // Include offer ID in the row data
        $row['OfferID'] = $offerId;
    }

    $data[] = $row;   
}

echo json_encode($data);

$conn->close();

?>
