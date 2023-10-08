class User {
  String user_email;
  String user_fisrtName;
  String user_LastName;
  String user_password;

  User(this.user_email, this.user_fisrtName, this.user_LastName,
      this.user_password);

  factory User.fromJson(Map<String, dynamic> json) => User(
        json["JobSeekerEmail"],
        json["FirstName"],
        json["LastName"],
        json["Password"],
      );

  // convert to json
  Map<String, dynamic> toJson() => {
        "email": user_email,
        "first_name": user_fisrtName,
        "last_name": user_LastName,
        "password": user_password
      };
}
