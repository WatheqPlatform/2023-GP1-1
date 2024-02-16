<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit();
}

include("../dbConnection.php");

// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $jpEmail = $_SESSION['JPEmail'];
    $CompanyName = $_POST['Name'];

    // Update company name in the jobprovider table
    $sql = "UPDATE jobprovider SET CompanyName = ? WHERE JobProviderEmail = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $CompanyName, $jpEmail);
    if (!$stmt->execute()) {
        echo "Error updating company name: " . $stmt->error;
        exit();
    }

    // Insert company profile details into the profile table
    $CompanyDescription = $_POST['Description'];
    $CompanyAddress = $_POST['Location'];
    $CompanyEmail = $_POST['Email'];
    $CompanyPhone = $_POST['Phone'];
    $CompanyLinkedin = $_POST['Linkedin'];
    $CompanyX = $_POST['X'];
    $CompanyURL = $_POST['URL'];

    // Check and prepend "https://" if not present
    $CompanyLinkedin = addHttpsPrefix($CompanyLinkedin);
    $CompanyX = addHttpsPrefix($CompanyX);
    $CompanyURL = addHttpsPrefix($CompanyURL);

    $sql = "INSERT INTO profile (JobProviderEmail, Description, Location, Email, Phone, Linkedin, Twitter, Link) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssssssss", $jpEmail, $CompanyDescription, $CompanyAddress, $CompanyEmail, $CompanyPhone, $CompanyLinkedin, $CompanyX, $CompanyURL);
    if (!$stmt->execute()) {
        echo "Error inserting company profile details: " . $stmt->error;
        exit();
    }

    // Send success message to JavaScript
    echo "success";
    
} else {
    
}

// Function to add "https://" prefix if not present
function addHttpsPrefix($url) {
    if (!empty($url) && !preg_match("#^https?://#i", $url)) {
        $url = "https://" . $url;
    }
    return $url;
}

?>
