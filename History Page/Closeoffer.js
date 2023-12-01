
// Function to close the offer using AJAX
function closeOffer(offerId, jobTitle) {
    var failureMessageElement = document.querySelector(".faliure_wrap p");

    failureMessageElement.textContent = "Are you sure you want to close the offer for '" + jobTitle + "'?";

    var modal_wrapper = document.querySelector(".modal_wrapper");
    var failure_wrap = document.querySelector(".faliure_wrap");
    var confirmButton = document.querySelector(".confirm_button");
    var cancelButton = document.querySelector(".cancel_button");
    var shadow = document.querySelector(".shadow");
    var success_wrap = document.querySelector(".success_wrap");

    modal_wrapper.classList.add("active");
    failure_wrap.classList.add("active");


    //Clicking anywhere on the screen remove the sessamge
    shadow.addEventListener("click", function () {

        modal_wrapper.classList.remove("active");
        failure_wrap.classList.remove("active");
    });
    // var confirmClose = confirm("Are you sure you want to close the offer for '" + jobTitle + "'?");
    confirmButton.addEventListener("click", function () {
        $.ajax({
            type: "POST",
            url: "CloseOfferLogic.php",
            data: {
                offerId: offerId,
                confirmClose: 'true'
            },
            success: function (response) {
                modal_wrapper.classList.remove("active");
                failure_wrap.classList.remove("active");
                // Display the confirmation message
                //  alert(response);
                modal_wrapper.classList.add("active");
                success_wrap.classList.add("active");
                shadow.addEventListener("click", function () {
                    modal_wrapper.classList.remove("active");
                    success_wrap.classList.remove("active");
                    // Reload the page to reflect the changes
                    location.reload();
                });
            },
            error: function (xhr, status, error) {
                var errorMessage = xhr.status + ': ' + xhr.statusText;
                alert("An error occurred while closing the offer. Error: " + errorMessage);
            }
        });
    });

    cancelButton.addEventListener("click", function () {
        // User clicked on "cancel" button
        modal_wrapper.classList.remove("active");
        failure_wrap.classList.remove("active");
    });
}
