class TruckOwnerModel {
  final String name;
  final String phone;
  // final String photo;

  TruckOwnerModel({
    required this.name,
    required this.phone,
    // required this.photo,
  });

  factory TruckOwnerModel.fromJson(Map<String, dynamic> json) {
    return TruckOwnerModel(
      name: json['name'] as String,
      phone: json['phone'] as String,
      // photo: json['photo'] as String,
    );
  }

  // Method to convert a TruckOwnerModel to a JSON map
  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone,
    //  'photo': photo
     };
  }
}
