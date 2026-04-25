import 'dart:io';

import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/features/truck/data/models/add_truck_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class TruckService {
  final String baseUrl = "https://www.bull-station.com";

  Future submitTruck({required TruckModel truckModel}) async {
    final client = http.Client();
    final String token = await getLoginToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://www.bull-station.com/api/trucks'),
    );
    request.followRedirects = false;
    // Add headers
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Accept'] = 'application/json';

    // Add fields
    request.fields['category_id'] = truckModel.categoryId.toString();
    request.fields['sub_category_id'] = truckModel.subCategoryId.toString();
    request.fields['name'] = truckModel.name.toString();

    request.fields['year_of_manufacture'] = truckModel.yearOfManufacture
        .toString();
    request.fields['size'] = truckModel.size;
    request.fields['model'] = truckModel.model;
    request.fields['description'] = truckModel.description;
    request.fields['price_per_day'] = truckModel.pricePerDay.toString();
    request.fields['price_per_hour'] = truckModel.pricePerHour.toString();
    request.fields['work_start_time'] = truckModel.workStartTime;
    request.fields['work_end_time'] = truckModel.workEndTime;
    request.fields['pickup_location'] = truckModel.pickupLocation;
    request.fields['latitude'] = truckModel.latitude.toString();
    request.fields['longitude'] = truckModel.longitude.toString();
    request.fields['delivery_available'] = truckModel.deliveryAvailable
        ? '1'
        : '0';
    if (truckModel.deliveryPrice != null) {
      request.fields['delivery_price'] = truckModel.deliveryPrice.toString();
    }
    // Add images
    for (var imagePath in truckModel.images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images[]',
          imagePath,
          filename: path.basename(imagePath),
        ),
      );
    }

    // Add video if available
    if (truckModel.video != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'video',
          truckModel.video!,
          filename: path.basename(truckModel.video!),
        ),
      );
    }
    final streamedResponse = await client.send(request);
    final response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  Future updateTruck({
    required int id,
    required Map<String, String> fields,
    required List<File> newImages,
    File? newVideo,
  }) async {
    final String token = await getLoginToken();
    final uri = Uri.parse('$baseUrl/api/trucks/$id');
    final request = http.MultipartRequest('POST', uri); // نبقيها POST

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] =
        'application/json'; // مهم جداً لاستلام رسائل الخطأ

    request.fields.addAll(fields);

    for (var imageFile in newImages) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images[]', // استخدم نفس الاسم هنا
          imageFile.path,
        ),
      );
    }

    if (newVideo != null) {
      request.files.add(
        await http.MultipartFile.fromPath('video', newVideo.path),
      );
    }

    try {
      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        // Handle the successful response
        return response.body;
      } else {
        // Handle the error response
        throw Exception('Failed to update truck: ${response.statusCode}');
      }
    } catch (e) {
      // Handle specific errors
      throw Exception('Failed to update truck: $e');
    }
  }
}
