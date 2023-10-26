<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit();
}

include("../dbConnection.php");
// Retrieve the rows from the "category" table
$sql = "SELECT * FROM category";
$result = $conn->query($sql);
// Fetch the cities from the "city" table
$sql2 = "SELECT CityName FROM city ORDER BY CityName ASC";
$result2 = $conn->query($sql2);


?>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'> <!--Icons retrevial-->                
        <link href="https://fonts.googleapis.com/css?family=Lato:100" rel="stylesheet">
        <link rel="stylesheet" href="Addoffer.css">
        <link rel="icon" href="../Images/Icon.png">
        <title>Job Adding Form - Watheq</title>
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
        <script src="Validation.js"></script>
        
    </head>

    <body>

        <div id="Main">

            <div id="Header">

                <div id="HeaderStart">
                    <a href="../Home Page/Home.php" id="LogoLink">
                        <img src="../Images/White Logo.png" alt="Watheq Logo" id="logo">
                    </a>
                    <a href="../Home Page/Home.php"> Home </a>
                    <a href=""> Profile </a>
                    <a href="../History Page/History.php"> History </a>
                    <a href="../AddOffer Page/AddOffer.php" id="CurrentPage"> Add Offer </a> 
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
                        </ul>
                    </div>

                    <!--Form Container-->
                    <div class="form_wrap">

                        <form id="AddForm" method="POST">

                            <!--First Form-->
                            <div class="form_1 data_info">

                                <h2>Basic Information</h2>

                                <div class="form_container">
                                    <div class="input_wrap">
                                        <label for="jobTitle">Job Title<span class="required"></span></label>
                                        <input type="text" name="jobTitle" class="input" id="jobTitle" >
                                    </div>
                                    <div class="input_wrap">
                                        <label for="jobType">Employment Type<span class="required"></span></label>
                                        <select name="jobType" class="input select" id="jobType" >
                                            <option disabled selected></option> 
                                            <option value="full-time">Full Time</option>
                                            <option value="part-time">Part Time</option>
                                        </select>
                                    </div>
                                    <div class="input_wrap">
                                        <label for="job-categories">Job Category<span class="required"></span></label>
                                        <select name="job-categories" id="job-categories" class="input select" >
                                            <?php
                                            // Check if there are any rows
                                            if ($result->num_rows > 0) {
                                                // Start the select field

                                                echo '<option disabled selected></option>';

                                                // Loop through the rows and print the options
                                                while ($row = $result->fetch_assoc()) {
                                                    echo '<option value="' . $row["CategoryName"] . '">' . $row["CategoryName"] . '</option>';
                                                }

                                                // End the select field
                                            } else {
                                                echo "No categories found.";
                                            }
                                            ?>
                                        </select>
                                    </div>
                                    <div class="input_wrap">
                                        <label for="jobField">Job Field<span class="required"></span></label>
                                        <input type="text" name="jobField" class="input" id="jobField" >
                                    </div>
                                    <div class="input_wrap">
                                        <label for="jobCity">Job City<span class="required"></span></label>
                                        <select name="jobCity" id="jobCity" class="input select">
                                            <option disabled selected></option>
                                            <?php
                                            // Generate the HTML options
                                                    
                                                    if ($result2->num_rows > 0) {
                                                        while ($row = $result2->fetch_assoc()) {

                                                            echo '<option value="' . $row["CityName"] . '">' . $row["CityName"] . '</option>';
                                                        }
                                                    }
                                                    else
                                                    {  echo "No cities found."; }
                                                    ?>
                                                   
                                        </select>
                                    </div>
                                    <div class="input_wrap">
                                        <label for="jobAddress">Job Address<span class="required"></span></label>
                                        <input type="text" name="jobAddress" class="input" id="jobAddress" >
                                    </div>
                                    <div class="input_wrap">
                                        <label for="jobDescription">Job Description<span class="required"></span></label>
                                        <textarea name="jobDescription" class="input" id="jobDescription" ></textarea>
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
                                        <input type="number" name="minSalary" class="input" id="minSalary" onkeyup="validateNumericInput(this, '1')" >
                                        <span id="warningMessage1">Please enter a valid number</span>

                                    </div>
                                    <div class="input_wrap">  
                                        <label for="maxSalary">Maximum Salary<span class="required"></span></label>
                                        <input type="number" name="maxSalary" class="input" id="maxSalary" onkeyup="validateNumericInput(this, '2')">
                                        <span id="warningMessage2">Please enter a valid number</span>
                                    </div>
                                    <div class="input_wrap">
                                        <label for="date">Starting Date</label> 
                                        <input type="date" name="date"  class="input" id="date">
                                    </div>
                                    <div class="input_wrap">
                                        <label for="workingHours">Working Hours Per Day</label> 
                                        <input type="number" name="workingHours" class="input" id="workingHours" onkeyup="validateNumericInput(this, '3')">
                                        <span id="warningMessage3">Please enter a valid number</span>
                                    </div>
                                    <div class="input_wrap checklist">
                                        <label for="day">Working Days</label>  <!-- not required-->
                                        <label>
                                            <input type="checkbox" name="day" value="sunday">
                                            Sunday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day" value="monday">
                                            Monday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day" value="tuesday">
                                            Tuesday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day" value="wednesday">
                                            Wednesday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day" value="thursday">
                                            Thursday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day" value="friday">
                                            Friday
                                        </label>
                                        <label>
                                            <input type="checkbox" name="day" value="saturday">
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
                                        <input type="text" name="skills[0]" class="input" id="company">              
                                    </div> 
                                </div>
                                <ion-icon name="add-circle-outline" id="addSkill" class="AddingExtraButton"></ion-icon>           
                            </div>

                            <!--Fourth Form-->
                            <!-- All non required fields-->
                            <div class="form_4 data_info" style="display: none;">
                                <h2>Required Qualifications</h2>
                                <div class="form_container" id="qualificationFields">
                                    <div class="input_wrap Multiable" id="qualification0">
                                        <h4> Qualification 1: </h4>
                                        <label for="degreeLevel0">Degree Level</label>   
                                        <select name="degreeLevel0" id="degreeLevel" class="input select">
                                            <option disabled selected></option>
                                            <option value="Pre-high school education">Pre-high school</option>
                                            <option value="High School">High School</option>
                                            <option value="Diploma">Diploma</option>
                                            <option value="Bachelor">Bachelor</option>
                                            <option value="Master">Master</option>
                                            <option value="Doctorate">Doctorate</option>
                                            <option value="Post Doctorate">Post Doctorate</option>
                                        </select>
                                        <label for="degreeField0">Degree Field <span id="MaybeRequiredQualification"></span></label> 
                                        <input type="text" name="degree[0][field]" class="input" >  
                                    </div> 
                                </div>
                                <ion-icon name="add-circle-outline" id="addQualification" class="AddingExtraButton"></ion-icon> 
                            </div>

                            <!--Fifth Form-->
                            <!-- All non required fields-->
                            <div class="form_5 data_info" style="display: none;">
                                <h2>Required Experiences</h2>
                                <div class="form_container" id="experienceFields">
                                    <div class="input_wrap Multiable" id="experience0">
                                        <h4> Experience 1: </h4>
                                        <label for="experienceField0">Experience Field</label> 
                                        <input type="text" name="experience[0][field]" class="input">
                                        <label for="experienceDescription0" >Experience Description <span class="MaybeRequiredExperince"></span></label> 
                                        <input type="text" name="experiences[0][description]" class="input">
                                        <label for="experienceYears0">Minimum Years of Experience <span class="MaybeRequiredExperince"></span></label>   
                                        <input type="number" name="experiences[0][years]" class="input" onkeyup="validateNumericInput(this, '4')" >  
                                        <span id="warningMessage4">Please enter a valid number</span>
                                    </div>
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
                                        <textarea id="notes" name="notes" rows="4" cols="50" class="input" id="notes"></textarea>
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
                                    <button type="button" class="btn_next">Next <span class="icon"><ion-icon name="arrow-forward-sharp"></ion-icon></span></button>
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
                                    <input type="button" value="Submit" id="SubmitButton">
                                </div>

                            </div>
                        </form>
                    </div>


                </div>

            </div>

        </div>

        <!--Final Message after submitting the form-->
        <div class="modal_wrapper">
            <div class="shadow"></div> <!--To make the screen dark when message displayed-->
            <div class="success_wrap">
                <span class="modal_icon"><ion-icon name="checkmark-sharp"></ion-icon></span> <!--Checkmark icon-->
                <p>You have successfully posted the offer.</p>
            </div>
            <div class="faliure_wrap">
                <span class="modal_icon"><ion-icon name="close-outline"></ion-icon></span> <!--Cross icon-->
                <p>You Need to fill all the required fields. </p>
            </div>
        </div>

    </body>
</html>