
// Function to close the offer using AJAX
function closeOffer(offerId, jobTitle) {
    var confirmClose = confirm("Are you sure you want to close the offer for '" + jobTitle + "'?");
    if (confirmClose) {
        $.ajax({
            type: "POST",
            url: "CloseOfferLogic.php",
            data: {
                offerId: offerId,
                confirmClose: 'true'
            },
            success: function(response) {
                // Display the confirmation message
                alert(response);
                // Reload the page to reflect the changes
                location.reload();
            },
            error: function(xhr, status, error) {
                var errorMessage = xhr.status + ': ' + xhr.statusText;
                alert("An error occurred while closing the offer. Error: " + errorMessage);
            }
        });
    }
}
