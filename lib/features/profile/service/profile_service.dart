import 'dart:convert';

import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  Future updateLocation({required String location}) async {
    final String baseUrl = "https://bull-station.com";
    final String token = await getLoginToken();

    var url = Uri.parse('$baseUrl/api/update-location');
    var body = {'location': location};

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final UserModel user = UserModel.fromJson(responseData["user"]);

      return user; // Success exist
    } else if (response.statusCode == 401) {
      throw Exception('Invalid Firebase ID Token:');
    } else {
      throw Exception(
        'Failed to log in with status code: ${response.statusCode}',
      );
    }
  }

  Future<UserModel> updateProfile({String? name, String? identityImage}) async {
    final String token = await getLoginToken();
    final String baseUrl = "https://bull-station.com";

    var url = Uri.parse('$baseUrl/api/profile/update');

    var request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    if (name != null && name.isNotEmpty) {
      request.fields['name'] = name;
    }

    if (identityImage != null && identityImage.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_photo', identityImage),
      );
    }

    // 5. إرسال الطلب واستلام الرد
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return UserModel.fromJson(responseData["user"]);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid Token');
    } else {
      throw Exception('Failed to update profile: ${response.statusCode}');
    }
  }

  Future<void> updateFCMToken({required String fcmToken}) async {
    try {
      final String baseUrl = "https://bull-station.com";
      final String token =
          await getLoginToken(); 

      var url = Uri.parse('$baseUrl/api/update-fcm-token');

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'fcm_token': fcmToken}),
      );

      if (response.statusCode == 200) {
        print("FCM Token updated successfully on server");
      } else {
        print("Failed to update FCM Token: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating FCM Token: $e");
    }
  }
}
