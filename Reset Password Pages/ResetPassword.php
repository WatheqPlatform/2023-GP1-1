<?php

 include("../dbConnection.php");

// Check if the token is provided in the URL parameter
if (isset($_GET["token"])) {
    
    $token = urldecode($_GET["token"]);

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

        // Check if the token is still valid (e.g., not expired)
        $expirationTime = 3 * 60; // Token expires after 3 minutes 
        if (time() - $timestamp < $expirationTime) {
            // Token is valid, allow the user to reset the password
            if ($_SERVER["REQUEST_METHOD"] == "POST") {
                
                $newPassword = $_POST["new_password"];
                
                $passwordRegex = "/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()\-_=+{};:,<.>])(?!.*\s).{8,}$/";
                
           if (!preg_match($passwordRegex, $newPassword)) {
               
              echo "<script>alert('Password must be at least 8 characters long and contain at least one uppercase letter, one lowercase letter, one number, and one special character.');</script>";
              
             echo '<script>window.location.href = "PasswordResset.php?token=' . urlencode($token). '</script>';
             
                 exit();
    }

                // Update the password in the database for the corresponding email address
                $hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);
                
                $stmt2 = $conn->prepare("UPDATE jobprovider SET Password = ? WHERE JobProviderEmail = ? ");
                
                 $stmt2->bind_param("ss", $hashedPassword , $email);
    
                 $stmt2->execute();

            

                echo "<script>alert('Password reset successful. You can now login with your new password.');</script>";
                
                echo '<script>window.location.href = "../LogIn Page/LogIn.html?email=' . urlencode($email) . '";</script>';
            }
        } else {
            echo "<script>alert('The password reset link has expired. Please request a new one.');</script>";
            
            echo '<script>window.location.href="index.php";</script>';
            exit();
        }
    } else {
        echo "<script>alert('Invalid link. Please request a new password reset link.');</script>";
        
         echo '<script>window.location.href="../index.php";</script>';
         exit();
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
    <script src="../Functions/ValidatePassword.js"></script>
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

            <form id="resetPasswordForm" method="POST" action="<?php echo $_SERVER['PHP_SELF'] . '?token=' . urlencode($token); ?>">
                <label for="new_password">New Password</label>
                <input type="password" name="new_password" id="passwordInput" onkeyup="validatePassword()"  required>
                <div id="passwordMessage"></div>
                <input type="submit" value="Reset Password">
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

    </div>
</body>
</html>

<?php
$conn->close(); // Close the database connection
?>