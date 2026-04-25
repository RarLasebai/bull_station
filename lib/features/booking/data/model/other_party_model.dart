class OtherPartyModel {
  final String type;
  final String name;
  final String profilePhoto;
  OtherPartyModel({
    required this.type,
    required this.name,
    required this.profilePhoto,
  });

  factory OtherPartyModel.fromJson(Map<String, dynamic> json) {
    return OtherPartyModel(
      type: json['type'] as String,
      name: json['name'] as String,
      profilePhoto: json['profile_photo_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'name': name, 'profile_photo': profilePhoto};
  }
}
