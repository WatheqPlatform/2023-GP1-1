<?php

include("../../dbConnection.php");


$email = $_POST["email"];


$stmt = $conn->prepare("SELECT * FROM jobseeker WHERE JobSeekerEmail= ? ");
$stmt->bind_param("s", $email);


if($stmt->execute()){

 $result = $stmt->get_result();
 
  if ($result-> num_rows > 0){
 
   echo json_encode(1);}
   
 else{
 
    echo json_encode(0);}
 
  }
  
  
 $stmt->close();
 $conn->close();




?>
