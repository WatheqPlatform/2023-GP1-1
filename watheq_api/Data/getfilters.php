<?php
include("../../dbConnection.php");

$sql1 = "SELECT DISTINCT ci.CityName
FROM joboffer AS JO
LEFT JOIN city AS ci ON ci.CityID = JO.CityID
WHERE JO.Status = 'Active';";
$result1 = $conn->query($sql1);

$data = array();
while($row1 = $result1->fetch_assoc()) {
    $data[] = $row1;   
}

$sql2 = "SELECT DISTINCT JP.CompanyName
FROM joboffer AS JO
INNER JOIN jobprovider AS JP ON JO.JPEmail = JP.JobProviderEmail
WHERE JO.Status = 'Active';";
$result2 = $conn->query($sql2);

while($row2 = $result2->fetch_assoc()) {
    $data[] = $row2;   
}

$sql3 = "SELECT DISTINCT JO.EmploymentType
FROM joboffer AS JO
WHERE JO.Status = 'Active';";
$result3 = $conn->query($sql3);

while($row3 = $result3->fetch_assoc()) {
    $data[] = $row3;   
}


$sql5 = "SELECT DISTINCT JO.JobTitle
FROM joboffer AS JO
WHERE JO.Status = 'Active';";
$result5 = $conn->query($sql5);

while($row5 = $result5->fetch_assoc()) {
    $data[] = $row5;   
}

$sql6 = "SELECT DISTINCT C.CategoryName
FROM joboffer AS JO
INNER JOIN category AS C ON JO.CategoryID = C.CategoryID
WHERE JO.Status = 'Active';";
$result6 = $conn->query($sql6);

while($row6 = $result6->fetch_assoc()) {
    $data[] = $row6;   
}

$sql7 = "SELECT 
    jo.OfferID,
    COALESCE(e.YearsOfExperience, 0) AS ExperienceYears
FROM 
    joboffer AS jo
LEFT JOIN 
    offerexperince AS e ON jo.OfferID = e.OfferID 
WHERE 
    jo.Status = 'Active' 
   ";
    
    $result7 = $conn->query($sql7);

while($row7 = $result7->fetch_assoc()) {
    $data[] = $row7;   
}



echo json_encode($data);

$conn->close();
?>
