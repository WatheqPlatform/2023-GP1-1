<?php

include("../../dbConnection.php");

$query = "SELECT `CategoryID`, `CategoryName` FROM `category`";
$result = $conn->query($query);
if ($result->num_rows > 0) {
    
    $categories = array();
    while ($row = $result->fetch_assoc()) {
        $categories[] = $row;
    }

    echo json_encode($categories);
} else {
    echo "No Categories found";
}

$conn->close();
?>
