import 'package:bull_station/features/home/data/models/sub_category_model.dart';

class CategoryModel {
  final int id;
  final String name;
  final String icon;
  final List<SubCategoryModel> subCategoryModel;
  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.subCategoryModel,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> subCategoriesJson =
        json['sub_categories'] as List<dynamic>;

    // Use the .map() method to convert each JSON object into a SubCategoryModel
    final List<SubCategoryModel> subCategories = subCategoriesJson
        .map(
          (subCategoryJson) => SubCategoryModel.fromJson(
            subCategoryJson as Map<String, dynamic>,
          ),
        )
        .toList();

    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String,
      subCategoryModel: subCategories,
    );
  }

  Map<String, dynamic> toJson() {
      final List<Map<String, dynamic>> subCategoriesJson = subCategoryModel.map((subCategory) => subCategory.toJson()).toList();

    return {
      'id': id,
      'name': name,
      'icon': icon,
      'sub_categories': subCategoriesJson,
    };
  }
}
