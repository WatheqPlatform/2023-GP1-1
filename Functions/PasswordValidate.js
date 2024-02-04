function validatePassword() {
    var passwordInput = document.getElementById("passwordInput");
    var passwordMessage = document.getElementById("passwordMessage");

    var passwordRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()\-_=+{};:,<.>])(?!.*\s).{8,}$/;
    var password = passwordInput.value;

    if (passwordRegex.test(password)) {
      passwordMessage.innerHTML = "Password is valid.";
      passwordMessage.style.color = "green";
      passwordMessage.style.maxWidth = "51vh";
      passwordMessage.style.fontSize = "12px";
      passwordMessage.style.textAlign = "center";
    } else {
      passwordMessage.innerHTML = "Password must contain at least one lowercase letter, one uppercase letter, one digit, one special character, and be at least 8 characters long.";
      passwordMessage.style.color = "red";
      passwordMessage.style.maxWidth = "51vh";
      passwordMessage.style.fontSize = "12px";
      passwordMessage.style.textAlign = "center";
    }
}

function validatePassword2() {
var passwordInput = document.getElementById("passwordInput");
var passwordInput2 = document.getElementById("passwordInput2");
var passwordMessage = document.getElementById("CpasswordMessage");


if (passwordInput.value!==passwordInput2.value) {
  passwordMessage.innerHTML = "Passwords do not match";
  passwordMessage.style.color = "red";
  passwordMessage.style.maxWidth  = "51vh";
  passwordMessage.style.fontSize = "12px";
  passwordMessage.style.textAlign = "center";
} 
else {
    passwordMessage.style.display = "none";
}
}