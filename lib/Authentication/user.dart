class User {
  String userEmail;
  String userName;
  String userPassword;

  User(this.userEmail, this.userName, this.userPassword);

  factory User.fromJson(Map<String, dynamic> json) => User(
        json["JobSeekerEmail"],
        json["Name"],
        json["Password"],
      );

  // convert to json
  Map<String, dynamic> toJson() =>
      {"email": userEmail, "name": userName, "password": userPassword};
}
