document.addEventListener('DOMContentLoaded', function () {
    // Retrieve the email from the URL query parameters
    var urlParams = new URLSearchParams(window.location.search);
    var emailParam = urlParams.get('email');

    // Retrieve the email input field
    var emailInput = document.querySelector('input[name="email"]');

    // Pre-fill the email input field with the retrieved email
    if (emailParam) {
        emailInput.value = emailParam;
    }
});
