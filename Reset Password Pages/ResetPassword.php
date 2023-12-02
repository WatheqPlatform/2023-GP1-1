<?php

 include("../dbConnection.php");

 // Check if the token is provided in the URL parameter
 if (isset($_GET["token"]) || ($_SERVER["REQUEST_METHOD"] == "POST" && $_POST["Newtoken"] !="")) {
    
    if (isset($_GET["token"]) && $_GET["token"] != "") {
        $token = urldecode($_GET["token"]);
    } elseif (isset($_POST["Newtoken"]) && $_POST["Newtoken"] != "") {
        $token = $_POST["Newtoken"];
    } else {
         $token="";
    }
  
    if ($_SERVER["REQUEST_METHOD"] == "POST") {
        
        // Retrieve the email and timestamp associated with the token
        $stmt = $conn->prepare("SELECT Email, Timestamp FROM providerresettokens WHERE Token =  ? ");
        $stmt->bind_param("s", $token);
        if($stmt->execute()){
           $result = $stmt->get_result();
        }
        
        if ($result->num_rows > 0) {      
            $row = $result->fetch_assoc();
            $email = $row["Email"];
            $timestamp = $row["Timestamp"];
        } else {
            echo "failure3";   
            exit();
        }
        
        // Check if the token is still valid (e.g., not expired)
        $expirationTime = 3 * 60; // Token expires after 3 minutes 
        if (time() - $timestamp < $expirationTime) {
            // Token is valid, allow the user to reset the password
            
            $newPassword = $_POST["Newpassword"];
            $passwordRegex = "/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()\-_=+{};:,<.>])(?!.*\s).{8,}$/";
            
            if (!preg_match($passwordRegex, $newPassword)) {           
                echo "failure4";   
                exit();
            }
            // Update the password in the database for the corresponding email address
            $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);        
            $stmt2 = $conn->prepare("UPDATE jobprovider SET Password = ? WHERE JobProviderEmail = ? ");
            $stmt2->bind_param("ss", $hashedPassword , $email);
            $stmt2->execute();
            echo "success";
            exit();  
            
        }else {
            echo "failure2";    
            exit();
        }
    }
    
} else {
    echo '<script>window.location.href="../index.php";</script>';
    exit();
}
?>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="Password.css">
    <link rel="icon" href="../Images/Icon.png">
    <title>Reset Password - Watheq</title>
    <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script> <!--Icons retrevial-->
    <script type="module" src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.esm.js"></script> <!--Icons retrevial-->      
    <script nomodule src="https://unpkg.com/ionicons@7.1.0/dist/ionicons/ionicons.js"></script> <!--Icons retrevial-->      
    <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script> <!--Icons retrevial--> 
    <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script> <!--Icons retrevial-->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://kit.fontawesome.com/cc933efecf.js" crossorigin="anonymous"></script> <!--Icons retrevial-->
    <script src="../Functions/ValidatePassword.js"></script>
    <script src="ResetValidation.js"></script>
</head>

<body>

    <div id="Main">

        <div id="Main1">

            <div id="header">
                <a href="../index.php">
                    <img src="../Images/White Logo.png" alt="Watheq Logo" id="logo">
                </a>
            </div>

            <div id="Content">
                <div id="MainContent">
                    <h1>
                        You're Almost There! 
                    </h1>
                    <p>
                        Please note that for security reasons, this password reset link is unique to your account. Do not share this link with anyone to ensure the confidentiality and integrity of your account information.
                    </p>
                </div>

                <div id="MainContent2">
                    If you encounter any issues or have questions, our support team is ready to assist you through our social media accounts. 
                    Thank you for choosing Watheq for your hiring needs!
                </div>     
            </div>

        </div>

        
        <div id="ResetPasswordForm">

            <h2>Reset Password</h2>
            <p id="FormSentence">
                Please enter a new password for your account
            </p>

            <form id="resetPasswordForm" method="POST">
                <input type="hidden" name="token" id="token" value="<?php echo htmlspecialchars($token); ?>">
                <label for="new_password">New Password</label>
                <input type="password" name="new_password" id="passwordInput" onkeyup="validatePassword()"  required>
                <div id="passwordMessage"></div>
                <input type="button" value="Reset Password" id="SubmitButton">
            </form>


            <div class="social-icons">
                <a href="https://www.facebook.com/profile.php?id=61552475874538"  id="facebook" title="facebook"> 
                    <i class="fa-brands fa-square-facebook" aria-hidden="true"></i>
                </a>
                <a href="https://www.linkedin.com/in/watheq-platform-980a02295/" id="linkedin" title="linkedin">
                    <i class="fa-brands fa-linkedin" aria-hidden="true"></i>
                </a>
                <a href="https://twitter.com/WatheqPlatform" id="twitter" title="twitter"> 
                    <i class="fa-brands fa-square-x-twitter" aria-hidden="true"></i>
                <a href="https://www.youtube.com/channel/UCoKOXPubwqwW0TiycHcrvdw" id="youtube" title="youtube">
                    <i class="fa-brands fa-square-youtube" aria-hidden="true"></i>
                </a>
            </div>
        </div>

        <div class="modal_wrapper">
            <div class="shadow"></div> <!--To make the screen dark when message displayed-->
            <div class="faliure_wrap">
                <span class="modal_icon"><ion-icon name="close-outline"></ion-icon></span> <!--Cross icon-->
                <p>Please fill all the required information</p>
            </div>
            <div class="faliure_wrap2">
                <span class="modal_icon"><ion-icon name="close-outline"></ion-icon></span> <!--Cross icon-->
                <p>The password reset link has expired, please request a new one</p>
            </div>
            <div class="faliure_wrap3">
                <span class="modal_icon"><ion-icon name="close-outline"></ion-icon></span> <!--Cross icon-->
                <p>Invalid link, Please request a new password reset link</p>
            </div>
            <div class="faliure_wrap4">
                <span class="modal_icon"><ion-icon name="close-outline"></ion-icon></span> <!--Cross icon-->
                <p>Password must satisfy the specified rules</p>
            </div>
            <div class="success_wrap">
                <span class="modal_icon"><ion-icon name="checkmark-sharp"></ion-icon></span> <!--Checkmark icon-->
                <p>Password reset successfully, you can log in now.</p>
            </div>
        </div>

    </div>
</body>
</html>

<?php
$conn->close(); // Close the database connection
?>