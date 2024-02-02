function sortApplications() {
    var selectedOption = document.getElementById("sorting").value;

    // Perform AJAX request to fetch sorted data
    $.ajax({
        type: "POST",
        url: "SortApplications.php",
        data: { sort: selectedOption },
        success: function (data) {
            document.getElementById("pending").innerHTML=data;
                              
        },
        error: function () {
            alert("There is an error, try again later");
        }
    });
}
