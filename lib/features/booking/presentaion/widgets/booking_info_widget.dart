import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingInfoWidget extends StatelessWidget {
  final String title;
  final String info;
  final Color color;
  const BookingInfoWidget({super.key, required this.title, required this.info, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TxtStyle(title, 11),
        SizedBox(height: 5.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: softGrey,
          ),
          child: TxtStyle(info, 12, color: color),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
