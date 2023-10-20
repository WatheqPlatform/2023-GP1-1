class Connection {
  static const hostConnect =
      "https://watheqplatform.com/watheq_api"; // ip of the host device

  static const signUp = "$hostConnect/authentication/sign_up.php";

  static const validateEmail = "$hostConnect/authentication/validation.php";
  static const logIn = "$hostConnect/authentication/log_in.php";

  static const jobOffersData = "$hostConnect/getdata.php";
  static const jobSeekerData = "$hostConnect/jobseeker_data.php";

  static const forgetPassword = "$hostConnect/forget_password.php";
  static const verifyToken = "$hostConnect/verify_code.php";
  static const resetPassword = "$hostConnect/reset_password.php";
}
