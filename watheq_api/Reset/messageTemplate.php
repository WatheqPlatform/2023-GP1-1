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
 text-align: left;
 " >

    <img src="https://watheqplatform.com/Images/Blue%20Logo.png" style= "max-width: 200px;  height: auto;">
       
    <div>
       
      <h3 style = "color: #0c3a7b;
 font-family: 'Avenir', sans-serif;">Dear <?php echo $Name ?>, <br> </h3>

          <p style = "color: #0c3a7b;
 font-family: 'Avenir', sans-serif;">
              Your reset password code  is:
          </p>

          <h3 style = "color: #0c3a7b;
 font-family: 'Avenir', sans-serif;">
             <?php echo $code ?>
          </h3>
            

           <p style = "color: #0c3a7b;
 font-family: 'Avenir', sans-serif;">
               Please DO NOT share the reset code with anyone, Watheq team will not ask about your password. <br><br>
               If you didn't request a password reset, please ignore this email.
          </p>

                
    </div>
           

</body>
</html>
