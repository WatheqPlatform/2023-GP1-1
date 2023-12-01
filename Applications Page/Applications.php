<?php
include('ApplicationsLogic.php');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> <!-- Icons retrieval -->           
    <link href="https://fonts.googleapis.com/css?family=Lato:100" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.8.1/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="Applications.css">
    <link rel="icon" href="../Images/Icon.png">
    <title>Applications - Watheq</title>
    <script src="../Functions/Logout.js"></script>
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script> <!-- Icons retrieval -->
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script>      
    <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script>    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script> <!-- jQuery for AJAX functionality -->
    <script src="ApplicationStatusLogic.js"></script>
   
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

            <div id="Applications">
                <?php
                    // Check if there are any applications
                    if (!empty($PendingApplications) || !empty($RejectedApplications) || !empty($AcceptedApplications)) {
                        echo "<h1>". $_GET["JobTitle"]." Applications</h1>";
                        echo "<div id='links'>";
                        echo "<a id='link1' href='#PendingSegment'  class='tooltip'>Pending Applications";
                        if (empty($PendingApplications)){
                            echo "<span class='tooltiptext'>There are no pending applications</span>";
                        }
                        echo "</a>";
                        echo "<div id='linksLine'></div>";
                        echo "<a id='link2' href='#AccpetedSegment'  class='tooltip'>Accepted Applications";
                        if (empty($AcceptedApplications)){
                            echo "<span class='tooltiptext'>There are no accepted applications</span>";
                        }
                        echo "</a>";
                        echo "<div id='linksLine1'></div>";
                        echo "<a id='link3' href='#CloseSegment'  class='tooltip'>Rejected Applications";
                        if (empty($RejectedApplications)){
                            echo "<span class='tooltiptext'>There are no rejected applications</span>";
                        }
                        echo "</a>";
                        echo "</div>";

                        // Function to display applications
                        function displayApplications($applications, $status) {
                            foreach ($applications as $application) {
                                echo "<div id='WholeApplication'>";
                                echo "<div id='FirstPart' class='".$application['Status']."'>";
                                echo "<p id='Title'>Applicant Name</p>";
                                echo "<p id='ApplicantName'>{$application['Name']}</p>";
                                echo "<p><a href='../CV Page/CV.php?ID=".$application["CVID"]."'>View Applicant CV <i class='fa-solid fa-arrow-right'></i></a></p>";
                                echo "</div>";

                                echo "<div id='SecondPart'>";
                                echo "<p id='Status'class='".$application['Status']."'>{$application['Status']} Application</p>";
                                echo "<p id='Summary'>".preg_replace('/\s+/', ' ', $application['Summary'])."</p>";
                            
                                echo "<div id='BottomDiv'>";
                                echo "<div id='ContactDiv'>";
                                echo "<p id='Email'><i class='bi bi-envelope icon-space'> </i>  {$application['ContactEmail']}</p>";
                                echo "<p id='Number'><i class='bi bi-telephone icon-space'> </i>0{$application['PhoneNumber']}</p>";
                                echo "</div>";
                                if ($status === 'Pending') {
                                    echo "<div id='Buttons'>";
                                    echo "<button type='button' class='accept-button' data-application-id='{$application['ApplicationID']}'>Accept</button>";
                                    echo "<button type='button' class='reject-button' data-application-id='{$application['ApplicationID']}'>Reject</button>";
                                    echo "</div>";
                                }
                                echo "</div>";
                                echo "</div>";
                                echo "</div>";
                            }
                        }

                        // Call function for each application status
                        if (!empty($PendingApplications)) {
                            echo "<h2 id='PendingSegment'>Pending Applications</h2>";
                            displayApplications($PendingApplications, 'Pending');
                        }
                        if (!empty($AcceptedApplications)) {
                            echo "<h2 id='AccpetedSegment'>Accepted Applications</h2>";
                            displayApplications($AcceptedApplications, 'Accepted');
                        }
                        if (!empty($RejectedApplications)) {
                            echo "<h2 id='CloseSegment'>Rejected Applications</h2>";
                            displayApplications($RejectedApplications, 'Rejected');
                        }
                        
                    } else {
                        echo "<p id='Empty'>No job applications found.</p>";
                    }
                ?> 
            </div> 
        </div> 
    </div>
       
</body>
</html>