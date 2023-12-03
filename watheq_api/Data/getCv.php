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

    // Iterate through the result set
    while ($row = $result->fetch_assoc()) {

        if (empty($selectedData)) {
            $selectedData['firstName'] = $row['FirstName'];
            $selectedData['lastName'] = $row['LastName'];
            $selectedData['phoneNumber'] = $row['PhoneNumber'];
            $selectedData['contactEmail'] = $row['ContactEmail'];
            $selectedData['summary'] = $row['Summary'];
            $selectedData['city'] = $row['CityID'];
            $selectedData['seekerEmail'] = $row['JobSeekerEmail'];
            $selectedData['ID'] = $row['CV_ID'];
        }

        $selectedData['awards'][] = array(
            'awardName' => $row['AwardName'],
            'issuedBy' => $row['IssuedBy'],
            'date' => $row['AwardDate'],
            'id' => $row['AwardID']
        );
        
        $selectedData['certificates'][] = array(
            'certificateName' => $row['CertificateName'],
            'issuedBy' => $row['CertificateIssuedBy'],
            'date' => $row['CertificateDate'],
            'id' => $row['CertificateID']
        );

        $selectedData['qualifications'][] = array(
            'DegreeLevel' => $row['DegreeLevel'],
            'Field' => $row['Field'],
            'FieldFlag' => $row['FieldFlag'],
            'StartDate' => $row['QualificationStartDate'],
            'EndDate' => $row['QualificationEndDate'],
            'IssuedBy' => $row['QualificationIssuedBy'],
            'id' => $row['QualificationID']
        );

        $selectedData['experiences'][] = array(
            'CategoryID' => $row['CategoryID'],
            'JobTitle' => $row['JobTitle'],
            'CompanyName' => $row['CompanyName'],
            'StartDate' => $row['ExperienceStartDate'],
            'EndDate' => $row['ExperienceEndDate'],
            'id' => $row['ExperienceId']
        );

        $selectedData['projects'][] = array(
            'ProjectName' => $row['ProjectName'],
            'Description' => $row['Description'],
            'Date' => $row['ProjectDate'],
            'id' => $row['ProjectID']
        );
        $selectedData['skills'][] = array(
            'Description' => $row['SkillDescription'],
            'id' => $row['SkillID']
        );
    }
    $selectedData['experiences'] = array_filter($selectedData['experiences'], function ($experience) {
        return $experience['CategoryID'] !== null;
    });
    $selectedData['awards'] = array_filter($selectedData['awards'], function ($award) {
        return $award['awardName'] !== null;
    });
    $selectedData['qualifications'] = array_filter($selectedData['qualifications'], function ($qualification) {
        return $qualification['DegreeLevel'] !== null;
    });
    $selectedData['projects'] = array_filter($selectedData['projects'], function ($project) {
        return $project['ProjectName'] !== null;
    });
    $selectedData['skills'] = array_filter($selectedData['skills'], function ($project) {
        return $project['Description'] !== null;
    });
    $selectedData['certificates'] = array_filter($selectedData['certificates'], function ($project) {
        return $project['certificateName'] !== null;
    });
    

    $selectStatement->close();

    $conn->close();
    
    echo json_encode(array('status' => 'success', 'data' => $selectedData));
} else {
    echo json_encode(array('status' => 'error', 'message' => 'Invalid request method'));
}

?>

