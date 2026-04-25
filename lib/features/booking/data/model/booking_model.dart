import 'package:bull_station/features/booking/data/model/other_party_model.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';

class BookingModel {
  final int id;
  final String status;
  final DateTime startDatetime;
  final DateTime endDatetime;
  final double totalPrice;
  final String customerName;
  final TruckCardModel truck;
  final OtherPartyModel otherParty;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.status,
    required this.startDatetime,
    required this.endDatetime,
    required this.totalPrice,
    required this.customerName,
    required this.truck,
    required this.otherParty,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as int,
      customerName: json['customer_name'] as String,
      status: json['status'] as String,
      startDatetime: DateTime.parse(json['start_datetime'] as String),
      endDatetime: DateTime.parse(json['end_datetime'] as String),
      totalPrice: double.parse(json['total_price'] as String),
      truck: TruckCardModel.fromJson(json['truck'] as Map<String, dynamic>),
      otherParty: OtherPartyModel.fromJson(
        json['other_party'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      "customer_name": customerName,
      'start_datetime': startDatetime.toIso8601String(),
      'end_datetime': endDatetime.toIso8601String(),
      'total_price': totalPrice.toString(),
      'truck': truck.toJson(),
      'other_party': otherParty.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
