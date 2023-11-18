<?php
session_start();
ini_set('display_errors', 1);
error_reporting(E_ALL);

if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit; 
}

include("../dbConnection.php");

$cvID = (int) $_GET["ID"];

// Fetch basic CV details along with city name
$sqlCv = "SELECT cv.FirstName, cv.LastName, cv.PhoneNumber, cv.ContactEmail, cv.Summary, city.CityName 
          FROM cv 
          LEFT JOIN city ON cv.CityID = city.CityID
          WHERE cv.CV_ID = ?";

$stmtCv = $conn->prepare($sqlCv);
$stmtCv->bind_param("i", $cvID);
$stmtCv->execute();
$resultCv = $stmtCv->get_result();
$cvRow = $resultCv->fetch_assoc(); // Fetch the CV details


// Function to fetch related data
function fetchRelatedData($conn, $sql, $cvID) {
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        // Prepare failed
        die("Prepare failed: " . $conn->error);
    }
    $stmt->bind_param("i", $cvID);
    if (!$stmt->execute()) {
        // Execute failed
        die("Execute failed: " . $stmt->error);
    }
    $result = $stmt->get_result();
    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
    $stmt->close();
    return $data;
}


// Fetch related data for the CV
$projects = fetchRelatedData($conn, "SELECT ProjectName, Description, Date FROM project WHERE CV_ID = ?", $cvID);
$skills = fetchRelatedData($conn, "SELECT Description FROM skill WHERE CV_ID = ?", $cvID);
$awards = fetchRelatedData($conn, "SELECT AwardName, IssuedBy, Date FROM award WHERE CV_ID = ?", $cvID);
$certificates = fetchRelatedData($conn, "SELECT CertificateName, IssuedBy, Date FROM certificate WHERE CV_ID = ?", $cvID);
$experience = fetchRelatedData($conn, "SELECT JobTitle, CompanyName, StartDate, EndDate, category.CategoryName FROM cvexperience LEFT JOIN category ON cvexperience.CategoryID = category.CategoryID WHERE cvexperience.CV_ID = ?", $cvID);
$qualifications = fetchRelatedData($conn, "SELECT StartDate, EndDate, IssuedBy, DegreeLevel, Field FROM cvqualification INNER JOIN qualification ON cvqualification.QualificationID = qualification.QualificationID WHERE CV_ID = ?", $cvID);

// Combine all data into a single array for the CV
$cvDetails = [
    'CV_Info' => $cvRow,
    'Projects' => $projects,
    'Skills' => $skills,
    'Awards' => $awards,
    'Certificates' => $certificates,
    'Qualifications' => $qualifications,
    'Experience' => $experience

];

$stmtCv->close();
$conn->close();
?>
