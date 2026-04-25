import 'dart:io';

class TruckModel {
  final int categoryId;
  final int subCategoryId;
  final int yearOfManufacture;
  final String name;
  final String size;
  final String model;
  final String description;
  final String? features;
  final double pricePerDay;
  final double pricePerHour;
  final String workStartTime;
  final String workEndTime;
  final String pickupLocation;
  final bool deliveryAvailable;
  final double? deliveryPrice;
  final List<String> images;
  final String? video;
  final double latitude;
  final double longitude;

  const TruckModel({
    required this.categoryId,
    required this.subCategoryId,
    required this.yearOfManufacture,
    required this.name,
    required this.size,
    required this.model,
    required this.description,
    required this.pricePerDay,
    required this.pricePerHour,
    required this.workStartTime,
    required this.workEndTime,
    required this.pickupLocation,
    required this.deliveryAvailable,
    required this.features,
    this.deliveryPrice,
    this.images = const [],
    this.video,
    required this.latitude,
    required this.longitude,
  });

  factory TruckModel.fromJson(Map<String, dynamic> json) {
    return TruckModel(
      name: json['name'],
      categoryId: json['category_id'] as int,
      subCategoryId: json['sub_category_id'] as int,
      yearOfManufacture: json['year_of_manufacture'] as int,
      size: json['size'] as String,
      model: json['model'] as String,
      description: json['description'] as String,
      pricePerDay: (json['price_per_day'] as num).toDouble(),
      pricePerHour: (json['price_per_hour'] as num).toDouble(),
      workStartTime: json['work_start_time'] as String,
      workEndTime: json['work_end_time'] as String,
      pickupLocation: json['pickup_location'] as String,
      deliveryAvailable: json['delivery_available'] as bool,
      deliveryPrice: (json['delivery_price'] as num?)?.toDouble(),
      images:
          (json['images'] as List<File>?)?.map((e) => e as String).toList() ??
          [],
      video: json['video'] as String?,
      features: json['description'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'year_of_manufacture': yearOfManufacture,
      'size': size,
      'model': model,
      'description': description,
      'price_per_day': pricePerDay,
      'price_per_hour': pricePerHour,
      'work_start_time': workStartTime,
      'work_end_time': workEndTime,
      'pickup_location': pickupLocation,
      'delivery_available': deliveryAvailable,
      'delivery_price': deliveryPrice,
      'features': features,
      'images': images,
      'video': video,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  TruckModel copyWith({
    int? categoryId,
    String? name,
    int? subCategoryId,
    int? yearOfManufacture,
    String? features,
    String? size,
    String? model,
    String? description,
    double? pricePerDay,
    double? pricePerHour,
    String? workStartTime,
    String? workEndTime,
    String? pickupLocation,
    bool? deliveryAvailable,
    double? deliveryPrice,
    List<String>? images,
    String? video,
      double? latitude,
      double? longitude,
  }) {
    return TruckModel(
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      yearOfManufacture: yearOfManufacture ?? this.yearOfManufacture,
      size: size ?? this.size,
      model: model ?? this.model,
      description: description ?? this.description,
      features: features ?? this.features,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      workStartTime: workStartTime ?? this.workStartTime,
      workEndTime: workEndTime ?? this.workEndTime,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      deliveryAvailable: deliveryAvailable ?? this.deliveryAvailable,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      images: images ?? this.images,
      video: video ?? this.video,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  factory TruckModel.initial() {
    return TruckModel(
      name: "",
      categoryId: 1,
      subCategoryId: 1,
      yearOfManufacture: 1,
      size: '',
      model: '',
      description: '',
      pricePerDay: 1,
      pricePerHour: 1,
      workStartTime: '',
      workEndTime: '',
      pickupLocation: '',
      deliveryAvailable: true,
      features: '',
      latitude: 0.0,
      longitude: 0.0,
    );
  }
}
