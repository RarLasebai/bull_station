import 'dart:convert';
import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:http/http.dart' as http;

class MapService {
  final String baseUrl = "https://bull-station.com";

  Future<List<TruckCardModel>> getActiveTrucks() async {
    final String token = await getLoginToken();
    var url = Uri.parse('$baseUrl/api/trucks?page=1');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['data'];
      return jsonList.map((json) => TruckCardModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch active trucks');
    }
  }

  Future<List<TruckCardModel>> getSearchTrucks({
    int? categoryId,
    double? radius,
    String? name,
    String? model,
    int? year,
    double? lat,
    double? lng,
  }) async {
    final String token = await getLoginToken();

    final Map<String, String> queryParameters = {};
    if (categoryId != null)
      queryParameters['category_id'] = categoryId.toString();
    if (radius != null) queryParameters['radius'] = radius.toString();
    if (name != null && name.isNotEmpty) queryParameters['name'] = name;
    if (model != null && model.isNotEmpty) queryParameters['model'] = model;
    if (year != null) queryParameters['year'] = year.toString();
    if (lat != null) queryParameters['lat'] = lat.toString();
    if (lng != null) queryParameters['lng'] = lng.toString();

    var url = Uri.parse(
      '$baseUrl/api/trucks-map',
    ).replace(queryParameters: queryParameters);

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
      throw Exception('Failed to fetch filtered trucks');
    }
  }
}
