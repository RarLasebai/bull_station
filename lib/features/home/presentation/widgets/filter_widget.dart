import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterWidget extends StatelessWidget {
  final Color color;
  final String title;
  final String icon;
  final bool isStatus;
  const FilterWidget({
    super.key,
    this.color = softGrey,
    this.title = "معدات بناء",
    this.icon = "",
    this.isStatus = false,
  });

  @override
  Widget build(BuildContext context) {
    String status = "status";
    Color statusColor = softGrey;
    if (title == "pending") {
      status = "قيد المراجعة";
      statusColor = yellowBg;
    } else if (title == "approved") {
      status = "تم القبول";
      statusColor = blueBg;
    } else if (title == "rejected") {
      status = "مرفوض";
      statusColor = redBg;
    }else if (title == "cancelled") {
      status = "ملغي";
      statusColor = redBg;
    } else if (title == "completed") {
      status = "مكتمل";
      statusColor = greenBg;
    } else if (title == "confirmed") {
      status = "تم التأكيد";
      statusColor = greenBg;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: isStatus ? statusColor : color,
          ),
          child: Row(
            children: [
              icon == "" ? SizedBox() : Image.network(icon, width: 15.w),
              SizedBox(width: 4.w),
              TxtStyle(isStatus ? status : title, 12),
            ],
          ),
        ),
        SizedBox(width: 13.w),
      ],
    );
  }
}
