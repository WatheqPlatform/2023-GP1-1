<?php 


include("../../dbConnection.php");


$email =$_POST["email"];
$name =$_POST["name"];

$password = password_hash($_POST["password"], PASSWORD_DEFAULT);

$stmt = $conn->prepare("INSERT INTO jobseeker (JobSeekerEmail, Name,Password) VALUES (?,  ?, ?) ");
$stmt->bind_param("sss", $email, $name, $password);

 if($stmt->execute()){

  echo json_encode(1);
 }
 else{
 
   echo json_encode(0);
 }
 
 
 $stmt->close();
 $conn->close();


?>