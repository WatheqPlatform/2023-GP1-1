$(document).ready(function () {
    $("#SubmitButton").click(function () {
        let inputValues = [
            // REQUIRED FIELDS ONLY
            $("#email").val(),
            $("#password").val(),
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
        else {
            // Send the information to PHP File
            $.post("LogIn.php", {
                email: inputValues[0],
                password: inputValues[1],
            }, function (data) {
                if (data === "success") {
                    window.location.href = "../Home Page/Home.php";
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
                    var faliure_wrap = document.querySelector(".faliure_wrap2");
                    var shadow = document.querySelector(".shadow");

                    modal_wrapper.classList.add("active");
                    faliure_wrap.classList.add("active");

                    // Clicking anywhere on the screen remove the message
                    shadow.addEventListener("click", function () {
                        modal_wrapper.classList.remove("active");
                        faliure_wrap.classList.remove("active");
                    });
                }
                else{
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
                    });
                }
            });
        }
    });
});
