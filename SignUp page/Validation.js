$(document).ready(function () {
    $("#SubmitButton").click(function () {
        let inputValues = [
            // REQUIRED FIELDS ONLY
            $("#companyName").val(),
            $("#email").val(),
        ];
        let isEmpty = false;
        // Check if any item in the array is empty
        inputValues.forEach(value => {
            if (value == undefined || value == null || value === "") {
                isEmpty = true;
            }
        });

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
                    var faliure_wrap = document.querySelector('.faliure_wrap6');
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
            $.post("SignUp.php", {
                companyName: inputValues[0],
                email: inputValues[1],
                password: $("#passwordInput").val(),
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
                        window.location.href = "../LogIn Page/LogIn.html?email="+inputValues[1];
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
                    });

                } else if (data === "failure3") {
                    // Handle failure2 case
                    var modal_wrapper = document.querySelector(".modal_wrapper");
                    var faliure_wrap = document.querySelector(".faliure_wrap3");
                    var shadow = document.querySelector(".shadow");

                    modal_wrapper.classList.add("active");
                    faliure_wrap.classList.add("active");

                    // Clicking anywhere on the screen remove the message
                    shadow.addEventListener("click", function () {
                        modal_wrapper.classList.remove("active");
                        faliure_wrap.classList.remove("active");
                        window.location.href = "../LogIn Page/LogIn.html?email="+inputValues[1];
                    });
                }
                else if (data === "failure5") {

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
                else{
                    alert(data);
                    // Handle failure2 case
                    var modal_wrapper = document.querySelector(".modal_wrapper");
                    var faliure_wrap = document.querySelector(".faliure_wrap4");
                    var shadow = document.querySelector(".shadow");

                    modal_wrapper.classList.add("active");
                    faliure_wrap.classList.add("active");

                    // Clicking anywhere on the screen remove the message
                    shadow.addEventListener("click", function () {
                        modal_wrapper.classList.remove("active");
                        faliure_wrap.classList.remove("active");
                    });
                }
            });
        }
    });
});
