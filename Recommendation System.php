<?

include("dbConnection.php");

if (php_sapi_name() === 'cli') {
    // Command line access - for app notification
    if ($argc > 1) { // Check if an argument exists
        $offerID = $argv[1];
      $threshold = $argv[2]; 
      // Get the threshold from the command line argument// Get the OfferID from the command line argument
        $sorting=0;
    } else {
        echo "No offer ID provided via command line.";
        exit();
    }
} else {
    // Web server access - for sorting
    session_start();
    if (isset($_SESSION['OfferID'])) {
        $offerID = $_SESSION['OfferID'];
        $sorting = $_SESSION['Sorting'];
    } else {
        echo "No offer ID found in session.";
        exit();
    }
}


$absolutePathToPythonScript = __DIR__ . '/Pre-prosessing.py';

//To store all the similarity results of the CVs
$cvSimilarityResults = array();


// City Code
// Fetch OfferCity from database
$offerCityQuery = "SELECT CityID FROM joboffer WHERE OfferID = '$offerID' "; 
$offerCityResult = $conn->query($offerCityQuery);
$offerCity = $offerCityResult->fetch_assoc();

// Fetch CVCity from database
if($sorting){
    $cvCityQuery = "SELECT DISTINCT cv.CV_ID, cv.CityID
    FROM cv
    JOIN application ON cv.JobSeekerEmail = application.JobSeekerEmail
    WHERE OfferID = $offerID"; 
} else{
    $cvCityQuery = "SELECT CV_ID, CityID FROM cv";
}

$cvCityResult = $conn->query($cvCityQuery);
while ($cvCityRow = $cvCityResult->fetch_assoc()) {
    $cvCities[] = $cvCityRow;
}

//Find the city similarity score for each CV 
foreach ($cvCities as $cv) {
    if ($cv['CityID'] == $offerCity['CityID']) {
        $cvSimilarityResults[$cv['CV_ID']]["city"] = 1;
        $cvSimilarityResults[$cv['CV_ID']]["skills"] = 0;
        $cvSimilarityResults[$cv['CV_ID']]["experience"] = 0;
        $cvSimilarityResults[$cv['CV_ID']]["qualification"] = 0;
    }
    else{
       $cvSimilarityResults[$cv['CV_ID']]["city"] = 0;
       $cvSimilarityResults[$cv['CV_ID']]["skills"] = 0;
       $cvSimilarityResults[$cv['CV_ID']]["experience"] = 0;
       $cvSimilarityResults[$cv['CV_ID']]["qualification"] = 0;
    }
}

//Availability of the city in job offer is always 1 since it is mandatory
$aCity=1;




// Skills Code
// Fetch OfferSkills from database
$offerSkillsQuery = "SELECT GROUP_CONCAT(Description) AS skills FROM skill WHERE OfferID = '$offerID'";
$offerSkillsResult = mysqli_query($conn, $offerSkillsQuery);
while ($offerSkillsRow  = $offerSkillsResult->fetch_assoc()) {
        $offerSkills[]=$offerSkillsRow;   
}

//Availability of the skill in job offer
$aSkill= mysqli_num_rows($offerSkillsResult) !== 0 ? 1:0;

if($aSkill===1){
    // Fetch CVSkills from database
    if ($sorting){
        $cvSkillsQuery = "SELECT cv.CV_ID, 
        GROUP_CONCAT(s.Description) AS skills
        FROM cv
        JOIN application a ON cv.JobSeekerEmail = a.JobSeekerEmail
        JOIN skill s ON cv.CV_ID = s.CV_ID
        WHERE a.OfferID = $offerID AND cv.CV_ID IS NOT NULL
        GROUP BY cv.CV_ID"; 
    } else{
        $cvSkillsQuery = "SELECT CV_ID, GROUP_CONCAT(Description) AS skills FROM skill WHERE CV_ID IS NOT NULL GROUP BY CV_ID";
    }
    $cvSkillsResult = mysqli_query($conn, $cvSkillsQuery);
    while ($cvSkillsRow  = $cvSkillsResult->fetch_assoc()) {
        $cvSkills[]=$cvSkillsRow;
    }
    
    //Encode to json before send it to python
    $cvSkillsDataJson = json_encode($cvSkills);
    $offerSkillsDataJson= json_encode($offerSkills);
    
    //Send the data to python for preprosessing
    $command = "python3 " . escapeshellarg($absolutePathToPythonScript) . " " . escapeshellarg($cvSkillsDataJson) . " " . escapeshellarg($offerSkillsDataJson); 
    $output = shell_exec($command);
    
    //Receive the data back from python after preprosessing
    $outputArray = json_decode($output, true);
    $cvSkillsInfo = $outputArray[0];
    $offerSkillsInfo = $outputArray[1];

    //Find the skills similarity score for each CV 
    foreach ($cvSkillsInfo as $cv) {
        $similarity = jaccard_similarity_variant($cv['skills'], $offerSkillsInfo[0]['skills']);
        // Add the similarity score to the CV array
        $cvSimilarityResults[$cv['CV_ID']]["skills"] = $similarity;
    }   
}




// Qualifications Code
// Fetch OfferQualification from database
$offerQualificationQuery = "SELECT q.DegreeLevel, q.Field FROM offerqualification oq JOIN qualification q ON oq.QualificationID = q.QualificationID WHERE oq.OfferID = '$offerID'"; //!!!! ID TO BE CHANGED
$offerQualificationResult = $conn->query($offerQualificationQuery);
while ($offerQualificationRow = $offerQualificationResult->fetch_assoc()) {
    $offerQualifications[] = $offerQualificationRow;
}

//Availability of the qualification in job offer
$aQualification= mysqli_num_rows($offerQualificationResult) !== 0 ? 1:0;

if($aQualification ==1){
    // Fetch CVQualification from database
    if ($sorting){
        $cvQualificationQuery = "SELECT cv.CV_ID, 
        q.Field,
        q.DegreeLevel
        FROM cv
        JOIN cvqualification cvq ON cv.CV_ID = cvq.CV_ID
        JOIN qualification q ON cvq.QualificationID = q.QualificationID
        JOIN application a ON cv.JobSeekerEmail = a.JobSeekerEmail
        WHERE a.OfferID = $offerID"; 
    } else{
        $cvQualificationQuery = "SELECT CV_ID, q.Field, q.DegreeLevel FROM cvqualification cvq JOIN qualification q ON cvq.QualificationID = q.QualificationID;";
    }
    $cvQualificationResult = $conn->query($cvQualificationQuery);
    while ($cvQualificationRow = $cvQualificationResult->fetch_assoc()) {
        $cvQualifications[] = $cvQualificationRow;
    } 
    
    //Encode to json before send it to python
    $cvQualificationDataJson =json_encode($cvQualifications);
    $offerQualificationDataJson =json_encode($offerQualifications);
    
    //Send the data to python for preprosessing
    $command = "python3 " . escapeshellarg($absolutePathToPythonScript) . " " . escapeshellarg($cvQualificationDataJson) . " " . escapeshellarg($offerQualificationDataJson);
    $output = shell_exec($command);
    
    //Receive the data back from python after preprosessing
    $outputArray = json_decode($output, true);
    $cvQualificationInfo = $outputArray[0];
    $offerQualificationInfo = $outputArray[1];
   
    // Calculate qualification similarity of a single cv with an offer
    function calculate_qualification_similarity($cv, $offer) {
        $jaccardScore = jaccard_similarity_variant($cv['Field'], $offer['Field']);
        $DegreeLevelMatch = ($cv['DegreeLevel'] == $offer['DegreeLevel']) ? 1 : 0;
        return ($jaccardScore + $DegreeLevelMatch) / 2;
    }
    
    //Find the max experince similarity score for each CV 
    foreach ($cvQualificationInfo as $cv) {
        $max_similarity = 0;
        foreach ($offerQualificationInfo as $offer) {
            $similarity = calculate_qualification_similarity($cv, $offer);
            if ($similarity > $max_similarity) {
                $max_similarity = $similarity;
            }
        }
        // Add the maximum similarity score to the CV array
        if($max_similarity > $cvSimilarityResults[$cv['CV_ID']]["qualification"]){
            $cvSimilarityResults[$cv['CV_ID']]["qualification"]= $max_similarity;
        }
    }
} 




// Experinces Code
// Fetch OfferExperience from database
$offerExperinceQuery = "SELECT JobTitle, CategoryID, YearsOfExperience FROM offerexperince WHERE OfferID = '$offerID' "; 
$offerExperinceResult = $conn->query($offerExperinceQuery);
while ($offerExperinceRow = $offerExperinceResult->fetch_assoc()) {
    $offerExperiences[] = $offerExperinceRow;
}

//Availability of the experince in job offer
$aExperience= mysqli_num_rows($offerExperinceResult) !== 0 ? 1:0;

if($aExperience==1){
    // Fetch CVExperience from database
    if ($sorting){
        $cvExperinceQuery = "SELECT ce.JobTitle, 
        ce.StartDate, 
        ce.EndDate, 
        ce.CategoryID, 
        cv.CV_ID
        FROM cvexperience ce
        JOIN cv ON ce.CV_ID = cv.CV_ID
        JOIN application a ON cv.JobSeekerEmail = a.JobSeekerEmail
        WHERE a.OfferID = $offerID"; 
    } else{
        $cvExperinceQuery = "SELECT JobTitle, StartDate, EndDate, CategoryID, CV_ID FROM cvexperience";
    }
    $cvExperinceResult = $conn->query($cvExperinceQuery);
    while ($cvExperinceRow = $cvExperinceResult->fetch_assoc()) {
        $cvExperiences[] = $cvExperinceRow;
    }
    
    //Encode to json before send it to python
    $cvExperinceDataJson =json_encode($cvExperiences);
    $offerExperinceDataJson =json_encode($offerExperiences);
    
    //Send the data to python for preprosessing
    $command = "python3 " . escapeshellarg($absolutePathToPythonScript) . " " . escapeshellarg($cvExperinceDataJson) . " " . escapeshellarg($offerExperinceDataJson);
    $output = shell_exec($command);
    
    //Receive the data back from python after preprosessing
    $outputArray = json_decode($output, true);
    $cvExperinceInfo = $outputArray[0];
    $offerExperinceInfo = $outputArray[1];
    
    // Calculate similarity between years of experince
    function calculate_years_similarity($jobExperienceYears, $cvStartDate, $cvEndDate) {
        // If EndDate is null, consider it as the current date
        if ($cvEndDate === null) {
            $cvEndDate = date('Y-m-d');
        }
    
        //Convert end and start dates to seconds
        $startTimestamp = strtotime($cvStartDate);
        $endTimestamp = strtotime($cvEndDate);
    
        // Calculate the difference in months
        $difference = ($endTimestamp - $startTimestamp) / (60 * 60 * 24 * 30.44); 
        $cvMonths = round($difference); 
        
        $jobMonths = $jobExperienceYears * 12;
    
        if ($cvMonths >= $jobMonths) {
            return 1;
        } else {
           return max(0, 1 - (($jobMonths - $cvMonths) / $jobMonths));
        }
    }
    
    // Calculate experince similarity of a single cv with an offer
    function calculate_experince_similarity($cv, $offer) {
        $jaccardScore = jaccard_similarity_variant($cv['JobTitle'], $offer['JobTitle']);
        $yearsMatch = calculate_years_similarity($offer['YearsOfExperience'], $cv['StartDate'], $cv['EndDate']);
        $categoryIdMatch = ($cv['CategoryID'] == $offer['CategoryID']) ? 1 : 0;
        return ($jaccardScore + $yearsMatch + $categoryIdMatch) / 3;
    }
    
    //Find the max experince similarity score for each CV 
    foreach ($cvExperinceInfo as $cv) {
        $max_similarity = 0;
        foreach ($offerExperinceInfo as $offer) {
            $similarity = calculate_experince_similarity($cv, $offer);
            if ($similarity > $max_similarity) {
                $max_similarity = $similarity;
            }
        }
        if($max_similarity > $cvSimilarityResults[$cv['CV_ID']]["experience"]){
            $cvSimilarityResults[$cv['CV_ID']]["experience"]= $max_similarity;
        }
    }
}




//Calculate the similarity between two set of words
function jaccard_similarity_variant($cv, $offer) {
    //Convert to array of words
    $setCV = explode(" ", $cv);
    $setOffer = explode(" ", $offer);

    $intersection = count(array_intersect($setCV, $setOffer));
    $offerCount = count($setOffer);

    return $offerCount == 0 ? 0 : $intersection / $offerCount;
}




// Calculate the wieghts for the final equation
// Fetch Weights from database
$wieghtQuery = "SELECT Wcity, Wexperience, Wskill, Wqualification FROM joboffer WHERE OfferID = '$offerID'"; 
$wieghtResult = $conn->query($wieghtQuery);
$wieght = $wieghtResult->fetch_assoc();

$wCity = $wieght['Wcity'];
$wSkill = $wieght['Wskill'];
$wQualification = $wieght['Wqualification'];
$wExperience = $wieght['Wexperience'];




//Calculate the total score
foreach ($cvSimilarityResults as $cvID => $scores) {
    $totalScore = 0;

    // Calculate the total score using weights and availabilities
    $totalScore += $cvSimilarityResults[$cvID]['city'] * $wCity * $aCity; 
    $totalScore +=  $cvSimilarityResults[$cvID]['qualification'] * $wQualification * $aQualification;
    $totalScore +=  $cvSimilarityResults[$cvID]['experience']  * $wExperience * $aExperience;
    $totalScore +=  $cvSimilarityResults[$cvID]['skills']  * $wSkill * $aSkill;
    
    // Add the total score to the CV's array, rounding to two decimal places
    $cvSimilarityResults[$cvID]['totalScore'] = round($totalScore, 2);
}




//MUST BE CHANGED
//Send Notification 
if ($sorting == 0 ){
    $date = date("Y-m-d");
    foreach ($cvSimilarityResults as $cvID => $scores) {
        
        if ($scores['totalScore'] >= $threshold) {
            // Retrieve job provider email
            $stmtEmail = $conn->prepare("SELECT JPEmail FROM joboffer WHERE OfferID=?");
            $stmtEmail->bind_param("i", $offerID);
            $stmtEmail->execute();
            $stmtEmail->bind_result($jobProviderEmail);

            // Fetch the result into variables
            $stmtEmail->fetch();

            // Close the first prepared statement
            $stmtEmail->close();
            
            // Fetch the seeker Email using cv id
            $query = $conn->prepare("SELECT JobSeekerEmail FROM cv WHERE CV_ID = ?");
            $query->bind_param("i", $cvID); 
            $query->execute();
            $result = $query->get_result();

            if ($result->num_rows > 0) {
                $row = $result->fetch_assoc();
                $seekerEmail = $row['JobSeekerEmail'];
                
        $details = "match:$offerID:" . $scores['totalScore'];
                // Insert into the notification table
                $insertQuery = $conn->prepare("INSERT INTO notification (JSEmail, Details, JPEmail, Date) VALUES (?, ?, ?, ?) ");
                $insertQuery->bind_param("ssss", $seekerEmail, $details, $jobProviderEmail, $date); 
                $insertQuery->execute();
            }
            
        }
        
    }
}

?>
