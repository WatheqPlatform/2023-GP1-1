class User {
  String userEmail;
  String userFisrtName;
  String userLastName;
  String userPassword;

  User(
      this.userEmail, this.userFisrtName, this.userLastName, this.userPassword);

  factory User.fromJson(Map<String, dynamic> json) => User(
        json["JobSeekerEmail"],
        json["FirstName"],
        json["LastName"],
        json["Password"],
      );

  // convert to json
  Map<String, dynamic> toJson() => {
        "email": userEmail,
        "first_name": userFisrtName,
        "last_name": userLastName,
        "password": userPassword
      };
}
