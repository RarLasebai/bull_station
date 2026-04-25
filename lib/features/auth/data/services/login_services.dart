import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginServices {
  Future<http.Response> login({
    required String phone,
    required String password,
  }) async {
    final String baseUrl = "https://bull-station.com";
    var url = Uri.parse('$baseUrl/api/login');
    var body = {'phone': phone, 'password': password};
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer $firebaseIdToken',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return response; // Success
    } else if (response.statusCode == 401) {
      throw Exception('Invalid credentials or token.');
    } else {
      throw Exception(
        'Failed to log in with status code: ${response.statusCode}',
      );
    }
  }
}
