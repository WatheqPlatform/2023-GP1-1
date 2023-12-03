<?php

include("../../dbConnection.php");

$OfferID = $_POST["ID"];

$stmt = $conn->prepare("
SELECT
    joboffer.*,
    jobprovider.CompanyName,
    city.CityName,
    category.CategoryName,
    (
    SELECT
        IF(
            COUNT(experience.ExperienceID) = 0,
            JSON_ARRAY(), JSON_ARRAYAGG(
                experience.DISTINCT_JSON_OBJECT
            ))
        FROM
            (
            SELECT DISTINCT
                OfferID,
                offerexperince.ID ExperienceID,
                JSON_OBJECT(
                    'YearsOfExperience',
                    YearsOfExperience,
                    'ExperienceField',
                    category.CategoryName,
                    'Description',
                    ''
                ) AS DISTINCT_JSON_OBJECT
            FROM
                offerexperince
            LEFT JOIN category on category.CategoryID = offerexperince.CategoryID
        ) AS experience
    WHERE
        experience.OfferID = joboffer.OfferID
        ) AS experiences,
        (
        SELECT
            IF(
                COUNT(qualification.QualificationID) = 0,
                JSON_ARRAY(), JSON_ARRAYAGG(
                    qualification.DISTINCT_JSON_OBJECT
                ))
            FROM
                (
                SELECT DISTINCT
                    OfferID,
                    QualificationID,
                    JSON_OBJECT(
                        'DegreeLevel',
                        DegreeLevel,
                        'Field',
                        FIELD
                    ) AS DISTINCT_JSON_OBJECT
                FROM
                    offerqualification
                JOIN qualification USING(QualificationID)
            ) AS qualification
        WHERE
            qualification.OfferID = joboffer.OfferID
            ) AS qualifications,
            (
            SELECT
                IF(
                    COUNT(skill.SkillID) = 0,
                    JSON_ARRAY(), JSON_ARRAYAGG(skill.Description))
                FROM
                    skill
                WHERE
                    skill.OfferID = joboffer.OfferID
                ) AS skills
            FROM
                joboffer
            INNER JOIN jobprovider ON joboffer.JPEmail = jobprovider.JobProviderEmail
            INNER JOIN category ON joboffer.CategoryID = category.CategoryID
            LEFT JOIN city ON city.CityID = joboffer.CityID
            WHERE joboffer.OfferID = ?;
    ");

        
$stmt->bind_param("i", $OfferID);
$stmt->execute();
$result = $stmt->get_result();

        

$data =array();
while($row = $result->fetch_assoc()){
 $data[] = $row;   
}

echo json_encode($data);

$stmt->close();
$conn->close();

?>