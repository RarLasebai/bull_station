import 'dart:convert';

import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/features/home/data/models/category_model.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:http/http.dart' as http;

class CategoryServices {
  Future<List<CategoryModel>> getAllCategories() async {
    final String baseUrl = "https://bull-station.com";
    var url = Uri.parse('$baseUrl/api/categories');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['categories'];

      return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to fetch categories with status code: ${response.statusCode}',
      );
    }
  }

  Future<List<TruckCardModel>> getSubCategoryTrucks(int subCategoryId) async {
    final String baseUrl = "https://bull-station.com";
    var url = Uri.parse('$baseUrl/api/sub-categories/$subCategoryId/trucks');
    final String token = await getLoginToken();

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
        'Failed to fetch Trucks with status code: ${response.statusCode}',
      );
    }
  }
}
