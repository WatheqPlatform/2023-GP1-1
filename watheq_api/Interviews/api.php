<?php
include("../../dbConnection.php"); // Assuming dbConnection.php initializes $conn with a mysqli connection

// Get JSON POST body
$content = file_get_contents("php://input");
$data = json_decode($content, true);

$status = $data['status'];
$pythonPath = '/home4/csfrybmy/python/Python-3.9.2/python';




// Prepare a response array
$response = [];


if ($status == 'start') {
    $job_seeker_email = $data['email'];
    $offer_id = $data['offerId'];

    // Fetch CV data with LEFT JOIN to ensure rows are returned even if some data is missing 
    $cv_query1 = "SELECT cv.FirstName, cv.Summary
                 FROM cv 
                 WHERE cv.JobSeekerEmail = ?";
    $stmt_cv = $conn->prepare($cv_query1);
    $stmt_cv->bind_param("s", $job_seeker_email);
    $stmt_cv->execute();
    $cv_result = $stmt_cv->get_result()->fetch_assoc();
    // Filter out null values from $cv_result 
    // $cv_result = array_filter($cv_result_raw);
    $first_name = $cv_result["FirstName"];
    $summary = $cv_result["Summary"];

    // Fetch CV skills 
    $cv_query2 = "SELECT  s.Description 
    FROM cv 
    LEFT JOIN skill s ON cv.CV_ID = s.CV_ID 
    WHERE cv.JobSeekerEmail = ?";

    $stmt_cv2 = $conn->prepare($cv_query2);
    $stmt_cv2->bind_param("s", $job_seeker_email);
    $stmt_cv2->execute();
    $cv_result_raw2 = $stmt_cv2->get_result()->fetch_all(MYSQLI_ASSOC);

    if (!empty($cv_result_raw2)) {
        // Extract the descriptions from the fetched data
        $descriptions = array_column($cv_result_raw2, "Description");

        // Create a comma-separated string of descriptions
        $CVskills = implode(", ", $descriptions);
    } else {
        $CVskills = "No skills.";
    }

    // Fetch experiences job titels  
    $cv_query3 = "SELECT  ce.JobTitle
    FROM cv 
    LEFT JOIN cvexperience ce ON cv.CV_ID = ce.CV_ID 
    WHERE cv.JobSeekerEmail = ?";

    $stmt_cv3 = $conn->prepare($cv_query3);
    $stmt_cv3->bind_param("s", $job_seeker_email);
    $stmt_cv3->execute();
    $cv_result_raw3 = $stmt_cv3->get_result()->fetch_all(MYSQLI_ASSOC);

    if (!empty($cv_result_raw3)) {
        // Extract the descriptions from the fetched data
        $descriptions = array_column($cv_result_raw3, "JobTitle");

        // Create a comma-separated string of descriptions
        $CVJobTitles = implode(", ", $descriptions);
    } else {
        $CVJobTitles = "No experinece.";
    }


    // Fetch offer data with LEFT JOIN 
    $offer_query = "SELECT jo.JobTitle, jo.JobDescription, s.Description AS SkillDescription 
                    FROM joboffer jo 
                    LEFT JOIN skill s ON jo.OfferID = s.OfferID 
                    WHERE jo.OfferID = ?";

    $stmt_offer = $conn->prepare($offer_query);
    $stmt_offer->bind_param("i", $offer_id);
    $stmt_offer->execute();
    $offer_result_raw = $stmt_offer->get_result()->fetch_assoc();
    // Filter out null values from $offer_result 
    $offer_result = array_filter($offer_result_raw);


    // Fetch offer data with LEFT JOIN 
    $offer_query2 = "SELECT Description 
                    FROM skill
                    WHERE OfferID = ?";

    $stmt_offer2 = $conn->prepare($offer_query2);
    $stmt_offer2->bind_param("i", $offer_id);
    $stmt_offer2->execute();
    $offer_result_raw2 = $stmt_offer2->get_result()->fetch_all(MYSQLI_ASSOC);


    if (!empty($offer_result_raw2)) {
        // Extract the descriptions from the fetched data
        $descriptions2 = array_column($offer_result_raw2, "Description");

        // Create a comma-separated string of descriptions
        $offerSkills = implode(", ", $descriptions2);
    } else {
        $offerSkills = "No required skills.";
    }

    // Convert filtered data to JSON strings 
    // $cv_data_str = escapeshellarg(json_encode($cv_result));
    // $offer_data_str = escapeshellarg(json_encode($offer_result));

   
    // Append job offer details to the context
    $job_title = $offer_result["JobTitle"];
    $job_description = $offer_result["JobDescription"];
    // $skill_description = $offer_result["SkillDescription"];

    $context = "In this interview simulation, you will be acting as my job interviewer.Your questions should be concise, limited to a single sentence, and it is important to not be longer than 100 letters. This is my CV details, containing my name, summary, skills, and the previous experience job titles, use the CV information to refer to me: my first name: " . $first_name . ". my summary:" . $summary . ", my skills: " . $CVskills . " and this is the positions I worked at before: " . $CVJobTitles . ".\nThis is the job offer details that you should refer to:\n\nJob Title: " . $job_title . "\nJob Description: " . $job_description . "\nThe rquired Skills: " . $offerSkills . "\n\nUse the job offer information to refer to the position during the interview, Remeber that your question should be about my CV and the Job Offer";
    // foreach ($cv_result as $key => $value) {
    //     if ($value === null) {
    //         $value = "N/A"; // Replace null with "N/A" or any other placeholder
    //     }
    //     $context .= ucfirst($key) . ": " . $value . " ";
    // }
    // $context .= "\naand This is the job offer details:   ";
    // foreach ($offer_result as $key => $value) {
    //     $context .= ucfirst(str_replace("Job", "", $key)) . ": " . $value . " ";
    // }



    // Execute Python script with status, filtered CV data, and offer data as arguments 
    $pythonResult = shell_exec("$pythonPath Interviews.py start \"$context\" 2>&1");


    $response = ['status' => 'success', 'result' => ($pythonResult)];

} elseif ($status == 'next' || $status == 'last') {
    $answer = isset($data['answer']) ? $data['answer'] : '';
    $thread_id = $data['thread_id'];

    $pythonResult = shell_exec("$pythonPath Interviews.py $status \"$answer\" \"$thread_id\" 2>&1");

    $response = ['status' => 'success', 'result' => ($pythonResult)];
} else {
    $response = ['status' => 'error', 'message' => 'Invalid status'];
}

header('Content-Type: application/json');
echo json_encode($response);
?>