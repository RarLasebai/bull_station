class TruckCardModel {
  final int id;
  final String model;
  final String subCategory;
  final String pricePerDay;
  final String category;
  final String name;
  final String status;
  final String mainImage;
  final String? pickupLocation;

  TruckCardModel({
    required this.id,
    required this.model,
    required this.subCategory,
    required this.pricePerDay,
    required this.category,
    required this.name,
    required this.mainImage,
    required this.status,
    this.pickupLocation,
  });

  // Factory constructor to create a TruckCardModel from a JSON map
  factory TruckCardModel.fromJson(Map<String, dynamic> json) {
    return TruckCardModel(
      id: json['id'] as int,
      status: json['status'] as String,
      model: json['model'] as String,
      subCategory: json['sub_category'] as String,
      pricePerDay: json['price_per_day'] as String,
      category: json['category'] as String,
      name: json['name'] as String,
      mainImage: json['main_image'] as String,
      pickupLocation: json['pickup_location'] as String?,
    );
  }

  // Method to convert a TruckCardModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'status': status,
      'price_per_day': pricePerDay,
      'category': category,
      'sub_category': subCategory,
      'name': name,
      'main_image': mainImage,
      'pickup_location': pickupLocation,
    };
  }
}
