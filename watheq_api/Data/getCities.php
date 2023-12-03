<?php

include("../../dbConnection.php");

$query = "SELECT CityId, CityName FROM city"; // Modify the query to select both CityId and CityName
$result = $conn->query($query);

// Check if there are results
if ($result->num_rows > 0) {
    // Fetch data and store in an array
    $cities = array();
    while ($row = $result->fetch_assoc()) {
        $cities[] = $row;
    }

    // Convert the array to a JSON format and echo it
    echo json_encode($cities);
} else {
    echo "No cities found";
}

$conn->close();
?>
