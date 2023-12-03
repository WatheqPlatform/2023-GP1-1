<?php


include("../../dbConnection.php");


$email = $_GET['email']; // Get the email parameter from the request URL

$stmt = $conn ->prepare("SELECT Name, JobSeekerEmail FROM jobseeker WHERE JobSeekerEmail = ?");
$stmt->bind_param("s", $email);


$data = array();

if($stmt->execute()){
 $result = $stmt->get_result();

 while($row = $result->fetch_assoc()){
  $data[] = $row;
}
}

echo json_encode($data);

$conn->close();

?>