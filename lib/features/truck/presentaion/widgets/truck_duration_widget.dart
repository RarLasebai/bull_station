import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/features/truck/presentaion/widgets/truck_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TruckDurationWidget extends StatelessWidget {
  final TextEditingController workStartTimeController;
  final TextEditingController workEndTimeController;
  final void Function()? onTapStart; // أضف خاصية onTap
  final void Function()? onTapEnd; // أضف خاصية onTap
    final String startHint;
  final String endHint;

  const TruckDurationWidget({super.key, required this.workStartTimeController, required this.workEndTimeController, this.onTapStart, this.onTapEnd,  this.startHint = "00:00",  this.endHint= "00:00"});

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
                text: "ساعات العمل",
                icon: Icons.calendar_today_rounded,
                size: 14,
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: onTapStart,
                child: TruckInfoWidget(title: "وقت البدء", controller: workStartTimeController, isTime: true, hint: startHint,)),
            ],
          ),
          SizedBox(width: 100.w),
          Column(
            children: [
              SizedBox(height: 30.h),
              InkWell(
                onTap: onTapEnd,
                child: TruckInfoWidget(title: "وقت الانتهاء", controller: workEndTimeController, isTime: true, hint: endHint,)),
            ],
          ),
        ],
      ),
    );
  }
}
