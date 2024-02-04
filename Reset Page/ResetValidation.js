$(document).ready(function () {
    $("#SubmitButton").click(function () {
        password=$("#passwordInput").val();
        token=$("#token").val();
        sessionid=$("#ID").val();
        
        let isEmpty = false;
      
        if (password === undefined || password === null || password === "") {  
            isEmpty = true;
        }
        if (isEmpty) {
            var modal_wrapper = document.querySelector(".modal_wrapper");
            var faliure_wrap = document.querySelector(".faliure_wrap");
            var shadow = document.querySelector(".shadow");

            modal_wrapper.classList.add("active");
            faliure_wrap.classList.add("active");

            // Clicking anywhere on the screen remove the message
            shadow.addEventListener("click", function () {
                modal_wrapper.classList.remove("active");
                faliure_wrap.classList.remove("active");
            });
        }
        else  if ( $("#passwordInput").val()!== $("#passwordInput2").val()) {

            var modal_wrapper = document.querySelector('.modal_wrapper');
               var faliure_wrap = document.querySelector('.faliure_wrap5');
               var shadow = document.querySelector('.shadow');

               modal_wrapper.classList.add('active');
               faliure_wrap.classList.add('active');

               // Clicking anywhere on the screen remove the message
               shadow.addEventListener('click', function () {
                   modal_wrapper.classList.remove('active');
                   faliure_wrap.classList.remove('active');
               });
   }
        else {
            // Send the information to PHP File
            $.post("ResetPasswordd.php", {
                Newpassword:password,
                Newtoken: token,
                sessionID: sessionid
    
            }, function (data) {
                if (data === "success") {
                    var modal_wrapper = document.querySelector(".modal_wrapper");
                    var success_wrap = document.querySelector(".success_wrap");
                    var shadow = document.querySelector(".shadow");

                    modal_wrapper.classList.add("active");
                    success_wrap.classList.add("active");

                    // Clicking anywhere on the screen remove the message
                    shadow.addEventListener("click", function () {
                        modal_wrapper.classList.remove("active");
                        success_wrap.classList.remove("active");
                        window.location.href="../LogIn Page/LogIn.html";
                    });
                   
                } else if (data === "failure2") {
                    var modal_wrapper = document.querySelector('.modal_wrapper');
                    var faliure_wrap = document.querySelector('.faliure_wrap2');
                    var shadow = document.querySelector('.shadow');

                    modal_wrapper.classList.add('active');
                    faliure_wrap.classList.add('active');

                    // Clicking anywhere on the screen remove the message
                    shadow.addEventListener('click', function () {
                        modal_wrapper.classList.remove('active');
                        faliure_wrap.classList.remove('active');
                        window.location.href="../Reset Page/ForgotPasswordd.php";
                    });

                }
                else if (data === "failure3") {
                    var modal_wrapper = document.querySelector('.modal_wrapper');
                    var faliure_wrap = document.querySelector('.faliure_wrap3');
                    var shadow = document.querySelector('.shadow');

                    modal_wrapper.classList.add('active');
                    faliure_wrap.classList.add('active');

                    // Clicking anywhere on the screen remove the message
                    shadow.addEventListener('click', function () {
                        modal_wrapper.classList.remove('active');
                        faliure_wrap.classList.remove('active');
                        window.location.href="../Reset Page/ForgotPasswordd.php";
                    });

                }
                else if (data === "failure4") {
                    var modal_wrapper = document.querySelector('.modal_wrapper');
                    var faliure_wrap = document.querySelector('.faliure_wrap4');
                    var shadow = document.querySelector('.shadow');

                    modal_wrapper.classList.add('active');
                    faliure_wrap.classList.add('active');

                    // Clicking anywhere on the screen remove the message
                    shadow.addEventListener('click', function () {
                        modal_wrapper.classList.remove('active');
                        faliure_wrap.classList.remove('active');
                    });

                }
                
            });
        }
    });
});