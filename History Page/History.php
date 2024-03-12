<?php
    include('HistoryLogic.php');
    $email = $_SESSION['JPEmail'];
?>

<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'> <!--Icons retrevial-->              
        <link href="https://fonts.googleapis.com/css?family=Lato:100" rel="stylesheet">
        <link rel="stylesheet" href="Historypage.css">
        <link rel="icon" href="../Images/Icon.png">
        <title>Job Offers - Watheq</title>
        <script src="../Functions/Logout.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script> <!--Icons retrevial-->      
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script> <!--Icons retrevial-->      
        <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script> <!--Icons retrevial-->     
        <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script> <!-- jQuery for AJAX functionality -->  
        <script src="Closeoffer.js"></script>
        <script src="../Functions/DisplayNotification.js"></script> 
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

                <div id="Offers">

                    <?php
                    if (!empty($availableOffers) || !empty($closedOffers)) {
                        echo "<h1>Posted Job Offers</h1>";

                        echo "<div id='links'>";
                        echo "<a id='link1' href='#ActiveSegment' class='tooltip'>Active Job Offers";
                        if (empty($availableOffers)) {
                            echo "<span class='tooltiptext'>There are no active offers</span>";
                        }
                        echo "</a>";
                        echo "<div id='linksLine'></div>";
                        echo "<a id='link2' href='#CloseSegment' class='tooltip'>Closed Job Offers";
                        if (empty($closedOffers)) {
                            echo "<span class='tooltiptext'>There are no closed offers</span>";
                        }
                        echo "</a>";
                        echo "</div>";

                        function displayOffers($Offers, $status) {
                            foreach ($Offers as $offer) {
                                echo "<div id='WholeOffer'>";
                                echo "<div id='FirstPart'>";
                                echo "<p id='Title'>Job Title</p>";
                                echo "<p id='JobTitle'>{$offer['JobTitle']}</p>";
                                echo "<p><a href='../Applications Page/Applications.php?ID=" . $offer["OfferID"] . "&JobTitle=" . $offer["JobTitle"] . "&Status=" . $offer["Status"] .  "'>View Applications <i class='fa-solid fa-arrow-right'></i></a></p>";
                                echo "</div>";

                                echo "<div id='SecondPart'>";
                                echo "<div id='BottomDiv'>";
                                echo "<p id='Status'>{$offer['Status']} Job Offer</p>";
                                 if ($status === 'Active') {
                                    echo '<a id="Edit" href="../Edit Offer Page/Edit Offer.php?ID=' . $offer["OfferID"] . '"><i class="fa-regular fa-pen-to-square"></i></a>';
                                }
                               
                                echo "</div>";
                                echo "<p id='Description'>" . preg_replace('/\s+/', ' ', $offer['JobDescription']) . "</p>";
                                echo "<div class='button-date-container'>";
                                echo "<p id='PostDate'>Posted On {$offer['Date']}</p>";
                                if ($status === 'Active') {
                                    echo "<button type='button' onclick='closeOffer({$offer['OfferID']}, \"{$offer['JobTitle']}\")' id='CloseButton'>Close Offer</button>";
                                }
                                echo "</div>";
                                echo "</div>";
                                echo "</div>";
                            }
                        }

                        if (!empty($availableOffers)) {
                            echo "<h2 id='ActiveSegment'>Active Job Offers</h2>";
                            displayOffers($availableOffers, 'Active');
                        }

                        if (!empty($closedOffers)) {
                            echo "<h2 id='CloseSegment'>Closed Job Offers</h2>";
                            displayOffers($closedOffers, 'Closed');
                        }
                    } else {
                        echo "<p id='Empty'>No available job offers found.</p>";
                    }
                    ?> 

                </div> 

            </div> 

        </div>

        <div class="modal_wrapper">
            <div class="shadow"></div> <!--To make the screen dark when message displayed-->
            <div class="success_wrap">
                <span class="modal_icon"> <ion-icon name="checkmark-sharp"></ion-icon> </span> <!--Checkmark icon-->
                <p> The offer closed successfully! </p>
            </div>
            <div class="faliure_wrap">
                <div class="text_container">
                    <h3 id="ConfirmationTitle">Are you sure?</h3>
                    <p id="Confirmation"></p>
                    <div class="button_container">          
                        <button class="cancel_button">Cancel</button>
                        <button class="confirm_button">Close Offer</button>
                    </div>
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
        
    </body>
</html>
