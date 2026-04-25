import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/features/truck/presentaion/widgets/truck_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TruckCostWidget extends StatelessWidget {
  final TextEditingController pricePerDaycontroller;
  final TextEditingController pricePerHourcontroller;

  const TruckCostWidget({
    super.key,
    required this.pricePerDaycontroller,
    required this.pricePerHourcontroller,
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
                text: "أسعار الحجز",
                icon: Icons.credit_card_outlined,
                size: 14,
              ),
              SizedBox(height: 10.h),
              TruckInfoWidget(
                title: "السعر لليوم",
                controller: pricePerDaycontroller,
              ),
            ],
          ),
          SizedBox(width: 100.w),
          Column(
            children: [
              SizedBox(height: 30.h),
              TruckInfoWidget(title: "السعر للساعة", controller: pricePerHourcontroller),
            ],
          ),
        ],
      ),
    );
  }
}
