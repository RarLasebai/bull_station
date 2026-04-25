class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String createdAt;
  final bool isRead;
  final Data? data; 

  NotificationModel({required this.data, 
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      id: json['id'],
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      createdAt: json['created_at'] ?? '',
      isRead: json['read_at'] != null,
    );
  }
}
class Data {
  final String type;
  final String booking_id;

  Data({
    required this.type,
    required this.booking_id,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      type: json['type'] ?? '',
      booking_id: json['booking_id'] ?? '',
    );
  }
}