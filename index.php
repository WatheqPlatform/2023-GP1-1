<?php
session_start();
// Destroy the session to log the user out
if (isset($_SESSION['JPEmail'])) {
    session_destroy();
}
?>


<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="index.css">
    <link rel="icon" href="Images/Icon.png">
    <title>Watheq</title>
</head>

<body>

    <div id="Main">

        <div id="header">
            <a href="index.php">
                <img src="Images/White Logo.png" alt="Watheq Logo" id="logo">
            </a>
            <div id="RegistrationButtons">
                <a href="LogIn Page/LogIn.html">
                    <button id="SignInButton">Sign In</button>
                </a>
                <a href="SignUp page/SignUp.html">
                    <button id="SignUpButton">Sign Up</button>
                </a>
            </div>
        </div>
    
        <div id="MainContent">
            <div id="MainContent1">
                <img src="Images/Start1.svg" alt="" id="PhraseImage">
                <a href="#WhoWeAreSection">
                    <button id="DiscoverButton">Discover More</button> 
                </a>     
            </div>          
            <img src="Images/Start2.svg" alt="Download Watheq Application" id="DonloadImage">    
        </div>

        <!-- Moving Waves-->
        <div id="Waves">
            <div class='air air1'></div>
            <div class='air air2'></div>
            <div class='air air3'></div>
            <div class='air air4'></div>
        </div>

    </div>
   
    
    <div id="WhoWeAreSection">
        <h1>
           Who We Are? 
        </h1>
        <p>
            Welcome to Watheq, where innovation meets opportunity. We understand the dynamic challenges both job seekers and providers face in the ever-evolving job market. 
            At Watheq, we strive to redefine the employment experience by offering a platform that seamlessly connects talent with career opportunities. 
            Our commitment to simplicity, efficiency, and empowerment forms the foundation of Watheq, unlocking a world of possibilities for both employers and job seekers.
            Join us on this transformative journey as we revolutionize the way you discover talent or find your next career move. With Watheq, the future of employment is at your fingertips.
        </p>
    </div>

    <div id="FeaturesSection">
        <h1>
            Job Providers Services
        </h1>
        <div id="Features">
            <div>
                <h2>Effortless Job <br> Posting</h2>
                <p>
                    Simplify your job posting process by effortlessly creating detailed job offers. Specify job titles, descriptions, required qualifications, and more using our user-friendly interface.
                </p>
            </div>
    
            <div>
                <h2>Simplified Job <br>Management</h2>
                <p> 
                    Manage your job offers seamlessly from creation to fulfillment through easily view job applications, review applicants' CVs, and change the status of applications and job openings.
            </div>
    
            <div>
                <h2>Smart Application <br> Filtering</h2>
                <p>
                    Enhance your candidate selection process by our advanced algorithms that analyze job applications, sorting them based on the relevance of skills and qualifications to your job descriptions.
                </p>
            </div>
        </div>       
    </div>

    <footer>
        <div class="copyright">
            <p>&copy; 2023 Watheq. All rights reserved.</p>
        </div>
    </footer>


</body>
</html>
