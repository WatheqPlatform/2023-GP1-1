function validatePassword() {
    var passwordInput = document.getElementById("passwordInput");
    var passwordMessage = document.getElementById("passwordMessage");

    var passwordRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()\-_=+{};:,<.>])(?!.*\s).{8,}$/;
    var password = passwordInput.value;

    if (passwordRegex.test(password)) {
      passwordMessage.innerHTML = "Password is valid.";
      passwordMessage.style.color = "green";
      passwordMessage.style.width = "52.8vh";
      passwordMessage.style.fontSize = "12px";
    } else {
      passwordMessage.innerHTML = "Password must contain at least one lowercase letter, one uppercase letter, one digit, one special character, and be at least 8 characters long.";
      passwordMessage.style.color = "red";
      passwordMessage.style.width = "52.8vh";
      passwordMessage.style.fontSize = "12px";
      passwordMessage.style.paddingLeft = "10px";
    }
}