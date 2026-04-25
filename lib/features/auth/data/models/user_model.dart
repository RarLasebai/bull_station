class UserModel {
  final int id;
  final String name;
  final String phone;
  final String? phoneVerifiedAt;
  final String? fcmToken;
  final String accountType;
  final String? fleetOwnerCode;
  final String? identityImage;
  final String? drivingLicenseImage;
  final dynamic location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String photo;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.fcmToken,
    this.phoneVerifiedAt,
    required this.accountType,
    this.fleetOwnerCode,
    required this.identityImage,
    required this.drivingLicenseImage,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.photo,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? "", // استخدام قيمة افتراضية إذا كان نل
      phone: json['phone'] as String? ?? "",
      accountType: json['account_type'] as String? ?? "",
      fcmToken: json['fcm_token'] as String?,
      identityImage: json['identity_image'] as String?,

      drivingLicenseImage: json['driving_license_image'] as String?,
      location: json['location'] as String?,

      // التعامل مع التواريخ التي قد تختفي في استجابة التحديث
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(), // قيمة افتراضية إذا غاب الحقل
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      phoneVerifiedAt: json['phone_verified_at'] as String?,
      fleetOwnerCode: json['fleet_owner_code'] as String?,
      photo: json['profile_photo_path'] == null
          ? "" // قيمة افتراضية إذا لم يكن هناك صورة
          : "https://bull-station.com/${json['profile_photo_path']}", // بناء رابط الصورة الكامل
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'phone_verified_at': phoneVerifiedAt,
      'account_type': accountType,
      'fleet_owner_code': fleetOwnerCode,
      'identity_image': identityImage,
      'driving_license_image': drivingLicenseImage,
      'location': location,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'profile_photo_path': photo,
    };
  }
}
