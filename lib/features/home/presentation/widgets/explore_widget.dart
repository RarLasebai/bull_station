import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExploreWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const ExploreWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: darkGrey),
      ),
      child: Column(
        children: [
          TxtStyle(title, 14, fontWeight: FontWeight.bold),
          TxtStyle(subtitle, 10, textAlignm: TextAlign.center),
        ],
      ),
    );
  }
}
