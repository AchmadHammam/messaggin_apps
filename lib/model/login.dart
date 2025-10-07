import 'package:messaging_application/model/user.dart';

class LoginResponse {
  String message;
  LoginData data;

  LoginResponse({required this.message, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      data: LoginData.fromJson(json['data']),
    );
  }
}

class LoginData {
  User user;
  String token;

  LoginData({required this.user, required this.token});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(user: User.fromJson(json['user']), token: json['token']);
  }
}

