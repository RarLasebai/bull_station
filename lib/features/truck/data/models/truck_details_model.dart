import 'package:bull_station/features/truck/data/models/truck_owner_model.dart';

class TruckDetailsModel {
  final int id;
  final String status;
  final String model;
  final String yearOfManufacture;
  final String description;
  final String pricePerDay;
  final String pricePerHour;
  final String workHours;
  final String name;
  final bool deliveryAvailable;
  final String? features;
  final String size;
  final String pickupLocation;
  final String deliveryPrice;
  final TruckOwnerModel owner;
  final String category;
  final String subCategory;
  final List<String> images;
  final String video;
  final double latitude;
  final double longitude;

  TruckDetailsModel({
    required this.deliveryAvailable,
    required this.name,
    required this.size,
    required this.id,
    required this.status,
    required this.model,
    required this.yearOfManufacture,
    required this.description,
    required this.pricePerDay,
    required this.pricePerHour,
    required this.workHours,
    required this.pickupLocation,
    required this.deliveryPrice,
    required this.owner,
    required this.category,
    required this.subCategory,
    required this.images,
    required this.video,
    this.features = "",
    required this.latitude,
    required this.longitude,
  });

  factory TruckDetailsModel.fromJson(Map<String, dynamic> data) {
    final dynamic imagesJson = data['images'];
    final List<String> images = imagesJson is List
        ? imagesJson.map((e) => e.toString()).toList()
        : [];

    return TruckDetailsModel(
      id: data['id'] as int,
      status: data['status'] as String,
      model: data['model'] as String,
      features: data['additional_features'] != null
          ? data['additional_features'] as String
          : "",
      yearOfManufacture: data['year_of_manufacture'] as String,
      description: data['description'] as String,
      pricePerDay: data['price_per_day'] as String,
      pricePerHour: data['price_per_hour'] as String,
      workHours: data['work_hours'] as String,
      pickupLocation: data['pickup_location'] as String,
      deliveryPrice: data['delivery_price'] as String,
      owner: TruckOwnerModel.fromJson(data['owner'] as Map<String, dynamic>),
      category: data['category'] as String,
      subCategory: data['sub_category'] as String,
      // Map the list of dynamic objects to a List<String>
      images: images,
      video: data['video'] != null ? data['video'] as String : "",
      name: data['name'] as String,
      size: data['size'] as String,
      deliveryAvailable: data['delivery_available'] as bool,
      latitude: data['latitude'] as double,
      longitude: data['longitude'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'model': model,
      'name': name,
      'size': size,
      'delivery_available': deliveryAvailable,
      'additional_features': features,
      'year_of_manufacture': yearOfManufacture,
      'description': description,
      'price_per_day': pricePerDay,
      'price_per_hour': pricePerHour,
      'work_hours': workHours,
      'pickup_location': pickupLocation,
      'delivery_price': deliveryPrice,
      'owner': owner.toJson(),
      'category': category,
      'sub_category': subCategory,
      'images': images,
      'video': video,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  TruckDetailsModel copyWith({
    int? id,
    String? status,
    String? model,
    String? name,
    String? size,
    String? yearOfManufacture,
    String? description,
    String? pricePerDay,
    String? pricePerHour,
    String? workHours,
    String? pickupLocation,
    String? deliveryPrice,
    TruckOwnerModel? owner,
    String? category,
    String? subCategory,
    List<String>? images,
    String? video,
    bool? deliveryAvailable,
    String? features,
    double? latitude,
    double? longitude,
  }) {
    return TruckDetailsModel(
      id: id ?? this.id,
      status: status ?? this.status,
      model: model ?? this.model,
      yearOfManufacture: yearOfManufacture ?? this.yearOfManufacture,
      description: description ?? this.description,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      owner: owner ?? this.owner,
      workHours: workHours ?? this.workHours,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      images: images ?? this.images,
      video: video ?? this.video,
      name: name ?? this.name,
      size: size ?? this.size,
      features: features ?? this.features, deliveryAvailable: deliveryAvailable ?? this.deliveryAvailable,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
