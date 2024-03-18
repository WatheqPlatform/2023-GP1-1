<?php
include("../../dbConnection.php");

header('Content-Type: application/json');

$email = isset($_POST['email']) ? $_POST['email'] : '';

$response = ['success' => false, 'unseen_count' => 0];

if (!empty($email)) {
    // Prepare the SQL statement to count unseen notifications
    $sql = "SELECT COUNT(*) as unseen_count FROM notification WHERE JSEMAIL = ? AND isSeen = 0 AND Details LIKE '%:%'";

    if ($stmt = $conn->prepare($sql)) {
        // Bind variables to the prepared statement as parameters
        $stmt->bind_param("s", $email);
        
        // Attempt to execute the prepared statement
        if ($stmt->execute()) {
            // Store result
            $result = $stmt->get_result();
            
            // Fetch result row as an associative array
            if ($row = $result->fetch_assoc()) {
                $response['success'] = true;
                $response['unseen_count'] = $row['unseen_count'];
            }
        } else {
            $response['message'] = "Error executing query.";
        }

        // Close statement
        $stmt->close();
    } else {
        $response['message'] = "Error preparing query.";
    }
} else {
    $response['message'] = "Email is required.";
}

// Close connection
$conn->close();

// Echo the response as JSON
echo json_encode($response);
?>
