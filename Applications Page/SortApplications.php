<?php

session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit; 
}

include("../dbConnection.php");

// Check if the request is an AJAX request
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $offerID = $_SESSION['OfferID'];
    $sortingOption = $_POST['sort']; 
    $_SESSION['Sorting']=true;

    if($sortingOption !== 'similar'){
        // Query to retrieve job applications along with CV details for the specified job offer
        $sql = 'SELECT application.*, cv.CV_ID, cv.FirstName, cv.LastName, cv.ContactEmail, cv.PhoneNumber, cv.Summary
        FROM application
        INNER JOIN cv ON application.JobSeekerEmail = cv.JobSeekerEmail
        WHERE application.OfferID = ? AND Status= "Pending"';

        $sql .= ($sortingOption === 'new') ? 'ORDER BY application.ApplicationID DESC' : ' ORDER BY application.ApplicationID ASC';

        // Prepare and execute the query
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $offerID);
        $stmt->execute();

        $result = $stmt->get_result();
        $PendingApplications = array();
        while ($row = $result->fetch_assoc()) {
            $ApplicationID = $row["ApplicationID"];
            $CVID = $row["CV_ID"];
            $ContactEmail = $row["ContactEmail"];
            $JobSeekerName = $row["FirstName"] . " <br>" . $row["LastName"];
            $JobSeekerPhone = $row["PhoneNumber"];
            $Status = $row["Status"];
            $Summary = $row["Summary"];

            // Create an application array
            $PendingApplications[]= array(
                "ApplicationID" => $ApplicationID,
                "CVID" => $CVID,
                "ContactEmail" => $ContactEmail,
                "Name" => $JobSeekerName,
                "PhoneNumber" => $JobSeekerPhone,
                "Summary" => $Summary,
                "Status" => $Status
            );
        }
    } else {
        // Sorint based on similarity
        include("../Recommendation System.php");
        
        // Query to retrieve job applications along with CV details for the specified job offer
        $sql = 'SELECT application.*, cv.CV_ID, cv.FirstName, cv.LastName, cv.ContactEmail, cv.PhoneNumber, cv.Summary
        FROM application
        INNER JOIN cv ON application.JobSeekerEmail = cv.JobSeekerEmail
        WHERE application.OfferID = ? AND Status= "Pending"';
        
        // Prepare and execute the query
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("i", $offerID);
        $stmt->execute();
        
        $result = $stmt->get_result();
        $PendingApplications = array();
        while ($row = $result->fetch_assoc()) {
            $ApplicationID = $row["ApplicationID"];
            $CVID = $row["CV_ID"];
            $ContactEmail = $row["ContactEmail"];
            $JobSeekerName = $row["FirstName"] . " <br>" . $row["LastName"];
            $JobSeekerPhone = $row["PhoneNumber"];
            $Status = $row["Status"];
            $Summary = $row["Summary"];
        
            // Create an application array
            $PendingApplications[] = array(
                "ApplicationID" => $ApplicationID,
                "CVID" => $CVID,
                "ContactEmail" => $ContactEmail,
                "Name" => $JobSeekerName,
                "PhoneNumber" => $JobSeekerPhone,
                "Summary" => $Summary,
                "Status" => $Status
            );
        }
        
        foreach ($PendingApplications as &$application) {
            $application['totalScore'] = $cvSimilarityResults[$application['CVID']]['totalScore'];
        }
        
        //Sort based on highest score
        usort($PendingApplications, function ($a, $b) {
            return $b['totalScore'] <=> $a['totalScore'];
        });
        
        // Ensure to unset the reference to avoid issues in subsequent code
        unset($application);
    }
    
    // Initialize an empty string to concatenate the HTML content
    $pendingApplicationsHTML = '';

    // Loop through each pending application
    foreach ($PendingApplications as $application) {
        // Concatenate the HTML content for each application
        $pendingApplicationsHTML .= "<div id='WholeApplication'>";
        $pendingApplicationsHTML .= "<div id='FirstPart' class='".$application['Status']."'>";
        $pendingApplicationsHTML .= "<p id='Title'>Applicant Name</p>";
        $pendingApplicationsHTML .= "<p id='ApplicantName'>{$application['Name']}</p>";
        $pendingApplicationsHTML .= "<p><a href='../CV Page/CV.php?ID=".$application["CVID"]."'>View Applicant CV <i class='fa-solid fa-arrow-right'></i></a></p>";
        $pendingApplicationsHTML .= "</div>";
        $pendingApplicationsHTML .= "<div id='SecondPart'>";
        $pendingApplicationsHTML .= "<p id='Status'class='".$application['Status']."'>{$application['Status']} Application</p>";
        $pendingApplicationsHTML .= "<p id='Summary'>" . trim(preg_replace('/\s+/', ' ', $application['Summary'])) . "</p>";
        $pendingApplicationsHTML .= "<div id='BottomDiv'>";
        $pendingApplicationsHTML .= "<div id='ContactDiv'>";
        $pendingApplicationsHTML .= "<p id='Email'><i class='bi bi-envelope icon-space'> </i>  {$application['ContactEmail']}</p>";
        $pendingApplicationsHTML .= "<p id='Number'><i class='bi bi-telephone icon-space'> </i>0{$application['PhoneNumber']}</p>";
        $pendingApplicationsHTML .= "</div>";
        
        $pendingApplicationsHTML .= "<div id='Buttons'>";
        $pendingApplicationsHTML .= "<button type='button' class='accept-button' data-application-id='{$application['ApplicationID']}'>Accept</button>";
        $pendingApplicationsHTML .= "<button type='button' class='reject-button' data-application-id='{$application['ApplicationID']}'>Reject</button>";
        $pendingApplicationsHTML .= "</div>";

        $pendingApplicationsHTML .= "</div>"; // end of BottomDiv
        $pendingApplicationsHTML .= "</div>"; // end of SecondPart
        $pendingApplicationsHTML .= "</div>"; // end of WholeApplication
    }

    // Output the concatenated HTML content
    echo $pendingApplicationsHTML;
    
} else {
    // Handle non-AJAX requests
}

