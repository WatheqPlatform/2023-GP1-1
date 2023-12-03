<?php

include("../../dbConnection.php");

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $jobSeekerEmail = $_GET['jobSeekerEmail'];

    $selectQuery = "SELECT 
        CV.CV_ID, 
        CV.FirstName, 
        CV.LastName, 
        CV.PhoneNumber, 
        CV.ContactEmail, 
        CV.Summary, 
        CV.CityID, 
        CV.JobSeekerEmail,
        award.AwardID,
        award.AwardName, 
        award.IssuedBy, 
        DATE_FORMAT(award.Date, '%Y/%m/%e') as AwardDate,
        cvqualification.QualificationID,
        qualification.DegreeLevel,
        qualification.Field, 
        qualification.FieldFlag, 
        DATE_FORMAT(cvqualification.StartDate, '%Y/%m/%e') as QualificationStartDate, 
        DATE_FORMAT(cvqualification.EndDate, '%Y/%m/%e') as QualificationEndDate,
        cvqualification.IssuedBy as QualificationIssuedBy,
        cvexperience.ID as ExperienceId,
        cvexperience.CategoryID, 
        cvexperience.JobTitle, 
        cvexperience.CompanyName, 
        DATE_FORMAT(cvexperience.StartDate, '%Y/%m/%e')  as ExperienceStartDate, 
        DATE_FORMAT(cvexperience.EndDate, '%Y/%m/%e')  as ExperienceEndDate,
        project.ProjectID,
        project.ProjectName,
        project.Description, 
        DATE_FORMAT(project.Date, '%Y/%m/%e')  as ProjectDate,
        skill.Description as SkillDescription,
        skill.SkillID,
        certificate.CertificateID,
        certificate.CertificateName,
        certificate.IssuedBy as CertificateIssuedBy,
        DATE_FORMAT(certificate.Date, '%Y/%m/%e') as CertificateDate
    FROM 
        cv CV 
        LEFT JOIN award ON CV.CV_ID = award.CV_ID 
        LEFT JOIN cvqualification ON CV.CV_ID = cvqualification.CV_ID
        LEFT JOIN qualification ON cvqualification.QualificationID = qualification.QualificationID
        LEFT JOIN cvexperience ON CV.CV_ID = cvexperience.CV_ID 
        LEFT JOIN project ON CV.CV_ID = project.CV_ID
        LEFT JOIN skill on skill.CV_ID = CV.CV_ID
        left join certificate on certificate.CV_ID  = CV.CV_ID
    WHERE CV.JobSeekerEmail = ?";

    $selectStatement = $conn->prepare($selectQuery);
    $selectStatement->bind_param("s", $jobSeekerEmail);
    $selectStatement->execute();
    $result = $selectStatement->get_result();

    $selectedData = array();
    $cvDetailsAdded = false;

    // Initialize associative arrays for each section
    $selectedData['awards'] = [];
    $selectedData['certificates'] = [];
    $selectedData['qualifications'] = [];
    $selectedData['experiences'] = [];
    $selectedData['projects'] = [];
    $selectedData['skills'] = [];

    while ($row = $result->fetch_assoc()) {
        if (!$cvDetailsAdded) {
            $selectedData['firstName'] = $row['FirstName'];
            $selectedData['lastName'] = $row['LastName'];
            $selectedData['phoneNumber'] = $row['PhoneNumber'];
            $selectedData['contactEmail'] = $row['ContactEmail'];
            $selectedData['summary'] = $row['Summary'];
            $selectedData['city'] = $row['CityID'];
            $selectedData['seekerEmail'] = $row['JobSeekerEmail'];
            $selectedData['ID'] = $row['CV_ID'];
            $cvDetailsAdded = true;
        }

        // Awards
        if ($row['AwardName'] !== null) {
            $selectedData['awards'][$row['AwardID']] = [
                'awardName' => $row['AwardName'],
                'issuedBy' => $row['IssuedBy'],
                'date' => $row['AwardDate'],
                'id' => $row['AwardID']
            ];
        }

        // Certificates
        if ($row['CertificateName'] !== null) {
            $selectedData['certificates'][$row['CertificateID']] = [
                'certificateName' => $row['CertificateName'],
                'issuedBy' => $row['CertificateIssuedBy'],
                'date' => $row['CertificateDate'],
                'id' => $row['CertificateID']
            ];
        }

        // Qualifications
        if ($row['DegreeLevel'] !== null) {
            $selectedData['qualifications'][$row['QualificationID']] = [
                'DegreeLevel' => $row['DegreeLevel'],
                'Field' => $row['Field'],
                'FieldFlag' => $row['FieldFlag'],
                'StartDate' => $row['QualificationStartDate'],
                'EndDate' => $row['QualificationEndDate'],
                'IssuedBy' => $row['QualificationIssuedBy'],
                'id' => $row['QualificationID']
            ];
        }

        // Experiences
        if ($row['CategoryID'] !== null) {
            $selectedData['experiences'][$row['ExperienceId']] = [
                'CategoryID' => $row['CategoryID'],
                'JobTitle' => $row['JobTitle'],
                'CompanyName' => $row['CompanyName'],
                'StartDate' => $row['ExperienceStartDate'],
                'EndDate' => $row['ExperienceEndDate'],
                'id' => $row['ExperienceId']
            ];
        }

        // Projects
        if ($row['ProjectName'] !== null) {
            $selectedData['projects'][$row['ProjectID']] = [
                'ProjectName' => $row['ProjectName'],
                'Description' => $row['Description'],
                'Date' => $row['ProjectDate'],
                'id' => $row['ProjectID']
            ];
        }

        // Skills
        if ($row['SkillDescription'] !== null) {
            $selectedData['skills'][$row['SkillID']] = [
                'Description' => $row['SkillDescription'],
                'id' => $row['SkillID']
            ];
        }
    }

    // Convert associative arrays to indexed arrays
    foreach (['awards', 'certificates', 'qualifications', 'experiences', 'projects', 'skills'] as $section) {
        $selectedData[$section] = array_values($selectedData[$section]);
    }

    $selectStatement->close();
    $conn->close();

    echo json_encode(array('status' => 'success', 'data' => $selectedData));
} else {
    echo json_encode(array('status' => 'error', 'message' => 'Invalid request method'));
}

?>
