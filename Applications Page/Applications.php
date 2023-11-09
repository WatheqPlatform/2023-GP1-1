<?php
include('ApplicationsLogic.php');
?>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'> <!--Icons retrevial-->              
    <link href="https://fonts.googleapis.com/css?family=Lato:100" rel="stylesheet">
    <link rel="stylesheet" href="Applications.css">
    <link rel="icon" href="../Images/Icon.png">
    <title>Applications - Watheq</title>
    <script src="../Functions/Logout.js"></script>
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script> <!--Icons retrevial-->      
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script> <!--Icons retrevial-->      
    <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script> <!--Icons retrevial-->     
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
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
                <a href="../History Page/History.php" id="CurrentPage"> History </a>
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

            <div id="Applications">

                <?php
                    if (!empty($PendingApplications) ||  !empty($RejectedApplications) || !empty($AcceptedApplications)) {
                        echo "<h1>Job Applications</h1>";
                    }

                    echo"<div id='ApplicationsGrid'>";

                        if (!empty($PendingApplications)) {
                            foreach ($PendingApplications as $Application) {
                                echo "<div id='Application'>";

                                echo "<div id='Status' class='".$Application['Status']."'>";
                                echo "<p id='Status'>{$Application['Status']} Application</p>";
                                echo "</div>";

                                echo "<p id='Name'>{$Application['Name']}</p>";
                                echo "<p id='Email'>{$Application['JobSeekerEmail']}</p>";

                                echo "<button type='button'>Accept</button>";     
                                echo "<button type='button'>Reject</button>";   

                                
                                echo "</div>";
                            }
                        }

                        if (!empty($AcceptedApplications)) {
                            foreach ($AcceptedApplications as $Application) {
                                echo "<div id='Application'>";

                                echo "<div id='Status' class='".$Application['Status']."'>";
                                echo "<p id='Status'>{$Application['Status']} Application</p>";
                                echo "</div>";

                                echo "<p id='Name'>{$Application['Name']}</p>";
                                echo "<p id='Email'>{$Application['JobSeekerEmail']}</p>";

                                echo "</div>";
                            }
                        } 
                        
                        if (!empty($RejectedApplications)) {
                            foreach ($RejectedApplications as $Application) {
                                echo "<div id='Application'>";

                                echo "<div id='Status' class='".$Application['Status']."'>";
                                echo "<p id='Status'>{$Application['Status']} Application</p>";
                                echo "</div>";

                                echo "<p id='Name'>{$Application['Name']}</p>";
                                echo "<p id='Email'>{$Application['JobSeekerEmail']}</p>";
                                
                                echo "</div>";
                            }
                        }  
                   

                        if (empty($PendingApplications) && empty($RejectedApplications) && empty($AcceptedApplications)) {
                            echo "<p id='Empty'>No job applications yet.</p>";
                        }
                        
                    echo"</div>";
                ?> 

            </div> 

        </div> 

    </div>
    
   
</body>
</html>
