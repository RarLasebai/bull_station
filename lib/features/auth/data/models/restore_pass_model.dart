
class RestorePassResponseModel {
  final String message;

  RestorePassResponseModel({required this.message});

  factory RestorePassResponseModel.fromJson(Map<String, dynamic> json) {
    return RestorePassResponseModel(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return { 'message': message};
  }
}
