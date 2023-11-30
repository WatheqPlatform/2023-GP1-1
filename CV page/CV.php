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
                    echo '<div id="NameDiv">';
                    echo '<div id="NameStart"> </div>';
                    echo '<h2 id="Name">' . $cvDetails['CV_Info']['FirstName'] . ' ' . $cvDetails['CV_Info']['LastName'] . '</h2>';
                    echo '<div id="NameEnd"> </div>';
                    echo '</div>';

                    echo '<div id="AboutDiv">';
                    echo '<h4 id="AboutTitle">ABOUT ME</H4>';
                    echo '<div id="AboutLine"> </div>';
                    echo '</div>';

                    echo '<div id="CVContent">';

                    echo '<div id="LeftCV">';
                    echo '<p id=AboutMe>' . $cvDetails['CV_Info']['Summary'] . '</p>';  
                    // Skills
                    if (!empty($cvDetails['Skills'])) {
                        echo '<h4 id="SkillsTitle">  PROFESSIONAL<br>SKILLS</H4>';
                        foreach ($cvDetails['Skills'] as $skill) {
                            echo '<div id="skill"><div id="SkillCircle">•</div><p>' . $skill['Description'] . '</p></div>';
                        }
                    }
                    echo '</div>';//LeftCV Div end


                    echo '<div id="MiddleLine"></div>';


                    echo '<div id="RightCV">';

                    echo '<div id="ContactDiv">';
                    echo '<div id="Letters">' . ucfirst(substr($cvDetails['CV_Info']['FirstName'], 0, 1)). ucfirst(substr($cvDetails['CV_Info']['LastName'], 0, 1)) .'</div>';
                    echo '<div id="ContactInfo">';
                    echo '<p class="Contact"><span class="ContactTitle">PHONE : </span> 0' . $cvDetails['CV_Info']['PhoneNumber'] . '</p>';
                    echo '<p class="Contact"><span class="ContactTitle">EMAIL : </span> ' . $cvDetails['CV_Info']['ContactEmail'] . '</p>';  
                    echo '<p class="Contact"><span class="ContactTitle">ADDRESS : </span> ' . $cvDetails['CV_Info']['CityName'] . ', Saudi Arabia </p>';
                    echo '</div>';
                    echo '</div>';

                    
                    // Qualifications
                    echo '<div>';
                    if (!empty($cvDetails['Qualifications'])) {
                        echo '<h3 id="Titles">EDUCATION</h3>';
                        foreach ($cvDetails['Qualifications'] as $qualification) {
                            echo '<p id="Issuer">'. $qualification['IssuedBy'].'<p>';
                            echo '<p id="Info">' . $qualification['DegreeLevel'] . ' degree in ' . $qualification['Field'] .'</p>';

                            $date=!empty($qualification['EndDate']) ? date('Y', strtotime($qualification['EndDate'])) : 'Current';
                            echo '<p class="date">' . date('Y.m', strtotime($qualification['StartDate'])) . ' - '. $date . '</p>';
                        }
                    }
                    echo '</div>';


                    // Experince
                    echo '<div>';
                    if (!empty($cvDetails['Experience'])) {
                        echo '<h3 id="Titles">EXPERIENCES</h3>';
                        foreach ($cvDetails['Experience'] as $experience) {
                            echo '<p id="Issuer">' .$experience['CompanyName'] .'</p>';
                            echo '<p id="Info">' . $experience['CategoryName'] . ' : ' . $experience['JobTitle'] . '</p>';

                            $date=!empty($experience['EndDate']) ?  date('Y.m', strtotime($experience['EndDate'])) : 'Current';
                            echo '<p class="date">' . date('Y.m', strtotime($experience['StartDate'])) . ' - ' . $date . '</p>';                 
                        }
                    }
                    echo '</div>';


                    // Certificates
                    echo '<div>';
                    if (!empty($cvDetails['Certificates'])) {
                        echo '<h3 id="Titles">CERTIFICATES</h3>';
                        foreach ($cvDetails['Certificates'] as $certificate) {
                            echo '<p id="Title">' . $certificate['CertificateName'] . '</p>';
                            echo '<p id="IssuerDate">' . 'Issued by ' . $certificate['IssuedBy'] . ', ' . date('Y.m.d', strtotime($certificate['Date'])) . '</p>';
                        }
                    }
                    echo '</div>';


                    // Awards
                    echo '<div>';
                    if (!empty($cvDetails['Awards'])) {
                        echo '<h3 id="Titles">AWARDS</h3>';
                        foreach ($cvDetails['Awards'] as $award) {
                            echo '<p id="Title">' . $award['AwardName'] . '</p>';
                            echo '<p id="IssuerDate">' . 'Issued by ' . $award['IssuedBy'] . ', ' . date('Y.m.d', strtotime($award['Date'])) . '</p>';
                        }
                    }
                    echo '</div>';


                    // Projects
                    echo '<div>';
                    if (!empty($cvDetails['Projects'])) {
                        echo '<h3 id="Titles">PROJECTS</h3>';
                        foreach ($cvDetails['Projects'] as $project) {
                            echo '<p id="Title">' . $project['ProjectName'] . '</p>';
                            echo '<p id="Info">' . $project['Description'] . '</p>';
                            echo '<p class="date">Completed at ' . date('Y.m.d', strtotime($project['Date'])) . '</p>';
                        }
                    } 
                    echo '</div>';

                

                    echo '</div>';//RightCV Div end


                    echo '</div>';//Content Div end
                ?>
                
            </div> 
        </div> 
    </div>
</body>
</html>