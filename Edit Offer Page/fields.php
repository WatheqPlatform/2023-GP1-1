<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit();
}

// Retrieve category options from the database
include("../dbConnection.php");

// Query to retrieve distinct rows from the "Field" column
$query = "SELECT DISTINCT Field FROM qualification WHERE FieldFlag = 0 ORDER BY Field ASC";
$result = $conn->query($query);
$fieldOptions = array();

// Loop through the rows and add each field to the options array
while ($row = $result->fetch_assoc()) {
    $fieldOptions[] = $row;
}

// Return the options as JSON
echo json_encode($fieldOptions);


?>