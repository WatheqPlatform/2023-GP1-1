<?php
session_start();
if (!isset($_SESSION['JPEmail'])) {
  header("Location: ../index.php"); 
  exit();
}

include("../dbConnection.php");

$email = $_SESSION['JPEmail'];  // Set the variable with the logged-in provider's email

$companyName = "";
$retrieveCompanyNameQuery = "SELECT CompanyName FROM jobprovider WHERE JobProviderEmail = '$email'";
$result = $conn->query($retrieveCompanyNameQuery);
if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $companyName = $row["CompanyName"];
}

$totalOffers = 0;
$retrieveTotalOffersQuery = "SELECT COUNT(*) AS TotalOffers FROM joboffer WHERE JPEmail = '$email'";
$result = $conn->query($retrieveTotalOffersQuery);
if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $totalOffers = $row["TotalOffers"];
}

$activeOffers = 0;
$retrieveActiveOffersQuery = "SELECT COUNT(*) AS ActiveOffers FROM joboffer WHERE JPEmail = '$email' AND Status = 'Active'";
$result = $conn->query($retrieveActiveOffersQuery);
if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $activeOffers = $row["ActiveOffers"];
}

$closedOffers = $totalOffers  - $activeOffers;

$TotalApplications =0;
$sqlTotal = "SELECT COUNT(a.ApplicationID) AS TotalApplications
        FROM application a
        JOIN joboffer j ON j.JPEmail = '$email' AND j.OfferID = a.OfferID WHERE a.status != 'Cancelled'";

$result = $conn->query($sqlTotal);
if ($result->num_rows > 0) {
  $row = $result->fetch_assoc();
  $TotalApplications = $row['TotalApplications'];
}

$TotalAcceptedApplications = 0;
$sqlTotalAccepted = "SELECT COUNT(a.ApplicationID) AS TotalAcceptedApplications
        FROM application a
        JOIN joboffer j ON j.JPEmail = '$email' AND j.OfferID = a.OfferID
        WHERE a.Status = 'Accepted'";

$result = $conn->query($sqlTotalAccepted);
if ($result->num_rows > 0) {
  $row = $result->fetch_assoc();
  $TotalAcceptedApplications = $row['TotalAcceptedApplications'];
}

$TotalPendingApplications = 0;
$sqlTotalPending = "SELECT COUNT(a.ApplicationID) AS TotalPendingApplications
        FROM application a
        JOIN joboffer j ON j.JPEmail = '$email' AND j.OfferID = a.OfferID
        WHERE a.Status = 'Pending'";

$result = $conn->query($sqlTotalPending);
if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $TotalPendingApplications = $row['TotalPendingApplications'];
}

?>


<!DOCTYPE html>
<html>

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'> <!--Icons retrevial-->                
  <link href="https://fonts.googleapis.com/css?family=Lato:100" rel="stylesheet">
  <link rel="stylesheet" href="Home.css">
  <link rel="icon" href="../Images/Icon.png">
  <title>Home - Watheq</title>
  <script src="../Functions/Logout.js"></script>
  <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script> <!--Icons retrevial-->      
  <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script> <!--Icons retrevial-->      
  <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script> <!--Icons retrevial-->  
  <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script> <!-- jQuery for AJAX functionality -->  
  <script src="../Functions/DisplayNotification.js"></script> 
</head>

<body>

  <div id="Main">

    <div id="Header">

      <div id="HeaderStart">
        <a href="../Home Page/Home.php" id="LogoLink">
          <img src="../Images/White Logo.png" alt="Watheq Logo" id="logo">
        </a>
        <a href="../Home Page/Home.php" id="CurrentPage"> Home </a>
        <a href="../Profile Page/Profile.php"> Profile </a>
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

      <div id="Statstics">

        <h1 id="companyName">WELCOME <?php echo $companyName; ?>!</h1>

        <div id="Statstic">

          <div>
            <h2 id="TotalOffers">
              <?php echo $totalOffers; ?>
            </h2>
            <p>
              Total Posted Offers<br>
              <a href="../History Page/History.php">View All Offers <i class="fa-solid fa-arrow-right"></i></a>
            </p>
          </div>

          <div>
            <h2 id="activeOffer">
              <?php echo $activeOffers; ?>
            </h2>
            <p>
              Active Offers
            </p>
          </div>

          <div>
            <h2 id="closedOffers">
              <?php echo $closedOffers; ?>
            </h2>
            <p>
              Closed Offers
            </p>
          </div>
              
          <div>
            <h2><?php echo $TotalApplications; ?></h2>
            <p>
              Total Job Applications
            </p>
          </div>

          <div>
            <h2><?php echo $TotalAcceptedApplications; ?></h2>
            <p>
              Accepted Applications
            </p>
          </div>
              
          <div>
            <h2><?php echo $TotalPendingApplications; ?></h2> 
              <p> 
                Pending Applications
              </p>
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
  </div>
 
</body>
</html>
