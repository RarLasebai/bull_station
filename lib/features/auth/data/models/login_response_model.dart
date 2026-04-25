import 'package:bull_station/features/auth/data/models/user_model.dart';

class LoginResponseModel {
  final String token;
  final String message;
  final UserModel user;

  LoginResponseModel({
    required this.message,
    required this.user,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user']),
      token: json['access_token'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'access_token': token, 'message': message, 'user': user.toJson()};
  }
}
