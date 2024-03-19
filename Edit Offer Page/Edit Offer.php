<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit();
}

$email = $_SESSION['JPEmail'];

include("../dbConnection.php");
// Retrieve the rows from the "category" table
$sql = "SELECT * FROM category";
$result = $conn->query($sql);
$result4 = $conn->query($sql);
// Fetch the cities from the "city" table
$sql2 = "SELECT CityName FROM city ORDER BY CityName ASC";
$result2 = $conn->query($sql2);

// Query to retrieve distinct rows from the "Field" column
$query = "SELECT DISTINCT Field FROM qualification WHERE FieldFlag = 0 ORDER BY Field ASC";
$result3 = $conn->query($query);

$offerID = $_GET ["ID"];
$stmt = $conn->prepare("SELECT JobTitle, JobDescription, EmploymentType, JobAddress, MinSalary, MaxSalary, 
        Date, StartingDate, WorkingDays, WorkingHours, AdditionalNotes, CategoryID,
        CityID, Wexperience, Wqualification, Wskill, Wcity
        FROM joboffer
        WHERE OfferID = ?");
$stmt->bind_param("i", $offerID);
$stmt->execute();
$result5 = $stmt->get_result();

// Fetch the row from the result
$row = $result5->fetch_assoc();

$jobTitle = $row['JobTitle'];
$jobDescription1 = $row['JobDescription'];
$jobDescription = trim($jobDescription1);
$employmentType = $row['EmploymentType'];
$jobAddress = $row['JobAddress'];
$minSalary = $row['MinSalary'];
$maxSalary = $row['MaxSalary'];
$date = $row['Date'];
$startingDate = $row['StartingDate'];
$workingDays = $row['WorkingDays'];
$workingHours = $row['WorkingHours'];
$additionalNotes1 = $row['AdditionalNotes'];
$additionalNotes = trim($jobDescription1);
$industryID = $row['CategoryID'];
$cityID = $row['CityID'];
$wcity = $row ['Wcity'];
$Wskill = $row ['Wskill'];
$Wqualification = $row ['Wqualification'];
$Wexperience = $row ['Wexperience'];

$nonZeroAttributes = array();

if ($wcity != 0) {
    $nonZeroAttributes[] = $wcity;
}

if ($Wskill != 0) {
    $nonZeroAttributes[] = $Wskill;
}

if ($Wqualification != 0) {
    $nonZeroAttributes[] = $Wqualification;
}

if ($Wexperience != 0) {
    $nonZeroAttributes[] = $Wexperience;
}
$equalValues = true;

if (count($nonZeroAttributes) > 1) {
    $firstValue = $nonZeroAttributes[0];

    foreach ($nonZeroAttributes as $value) {
        if ($value !== $firstValue) {
            $equalValues = false;
            break;
        }
    }
}





// Perform a SELECT query on the city table
$cityQuery = 'SELECT CityName FROM city WHERE CityID = ' . $cityID;
$cityResult = $conn->query($cityQuery);
$cityRow = $cityResult->fetch_assoc();
$city = $cityRow['CityName'];

// Perform a SELECT query on the category table
$industryQuery = 'SELECT CategoryName FROM category WHERE CategoryID = ' . $industryID;
$industryResult = $conn->query($industryQuery);
$industryRow = $industryResult->fetch_assoc();
$industry = $industryRow ['CategoryName'];

// retreive Skills
$skillsQuery = "SELECT Description FROM skill WHERE OfferID = " . $offerID;
$skillsResult = $conn->query($skillsQuery);
// Fetch all skills and store them in an array
$skills = array();
while ($row = $skillsResult->fetch_assoc()) {
    $skills[] = $row['Description'];
}
// Count the number of rows returned by the query
$numRows = count($skills);
if ($numRows > 0) {
// Retrieve the first skill and append it to the existing HTML code
    $firstSkill = $skills[0];
    if ($numRows > 1) {
        $skillsJson = json_encode($skills);
    }
}
// retrieve qualifications
$qualificationIDs = array();
$qualificationQuery = "SELECT QualificationID FROM offerqualification WHERE OfferID = " . $offerID;
$qualificationResult = $conn->query($qualificationQuery);

// Fetch qualification IDs
while ($qualificationRow = $qualificationResult->fetch_assoc()) {
    $qualificationIDs[] = $qualificationRow['QualificationID'];
}

$QnumRows = count($qualificationIDs);
if ($QnumRows > 0) {
// Fetch qualification details
    $qualificationDetailsQuery = "SELECT * FROM qualification WHERE QualificationID IN (" . implode(',', $qualificationIDs) . ")";
    $qualificationDetailsResult = $conn->query($qualificationDetailsQuery);
}


$experiences = array();
$experienceQuery = "SELECT oe.JobTitle, oe.CategoryID, oe.YearsOfExperience, c.CategoryName
                    FROM offerexperince oe
                    INNER JOIN category c ON oe.CategoryID = c.CategoryID
                    WHERE oe.OfferID = " . $offerID;
$experienceResult = $conn->query($experienceQuery);

// Fetch experiences
while ($experienceRow = $experienceResult->fetch_assoc()) {
    $experiences[] = $experienceRow;
}
?>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'> <!--Icons retrevial-->                
        <link href="https://fonts.googleapis.com/css?family=Lato:100" rel="stylesheet">
        <link rel="stylesheet" href="Editoffer.css">
        <link rel="icon" href="../Images/Icon.png">
        <title>Job Editing Form - Watheq</title>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script> <!--Icons retrevial-->      
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script> <!--Icons retrevial-->      
        <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script> <!--Icons retrevial-->   
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="../Functions/Logout.js"></script>
        <script src="numInputsValidation.js"></script>
        <script src="AddNewExperience.js"></script>
        <script src="AddNewSkill.js"></script>
        <script src="AddNewQualification.js"></script>
        <script src="FormNavigation.js"></script>
        <script src="Validate.js"></script>
        <script src="ranking.js"></script>
        <script src="checkAttributes.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sortablejs@1.13.0/Sortable.min.js"></script>
        <script src="retrieveSkill.js"></script>
        <script src="../Functions/DisplayNotification.js"></script> 
        <script>
            var equalValues = <?php echo $equalValues ? 'true' : 'false'; ?>;
        </script>
    </head>

    <body>

        <div id="Main">

            <div id="Header">

                <div id="HeaderStart">
                    <a href="../Home Page/Home.php" id="LogoLink">
                        <img src="../Images/White Logo.png" alt="Watheq Logo" id="logo">
                    </a>
                    <a href="../Home Page/Home.php"> Home </a>
                    <a href="../Profile Page/Profile.php"> Profile </a>
                    <a href="../History Page/History.php" id="CurrentPage"> Job Offers </a>
                    <a href="../AddOffer Page/AddOffer.php" > Add Offer </a> 
                </div>

                <div id="HeaderEnd">
                    <div class="social-icons">
                        <a href="https://www.facebook.com/profile.php?id=61552475874538"  id="facebook" title="facebook"> 
                            <i class="fa-brands fa-square-facebook" aria-hidden="true"></i>
                        </a>
                        <a href="https://twitter.com/WatheqPlatform" id="twitter" title="twitter"> 
                            <i class="fa-brands fa-square-x-twitter" aria-hidden="true"></i>
                        </a>
                        <a href="https://www.linkedin.com/in/watheq-platform-980a02295/" id="linkedin" title="linkedin">
                            <i class="fa-brands fa-linkedin" aria-hidden="true"></i>
                        </a>
                        <a href="https://www.youtube.com/channel/UCoKOXPubwqwW0TiycHcrvdw" id="youtube" title="youtube">
                            <i class="fa-brands fa-square-youtube" aria-hidden="true"></i>
                        </a>
                    </div>
                </div>

            </div>


            <div id="Content">

                <div id="MenuButtons">
                    <!-- Notification Code -->
                    <?php
                    include("../dbConnection.php");
                    $NotificationQuery = "SELECT n.Date, n.isSeen, n.Details, cv.FirstName, cv.LastName, jo.JobTitle, jo.Status
                    FROM notification n
                    JOIN cv ON n.JSEmail = cv.JobSeekerEmail
                    JOIN joboffer jo ON n.Details = jo.OfferID
                    WHERE n.JPEmail = '$email' AND n.Details REGEXP '^[0-9]+$'
                    ORDER BY n.Date DESC";
                
                    $resultNotification = $conn->query($NotificationQuery);
                
                    // Store results in an array
                    $notifications = [];

                    // Check if there are any unseen notifications
                    $hasUnseenNotification = false;

                    if ($resultNotification->num_rows > 0) {
                        while ($NotificationRow = $resultNotification->fetch_assoc()) {
                            $notifications[] = $NotificationRow;
                            $isSeen = $NotificationRow["isSeen"];
                            $details = $NotificationRow["Details"];
                            $date = $NotificationRow["Date"];
                            $status = $NotificationRow["Status"];
                            $firstName = $NotificationRow["FirstName"];
                            $lastName = $NotificationRow["LastName"];
                            $jobTitle = $NotificationRow["JobTitle"];
                            
                            // Check if the notification is unseen
                            if ($isSeen == 0) {
                                $hasUnseenNotification = true;
                            }
                        }
                        if($hasUnseenNotification){
                            echo '<div id="NotificationCircle"></div>';
                        }
                    }
                    ?>
                    <ion-icon name="notifications-outline"  id="Bell"></ion-icon>
                    <button id="logoutButton">Log Out</button>    
                </div>

                <!--Form  content starts here-->
                <div class="wrapper">

                    <!--Progress Bar-->
                    <div class="header">
                        <ul>
                            <li class="active form_1_progessbar">
                                <div>
                                    <p>1</p>
                                </div>
                            </li>
                            <li class="form_2_progessbar">
                                <div>
                                    <p>2</p>
                                </div>
                            </li>
                            <li class="form_3_progessbar">
                                <div>
                                    <p>3</p>
                                </div>
                            </li>
                            <li class="form_4_progessbar">
                                <div>
                                    <p>4</p>
                                </div>
                            </li>
                            <li class="form_5_progessbar">
                                <div>
                                    <p>5</p>
                                </div>
                            </li>
                            <li class="form_6_progessbar">
                                <div>
                                    <p>6</p>
                                </div>
                            </li>
                            <li class="form_7_progessbar">
                                <div>
                                    <p>7</p>
                                </div>
                            </li>
                        </ul>
                    </div>

                    <!--Form Container-->
                    <div class="form_wrap">

                        <form id="EditForm" method="POST">
                            <input type="hidden" id="offerID" value="<?php echo $offerID; ?>">

                            <!--First Form-->
                            <div class="form_1 data_info">

                                <h2>Basic Information</h2>

                                <div class="form_container">
                                    <div class="input_wrap">
                                        <label for="jobTitle">Job Title<span class="required"></span></label>
                                        <input type="text" name="jobTitle" class="input" id="jobTitle" maxlength="25" value='<?php echo $jobTitle; ?>'>
                                    </div>
                                    <div class="input_wrap">
                                        <label for="jobType">Employment Type<span class="required"></span></label>
                                        <select name="jobType" class="input select" id="jobType">
                                            <option disabled></option>
                                            <option value="full-time" <?php echo ($employmentType == 'full-time') ? 'selected' : ''; ?>>Full Time</option>
                                            <option value="part-time" <?php echo ($employmentType == 'part-time') ? 'selected' : ''; ?>>Part Time</option>
                                        </select>
                                    </div>
                                    <div class="input_wrap">
                                        <label for="job-categories">Job Industry<span class="required"></span></label>
                                        <select name="job-categories" id="job-categories" class="input select" >
                                            <?php
// Check if there are any rows
                                            if ($result->num_rows > 0) {
                                                // Start the select field

                                                echo '<option disabled selected></option>';

                                                // Loop through the rows and print the options
                                                while ($row = $result->fetch_assoc()) {
                                                    //        echo '<option value="' . $row["CategoryName"] . '">' . $row["CategoryName"] . '</option>';
                                                    $categoryName = $row["CategoryName"];
                                                    $selected = ($categoryName == $industry) ? 'selected' : '';
                                                    echo '<option value="' . $categoryName . '" ' . $selected . '>' . $categoryName . '</option>';
                                                }

                                                // End the select field
                                            } else {
                                                echo "No categories found.";
                                            }
                                            ?>
                                        </select>
                                    </div>

                                    <div class="input_wrap">
                                        <label for="jobCity">Job City<span class="required"></span></label>
                                        <select name="jobCity" id="jobCity" class="input select">
                                            <option disabled selected></option>
                                            <?php
// Generate the HTML options

                                            if ($result2->num_rows > 0) {
                                                while ($row = $result2->fetch_assoc()) {


                                                    $cityName = $row["CityName"];
                                                    $selected = ($cityName == $city) ? 'selected' : '';
                                                    echo '<option value="' . $cityName . '" ' . $selected . '>' . $cityName . '</option>';
                                                }
                                            } else {
                                                echo "No cities found.";
                                            }
                                            ?>

                                        </select>
                                    </div>
                                    <div class="input_wrap">
                                        <label for="jobAddress">Job Address<span class="required"></span></label>
                                        <input type="text" name="jobAddress" class="input" id="jobAddress" maxlength="100" value='<?php echo $jobAddress; ?>'>
                                    </div>
                                    <div class="input_wrap">
                                        <label for="jobDescription">Job Description<span class="required"></span></label>
                                        <textarea name="jobDescription" class="input" id="jobDescription" maxlength="300" > <?php echo $jobDescription; ?> </textarea>
                                    </div> 
                                </div>

                            </div>

                            <!--Second Form-->
                            <!-- All non required fields except for salary-->
                            <div class="form_2 data_info" style="display: none;">

                                <h2>Additional Information</h2>

                                <div class="form_container">
                                    <div class="input_wrap">  
                                        <label for="minSalary">Minimum Salary<span class="required"></span></label>
                                        <input type="number" name="minSalary" class="input" id="minSalary" value='<?php echo $minSalary; ?>' onkeyup="validateNumericInput(this, '1')" min="0">
                                        <span id="warningMessage1">Please enter a valid number</span>

                                    </div>
                                    <div class="input_wrap">  
                                        <label for="maxSalary">Maximum Salary<span class="required"></span></label>
                                        <input type="number" name="maxSalary" class="input" id="maxSalary" value='<?php echo $maxSalary ?>' onkeyup="validateNumericInput(this, '2')" min='0' >
                                        <span id="warningMessage2">Please enter a valid number</span>
                                        <span id="warningMessageMaxSalary">Maximum salary must be greater than minimum salary</span>
                                    </div>
                                    <div class="input_wrap">
                                        <label for="date">Starting Date</label> 
                                        <input type="date" name="date" class="input" id="date" <?php echo isset($startingDate) ? 'value="' . $startingDate . '"' : ''; ?> min="<?php echo date('Y-m-d'); ?>">
                                    </div>
                                    <div class="input_wrap">
                                        <label for="workingHours">Working Hours Per Day</label> 
                                        <input type="number" name="workingHours" class="input" id="workingHours" value="<?php echo isset($workingHours) ? $workingHours : ''; ?>" onkeyup="validateNumericInput(this, '3')" max="24">
                                        <span id="warningMessage3">Please enter a valid number</span>
                                    </div>
                                    <div class="input_wrap checklist">
                                        <label for="day">Working Days</label> <!-- not required-->
                                        <label>
                                            <input type="checkbox" name="day[]" value="sunday" <?php echo in_array('sunday', explode(', ', $workingDays)) ? 'checked' : ''; ?>>
                                            Sunday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day[]" value="monday" <?php echo in_array('monday', explode(', ', $workingDays)) ? 'checked' : ''; ?>>
                                            Monday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day[]" value="tuesday" <?php echo in_array('tuesday', explode(', ', $workingDays)) ? 'checked' : ''; ?>>
                                            Tuesday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day[]" value="wednesday" <?php echo in_array('wednesday', explode(', ', $workingDays)) ? 'checked' : ''; ?>>
                                            Wednesday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day[]" value="thursday" <?php echo in_array('thursday', explode(', ', $workingDays)) ? 'checked' : ''; ?>>
                                            Thursday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day[]" value="friday" <?php echo in_array('friday', explode(', ', $workingDays)) ? 'checked' : ''; ?>>
                                            Friday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day[]" value="saturday" <?php echo in_array('saturday', explode(', ', $workingDays)) ? 'checked' : ''; ?>>
                                            Saturday
                                        </label>
                                    </div>
                                </div>

                            </div>


                           
                            <!--Third Form-->
                            <!-- All non required fields-->
                            <div class="form_3 data_info" style="display: none;">
                                <h2>Required Skills</h2>

                                <div class="form_container" id="skillsContainer">
                                    <div class="input_wrap Multiable" id="skill0">                                                    
                                        <h4> Skill 1: </h4>
                                        <input type="text" name="skills[0]" class="input" id="skillInput" maxlength= "50" value = "<?php echo isset($firstSkill) ? $firstSkill : '' ;?>" >              
                                    </div> 
                                </div>
                                <ion-icon name="add-circle-outline" id="addSkill" class="AddingExtraButton"></ion-icon>           
                            </div>
                                                      


                            <!--Fourth Form-->

                            <!-- All non required fields-->
                            <div class="form_4 data_info" style="display: none;">
                                <h2>Required Qualifications</h2>
                                <div class="form_container" id="qualificationFields">
                                    <?php if (empty($qualificationDetailsResult)): ?>

                                        <div class="input_wrap Multiable" id="qualification0">
                                            <h4> Qualification 1: </h4>
                                            <label for="degreeLevel0">Degree Level</label>   
                                            <select name="degreeLevel0" id="degreeLevel0" class="input select" onchange="handleDegreeLevelChange(event, 0)">
                                                <option> </option>
                                                <option value="Pre-high school">Pre-high school</option>
                                                <option value="High School">High School</option>
                                                <option value="Diploma">Diploma</option>
                                                <option value="Bachelor">Bachelor</option>
                                                <option value="Master">Master</option>
                                                <option value="Doctorate">Doctorate</option>
                                                <option value="Post Doctorate">Post Doctorate</option>
                                            </select>
                                            <label id= "DegreeFieldLabel0" for="degreeField0">Degree Field  <span class="MaybeRequiredQualification"></span> </label> 
                                            <select name="degree[0][field]" id="degreeField0" class="input select" onchange="handleDegreeFieldChange(event, 0)">

                                                <?php
                                                // Generate the HTML options

                                                if ($result3->num_rows > 0) {
                                                    echo '<option> </option>';
                                                    while ($row = $result3->fetch_assoc()) {

                                                        echo '<option value="'.$row["Field"].'">' . $row["Field"] . '</option>';
                                                    }
                                                    echo '<option value="Other"> Other </option>';
                                                } else {
                                                    echo "No Fields found.";
                                                }
                                                ?>

                                            </select>
                                            <span class ="EnterMessage" id="EnterMessage0" style="display: none;">Please enter your qualification field below</span>
                                            <label id = "LableOther0" for="qualificationOther0" style="display: none;"> Qualification Field <span class="MaybeRequiredQualification"></span></label> 
                                            <input type="text" id = "qualificationOther0" name="qualificationOther0" class="input" style="display: none;" maxlength="100">
                                        </div> 

                                    <?php else: ?>
                                        <?php foreach ($qualificationDetailsResult as $index => $qualification): ?>
                                            <div class="input_wrap Multiable" id="qualification<?php echo $index; ?>">
                                                <h4>Qualification <?php echo $index + 1; ?>:</h4>
                                                <label for="degreeLevel<?php echo $index; ?>">Degree Level</label>
                                                <select name="degreeLevel<?php echo $index; ?>" id="degreeLevel<?php echo $index; ?>" class="input select" onchange="handleDegreeLevelChange(event, <?php echo $index; ?>)">
                                                    <option></option>
                                                    <option value="Pre-high school" <?php echo ($qualification['DegreeLevel'] === 'Pre-high school') ? 'selected' : ''; ?>>Pre-high school</option>
                                                    <option value="High School" <?php echo ($qualification['DegreeLevel'] === 'High School') ? 'selected' : ''; ?>>High School</option>
                                                    <option value="Diploma" <?php echo ($qualification['DegreeLevel'] === 'Diploma') ? 'selected' : ''; ?>>Diploma</option>
                                                    <option value="Bachelor" <?php echo ($qualification['DegreeLevel'] === 'Bachelor') ? 'selected' : ''; ?>>Bachelor</option>
                                                    <option value="Master" <?php echo ($qualification['DegreeLevel'] === 'Master') ? 'selected' : ''; ?>>Master</option>
                                                    <option value="Doctorate" <?php echo ($qualification['DegreeLevel'] === 'Doctorate') ? 'selected' : ''; ?>>Doctorate</option>
                                                    <option value="Post-Doctorate" <?php echo ($qualification['DegreeLevel'] === 'Post-Doctorate') ? 'selected' : ''; ?>>Post Doctorate</option>
                                                </select>
                                                <label id="DegreeFieldLabel<?php echo $index; ?>" for="degreeField<?php echo $index; ?>" <?php if ($qualification['DegreeLevel'] === 'Pre-high school') echo 'style="display: none;"' ?>>Degree Field <span class="MaybeRequiredQualification"></span></label>
                                                <select name="degree[<?php echo $index; ?>][field]" id="degreeField<?php echo $index; ?>" <?php if ($qualification['DegreeLevel'] === 'Pre-high school') echo 'style="display: none;"' ?> class="input select" onchange="handleDegreeFieldChange(event, <?php echo $index; ?>)">
                                                    <?php
                                                    if ($result3->num_rows > 0) {
                                                        echo '<option> </option>';
//                                                        while ($row = $result3->fetch_assoc()) {
                                                        foreach ($result3 as $row) {
                                                            $fieldname = $row["Field"];
                                                            $field = $qualification['Field'];
                                                            $selected = ($fieldname == $field) ? 'selected' : '';
//                                                            echo '<option value="' . $fieldname . '" ' . $selected . '>' . $fieldname . '</option>';
                                                            echo '<option value="' . $row["Field"]. '" ' . $selected . '>' . $row["Field"]. '</option>';

                                                        }
                                                        $selectedFlag = ($qualification['FieldFlag'] == 1) ? 'selected' : '';
                                                        echo '<option value="Other"' . $selectedFlag . '> Other </option>';
                                                    } else {
                                                        echo "No Fields found.";
                                                    }
                                                    ?>

                                                </select>


                                                <span class ="EnterMessage" id="EnterMessage<?php echo $index; ?>" style="display: none;">Please enter your qualification field below</span>
                                                <label id="LableOther<?php echo $index; ?>" for="qualificationOther<?php echo $index; ?>" <?php if ($qualification['FieldFlag'] != 1) echo 'style="display: none;"' ?>">Qualification Field <span class="MaybeRequiredQualification"></span></label>
                                                <input class="input" type="text" id="qualificationOther<?php echo $index; ?>" name="qualificationOther<?php echo $index; ?>" <?php if ($qualification['FieldFlag'] != 1) {echo 'style="display: none;"';} ?> maxlength="100" <?php if ($qualification['FieldFlag'] == 1) {echo 'value="' . $qualification["Field"] . '"';} ?>>                                          
                                                    <?php if ($index > 0): ?>
                                                        <ion-icon name="close-circle-outline" class="removeQualification remove" data-qualification="<?php echo $index; ?>"></ion-icon>
                                                    <?php endif; ?> 
                                                         
                                                </div>
                                   

                                        <?php endforeach; ?>
                                    <?php endif; ?>
                                    
                                </div>
                                <ion-icon name="add-circle-outline" id="addQualification" class="AddingExtraButton"></ion-icon>
                            </div>       
                             



                            <!--Fifth Form-->
                            <!-- All non required fields-->
                            <div class="form_5 data_info" style="display: none;">
                                <h2>Required Experiences</h2>
                                <div class="form_container" id="experienceFields">
                                    <?php if (empty($experiences)): ?>
                                        <div class="input_wrap Multiable" id="experience0">
                                            <h4>Experience 1:</h4>
                                            <label for="experienceCategory0">Experience Industry</label>
                                            <select name="experiences[0][Category]" id="experienceCategory0" class="input select">
                                                <?php
                                                if ($result4->num_rows > 0) {

                                                    echo '<option></option>';
                                                    foreach ($result4 as $row) {

                                                        echo '<option value="' . $row["CategoryName"] . '">' . $row["CategoryName"] . '</option>';
                                                    }
                                                } else {
                                                    echo "No industries found.";
                                                }
                                                ?>
                                            </select>
                                            <label for="experienceJobTitle0">Job Title<span class="MaybeRequiredExperince"></span></label>
                                            <input type="text" name="experiences[0][JobTitle]" class="input" maxlength="100" id="EJobTitle">
                                            <label for="experienceYears0">Minimum Years of Experience<span class="MaybeRequiredExperince"></span></label>
                                            <input type="number" name="experiences[0][years]" class="input" onkeyup="validateNumericInput(this, '4')" id="EYears">
                                            <span id="warningMessage4">Please enter a valid number</span>
                                        </div>
                                    <?php else: ?>
                                        <?php foreach ($experiences as $index => $experience): ?>

                                            <div class="input_wrap Multiable" id="experience<?php echo $index; ?>">
                                                <h4> Experience <?php echo $index + 1; ?>: </h4>
                                                <label for="experienceCategory<?php echo $index; ?>">Experience Industry</label> 

                                                <select name="experiences[<?php echo $index; ?>][Category]" id="experienceCategory<?php echo $index; ?>" class="input select" >
                                                    <?php
// Check if there are any rows
                                                    if ($result4->num_rows > 0) {
                                                        echo '<option></option>';
                                                        foreach ($result4 as $row) {
// Start the select field
                                                            $fieldname = $row["CategoryName"];
                                                            $field = $experience["CategoryName"];
                                                            $selected = ($fieldname == $field) ? 'selected' : '';

// Loop through the rows and print the options

                                                            echo '<option value="' . $row["CategoryName"] . '" ' . $selected . '>' . $row["CategoryName"] . '</option>';
                                                        }

// End the select field
                                                    } else {
                                                        echo "No industries found.";
                                                    }
                                                    ?>
                                                </select>
                                                <label for="experienceJobTitle<?php echo $index; ?>"  >Job Title<span class="MaybeRequiredExperince"></span></label> 
                                                <input type="text" name="experiences[<?php echo $index; ?>][JobTitle]" value='<?php echo $experience['JobTitle']; ?>' class="input" maxlength="100" id='EJobTitle'>
                                                <label for="experienceYears<?php echo $index; ?>">Minimum Years of Experience <span class="MaybeRequiredExperince"></span></label>   
                                                <input type="number" name="experiences[<?php echo $index; ?>][years]" value='<?php echo $experience["YearsOfExperience"]; ?>' class="input" onkeyup="validateNumericInput(this, '4+<?php echo $index; ?>')" id='EYears'>  
                                                <span id="warningMessage4">Please enter a valid number</span>
                                                <?php if ($index > 0): ?>
                                                    <ion-icon name="close-circle-outline" class="removeExperience remove" data-experience="<?php echo $index; ?>"></ion-icon>
                                                <?php endif; ?>

                                            </div>
                                    
                                        <?php endforeach; ?>
                                    <?php endif; ?>
                                </div>

                                <ion-icon name="add-circle-outline" id="addExperience" class="AddingExtraButton"></ion-icon>  
                            </div>


                            <!--sixth Form-->
                            <!-- All non required fields-->
                            <div class="form_6 data_info" style="display: none;">
                                <h2>Extra Information</h2>
                                <div class="form_container">
                                    <div class="input_wrap">
                                        <label for="notes">Additional Notes</label>
                                        <textarea id="notes" name="notes" rows="4" cols="50" class="input" maxlength="500"> <?php echo$additionalNotes; ?></textarea>
                                    </div>
                                </div>
                            </div>

                            <!--seventh Form-->
                            <!-- All non required fields-->
                            <div class="form_7 data_info" style="display: none;">
                                <h2>Criteria Importance</h2>
                                <div class="form_container" id = "container">
                                    <div class="input_wrap" id="ranking">

                                        <div id="dragAndDrop">
                                            <p id="note">Drag and drop each criterion to arrange them.<br> Your selections will assist in finding the perfect match for your offer!<p> <!-- comment -->
                                            <ul class="attribute-list">
                                                <!-- the attributes will show dynamically based on the offer information -->
                                            </ul>
                                        </div>


                                        <div id="Customized_wrap" style="display: none;">
                                            <p id="note2"> Make sure the weights sum equals 100%! </p>

                                            <div id ="customization-div">

                                                <div class ="attribute-list-div">
                                                    <ul class="customization-list">
                                                        <!-- the attributes will show dynamically based on the offer information -->
                                                    </ul>
                                                </div>

                                                <div class="select-list-div">
                                                </div>
                                            </div>
                                        </div><!-- ?? -->

                                        <div id="checkboxContainer" style="display: none;">
                                            <label for="sameImportance">
                                                <?php
                                                // Set the checked attribute if equalValues is true
                                                $checkedAttribute = $equalValues ? 'checked' : '';
                                                echo '<input type="checkbox" id="sameImportance" name="sameImportance" ' . $checkedAttribute . '>';
                                                ?>
                                          <!--      <input type="checkbox" id="sameImportance" name="sameImportance"> -->
                                                All criteria are of the same importance
                                            </label>
                                        </div>

                                        <div id="CustomizeBoxContainer" >
                                            <label for="Customize">
                                                <input type="checkbox" id="Customize" name="Customize">
                                                Advanced customization
                                            </label>
                                        </div>



                                    </div>
                                </div>
                            </div> 

                            <!--Navigation Buttons-->
                            <div class="btns_wrap">

                                <div class="common_btns form_1_btns">
                                    <button type="button" class="btn_next">Next <span class="icon"><ion-icon name="arrow-forward-sharp"></ion-icon></span></button>
                                </div>

                                <div class="common_btns form_2_btns" style="display: none;">
                                    <button type="button" class="btn_back"><span class="icon"><ion-icon name="arrow-back-sharp"></ion-icon></span>Back</button>
                                    <button type="button" class="btn_next" <?php echo isset($skillsJson) ? "onclick='retrieveSkills(" . $skillsJson . ");'" : ''; ?>> Next <span class="icon"><ion-icon name="arrow-forward-sharp"></ion-icon></span>
                                    </button>                                
                                </div>

                                <div class="common_btns form_3_btns" style="display: none;">
                                    <button type="button" class="btn_back"><span class="icon"><ion-icon name="arrow-back-sharp"></ion-icon></span>Back</button>
                                    <button type="button" class="btn_next">Next <span class="icon"><ion-icon name="arrow-forward-sharp"></ion-icon></span></button>
                                </div>

                                <div class="common_btns form_4_btns" style="display: none;">
                                    <button type="button" class="btn_back"><span class="icon"><ion-icon name="arrow-back-sharp"></ion-icon></span>Back</button>
                                    <button type="button" class="btn_next">Next <span class="icon"><ion-icon name="arrow-forward-sharp"></ion-icon></span></button>
                                </div>

                                <div class="common_btns form_5_btns" style="display: none;">
                                    <button type="button" class="btn_back"><span class="icon"><ion-icon name="arrow-back-sharp"></ion-icon></span>Back</button>
                                    <button type="button" class="btn_next">Next <span class="icon"><ion-icon name="arrow-forward-sharp"></ion-icon></span></button>
                                </div>

                                <div class="common_btns form_6_btns" style="display: none;">
                                    <button type="button" class="btn_back"><span class="icon"><ion-icon name="arrow-back-sharp"></ion-icon></span>Back</button>
                                    <button type="button" class="btn_next" id='check'> Next <span class="icon"><ion-icon name="arrow-forward-sharp"></ion-icon></span></button>
                                </div>
                                <div class="common_btns form_7_btns" style="display: none;">
                                    <button type="button" class="btn_back"><span class="icon"><ion-icon name="arrow-back-sharp"></ion-icon></span>Back</button>
                                    <input type="button" value="Submit" id="SubmitButton">
                                </div>

                            </div>

                        </form>
                    </div>


                </div>

            </div>

            <!-- Notification -->
            <?php   
                echo '<div id="NotificationDiv" class="scrollbar style-4">';
                echo '<div class="force-overflow"></div>';
                echo '<h3 id="NotificationTitle">Notification Center</h3>';


                $length = count($notifications); // Variable to keep track of the iteration
                if (count($notifications)> 0) {
                foreach ($notifications as $index => $notification) {
                    $isSeen = $notification["isSeen"];
                    $details = $notification["Details"];
                    $date = $notification["Date"];
                    $status = $notification["Status"];
                    $firstName = ucfirst($notification["FirstName"]);
                    $lastName = ucfirst($notification["LastName"]);
                    $jobTitle = ucfirst($notification["JobTitle"]);

                    // Date calculations
                    $now = new DateTime();
                    $givenDate = new DateTime($date);
                    $interval = $now->diff($givenDate);
                    if ($interval->y > 0) {
                        $timeAgo = $interval->y . ' Year' . ($interval->y > 1 ? 's' : '');
                    } elseif ($interval->m > 0) {
                        $timeAgo = $interval->m . ' Month' . ($interval->m > 1 ? 's' : '');
                    } elseif ($interval->d > 0) {
                        $timeAgo = $interval->d . ' Day' . ($interval->d > 1 ? 's' : '');
                    } else {
                        $timeAgo = 'Today';
                    }

                    echo '<div id="OneNotification" onclick="window.location.href=\'../Applications Page/Applications.php?ID=' . $details . '&JobTitle=' . $jobTitle . '&Status=' . $status . '\'">';
                    echo '<div id="NotificationHeader">';
                    echo '<div id="CircleHeader">';
                    if ($isSeen == 0) {
                    echo '<div id="UnseenCircle"></div>';
                    echo '<p id="UnseenHeaderTitle">New Application!</p>';
                    }else{
                    echo '<div id="SeenCircle"></div>';
                    echo '<p id="SeenHeaderTitle">New Application!</p>';
                    }    
                    echo '</div>';
                    echo '<p id="Date">'.$timeAgo.'</p>';
                    echo '</div>';
                    echo '<p id="Notification">' . $firstName . ' ' . $lastName . ' has applied to your ' . $jobTitle . ' job offer.</p>';
                    echo '</div>';
                        
                    // Add the line div if it's not the last iteration
                    if ($index != $length-1) {
                    echo '<div id="NotificationLine"></div>';
                    }           
                }
                } else {
                    echo "<p id='NoNotification'>There is no notification.</p>";
                } 
                echo '</div>';       
            ?>

        </div>

        <!--Final Message after submitting the form-->
        <div class="modal_wrapper">

            <div class="shadow"></div> <!--To make the screen dark when message displayed-->
            <div class="success_wrap">
                <span class="modal_icon"><ion-icon name="checkmark-sharp"></ion-icon></span> <!--Checkmark icon-->
                <p>You have successfully edited the offer</p>
            </div>
            <div class="faliure_wrap">
                <span class="modal_icon"><ion-icon name="close-outline"></ion-icon></span> <!--Cross icon-->
                <p>You need to fill all the required fields</p>
            </div>


        </div>

    </body>
</html>
