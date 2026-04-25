import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'dart:io';

class SignupServices {
  Future<http.StreamedResponse> sendSignUpRequest({
    required String name,
    required String phone,
    required String password,
    required String accountType,
    File? identityImage,
    File? drivingLicenseImage,
    required String firebaseIdToken,
    String? fleetOwnerCode,
    required String location,
  }) async {
    final String baseUrl = "https://bull-station.com";
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/register'),
    );

    request.headers['Authorization'] = 'Bearer $firebaseIdToken';

    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.fields['password'] = password;
    request.fields['account_type'] = accountType;
    request.fields['location'] = location;
    if (fleetOwnerCode != null && fleetOwnerCode.isNotEmpty) {
      request.fields['fleet_owner_code'] = fleetOwnerCode;
    }

    // Add the files
    if (identityImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'identity_image',
          identityImage.path,
          filename: path.basename(identityImage.path),
        ),
      );
    }
    if (drivingLicenseImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'driving_license_image',
          drivingLicenseImage.path,
          filename: path.basename(drivingLicenseImage.path),
        ),
      );
    }
    return request.send();
  }
}
