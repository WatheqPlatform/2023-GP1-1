<?php

include("../../dbConnection.php");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);

    $firstName = $data['firstName'];
    $lastName = $data['lastName'];
    $phoneNumber = $data['phoneNumber'];
    $contactEmail = $data['contactEmail'];
    $seekerEmail = $data['seekerEmail'];
    $summary = $data['summary'];
    $city = $data['city'];
    $ID = null;
    $cvID = 0;
    if (isset($data['ID'])) {
        $ID = $data['ID'] == 0 ? null : $data['ID'];
        $cvQuery = "INSERT INTO cv (CV_ID, JobSeekerEmail, FirstName, LastName, PhoneNumber, ContactEmail, CityID, Summary) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE
        JobSeekerEmail = VALUES(JobSeekerEmail),
        FirstName = VALUES(FirstName),
        LastName = VALUES(LastName),
        PhoneNumber = VALUES(PhoneNumber),
        ContactEmail = VALUES(ContactEmail),
        CityID = VALUES(CityID),
        Summary = VALUES(Summary);";
        $cvStatement = $conn->prepare($cvQuery);
        $cvStatement->bind_param("isssssss",$ID, $seekerEmail, $data['firstName'], $data['lastName'], $data['phoneNumber'], $data['contactEmail'], $data['city'], $data['summary']);
        $cvStatement->execute();
        if ($ID == null) {
            $cvID = $conn->insert_id;
        }
        else {
            $cvID = $ID;
        }
    }
    $skillIdsArray = array_column($data['skills'], 'id');
    
        $deleteSql = "DELETE FROM skill WHERE CV_ID = ? ";
        if (count($skillIdsArray) > 0){
            $deleteSql .= "AND SkillID NOT IN (" . implode(',', array_fill(0, count($skillIdsArray), '?')) . ")";
        }
        $deleteStmt = $conn->prepare($deleteSql);
        $deleteStmt->bind_param(str_repeat('i', count($skillIdsArray) + 1), $cvID, ...$skillIdsArray);
        $deleteStmt->execute();
        $deleteStmt->close();
    

    
    $insertUpdateSql = "INSERT INTO skill (SkillID, Description, CV_ID) VALUES (?, ?, ?)
                    ON DUPLICATE KEY UPDATE Description = VALUES(Description)";

    $stmt = $conn->prepare($insertUpdateSql);
    if (isset($data['skills']) && is_array($data['skills'])) {
        foreach ($data['skills'] as $skill) {
            if (isset($skill['Description'])) {
                $stmt->bind_param("isi", $skill['id'], $skill['Description'], $cvID);
                $stmt->execute();
             }
        }
    }
    
    
    $awardIdsArray = array_column($data['awards'], 'id');

    $deleteAwardSql = "DELETE FROM award WHERE CV_ID = ? ";
    if (count($awardIdsArray) > 0 ){ 
        $deleteAwardSql .= "AND AwardID NOT IN (" . implode(',', array_fill(0, count($awardIdsArray), '?')) . ")";
    }
    $deleteAwardStmt = $conn->prepare($deleteAwardSql);
    $deleteAwardStmt->bind_param(str_repeat('i', count($awardIdsArray) + 1), $cvID, ...$awardIdsArray);
    $deleteAwardStmt->execute();
    $deleteAwardStmt->close();
    

    $insertUpdateAwardSql = "INSERT INTO award (AwardID, CV_ID, AwardName, IssuedBy, Date) 
                            VALUES (?, ?, ?, ?, ?)
                            ON DUPLICATE KEY UPDATE AwardName = VALUES(AwardName), IssuedBy = VALUES(IssuedBy), Date = VALUES(Date)";
    $insertUpdateAwardStmt = $conn->prepare($insertUpdateAwardSql);

    foreach ($data['awards'] as $award) {
        $date = date('Y-m-d', strtotime(str_replace('/', '-', $award['date'])));
        $awardID = $award['id'];

        $insertUpdateAwardStmt->bind_param("iisss", $awardID, $cvID, $award['awardName'], $award['issuedBy'], $date);
        $insertUpdateAwardStmt->execute();
    }

    $insertUpdateAwardStmt->close();

    
    $certificateIdsArray = array_column($data['certificates'], 'id');
     
    $deleteCertificateSql = "DELETE FROM certificate WHERE CV_ID = ? ";
    if (count($certificateIdsArray) > 0) {
        $deleteCertificateSql .= "AND CertificateID NOT IN (" . implode(',', array_fill(0, count($certificateIdsArray), '?')) . ")";
    }
    $deleteCertificateStmt = $conn->prepare($deleteCertificateSql);
    $deleteCertificateStmt->bind_param(str_repeat('i', count($certificateIdsArray) + 1), $cvID, ...$certificateIdsArray);
    $deleteCertificateStmt->execute();
    $deleteCertificateStmt->close();
     
    $insertUpdateCertificateSql = "INSERT INTO certificate (CertificateID, CV_ID, CertificateName, IssuedBy, Date) 
                                VALUES (?, ?, ?, ?, ?)
                                ON DUPLICATE KEY UPDATE CertificateName = VALUES(CertificateName), IssuedBy = VALUES(IssuedBy), Date = VALUES(Date)";
    $insertUpdateCertificateStmt = $conn->prepare($insertUpdateCertificateSql);
    foreach ($data['certificates'] as $certificate) {
        $date = date('Y-m-d', strtotime(str_replace('/', '-', $certificate['date'])));
        $certificateID = $certificate['id'];
        $insertUpdateCertificateStmt->bind_param("iisss", $certificateID, $cvID, $certificate['certificateName'], $certificate['issuedBy'], $date);
        $insertUpdateCertificateStmt->execute();
    }

    $insertUpdateCertificateStmt->close();
    
    $qualificationIdsArray = array_column($data['qualifications'], 'id');
    
        $deleteQualificationSql = "DELETE qualification, cvqualification 
                           FROM qualification 
                           LEFT JOIN cvqualification ON qualification.QualificationID = cvqualification.QualificationID
                           WHERE cvqualification.CV_ID = ?";
        if (count($qualificationIdsArray) > 0){
            $deleteQualificationSql .= " AND qualification.QualificationID NOT IN (" . implode(',', array_fill(0, count($qualificationIdsArray), '?')) . ")";
        }
        $deleteQualificationStmt = $conn->prepare($deleteQualificationSql);
        $deleteQualificationStmt->bind_param(str_repeat('i',1+ count($qualificationIdsArray)), $cvID,...$qualificationIdsArray);

        $deleteQualificationStmt->execute();
        $deleteQualificationStmt->close();
    $insertUpdateQualificationSql = "INSERT INTO qualification (QualificationID, DegreeLevel, Field, FieldFlag) 
                                    VALUES (?, ?, ?, ?)
                                    ON DUPLICATE KEY UPDATE DegreeLevel = VALUES(DegreeLevel), Field = VALUES(Field), FieldFlag = VALUES(FieldFlag)";
    $insertUpdateQualificationStmt = $conn->prepare($insertUpdateQualificationSql);

    $insertUpdateCvQualificationSql = "INSERT INTO cvqualification (CV_ID, QualificationID, StartDate, EndDate, IssuedBy) 
                                        VALUES (?, ?, ?, ?, ?)
                                        ON DUPLICATE KEY UPDATE StartDate = VALUES(StartDate), EndDate = VALUES(EndDate), IssuedBy = VALUES(IssuedBy)";
    $insertUpdateCvQualificationStmt = $conn->prepare($insertUpdateCvQualificationSql);

    foreach ($data['qualifications'] as $qualification) {
        $qualificationID =  $qualification['id'];
        $insertUpdateQualificationStmt->bind_param("issi", $qualificationID, $qualification['DegreeLevel'], $qualification['Field'], $qualification['FieldFlag']);
        $insertUpdateQualificationStmt->execute();

        $qId = $conn->insert_id;
        if ($qualificationID == null) {
            $qualificationID = $qId;
        }

        
        $sdate = date('Y-m-d', strtotime(str_replace('/', '-', $qualification['StartDate'])));
        $endDate = $qualification['EndDate'];
        if ($endDate !== null) {
            $endDate = date('Y-m-d', strtotime(str_replace('/', '-', $endDate)));
        }
        $insertUpdateCvQualificationStmt->bind_param("issss", $cvID, $qualificationID, $sdate, $endDate, $qualification['IssuedBy']);
        $insertUpdateCvQualificationStmt->execute();
    }

    $insertUpdateQualificationStmt->close();
    $insertUpdateCvQualificationStmt->close();

        
    $experienceIdsArray = array_column($data['experiences'], 'id');
    
        $deleteExperienceSql = "DELETE FROM cvexperience WHERE CV_ID = ? ";
        if (count($experienceIdsArray) > 0 ){
            $deleteExperienceSql .= "AND ID NOT IN (" . implode(',', array_fill(0, count($experienceIdsArray), '?')) . ")";
        }
        $deleteExperienceStmt = $conn->prepare($deleteExperienceSql);
        $deleteExperienceStmt->bind_param("i" . str_repeat('i', count($experienceIdsArray)), $cvID, ...$experienceIdsArray);

        $deleteExperienceStmt->execute();
        $deleteExperienceStmt->close();
    
    $insertUpdateExperienceSql = "INSERT INTO cvexperience (ID, CategoryID, JobTitle, CompanyName, StartDate, EndDate, CV_ID) 
                                VALUES (?, ?, ?, ?, ?, ?, ?)
                                ON DUPLICATE KEY UPDATE CategoryID = VALUES(CategoryID), JobTitle = VALUES(JobTitle), 
                                CompanyName = VALUES(CompanyName), StartDate = VALUES(StartDate), EndDate = VALUES(EndDate)";
    $insertUpdateExperienceStmt = $conn->prepare($insertUpdateExperienceSql);

    foreach ($data['experiences'] as $experience) {
        $experienceID = isset($experience['id']) ? $experience['id'] : null;

        $sdate = date('Y-m-d', strtotime(str_replace('/', '-', $experience['StartDate'])));
        $endDate = $experience['EndDate'];
        if ($endDate !== null) {
            $edate = date('Y-m-d', strtotime(str_replace('/', '-', $endDate)));
        }

        $insertUpdateExperienceStmt->bind_param("iissssi", $experienceID, $experience['CategoryID'], $experience['JobTitle'], $experience['CompanyName'], $sdate, $edate, $cvID);
        $insertUpdateExperienceStmt->execute();
    }

    $insertUpdateExperienceStmt->close();

    $projectIdsArray = array_column($data['projects'], 'id');
    
        $deleteProjectSql = "DELETE FROM project WHERE CV_ID = ?";
        if (count($projectIdsArray) > 0 ){
            $deleteProjectSql .= " AND ProjectID NOT IN (" . implode(',', array_fill(0, count($projectIdsArray), '?')) . ")";
        }
        $deleteProjectStmt = $conn->prepare($deleteProjectSql);

        $deleteProjectStmt->bind_param("i" . str_repeat('i', count($projectIdsArray)), $cvID, ...$projectIdsArray);

        $deleteProjectStmt->execute();
        $deleteProjectStmt->close();
    
    $insertUpdateProjectSql = "INSERT INTO project (ProjectID, CV_ID, ProjectName, Description, Date) 
                            VALUES (?, ?, ?, ?, ?)
                            ON DUPLICATE KEY UPDATE ProjectName = VALUES(ProjectName), Description = VALUES(Description), Date = VALUES(Date)";
    $insertUpdateProjectStmt = $conn->prepare($insertUpdateProjectSql);

    foreach ($data['projects'] as $project) {
        $projectID = isset($project['id']) ? $project['id'] : null;

        $sdate = date('Y-m-d', strtotime(str_replace('/', '-', $project['Date'])));
        
        $insertUpdateProjectStmt->bind_param("iisss", $projectID, $cvID, $project['ProjectName'], $project['Description'], $sdate);
        $insertUpdateProjectStmt->execute();
    }

    $insertUpdateProjectStmt->close();

    
    $cvStatement->close();
    $stmt->close();
    $conn->close(); 

    echo json_encode(array('status' => 'success'));
} else {
    // Return an error response if the request method is not POST
    echo json_encode(array('status' => 'error', 'message' => 'Invalid request method'));
}

?>