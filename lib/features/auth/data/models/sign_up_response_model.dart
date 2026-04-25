import 'user_model.dart';

class SignUpResponse {
  final String message;
  final String accessToken;
  final String tokenType;
  final UserModel user;

  SignUpResponse({
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      message: json['message'] as String,
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      user: UserModel.fromJson(json['user']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'access_token': accessToken,
      'token_type': tokenType,
      'user': user.toJson(),
    };
  }
}
