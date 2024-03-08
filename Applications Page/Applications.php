<?php
    include('ApplicationsLogic.php');
    $email = $_SESSION['JPEmail'];
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
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script> <!-- jQuery for AJAX functionality -->  
    <script src="ApplicationStatusLogic.js"></script>
    <script src="SortFunction.js"></script> 
    <script src="../Functions/DisplayNotification.js"></script>  
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
                <a href="../Profile Page/Profile.php"> Profile </a>
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
                <!-- Notification Code -->
                <?php
                include("../dbConnection.php");
                $NotificationQuery = "SELECT n.Date, n.isSeen, n.Details, cv.FirstName, cv.LastName, jo.JobTitle, jo.Status
                FROM notification n
                JOIN cv ON n.JSEmail = cv.JobSeekerEmail
                JOIN joboffer jo ON n.Details = jo.OfferID
                WHERE n.JPEmail = '$email' AND n.Details REGEXP '^[0-9]+$'
                ORDER BY n.Date DESC";
            
                $result = $conn->query($NotificationQuery);
            
                // Store results in an array
                $notifications = [];

                // Check if there are any unseen notifications
                $hasUnseenNotification = false;

                if ($result->num_rows > 0) {
                    while ($row = $result->fetch_assoc()) {
                        $notifications[] = $row;
                        $isSeen = $row["isSeen"];
                        $details = $row["Details"];
                        $date = $row["Date"];
                        $status = $row["Status"];
                        $firstName = $row["FirstName"];
                        $lastName = $row["LastName"];
                        $jobTitle = $row["JobTitle"];
                        
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

            <div id="Applications">
                <?php
                    // Check if there are any applications
                    if (!empty($PendingApplications) || !empty($RejectedApplications) || !empty($AcceptedApplications)) {
                        echo "<h1>". $_GET["JobTitle"]." Applications</h1>";
                        echo "<div id='links'>";
                        if($_GET["Status"]!="Closed"){
                            echo "<a id='link1' href='#PendingSegment'  class='tooltip'>Pending Applications";
                            if (empty($PendingApplications)){
                                echo "<span class='tooltiptext'>There are no pending applications</span>";
                            }
                            echo "</a>";
                            echo "<div id='linksLine'></div>";
                        } 
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
                                echo "<p><a href='../CV page/CV.php?ID=".$application["CVID"]."'>View Applicant CV <i class='fa-solid fa-arrow-right'></i></a></p>";
                                echo "</div>";

                                echo "<div id='SecondPart'>";
                                
                                echo "<p id='Status'class='".$application['Status']."'>{$application['Status']} Application</p>";
                                echo "<p id='Summary'>" . trim(preg_replace('/\s+/', ' ', $application['Summary'])) . "</p>";
                            
                                echo "<div id='BottomDiv'>";
                                echo "<div id='ContactDiv'>";
                                echo "<p id='Email'><i class='bi bi-envelope icon-space'> </i>  {$application['ContactEmail']}</p>";
                                echo "<p id='Number'><i class='bi bi-telephone icon-space'> </i>0{$application['PhoneNumber']}</p>";
                                echo "</div>";
                                echo "</div>"; //end of BottomDiv
                                echo "</div>"; //end of SecondPart
                                echo "</div>"; //end of WholeApplication
                            }
                        }

                        // Call function for each application status
                        if (!empty($PendingApplications)) {
                            echo '<div id="SortingTitle">';
                            echo "<h2 id='PendingSegment'>Pending Applications</h2>";
                            echo '<select id="sorting" onchange="sortApplications()" class="input">
                                        <option value>Sort By</option>
                                        <option value="new">Newest</option>
                                        <option value="old">Oldest</option>
                                        <option value="similar">Best Matching</option>         
                                    </select>';
                            echo '</div>';
                            echo '<div id="pending">';
                            foreach ($PendingApplications as $application) {
                                echo "<div id='WholeApplication'>";

                                echo "<div id='FirstPart' class='".$application['Status']."'>";
                                echo "<p id='Title'>Applicant Name</p>";
                                echo "<p id='ApplicantName'>{$application['Name']}</p>";
                                echo "<p><a href='../CV page/CV.php?ID=".$application["CVID"]."'>View Applicant CV <i class='fa-solid fa-arrow-right'></i></a></p>";
                                echo "</div>";

                                echo "<div id='SecondPart'>";
                                
                                echo "<p id='Status'class='".$application['Status']."'>{$application['Status']} Application</p>";
                                echo "<p id='Summary'>" . trim(preg_replace('/\s+/', ' ', $application['Summary'])) . "</p>";
                            
                                echo "<div id='BottomDiv'>";
                                echo "<div id='ContactDiv'>";
                                echo "<p id='Email'><i class='bi bi-envelope icon-space'> </i>  {$application['ContactEmail']}</p>";
                                echo "<p id='Number'><i class='bi bi-telephone icon-space'> </i>0{$application['PhoneNumber']}</p>";
                                echo "</div>";

                                echo "<div id='Buttons'>";
                                echo "<button type='button' class='accept-button' data-application-id='{$application['ApplicationID']}' data-applicant-email='{$application['ContactEmail']}'>Accept</button>";
                                echo "<button type='button' class='reject-button' data-application-id='{$application['ApplicationID']}' data-applicant-email='{$application['ContactEmail']}'>Reject</button>";
                                echo "</div>";
  
                                echo "</div>"; //end of BottomDiv
                                echo "</div>"; //end of SecondPart
                                echo "</div>"; //end of WholeApplication
                            }
                            echo '</div>';

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
       
</body>
</html>