import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/features/booking/presentaion/widgets/booking_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDurationCard extends StatelessWidget {
  final void Function() onTapDateStart;
  final void Function() onTapDateEnd;
  final void Function() onTapTimeStart;
  final void Function() onTapTimeEnd;
  final String startDate;
  final String endDate;
  final String startTime;
  final String endTime;
  const BookingDurationCard({
    super.key,
    required this.onTapDateStart,
    required this.onTapDateEnd,
    required this.onTapTimeStart,
    required this.onTapTimeEnd,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370.w,
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: darkGrey),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTextWidget(
                text: "مدة الحجز",
                icon: Icons.calendar_today_rounded,
                size: 14,
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: onTapDateStart,
                child: BookingInfoWidget(title: "تاريخ البدء", info: startDate),
              ),
              InkWell(
                onTap: onTapTimeStart,
                child: BookingInfoWidget(title: "وقت البدء", info: startTime),
              ),
            ],
          ),
          SizedBox(width: 100.w),
          Column(
            children: [
              SizedBox(height: 30.h),
              InkWell(
                onTap:  onTapDateEnd,
                child: BookingInfoWidget(
                  title: "تاريخ الانتهاء",
                  info: endDate,
                ),
              ),
              InkWell(
                onTap:  onTapTimeEnd,
                child: BookingInfoWidget(title: "وقت الانتهاء", info: endTime),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
