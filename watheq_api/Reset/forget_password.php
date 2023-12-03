<?php

 include("../../dbConnection.php");
header("Content-Type: application/json");

// Handle POST request to generate a reset token
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Get the user's email from the POST request
    $data = json_decode(file_get_contents("php://input"), true);
    if (!isset($data["email"])) {
        echo json_encode(["error" => "Email is required."]);
        exit;
    }

    $email = $data["email"];

    $sql = "SELECT * FROM jobseeker WHERE JobSeekerEmail = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows !== 1) {
        echo json_encode(["error" => "Email not found in the database."]);
       exit();
    }

    
    $code = strval(mt_rand(100000, 999999));

    $timestamp = time();

    $checkQuery =$conn-> prepare( "SELECT * from seekerresettoken WHERE Email = ? ");

    $checkQuery->bind_param("s",$email);

    $checkQuery->execute();

    $checkResult = $checkQuery->get_result();

    if($checkResult-> num_rows > 0){//have previous record

        $updateToken = $conn->prepare( "UPDATE seekerresettoken  SET Token = ? , Timestamp = ? WHERE Email = ? ");

        $updateToken->bind_param("iis",$code,$timestamp,$email);

        $updateToken->execute();

    }
    else{//first time

    $stmt2 = $conn->prepare("INSERT INTO seekerresettoken (Email, Token, Timestamp) VALUES (?, ? , ?)");
     
    $stmt2->bind_param("sii", $email , $code , $timestamp);
    
    $stmt2->execute();

    }


        $Name = "";
        $retrieveNameQuery = "SELECT Name FROM jobseeker WHERE JobSeekerEmail = '$email'";

         $nameresult = $conn->query($retrieveNameQuery);

         if ($nameresult->num_rows > 0) {
           $namerow = $nameresult->fetch_assoc();
           $Name = $namerow["Name"];
        }

    // Send an email to the user with the reset token
    
    $to = $email;
    $subject = "Password Reset Code";

    $headers  = 'MIME-Version: 1.0' . "\r\n";
    $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
    $headers .= 'From: watheq.ksu@gmail.com'  . "\r\n";


     ob_start();
     include("messageTemplate.php");
     $message = ob_get_contents();
      ob_end_clean();

      $sent = mail($to, $subject, $message, $headers);
      
      if ($sent){
           echo json_encode(["message" => "Reset token generated successfully. Check your email for the reset link."]);
      }
      else{
          echo json_encode(["error" => "Email could not be sent."]);
      }
    



    // Close the database connection
    $stmt->close();
     $stmt2->close();
     $updateToken->close();
     $checkQuery->close();
    $nameresult->free();
    $update_stmt->close();
    $conn->close();
    
} else {
    // Handle other types of requests or provide an error response
    echo json_encode(["error" => "Invalid request method."]);
}



?>