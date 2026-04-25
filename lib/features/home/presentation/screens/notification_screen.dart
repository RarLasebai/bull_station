// ignore_for_file: deprecated_member_use

import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/booking/application/booking_cubit.dart';
import 'package:bull_station/features/booking/data/model/booking_model.dart';
import 'package:bull_station/features/booking/presentaion/screens/booking_details_screen.dart';
import 'package:bull_station/features/home/application/notification_cubit/notifiaction_states.dart';
import 'package:bull_station/features/home/application/notification_cubit/notification_cubit.dart';
import 'package:bull_station/features/home/data/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatelessWidget {
  final bool isOwner;
  const NotificationScreen({super.key, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    context.read<NotificationCubit>().fetchNotifications();

    return SafeArea(
      child: Scaffold(
        appBar: TopNavBar("الإشعارات"),
        body: BlocBuilder<NotificationCubit, NotificationStates>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationSuccess) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    // شريط التنبيه العلوي (عدد الإشعارات غير المقروءة مثلاً)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 20.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: darkGreen),
                        borderRadius: BorderRadius.circular(5.r),
                        color: greenBg,
                      ),
                      child: TxtStyle(
                        "لديك ${state.notifications.length} إشعارات",
                        14,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // قائمة الإشعارات الديناميكية
                    Expanded(
                      child: RefreshIndicator(
                        color: darkGreen,
                        onRefresh: () async {
                          // استدعاء دالة الجلب مرة أخرى عند السحب
                          await context
                              .read<NotificationCubit>()
                              .getNotifications();
                        },
                        child: state.notifications.isEmpty
                            ? const Center(
                                child: TxtStyle("لا توجد إشعارات حالياً", 14),
                              )
                            : ListView.builder(
                                itemCount: state.notifications.length,
                                itemBuilder: (context, index) {
                                  var item = state.notifications[index];
                                  return buildNotificationItem(context, item);
                                },
                              ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: TxtStyle("حدث خطأ في جلب البيانات", 14),
              );
            }
          },
        ),
      ),
    );
  }

  Widget buildNotificationItem(BuildContext context, NotificationModel item) {
    return InkWell(
      onTap: () async {
        final data = item.data;

        if (data != null && data.type == 'booking') {
          String bookingId = data.booking_id;
        await  context.read<BookingCubit>().getBookings(isOwner).then((bookings) {
            final BookingModel? booking = bookings.where((b) => b.id.toString() == bookingId).isNotEmpty
                ? bookings.firstWhere((b) => b.id.toString() == bookingId)
                : null;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BookingDetailsScreen(bookingModel: booking!),
              ),
            );
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: darkGrey),
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: Row(
            children: [
              Container(
                height: 65.h,
                width: 65.w,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(
                      5,
                    ), // تعديل بسيط ليتناسب مع الصف
                  ),
                  color: item.isRead == false
                      ? greenBg.withOpacity(0.3)
                      : Colors.white,
                ),
                child: Image.asset("assets/icons/notification.png"),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TxtStyle(item.title, 12, fontWeight: FontWeight.bold),
                        TxtStyle(
                          "  ${formatNotificationTime(item.createdAt) }",
                          10,
                          color: Colors.grey, // لون هادئ للوقت
                        ),
                      ],
                    ),
                    TxtStyle(item.body, 11, color: darkGrey, longText: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatNotificationTime(String createdAt) {
    // 1. تحويل النص القادم من السيرفر إلى كائن DateTime
    DateTime dateTime = DateTime.parse(createdAt).toLocal();
    DateTime now = DateTime.now();

    // حساب الفرق الزمني
    Duration difference = now.difference(dateTime);

    if (difference.inDays < 1) {
      // 2. إذا كان أقل من يوم، نستخدم مكتبة timeago لإظهار "منذ ساعة" مثلاً
      // لضبط اللغة العربية:
      timeago.setLocaleMessages('ar', timeago.ArMessages());
      return timeago.format(dateTime, locale: 'ar');
    } else {
      // 3. إذا مر يوم أو أكثر، نستخدم مكتبة intl لإظهار التاريخ بصيغة يوم/شهر/سنة
      return DateFormat('yyyy/MM/dd').format(dateTime);
    }
  }
}
