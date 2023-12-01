$(document).ready(function () {
    $("#SubmitButton").click(function () {

        email=$("#email").val();
        let isEmpty = false;

        if (email === undefined || email === null || email === "") {
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
        else {
            // Send the information to PHP File
            $.post("ForgotPassword.php", {
                email: email
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

                }
            });
        }
    });
});
