class UserLoginModel {
  final String email;
  final String password;
  String? token;

  UserLoginModel({
    required this.email,
    required this.password,
    this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return UserLoginModel(
      email: json['email'],
      password: json['password'],
      token: json['token'], // Assuming API returns token
    );
  }
}
