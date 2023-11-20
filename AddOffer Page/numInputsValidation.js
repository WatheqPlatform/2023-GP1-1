function validateNumericInput(input, num) {
    var value = input.value;
    var warningMessage = document.getElementById("warningMessage" + num);
    var WarningMax = document.getElementById("warningMessageMaxSalary");
    var minSalary = document.getElementById('minSalary').value;
    var maxSalary = document.getElementById('maxSalary').value;

    if (!value.match(/^\d+$/)) {
        warningMessage.style.display = "block";
    } else {
        warningMessage.style.display = "none";
    }

    if (maxSalary < minSalary)

    {
        WarningMax.style.display = "block";

    } else {
        WarningMax.style.display = "none";
    }
}
