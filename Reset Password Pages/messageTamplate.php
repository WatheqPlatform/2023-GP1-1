<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Reset Tamplet</title>
</head>

<body style= 
"background-color: rgb(246, 246, 246);
 border-radius: 8px;
 max-width: 400px;
 padding: 20px 35px;
 margin: 0 auto;
 color:#0c3a7b;
 font-family: 'Avenir', sans-serif;
 text-align: left;" >

    <img src="https://watheqplatform.com/Images/Blue%20Logo.png" style= "max-width: 200px;  height: auto;">
       
    <div>
                
      <?php

        include("../dbConnection.php");

        $companyName = "";
        $retrieveCompanyNameQuery = "SELECT CompanyName FROM jobprovider WHERE JobProviderEmail = '$email'";

         $result = $conn->query($retrieveCompanyNameQuery);

         if ($result->num_rows > 0) {
           $row = $result->fetch_assoc();
           $companyName = $row["CompanyName"];
        }

     ?>

        
      <h3>Dear <?php echo $companyName ?>, <br> </h3>

          <p>
              Click the following button to reset your password.
          </p>
              
           <a href=<?php echo$resetLink ?> style="text-decoration: none;">
            
             <input type="submit" value="Reset Password" id="button" style =
              " display: block;
                 width: 45vh;
                 height: 40px;
                 border: 0px;
                 border-radius: 10px; 
                 color: white;
                 font-size: 18px;
                 margin-bottom: 25px;
                 background-color: #14386e;
                 "
                 >
                
           </a>

           <p>
               Please DO NOT share the reset link with anyone, Watheq team will not ask about your password. <br><br>
               If you didn't request a password reset, please ignore this email.
          </p>

                
    </div>
           

</body>
</html>
