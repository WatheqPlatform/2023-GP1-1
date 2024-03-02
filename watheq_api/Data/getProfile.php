<?php

include("../../dbConnection.php");

$offerID = $_POST['OfferID'];

// First query to retrieve jobprovideremail
$sql = "SELECT JPEmail FROM joboffer WHERE offerID = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $offerID);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $jobProviderEmail = $row['JPEmail'];

    // Second query to retrieve profile information
    $sqlProfile = "SELECT Description, Location, Email, Phone, Linkedin, Twitter, Link
                   FROM profile
                   WHERE JobProviderEmail = ?";
    $stmtProfile = $conn->prepare($sqlProfile);
    $stmtProfile->bind_param("s", $jobProviderEmail);
    $stmtProfile->execute();
    $resultProfile = $stmtProfile->get_result();

    $data = array();
    while ($rowProfile = $resultProfile->fetch_assoc()) {
        $data[] = $rowProfile;
    }

    echo json_encode($data);
} else {
echo "No results found";
    
}

$stmt->close();
$stmtProfile->close();
$conn->close();
?>
