<?php


include("../../dbConnection.php");

$email = $_POST["email"];

$stmt= $conn->prepare("SELECT
jp.CompanyName AS CompanyName,
jo.JobTitle AS JobTitle,
c.CategoryName AS Category,
a.Status AS ApplicationStatus,
jo.OfferID AS OfferID
FROM
application a
JOIN joboffer jo ON a.OfferID = jo.OfferID
JOIN jobprovider jp ON jo.JPEmail = jp.JobProviderEmail
JOIN category c ON jo.CategoryID = c.CategoryID
WHERE
a.JobSeekerEmail =? ");

$stmt->bind_param("s", $email);

$stmt->execute();

$result = $stmt->get_result();


$data =array();
while($row = $result->fetch_assoc()){
 $data[] = $row;   
}

echo json_encode($data);


 $stmt->close();
 $conn->close();


?>