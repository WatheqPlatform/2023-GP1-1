<?php

include("../../dbConnection.php");

$query = "SELECT DISTINCT Field CategoryName FROM qualification WHERE FieldFlag = 0 AND Field != '';"; 
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $data = array();
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    echo json_encode($data);
} else {
    echo "No qualifications found";
}

$conn->close();
?>
