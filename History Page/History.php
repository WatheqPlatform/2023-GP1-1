<?php
include('HistoryLogic.php');
?>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'> <!--Icons retrevial-->              
    <link href="https://fonts.googleapis.com/css?family=Lato:100" rel="stylesheet">
    <link rel="stylesheet" href="History.css">
    <link rel="icon" href="../Images/Icon.png">
    <title>History - Watheq</title>
    <script src="../Functions/logout.js"></script>
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
                <a href="../Home Page/Home.php"> Home </a>
                <a href=""> Profile </a>
                <a href="../History Page/History.php" id="CurrentPage"> History </a>
                <a href="../AddOffer Page/AddOffer.html"> Add Offer </a> 
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

            <div id="Offers">

                <?php
                    if (!empty($availableOffers)) {
                        echo "<h1>Offers List</h1>";
                        foreach ($availableOffers as $offer) {
                            echo "<div id='WholeOffer'>";
                            echo "<div id='FirstPart'>";
                            echo "<p id='Title'>Job Title</p>";
                            echo "<p id='JobTitle'>{$offer['JobTitle']}</p>";
                            echo "<p><a href='#'>View Offer Details <i class='fa-solid fa-arrow-right'></i></a></p>";
                            echo "</div>";

                            echo "<div id='SecondPart'>";
                            echo "<p id='Status'>{$offer['Status']} Job Offer</p>";
                            echo "<p id='Description'>{$offer['JobDescription']}</p>";
                            echo "<button id='CloseButton'>Close Offer</button>";
                            echo "</div>";

                            echo "</div>";
                        }
                    }

                    if (!empty($closedOffers)) {
                        foreach ($closedOffers as $offer) {
                            echo "<div id='WholeOffer'>";

                            echo "<div id='FirstPart'>";
                            echo "<p id='Title'>Job Title</p>";
                            echo "<p id='JobTitle'>{$offer['JobTitle']}</p>";
                            echo "<p><a href='#'>View Offer Details <i class='fa-solid fa-arrow-right'></i></a></p>";
                            echo "</div>";

                            echo "<div id='SecondPart'>";
                            echo "<p id='Status'>{$offer['Status']} Job Offer</p>";
                            echo "<p id='Description'>{$offer['JobDescription']}</p>";
                            echo "</div>";

                            echo "</div>";
                        }
                    }  

                    if (empty($availableOffers) && empty($closedOffers)) {
                        echo "<p id='Empty'>No available job offers found.</p>";
                    }
                ?> 

            </div> 

        </div> 

    </div>
    
   
</body>
</html>
