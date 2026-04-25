import 'dart:convert';

import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:http/http.dart' as http;

class MapService {

Future getActiveTrucks() async {
    final String token = await getLoginToken();

    final String baseUrl = "https://bull-station.com";
    var url = Uri.parse('$baseUrl/api/active-trucks');
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
        'Failed to fetch active trucks with status code: ${response.statusCode}',
      );
    }
  }
}