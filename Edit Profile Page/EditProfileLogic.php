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
    $sql_update_jobprovider = "UPDATE jobprovider SET CompanyName = ? WHERE JobProviderEmail = ?";
    $stmt_update_jobprovider = $conn->prepare($sql_update_jobprovider);
    $stmt_update_jobprovider->bind_param("ss", $CompanyName, $jpEmail);
    if (!$stmt_update_jobprovider->execute()) {
        echo "Error updating company name: " . $stmt_update_jobprovider->error;
        exit();
    }

    // Update company profile details in the profile table
    $CompanyDescription = $_POST['Description'];
    $CompanyAddress = $_POST['Location'];
    $CompanyEmail = $_POST['Email'];
    $CompanyPhone = $_POST['Phone'];
    $CompanyLinkedin = $_POST['Linkedin'];
    $CompanyX = $_POST['X'];
    $CompanyURL = $_POST['URL'];

    $sql_update_profile = "UPDATE profile SET Description = ?, Location = ?, Email = ?, Phone = ?, Linkedin = ?, Twitter = ?, Link = ? WHERE JobProviderEmail = ?";
    $stmt_update_profile = $conn->prepare($sql_update_profile);
    $stmt_update_profile->bind_param("ssssssss", $CompanyDescription, $CompanyAddress, $CompanyEmail, $CompanyPhone, $CompanyLinkedin, $CompanyX, $CompanyURL, $jpEmail);
    if (!$stmt_update_profile->execute()) {
        echo "Error updating company profile: " . $stmt_update_profile->error;
        exit();
    }

    // Send success message to JavaScript
    echo "success";
} else {
    // Handle cases where the form is not submitted
}
?>
