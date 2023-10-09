class Connection {
  static const hostConnect =
      "http://192.168.100.11/watheq_api"; // ip of the host devise
  static const signUp = "$hostConnect/watheq_authentication/sign_up.php";
  static const validateEmail = "$hostConnect/watheq_authentication/validation.php";
  static const logIn = "$hostConnect/watheq_authentication/log_in.php";
  static const forgetPassword = "$hostConnect/forget_password.php";
  static const verifyToken = "$hostConnect/verify_code.php";
  static const resetPassword = "$hostConnect/reset_password.php";
  static const jobOffersData = "$hostConnect/getdata.php";
}
