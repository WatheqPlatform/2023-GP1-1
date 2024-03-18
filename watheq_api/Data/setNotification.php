<?php


include("../../dbConnection.php");

$email = $_POST['email'];

// Prepare the SQL statement to update the isSeen attribute
$sql = $conn->prepare("UPDATE notification SET isSeen = 1 WHERE JSEMAIL = ? AND Details LIKE '%:%'");

// Bind the email parameter and execute the update
$sql->bind_param("s", $email);
$result = $sql->execute();



// Close the connection
$conn->close();



?>
