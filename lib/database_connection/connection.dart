class Connection {
  static const hostConnect =
      "http://192.168.100.11/watheq_api"; // ip of the host devise

//Authentication
  static const signUp = "$hostConnect/authentication/sign_up.php";
  static const validateEmail = "$hostConnect/authentication/validation.php";
  static const logIn = "$hostConnect/authentication/log_in.php";

  static const jobOffersData = "$hostConnect/getdata.php";
}
