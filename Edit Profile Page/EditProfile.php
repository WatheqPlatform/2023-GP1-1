<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
    header("Location: ../index.php");
    exit();
}

$email = $_SESSION['JPEmail'];

include("../dbConnection.php");
// Retrieve the rows from the "category" table
$sql = 'SELECT CompanyName FROM jobprovider WHERE JobProviderEmail="' . $_SESSION["JPEmail"] . '"';
$result = $conn->query($sql);
$rowName = $result->fetch_assoc();

$sql = 'SELECT * FROM profile WHERE JobProviderEmail="' . $_SESSION["JPEmail"] . '"';
$result = $conn->query($sql);
$row = $result->fetch_assoc();
?>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'> <!--Icons retrevial-->                
        <link href="https://fonts.googleapis.com/css?family=Lato:100" rel="stylesheet">
        <link rel="stylesheet" href="EditProfile.css">
        <link rel="icon" href="../Images/Icon.png">
        <title>Job Adding Form - Watheq</title>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script> <!--Icons retrevial-->      
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script> <!--Icons retrevial-->      
        <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script> <!--Icons retrevial-->   
        <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script> <!-- jQuery for AJAX functionality -->  
        <script src="../Functions/Logout.js"></script>
        <script src="Validation.js"></script>
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
                    <!-- Notification Code -->
                    <?php
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
                        while ($FunctionRow = $result->fetch_assoc()) {
                            $notifications[] = $FunctionRow;
                            $isSeen = $FunctionRow["isSeen"];
                            $details = $FunctionRow["Details"];
                            $date = $FunctionRow["Date"];
                            $status = $FunctionRow["Status"];
                            $firstName = $FunctionRow["FirstName"];
                            $lastName = $FunctionRow["LastName"];
                            $jobTitle = $FunctionRow["JobTitle"];
                            
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

                <div id="container">
                    <form id="ProfileForm" method="POST">
                        <h2>Edit Profile</h2>
                        <div class="input_wrap">
                            <label for="Name">Company Name <span class="required"></span></label>
                            <input type="text" name="Name" class="input" id="Name" maxlength="100" value='<?php echo $rowName['CompanyName']; ?>'>
                        </div>
                        <div class="input_wrap">
                            <label for="Description">About The Company <span class="required"></span></label>
                            <textarea id="Description" name="Description" cols="50" class="input" maxlength="300"><?php echo $row['Description'];?></textarea>
                        </div>
                        <div class="input_wrap">
                            <label for="Location">Company HQ Location <span class="required"></span></label>
                            <input type="text" name="Location" class="input" id="Location" maxlength="100" value='<?php echo $row['Location']; ?>'>
                        </div>
                        <div class="input_wrap">
                            <label for="Email">Contact Email <span class="required"></span></label>
                            <input type="text" name="Email" class="input" id="Email" maxlength="100" value='<?php echo $row['Email']; ?>'>
                        </div>
                        <div class="input_wrap">
                            <label for="Phone">Phone Number</label>
                            <input type="number" name="Phone" class="input" id="Phone" maxlength="10" value='<?php echo $row['Phone']; ?>'>
                        </div>
                        <div class="input_wrap">
                            <label for="Linkedin">Linkedin URL</label>
                            <input type="text" name="Linkedin" class="input" id="Linkedin" maxlength="100" value='<?php echo $row['Linkedin']; ?>'>
                        </div>
                        <div class="input_wrap">
                            <label for="X">X (Formerly Twitter) URL</label>
                            <input type="text" name="X" class="input" id="X" maxlength="100" value='<?php echo $row['Twitter']; ?>'>
                        </div>
                        <div class="input_wrap">
                            <label for="URL">Website URL</label>
                            <input type="text" name="URL" class="input" id="URL" value='<?php echo $row['Link']; ?>' maxlength="100">
                        </div>
                        <button type="button" class="btnComplete" id="SubmitButton">Edit Profile</button>
                    </form>
                </div>

            </div>

        </div>

        <!--Final Message after submitting the form-->
        <div class="modal_wrapper">
            <div class="shadow"></div> <!--To make the screen dark when message displayed-->
            <div class="success_wrap">
                <span class="modal_icon"><ion-icon name="checkmark-sharp"></ion-icon></span> <!--Checkmark icon-->
                <p>You have successfully edited your profile!</p>
            </div>
            <div class="faliure_wrap">
                <span class="modal_icon"><ion-icon name="close-outline"></ion-icon></span> <!--Cross icon-->
                <p>You need to fill all the required fields</p>
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
