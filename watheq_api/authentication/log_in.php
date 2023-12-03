<?php 


include("../../dbConnection.php");


if(mysqli_connect_error()){
  die("Connection failed: " . $connection->connect_error);
}

$email =$_POST["email"];
$password =$_POST["password"];

$stmt = $conn->prepare("SELECT * FROM jobseeker WHERE JobSeekerEmail= ? ");

$stmt->bind_param("s", $email);



if($stmt->execute()){

 $result = $stmt->get_result();
 $row = $result->fetch_assoc();

 if (password_verify($password, $row['Password'])){

  echo json_encode(1);}
  
else{

   echo json_encode(0);}

 }
 
 
 $stmt->close();
 $conn->close();

  ?>
  
  