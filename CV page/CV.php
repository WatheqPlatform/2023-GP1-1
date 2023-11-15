<?php
include('CVLogic.php');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> <!-- Icons retrieval -->           
    <link href="https://fonts.googleapis.com/css?family=Lato:100" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.8.1/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="CV.css">
    <link rel="icon" href="../Images/Icon.png">
    <title>CV - Watheq</title>
    <script src="../Functions/Logout.js"></script>
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script> <!-- Icons retrieval -->
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>      
    <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script>    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script> <!-- jQuery for AJAX functionality -->
</head>
<body>
    <div id="Main">

        <!-- Header Section -->
        <div id="Header">

            <div id="HeaderStart">
                <a href="../Home Page/Home.php" id="LogoLink">
                    <img src="../Images/White Logo.png" alt="Watheq Logo" id="logo">
                </a>
                <a href="../Home Page/Home.php"> Home </a>
                <a href=""> Profile </a>
                <a href="../History Page/History.php" id="CurrentPage"> Job Offers </a>
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

        <!-- Content Section -->
        <div id="Content">
            <div id="MenuButtons">
                <ion-icon name="notifications-outline" id="Bell"></ion-icon>
                <button id="logoutButton">Log Out</button>    
            </div>

            <div id="CV">
                <?php          
                    echo '<div>';
                    echo '<h2>' . $cvDetails['CV_Info']['FirstName'] . ' ' . $cvDetails['CV_Info']['LastName'] . '</h2>';
                    echo '<p>Email: ' . $cvDetails['CV_Info']['ContactEmail'] . '</p>';
                    echo '<p>Phone: 0' . $cvDetails['CV_Info']['PhoneNumber'] . '</p>';
                    echo '<p>Address: Saudi Arabia, ' . $cvDetails['CV_Info']['CityName'] . '</p>';
                    echo '<p>Summary: ' . $cvDetails['CV_Info']['Summary'] . '</p>';

                    // Projects
                    echo '<div>';
                    echo '<div>Projects:</div>';
                    if (!empty($cvDetails['Projects'])) {
                        foreach ($cvDetails['Projects'] as $project) {
                            echo '<p>' . $project['ProjectName'] . ': ' . $project['Description'] . ' (Date: ' . $project['Date'] . ')</p>';
                        }
                    } 
                    echo '</div>';

                    // Skills
                    echo '<div>';
                    echo '<div>Skills:</div>';
                    if (!empty($cvDetails['Skills'])) {
                        foreach ($cvDetails['Skills'] as $skill) {
                            echo '<p>' . $skill['Description'] . '</p>';
                        }
                    }
                    echo '</div>';

                    // Awards
                    echo '<div>';
                    echo '<div>Awards:</div>';
                    if (!empty($cvDetails['Awards'])) {
                        foreach ($cvDetails['Awards'] as $award) {
                            echo '<p>' . $award['AwardName'] . ' by ' . $award['IssuedBy'] . ' (Date: ' . $award['Date'] . ')</p>';
                        }
                    }
                    echo '</div>';

                    // Certificates
                    echo '<div>';
                    echo '<div>Certificates:</div>';
                    if (!empty($cvDetails['Certificates'])) {
                        foreach ($cvDetails['Certificates'] as $certificate) {
                            echo '<p>' . $certificate['CertificateName'] . ' by ' . $certificate['IssuedBy'] . ' (Date: ' . $certificate['Date'] . ')</p>';
                        }
                    }
                    echo '</div>';

                    // Qualifications
                    echo '<div>';
                    echo '<div>Qualifications:</div>';
                    if (!empty($cvDetails['Qualifications'])) {
                        foreach ($cvDetails['Qualifications'] as $qualification) {
                            echo '<p>' . $qualification['DegreeLevel'] . ' in ' . $qualification['Field'] . ' from ' . $qualification['UniversityName'] . ' (' . $qualification['StartDate'] . ' to ' . $qualification['EndDate'] . ')</p>';
                        }
                    }
                    echo '</div>';


                    // Experince
                    echo '<div>';
                    echo '<div">Experience:</div>';
                    if (!empty($cvDetails['Experience'])) {
                        foreach ($cvDetails['Experience'] as $experience) {
                            echo '<p>' . $experience['JobTitle'] . ' from ' . $experience['CompanyName'] . ' in ' . $experience['CategoryName'] . ' (' . $experience['StartDate'] . ' to ' . $experience['EndDate'] . ')</p>';
                        }
                    }
                    echo '</div>';

                    echo '</div>';

                    ?>
            </div> 
        </div> 
    </div>
</body>
</html>