<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit();
}

// Retrieve category options from the database
include("../dbConnection.php");
// Retrieve the rows from the "category" table
$sql = "SELECT * FROM category";
$result4 = $conn->query($sql);

// Prepare an array to store the category options
$options = array();

// Loop through the rows and add each category to the options array
while ($row = $result4->fetch_assoc()) {
    $options[] = $row;
}

// Return the options as JSON
echo json_encode($options);
?>