<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);
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
    $qualifications = $_POST['qualifications'];
    $skills = isset($_POST['skills']) ? $_POST['skills'] : null;
    $experiences = isset($_POST['experiences']) ? $_POST['experiences'] : null;

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

    $sql = "INSERT INTO joboffer (JobTitle, JobDescription, EmploymentType, JobAddress, MinSalary, MaxSalary, Status, Date, JPEmail, CategoryID, CityID, StartingDate, WorkingHours, WorkingDays, AdditionalNotes) 
            VALUES (?, ?, ?, ?, ?, ?, 'Active', ?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssssssssiissss", $jobTitle, $jobDescription, $jobType, $jobAddress, $minSalary, $maxSalary, $date, $jpEmail, $categoryID, $cityID, $startingDate, $workingHours, $workingDays, $notes);

    if ($stmt->execute()) {

        $offerID = $stmt->insert_id;
        $stmt->close();

        // Insert skills into the database
        if (isset($_POST['skills']) && $_POST['skills'] = !null) {
            $sql2 = "INSERT INTO skill (Description, OfferID) VALUES (?, ?)";
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
        if (isset($_POST['qualifications']) && $_POST['qualifications'] !== null) {
            $sql3 = "INSERT INTO offerqualification (OfferID, QualificationID) VALUES (?, ?)";
            $stmt3 = $conn->prepare($sql3);
            $stmt3->bind_param("ii", $offerID, $searchResult);

            foreach ($qualifications as $qualification) {
                $degreeLevel = $qualification['level'];
                $degreeField = $qualification['field'];

                if ($degreeField == "Other") {
                    $qualificationOther = $qualification['other'];

                    // Insert the new qualification into the qualification table
                    $insertQualification = "INSERT INTO qualification (DegreeLevel, Field, FieldFlag) VALUES (?, ?, 1)";
                    $stmtInsertQualification = $conn->prepare($insertQualification);
                    $stmtInsertQualification->bind_param("ss", $degreeLevel, $qualificationOther);
                    $stmtInsertQualification->execute();

                    // Get the inserted QualificationID
                    $searchResult = $stmtInsertQualification->insert_id;

                    $stmtInsertQualification->close();
                } else {
                    $SearchQualification = "SELECT QualificationID FROM qualification WHERE DegreeLevel = ? AND Field = ?";
                    $stmtSearchQualification = $conn->prepare($SearchQualification);
                    $stmtSearchQualification->bind_param("ss", $degreeLevel, $degreeField);
                    $stmtSearchQualification->execute();
                    $result = $stmtSearchQualification->get_result();
                    $row = $result->fetch_assoc();
                    $searchResult = (int) $row['QualificationID'];

                    $stmtSearchQualification->close();
                }

                // Execute the prepared statement
                $stmt3->execute();
            }

            $stmt3->close();
        }

        // Insert experiences into the database
        if (isset($_POST['experiences']) && $_POST['experiences'] !== null) {
            $sql4 = "INSERT INTO offerexperince (YearsOfExperience, CategoryID, JobTitle, OfferID) VALUES (?, ?, ?, ?)";
            $stmt4 = $conn->prepare($sql4);
            $stmt4->bind_param("iisi", $yearsOfExperience, $CategoryID, $JobTitle, $offerID);

            foreach ($experiences as $experience) {

                $yearsOfExperience = $experience['years'];
                $experienceCategory = $experience['Category'];
                $JobTitle = $experience['JobTitle'];

                $stmtCC = $conn->prepare("SELECT CategoryID FROM category WHERE CategoryName = ?");
                $stmtCC->bind_param("s", $experienceCategory);
                $stmtCC->execute();
                $stmtCC->bind_result($CategoryID);
                $stmtCC->fetch();
                $stmtCC->close();
                // Execute the prepared statement
                $stmt4->execute();
            }
            $stmt4->close();
        }
        // Send success message to JavaScript
        echo "success";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error; // we have to delete the sql after we finish!!!
        echo mysqli_error($conn);
    }

    $conn->close();
}
?>