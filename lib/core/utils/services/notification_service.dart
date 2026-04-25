import 'package:bull_station/features/home/data/models/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  // تأكد أن هذا هو نفس الـ Base URL المستخدم في LoginServices
  final String baseUrl = "https://bull-station.com/api";

  Future<void> updateDeviceToken(String accessToken) async {
    try {
      // 1. جلب الـ FCM Token الحقيقي من Firebase (عنوان الجهاز)
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null) {
        print("FCM Token جاري الإرسال: $fcmToken");

        // 2. إرسال الـ FCM Token للسيرفر باستخدام الـ Access Token للتعريف
        final response = await http.post(
          Uri.parse('$baseUrl/fcm-token'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken', // التوكن العادي هنا
          },
          body: jsonEncode({
            'fcm_token': fcmToken, // توكن الجهاز هنا
          }),
        );

        if (response.statusCode == 200) {
          print("✅ تم ربط جهازك بحسابك بنجاح على السيرفر");
        } else {
          print("❌ فشل تحديث التوكن: ${response.statusCode}");
        }
      }
    } catch (e) {
      print("⚠️ خطأ في خدمة الإشعارات: $e");
    }
  }

  Future<List<NotificationModel>> getNotifications(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://bull-station.com/api/notifications'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> notificationsData = jsonData['data'];
      return notificationsData
          .map((e) => NotificationModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}
