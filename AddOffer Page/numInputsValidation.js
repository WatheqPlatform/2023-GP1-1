function validateNumericInput(input, num) {
  var value = input.value;
  var warningMessage = document.getElementById("warningMessage" + num);

  if (!value.match(/^\d+$/)) {
    warningMessage.style.display = "inline";
  } else {
    warningMessage.style.display = "none";
  }
}
