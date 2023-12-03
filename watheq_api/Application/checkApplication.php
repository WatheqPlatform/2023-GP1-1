<?php 

include("../../dbConnection.php");

$email = $_POST["email"];
$OfferID = $_POST["OfferID"];

$stmt = $conn->prepare("SELECT * FROM application WHERE JobSeekerEmail= ? AND OfferID = ?");
$stmt->bind_param("ss", $email, $OfferID);

$response = array("applied" => false, "accepted" => false, "rejected" => false);

if ($stmt->execute()) {
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();

        // Check if the status is not 'Cancelled'
        if ($row["Status"] !== 'Cancelled') {
            $response["applied"] = true;
            $response["accepted"] = ($row["Status"] == 'Accepted');
            $response["rejected"] = ($row["Status"] == 'Rejected');
        }
    }
}

echo json_encode($response);


 $stmt->close();
 $conn->close();

?>
