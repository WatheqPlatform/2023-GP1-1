<?php


include("../../dbConnection.php");


$response = [];

// Handle POST request to verify the entered code
if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $data = json_decode(file_get_contents("php://input"), true);

    if (!isset($data["email"]) || !isset($data["code"])) {

        $response["error"] = "Email and code are required.";

    } else {

        $email = $data["email"];
        $enteredCode = $data["code"];


    $stmt = $conn->prepare("SELECT Token ,Timestamp FROM seekerresettoken WHERE Email =  ? ");
     
    $stmt->bind_param("s", $email);
   
     $stmt->execute();

     $result = $stmt->get_result();
    

    if ($result->num_rows > 0) {// code has been generated and stored for email

        $row = $result->fetch_assoc();
        $storedCode = $row["Token"];
        $timestamp = $row["Timestamp"];

        // Check if the token is still valid (e.g., not expired)
        $expirationTime = 3 * 60; // Token expires after 3 minutes 
        if ((time() - $timestamp < $expirationTime) && ($enteredCode == $storedCode)) {

            $response["message"] = "Code is valid. You can reset your password now.";
        }
        else{

            $response["error"] = "Invalid or expired code. Please request a new code.";

        }

    $stmt->close();
    $conn->close();

} } } else {
    $response["error"] = "Invalid request method.";
}

// Send the response as JSON
header("Content-Type: application/json");
echo json_encode($response);
?>



