import 'dart:convert';
import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/features/booking/data/model/booking_model.dart';
import 'package:bull_station/features/booking/data/model/send_booking_request_model.dart';
import 'package:http/http.dart' as http;

//make the create booking and all post req, retrun the same model with full booking data
//even the get, it is id but others is booking id so make it unique
//return the truck details model
//missing delivery place
class BookingService {
  final baseUrl = 'https://bull-station.com';

  Future<List<BookingModel>> getMyBookings(bool isOwner) async {
    final token = await getLoginToken();
    Uri url;
    if (isOwner) {
      url = Uri.parse('$baseUrl/api/my-bookings?type=incoming');
    } else {
      url = Uri.parse('$baseUrl/api/my-bookings?type=outgoing');
    }
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final List<dynamic> bookingsJson = responseData['data'];

      final List<BookingModel> bookings = bookingsJson.map((jsonItem) {
        return BookingModel.fromJson(jsonItem as Map<String, dynamic>);
      }).toList();

      return bookings;
    } else {
      throw Exception(
        'Failed to get list of booking. Status code: ${response.statusCode}',
      );
    }
  }

  Future sendBookingRequest(SendBookingRequestModel model) async {
    final token = await getLoginToken();

    var url = Uri.parse('$baseUrl/api/bookings');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(model.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      String status = responseData['booking_details']['status'];

      return status;
    } else {
      throw Exception(
        'Failed to send booking request. Status code: ${response.statusCode}',
      );
    }
  }

  Future<BookingModel> changeBookingStatus(int bookingId, String status) async {
    final token = await getLoginToken();
    Uri url;
    url = Uri.parse('$baseUrl/api/my-bookings/$bookingId/$status');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final BookingModel booking = BookingModel.fromJson(
        responseData["booking"],
      );

      return booking;
    } else {
      throw Exception(
        'Failed to change booking status. Status code: ${response.statusCode}',
      );
    }
  }

  Future<List<DateTime>> getTruckCalendar(int truckId) async {
    Uri url = Uri.parse('$baseUrl/api/trucks/$truckId/calendar');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<DateTime> bookedDates = [];

      for (var period in data) {
        DateTime start = DateTime.parse(period['start_datetime']);
        DateTime end = DateTime.parse(period['end_datetime']);

        // إضافة كل الأيام بين البداية والنهاية للقائمة
        for (int i = 0; i <= end.difference(start).inDays; i++) {
          bookedDates.add(start.add(Duration(days: i)));
        }
      }
      return bookedDates;
    } else {
      throw Exception('Failed to load calendar');
    }
  }

  //payment
  Future initiatePayment(int bookingId) async {
    final token = await getLoginToken();
    Uri url = Uri.parse('$baseUrl/api/payment/tap/initiate');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'booking_id': bookingId}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      String paymentUrl = responseData['payment_url'];
      return paymentUrl;
    } else {
      throw Exception(
        'Failed to initiate payment. Status code: ${response.body}',
      );
    }
  }

  Future<bool> verifyPayment(int bookingId) async {
    final token = await getLoginToken();
    Uri url = Uri.parse('$baseUrl/api/bookings/$bookingId/verify-payment');

    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("Verify Response: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      // حسب الصورة المفتاح هو "paid" وقيمته bool
      return responseData['paid'] ?? false;
    } else {
      return false;
    }
  }

  // مثال بسيط لاستدعاء API السيرفر ليقوم هو بالإرسال
  Future<void> sendNotification(int ownerId) async {
    final token = await getLoginToken();

    await http.post(
      Uri.parse('$baseUrl/api/send-notification'),
      body: {
        'receiver_id': ownerId,
        'title': 'طلب جديد',
        'body': 'هناك عميل يريد حجز شاحنتك',
      },
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
