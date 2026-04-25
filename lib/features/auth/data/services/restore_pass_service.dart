import 'dart:convert';
import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:http/http.dart' as http;

class RestorePassService {
  Future<http.Response> checkPhoneExist({
    required String phone,
    // required String firebaseIdToken,
  }) async {
    final String baseUrl = "https://bull-station.com";
    var url = Uri.parse('$baseUrl/api/forgot-password');
    var body = {'phone': phone};
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $firebaseIdToken',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return response; // Success exist
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception(
        'Failed to log in with status code: ${response.statusCode}',
      );
    }
  }

  Future<http.Response> changePassword({
    required String phone,
    required String password,
  }) async {
    final String baseUrl = "https://bull-station.com";
    var firebaseIdToken = await getFirebaseIdToken();
    var url = Uri.parse('$baseUrl/api/reset-password');
    var body = {
      'phone': phone,
      "password": password,
      "password_confirmation": password,
    };

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $firebaseIdToken',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return response; // Success exist
    } else if (response.statusCode == 401) {
      throw Exception('Invalid Firebase ID Token:');
    } else {
      throw Exception(
        'Failed to log in with status code: ${response.statusCode}',
      );
    }
  }
}
