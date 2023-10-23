<?php


include("../dbConnection.php");

session_start();

if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit();
}

// Check if form is submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $jobTitle = $_POST['jobTitle'];
    $jobDescription = $_POST['jobDescription'];
    $jobField = $_POST['jobField'];
    $jobAddress = $_POST['jobAddress'];
    $jobType = $_POST['jobType'];
    $minSalary = $_POST['minSalary'];
    $maxSalary = $_POST['maxSalary'];
    $jobCategories = $_POST['jobCategories'];
    $jobCity = $_POST['jobCity'];

    $startingDate = $_POST['startingDate'];
    $workingHours = $_POST['workingHours'];
    $workingDays = $_POST['workingDays'];
    $notes = $_POST['notes'];
     $skills = $_POST['skills'];
     $qualifications = $_POST['qualifications'];
     $experiences = $_POST['experiences'];
    // Insert job offer data
    $date = date("Y-m-d");
    $jpEmail = $_SESSION['JPEmail'];
    
    // Prepare and execute a query to retrieve the CategoryID based on the CategoryName
    $stmtC = $conn->prepare("SELECT CategoryID FROM category WHERE CategoryName = ?");
    $stmtC->bind_param("s", $jobCategories);
    $stmtC->execute();
    $stmtC->bind_result($categoryID);
    $stmtC->fetch();
    $stmtC->close();
    
    // Prepare and execute the SQL query retrieve the CityID based on the CityName

$stmtCity = $conn->prepare("SELECT CityID FROM city WHERE CityName = ?");
$stmtCity->bind_param("s", $jobCity);
$stmtCity->execute();
$stmtCity->bind_result($cityID);
$stmtCity->fetch();
$stmtCity->close();







    $sql = "INSERT INTO joboffer (JobTitle, JobDescription, Field, EmploymentType, JobAddress, MinSalary, MaxSalary, Status, Date, JPEmail, Category, City, StartingDate, WorkingHours, WorkingDays, AdditionalNotes) 
            VALUES (?, ?, ?, ?, ?, ?, ?, 'Active', ?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssssssssssssss", $jobTitle, $jobDescription, $jobField, $jobType, $jobAddress, $minSalary, $maxSalary, $date, $jpEmail, $categoryID, $cityID, $startingDate, $workingHours, $workingDays, $notes);

    if ($stmt->execute()) {
        
        $offerID = $stmt->insert_id;
        $stmt->close();
        
        // Insert skills into the database
        if (isset($_POST['skills']) && $_POST['skills'] = !null) {
            $sql2 = "INSERT INTO skill (SkillName, OfferID) VALUES (?, ?)";
            $stmt2 = $conn->prepare($sql2);
            $stmt2->bind_param("si", $skill, $offerID);
           // $skills = $_POST['skills'];
            foreach ($skills as $skill) {
                // Execute the prepared statement
                $stmt2->execute();
            }
            $stmt2->close();
        }

        // Insert qualifications into the database
        if (isset($_POST['qualifications']) && $_POST['qualifications'] = !null) {
            $sql3 = "INSERT INTO qualification (DegreeLevel, Field, OfferID) VALUES (?, ?, ?)";
            $stmt3 = $conn->prepare($sql3);
            $stmt3->bind_param("ssi", $degreeLevel, $degreeField, $offerID);
//$qualifications = $_POST['qualifications'];
            foreach ($qualifications as $qualification) {
                $degreeLevel = $qualification['level'];
                $degreeField = $qualification['field'];

                // Execute the prepared statement
                $stmt3->execute();
            }
            $stmt3->close();
        }

        // Insert experiences into the database
        if (isset($_POST['experiences']) && $_POST['experiences'] = !null) {
            $sql4 = "INSERT INTO experience (YearsOfExperience, ExperienceField, Description, OfferID) VALUES (?, ?, ?, ?)";
            $stmt4 = $conn->prepare($sql4);
            $stmt4->bind_param("isss", $yearsOfExperience, $experienceField, $description, $offerID);

            foreach ($experiences as $experience) {
                $yearsOfExperience = $experience['years'];
                $experienceField = $experience['field'];
                $description = $experience['description'];

                // Execute the prepared statement
                $stmt4->execute();
            }
            $stmt4->close();
            
        }
        // Send success message to JavaScript
        echo "success"; 
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }

    $conn->close();
}
?>