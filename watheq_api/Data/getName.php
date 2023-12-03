<?php

include("../../dbConnection.php");

if (isset($_POST['email'])) {
    $email = $_POST['email'];
   
    $stmt = $conn ->prepare("SELECT Name FROM jobseeker WHERE JobSeekerEmail = ?");
    
  $stmt->bind_param("s", $email);
  $stmt->execute();
  $result = $stmt->get_result();
  

 while($row = $result->fetch_assoc()){
  $data[] = $row;
}

echo json_encode($data);
}

$conn->close();
?>
