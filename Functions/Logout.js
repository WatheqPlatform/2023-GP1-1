document.addEventListener("DOMContentLoaded", function() {
    // Get the logout button element
    var logoutButton = document.getElementById("logoutButton");

    // Add a click event listener to the logout button
    logoutButton.addEventListener("click", function() {
        // Display a confirmation dialog
        var confirmLogout = confirm("Are you sure you want to logout?");
        
        // Check the user's choice
        if (confirmLogout) {
            // If the user confirms, redirect to the logout page or perform logout actions
            window.location.href = "../index.php"; 
        } else {
            // If the user cancels, do nothing or stay on the current page
        }
    });
});


