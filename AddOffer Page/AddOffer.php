<?php
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

    // Save the data to the database
    $servername = "localhost";
    $username = "root";
    $password = "root";
    $dbname = "watheqdb";

    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }

    // Insert job offer data
    $date = date("Y-m-d");
    $jpEmail = $_SESSION['JPEmail'];

    $sql = "INSERT INTO JobOffer (JobTitle, JobDescription, Field, EmploymentType, LocationAddress, MinSalary, MaxSalary, Status, Date, JPEmail, Category, City, StartingDate, WorkingHours, WorkingDays, AdditionalNotes) 
            VALUES (?, ?, ?, ?, ?, ?, ?, 'Active', ?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssssssssssssss", $jobTitle, $jobDescription, $jobField, $jobType, $jobAddress, $minSalary, $maxSalary, $date, $jpEmail, $jobCategories, $jobCity, $startingDate, $workingHours, $workingDays, $notes);
    
    if ($stmt->execute()) {
        $offerID = $stmt->insert_id;
        echo "success"; // Send success message to JavaScript

        // Insert skills into the database
        if ($skills !== null) {
            $sql2 = "INSERT INTO skill (SkillName, OfferID) VALUES (?, ?)";
            $stmt2 = $conn->prepare($sql2);
            $stmt2->bind_param("si", $skill, $offerID);

            foreach ($skills as $skill) {
                // Execute the prepared statement
                $stmt2->execute();
            }
        }

        // Insert qualifications into the database
        if ($qualifications !== null) {
            $sql3 = "INSERT INTO qualification (DegreeLevel, Field, OfferID) VALUES (?, ?, ?)";
            $stmt3 = $conn->prepare($sql3);
            $stmt3->bind_param("ssi", $degreeLevel, $degreeField, $offerID);

            foreach ($qualifications as $qualification) {
                $degreeLevel = $qualification['level'];
                $degreeField = $qualification['field'];

                // Execute the prepared statement
                $stmt3->execute();
            }
        }

        // Insert experiences into the database
        if ($_POST['experiences'] !== null) {
            $sql4 = "INSERT INTO experience (YearsOfExperience, ExperienceField, Description, OfferID) VALUES (?, ?, ?, ?)";
            $stmt4 = $conn->prepare($sql4);
            $stmt4->bind_param("isss", $yearsOfExperience, $experienceField, $description, $offerID);

            foreach ($_POST['experiences'] as $experience) {
                $yearsOfExperience = $experience['years'];
                $experienceField = $experience['field'];
                $description = $experience['description'];

                // Execute the prepared statement
                $stmt4->execute();
            }
        }
        
        
        
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }

    $conn->close();
}
?>