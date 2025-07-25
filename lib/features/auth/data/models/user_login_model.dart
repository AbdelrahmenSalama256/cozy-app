// features/auth/data/models/user_login_model.dart
class UserLoginModel {
  final String? token;
  final int? id;
  final String? username;
  final String? mobile;

  UserLoginModel({
    this.token,
    this.id,
    this.username,
    this.mobile,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return UserLoginModel(
      token: data?['token'] as String?,
      id: data?['id'] as int?,
      username: data?['username'] as String?,
      mobile: data?['mobile'] as String?,
    );
  }
}
