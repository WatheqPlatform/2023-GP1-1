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
        <title>Job Offers - Watheq</title>
        <script src="../Functions/Logout.js"></script>
        <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script> <!--Icons retrevial-->      
        <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script> <!--Icons retrevial-->      
        <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script> <!--Icons retrevial-->     
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="Closeoffer.js"></script>
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
                                echo "<p><a href='../Applications Page/Applications.php?ID=" . $offer["OfferID"] . "&JobTitle=" . $offer["JobTitle"] . "'>View Applications <i class='fa-solid fa-arrow-right'></i></a></p>";
                                echo "</div>";

                                echo "<div id='SecondPart'>";
                                echo "<div id='BottomDiv'>";
                                echo "<p id='Status'>{$offer['Status']} Job Offer</p>";
                                echo "<p id='Date'>Posted On {$offer['Date']}</p>";
                                echo "</div>";
                                echo "<p id='Description'>" . preg_replace('/\s+/', ' ', $offer['JobDescription']) . "</p>";

                                if ($status === 'Active') {
                                    echo "<button type='button' onclick='closeOffer({$offer['OfferID']}, \"{$offer['JobTitle']}\")' id='CloseButton'>Close Offer</button>";
                                }
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
                <p> The Offer Closed Successfully! </p>
            </div>
            <div class="faliure_wrap">
                <!--Cross icon-->
                <div class="text_container">
                    
                    <p></p>

                    <div class="button_container">
                        <button class="confirm_button">Close Offer</button>
                        <button class="cancel_button">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
