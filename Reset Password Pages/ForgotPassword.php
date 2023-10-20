
<?php
include("../dbConnection.php");

// Form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
    $email = $_POST["email"];

    // Check if the email exists in the database
    $stmt = $conn->prepare("SELECT * FROM jobprovider WHERE JobProviderEmail = ?");
    
    $stmt->bind_param("s", $email);
    
    if($stmt->execute()){
       $result = $stmt->get_result();
    }

    if ($result->num_rows > 0) {
        // Generate a unique token
        $token = generateToken();

        // Store the token in the database along with the email and timestamp
        $timestamp = time();

        $checkQuery =$conn-> prepare( "SELECT * from providerresettokens WHERE Email = ? ");

        $checkQuery->bind_param("s",$email);

        $checkQuery->execute();

        $checkResult = $checkQuery->get_result();

        if($checkResult-> num_rows > 0){//have previous record

            $updateToken = $conn->prepare( "UPDATE providerresettokens  SET Token = ? , Timestamp = ? WHERE Email = ? ");

            $updateToken->bind_param("sis",$token,$timestamp,$email);

            $updateToken->execute();

        }
        else{//first time

        $stmt2 = $conn->prepare("INSERT INTO providerresettokens (Email, Token, Timestamp) VALUES (?, ? , ?)");
         
        $stmt2->bind_param("ssi", $email , $token , $timestamp);
        
        $stmt2->execute();

        }


        // Send the password reset email
        sendPasswordResetEmail($email, $token);

        echo "<script>alert('A password reset link has been sent to your email. Please check your inbox.');</script>";
          
    } else {
        echo "<script>alert('Email does not exist. Please try again.');</script>";
    }
}

function generateToken() {
    // Generate a random string as the token 
    $length = 32;
    $characters = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $token = '';
    for ($i = 0; $i < $length; $i++) {
        $token .= $characters[rand(0, strlen($characters) - 1)];
    }
    return $token;
}

function sendPasswordResetEmail($email, $token) {
    // Send the password reset email to the user  
    $to = $email;
    $subject = "Password Reset Check";

    $headers  = 'MIME-Version: 1.0' . "\r\n";
    $headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
    $headers .= 'From: watheq.ksu@gmail.com'  . "\r\n";

    $resetLink = "https://www.watheqplatform.com/Reset%20Password%20Pages/ResetPassword.php?token=" . urlencode($token);

    ob_start();
    include("messageTamplate.php");
    $message = ob_get_contents();
     
    ob_end_clean();

    $sent = mail($to, $subject, $message, $headers);
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
                        How To Reset <br> My Account Password?
                    </h1>
                    <p>
                        An email will be sent to your registered email address with instructions on how to reset your password. Please make sure to check your spam folder if you don't receive the email shortly.
                    </p>
                </div>

                <div id="MainContent2">
                    If you encounter any issues or have questions, our support team is ready to assist you through our social media accounts. 
                    Thank you for choosing Watheq for your hiring needs!
                </div>     
            </div>

        </div>

            
        <div id="ResetPasswordForm">

            <h2>Account Recovery</h2>
            <p id="FormSentence">
            Enter the email address associated with your <br> account and we'll send you a link to reset your <br> password
            </p>

            <form id="resetPasswordForm" method="POST" action="<?php echo $_SERVER['PHP_SELF']; ?>">
                <label for="email">Email</label>
                <input type="email" name="email" required>

                <input type="submit" value="Send Email">
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