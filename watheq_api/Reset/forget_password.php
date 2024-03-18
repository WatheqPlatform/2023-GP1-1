<?php
include("../../dbConnection.php");
header("Content-Type: application/json");

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $data = json_decode(file_get_contents("php://input"), true);

    // Check if session_id is provided in the request and set it
    if (isset($data["session_id"])) {
        session_id($data["session_id"]);
       
    }
    
    session_start();


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
    $_SESSION['reset_token'] = $code;
    $_SESSION['token_timestamp'] = time();
    
    $Name = "";
    $retrieveNameQuery = "SELECT Name FROM jobseeker WHERE JobSeekerEmail = '$email'";
    $nameresult = $conn->query($retrieveNameQuery);

    if ($nameresult->num_rows > 0) {
        $namerow = $nameresult->fetch_assoc();
        $Name = $namerow["Name"];
    }
    
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
      
    if ($sent) {
        // Provide the session_id back in the response, regardless of whether it was newly generated or provided in the request
        echo json_encode(["message" => "Reset token sent to your email.", "session_id" => session_id()]);
    } else {
        echo json_encode(["error" => "There was an error sending the email."]);
    }
} else {
    echo json_encode(["error" => "Invalid request method."]);
}
?>
