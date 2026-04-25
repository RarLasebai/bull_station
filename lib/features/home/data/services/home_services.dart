import 'dart:convert';
import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:bull_station/features/truck/data/models/truck_details_model.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  Future<List<TruckCardModel>> getAllTrucks() async {
    final String token = await getLoginToken();

    final String baseUrl = "https://bull-station.com";
    var url = Uri.parse('$baseUrl/api/trucks?page=1');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];

      return jsonList.map((json) => TruckCardModel.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to fetch trucks with status code: ${response.statusCode}',
      );
    }
  }

  Future<List<TruckCardModel>> getMyTrucks() async {
    final String token = await getLoginToken();

    final String baseUrl = "https://bull-station.com";
    var url = Uri.parse('$baseUrl/api/my-trucks?sort_by=latest');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];

      return jsonList.map((json) => TruckCardModel.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to fetch trucks with status code: ${response.statusCode}',
      );
    }
  }

  Future<TruckDetailsModel> getTruckDetails(int id) async {
        final String token = await getLoginToken();
    final String baseUrl = "https://bull-station.com";
    var url = Uri.parse('$baseUrl/api/trucks/$id');
      var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final Map<String, dynamic> truckData = jsonResponse['data'];
      return TruckDetailsModel.fromJson(truckData);
    } else {
      throw Exception(
        'Failed to fetch truck details with status code: ${response.statusCode}',
      );
    }
  }

  Future activateTruck(bool activate, int id) async {
    final String token = await getLoginToken();

    final String baseUrl = "https://bull-station.com";
    Uri url;
    activate
        ? url = Uri.parse('$baseUrl/api/my-trucks/$id/request-activation')
        : url = Uri.parse('$baseUrl/api/my-trucks/$id/deactivate');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['message'];
    } else {
      throw Exception('Failed to change the status: ${response.statusCode}');
    }
  }

  Future deleteTruck(int id) async {
    final String token = await getLoginToken();

    try {
      final url = Uri.parse('https://www.bull-station.com/api/trucks/$id');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      throw Exception('Failed to delete truck');
    }
  }
}
