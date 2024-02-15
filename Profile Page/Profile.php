<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit();
}

include("../dbConnection.php");
// Retrieve the rows from the "category" table
$sql = 'SELECT CompanyName FROM jobprovider WHERE JobProviderEmail="' . $_SESSION["JPEmail"] . '"';
$result = $conn->query($sql);
$rowName = $result->fetch_assoc();

$sql = 'SELECT * FROM profile WHERE JobProviderEmail="' . $_SESSION["JPEmail"] . '"';
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    $created = true;
    $row = $result->fetch_assoc();
}
else{
    $created=false;
}
?>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'> <!--Icons retrevial-->                
        <link href="https://fonts.googleapis.com/css?family=Lato:100" rel="stylesheet">
        <link rel="stylesheet" href="Profile.css">
        <link rel="icon" href="../Images/Icon.png">
        <title>Job Adding Form - Watheq</title>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script> <!--Icons retrevial-->      
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script> <!--Icons retrevial-->      
        <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script> <!--Icons retrevial-->   
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="../Functions/Logout.js"></script>
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
                    <a href="../Profile Page/Profile.php"  id="CurrentPage"> Profile </a>
                    <a href="../History Page/History.php"> Job Offers </a>
                    <a href="../AddOffer Page/AddOffer.php"> Add Offer </a> 
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

                <div id="container">
                    <?php if (!$created): ?>
                        <form id="ProfileForm" method="POST">
                            <h2>Create Profile</h2>
                            <p id="FormSentence">
                                Share your business details to connect with job seekers and showcase your organization.
                            </p>
                            <div class="input_wrap">
                                <label for="Name">Company Name <span class="required"></span></label>
                                <input type="text" name="Name" class="input" id="Name" maxlength="100" value='<?php echo $rowName["CompanyName"]?>'>
                            </div>
                            <div class="input_wrap">
                                <label for="Description">About The Company <span class="required"></span></label>
                                <textarea id="Description" name="Description" cols="50" class="input" maxlength="300"></textarea>
                            </div>
                            <div class="input_wrap">
                                <label for="Location">Company HQ Location <span class="required"></span></label>
                                <input type="text" name="Location" class="input" id="Location" maxlength="100">
                            </div>
                            <div class="input_wrap">
                                <label for="Email">Contact Email <span class="required"></span></label>
                                <input type="text" name="Email" class="input" id="Email" maxlength="100">
                            </div>
                            <div class="input_wrap">
                                <label for="Phone">Phone Number</label>
                                <input type="number" name="Phone" class="input" id="Phone" maxlength="10">
                            </div>
                            <div class="input_wrap">
                                <label for="Linkedin">Linkedin URL</label>
                                <input type="text" name="Linkedin" class="input" id="Linkedin" maxlength="100">
                            </div>
                            <div class="input_wrap">
                                <label for="X">X (Formerly Twitter) URL</label>
                                <input type="text" name="X" class="input" id="X" maxlength="100">
                            </div>
                            <div class="input_wrap">
                                <label for="URL">Website URL</label>
                                <input type="text" name="URL" class="input" id="URL" maxlength="100">
                            </div>
                            <button type="button" class="btnComplete" id="SubmitButton">Create Profile</button>
                        </form>
                    <?php else: ?>
                        <div id="DisplayContainer">
                        
                            <!-- Display profile information if profile is created -->
                            <div id="Top">
                                <div id="circle">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="bi bi-buildings" viewBox="0 0 16 16">
                                        <path d="M14.763.075A.5.5 0 0 1 15 .5v15a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5V14h-1v1.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V10a.5.5 0 0 1 .342-.474L6 7.64V4.5a.5.5 0 0 1 .276-.447l8-4a.5.5 0 0 1 .487.022M6 8.694 1 10.36V15h5zM7 15h2v-1.5a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 .5.5V15h2V1.309l-7 3.5z"/>
                                        <path d="M2 11h1v1H2zm2 0h1v1H4zm-2 2h1v1H2zm2 0h1v1H4zm4-4h1v1H8zm2 0h1v1h-1zm-2 2h1v1H8zm2 0h1v1h-1zm2-2h1v1h-1zm0 2h1v1h-1zM8 7h1v1H8zm2 0h1v1h-1zm2 0h1v1h-1zM8 5h1v1H8zm2 0h1v1h-1zm2 0h1v1h-1zm0-2h1v1h-1z"/>
                                    </svg>
                                </div>
                                <a id="Edit" href="../Edit Profile Page/EditProfile.php"><i class="fa-regular fa-pen-to-square"></i></a>
                            </div>
                            <h2 id="CompanyName"><?php echo $rowName['CompanyName']; ?></h2>
                            <h3 id="Title">About Us</h3>
                            <p id="FilledDescription"><?php echo $row['Description']; ?></p>
                            <h3 id="Title">Contact Information</h3>
                            <p id="FilledLocation">
                                <svg xmlns="http://www.w3.org/2000/svg" class="bi bi-building" viewBox="0 0 16 16">
                                    <path d="M4 2.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3 0a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3.5-.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zM4 5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zM7.5 5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zm2.5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zM4.5 8a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5zm2.5.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5zm3.5-.5a.5.5 0 0 0-.5.5v1a.5.5 0 0 0 .5.5h1a.5.5 0 0 0 .5-.5v-1a.5.5 0 0 0-.5-.5z"/>
                                    <path d="M2 1a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1zm11 0H3v14h3v-2.5a.5.5 0 0 1 .5-.5h3a.5.5 0 0 1 .5.5V15h3z"/>
                                </svg>
                                <?php echo $row['Location']; ?>
                            </p>
                            <p id="Contact">
                                <svg xmlns="http://www.w3.org/2000/svg" class="bi bi-envelope" viewBox="0 0 16 16">
                                    <path d="M0 4a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v.217l7 4.2 7-4.2V4a1 1 0 0 0-1-1zm13 2.383-4.708 2.825L15 11.105zm-.034 6.876-5.64-3.471L8 9.583l-1.326-.795-5.64 3.47A1 1 0 0 0 2 13h12a1 1 0 0 0 .966-.741M1 11.105l4.708-2.897L1 5.383z"/>
                                </svg>
                                <a id="ContactLink" href="malito:<?php echo $row['Email']; ?>">  <?php echo $row['Email']; ?></a>
                               
                            </p>
                            <?php if (!empty($row['Phone'])) { ?>
                                <p id="Contact">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="bi bi-telephone" viewBox="0 0 16 16">
                                        <path d="M3.654 1.328a.678.678 0 0 0-1.015-.063L1.605 2.3c-.483.484-.661 1.169-.45 1.77a17.6 17.6 0 0 0 4.168 6.608 17.6 17.6 0 0 0 6.608 4.168c.601.211 1.286.033 1.77-.45l1.034-1.034a.678.678 0 0 0-.063-1.015l-2.307-1.794a.68.68 0 0 0-.58-.122l-2.19.547a1.75 1.75 0 0 1-1.657-.459L5.482 8.062a1.75 1.75 0 0 1-.46-1.657l.548-2.19a.68.68 0 0 0-.122-.58zM1.884.511a1.745 1.745 0 0 1 2.612.163L6.29 2.98c.329.423.445.974.315 1.494l-.547 2.19a.68.68 0 0 0 .178.643l2.457 2.457a.68.68 0 0 0 .644.178l2.189-.547a1.75 1.75 0 0 1 1.494.315l2.306 1.794c.829.645.905 1.87.163 2.611l-1.034 1.034c-.74.74-1.846 1.065-2.877.702a18.6 18.6 0 0 1-7.01-4.42 18.6 18.6 0 0 1-4.42-7.009c-.362-1.03-.037-2.137.703-2.877z"/>
                                    </svg>
                                    <?php echo $row['Phone']; ?>
                                </p>
                            <?php } ?>

                            <?php if (!empty($row['Twitter'])) { ?>
                                <p id="Contact">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="bi bi-twitter-x" viewBox="0 0 16 16">
                                        <path d="M12.6.75h2.454l-5.36 6.142L16 15.25h-4.937l-3.867-5.07-4.425 5.07H.316l5.733-6.57L0 .75h5.063l3.495 4.633L12.601.75Zm-.86 13.028h1.36L4.323 2.145H2.865z"/>
                                    </svg>
                                    <a id="ContactLink" href="https://<?php echo $row['Twitter']; ?>"> <?php echo $row['Twitter']; ?></a>                             
                                </p>
                            <?php } ?>

                            <?php if (!empty($row['Linkedin'])) { ?>
                                <p id="Contact">
                                    <i class="fa-brands fa-linkedin-in"></i>
                                    <a id="ContactLink" href="https://<?php echo $row['Linkedin']; ?>"> <?php echo $row['Linkedin']; ?></a>
                                </p>
                            <?php } ?>

                            <?php if (!empty($row['Link'])) { ?>
                                <p id="Contact">
                                    <i class="fa-solid fa-link"></i>
                                    <a id="ContactLink" href="https://<?php echo $row['Link']; ?>"> <?php echo $row['Link']; ?></a>
                                </p>
                            <?php } ?>

                        </div>
                    <?php endif; ?>
                </div>

            </div>

        </div>

        <!--Final Message after submitting the form-->
        <div class="modal_wrapper">
            <div class="shadow"></div> <!--To make the screen dark when message displayed-->
            <div class="success_wrap">
                <span class="modal_icon"><ion-icon name="checkmark-sharp"></ion-icon></span> <!--Checkmark icon-->
                <p>You have successfully created your profile!</p>
            </div>
            <div class="faliure_wrap">
                <span class="modal_icon"><ion-icon name="close-outline"></ion-icon></span> <!--Cross icon-->
                <p>You need to fill all the required fields</p>
            </div>
        </div>

    </body>
</html>
