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
// SQL query
$sqlTotal = "SELECT COUNT(a.ApplicationID) AS TotalApplications
        FROM Application a
        JOIN joboffer j ON j.JPEmail = '$email' AND j.OfferID = a.OfferID WHERE a.status != 'Cancelled'";

// Execute the query
$result = $conn->query($sqlTotal);
// Check if the query executed successfully
if ($result->num_rows > 0) {
    // Fetch the result row
    $row = $result->fetch_assoc();
    // Get the total applications count
$TotalApplications = $row['TotalApplications'];}

// Initialize the total accepted applications count
$TotalAcceptedApplications = 0;
// SQL query
$sqlTotalAccepted = "SELECT COUNT(a.ApplicationID) AS TotalAcceptedApplications
        FROM Application a
        JOIN joboffer j ON j.JPEmail = '$email' AND j.OfferID = a.OfferID
        WHERE a.Status = 'Accepted'";

// Execute the query
$result = $conn->query($sqlTotalAccepted);

// Check if the query executed successfully
if ($result->num_rows > 0) {
  // Fetch the result row
  $row = $result->fetch_assoc();

  // Get the total accepted applications count
  $TotalAcceptedApplications = $row['TotalAcceptedApplications'];
}

// Initialize the total pending applications count
$TotalPendingApplications = 0;
// SQL query
$sqlTotalPending = "SELECT COUNT(a.ApplicationID) AS TotalPendingApplications
        FROM Application a
        JOIN joboffer j ON j.JPEmail = '$email' AND j.OfferID = a.OfferID
        WHERE a.Status = 'Pending'";

// Execute the query
$result = $conn->query($sqlTotalPending);

// Check if the query executed successfully
if ($result->num_rows > 0) {
    // Fetch the result row
    $row = $result->fetch_assoc();

    // Get the total pending applications count
    $TotalPendingApplications = $row['TotalPendingApplications'];
}


$conn->close();
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

    </div>  

  </div>
 
</body>
</html>
