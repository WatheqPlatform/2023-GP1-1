<?php

include("../../dbConnection.php");

$email = $_POST['email']; 

$sql = "SELECT
    JO.OfferID,
    JO.Date,
    ci.CityName,
    JO.Status,
    JO.JobTitle,
    JO.EmploymentType,
    JP.CompanyName,
    C.CategoryName,
    A.Status AS ApplicationStatus
FROM
    joboffer AS JO
INNER JOIN
    jobprovider AS JP ON JO.JPEmail = JP.JobProviderEmail
INNER JOIN
    category AS C ON JO.CategoryID = C.CategoryID
INNER JOIN
    city AS ci ON ci.CityID = JO.CityID
LEFT JOIN
    application AS A ON A.OfferID = JO.OfferID AND A.JobSeekerEmail = '$email'
WHERE
    JO.Status = 'Active'
    AND (A.Status IS NULL OR A.Status != 'Rejected')
ORDER BY
     JO.OfferID DESC";

$result = $conn->query($sql);

$data =array();
while($row = $result->fetch_assoc()){
 $data[] = $row;   
}

echo json_encode($data);

$conn->close();
?>
