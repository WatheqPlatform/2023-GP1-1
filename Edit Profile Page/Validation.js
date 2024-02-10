$(document).ready(function () {
    $("#SubmitButton").click(function () {
        let inputValues = [
            // REQUIRED FIELDS
            $("#Description").val(),
            $("#Location").val(),
            $("#Email").val(),
            $("#Name").val(),
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
        } else {
            // Send the information to PHP File
            $.post("EditProfileLogic.php", {
                Name: $("#Name").val(),
                Description: $("#Description").val(),
                Location: $("#Location").val(),
                Email: $("#Email").val(),
                Phone: $("#Phone").val(),
                Linkedin: $("#Linkedin").val(),
                X: $("#X").val(),
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
                        window.location.href = "../Profile Page/Profile.php";
                    });
                }
            });
        }
    });
});
