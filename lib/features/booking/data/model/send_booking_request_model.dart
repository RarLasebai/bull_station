class SendBookingRequestModel {
   final int truckId;
  final DateTime startDatetime;
  final DateTime endDatetime;
  final int days;
  final int hours;
  final bool needsDelivery;

  SendBookingRequestModel({
    required this.truckId,
    required this.startDatetime,
    required this.endDatetime,
    required this.days,
    required this.hours,
    required this.needsDelivery,
  });

  factory SendBookingRequestModel.fromJson(Map<String, dynamic> json) {
    return SendBookingRequestModel(
      truckId: json['truck_id'] as int,
      startDatetime: DateTime.parse(json['start_datetime'] as String),
      endDatetime: DateTime.parse(json['end_datetime'] as String),
      days: json['days'] as int,
      hours: json['hours'] as int,
      needsDelivery: json['needs_delivery'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'truck_id': truckId,
      'start_datetime': startDatetime.toIso8601String(),
      'end_datetime': endDatetime.toIso8601String(),
      'days': days,
      'hours': hours,
      'needs_delivery': needsDelivery,
    };
  }

}