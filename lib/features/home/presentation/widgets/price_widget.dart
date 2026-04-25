import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceWidget extends StatelessWidget {
  final String pricePerDay;
  final String pricePerHour;
  final bool isTime;
  const PriceWidget({
    super.key,
    required this.pricePerDay,
    required this.pricePerHour,
    this.isTime = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Container(
        width: 260.w,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: darkGrey),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                isTime
                    ? TxtStyle(pricePerDay, 14, fontWeight: FontWeight.bold)
                    : TxtStyle(
                        "$pricePerDay\$",
                        14,
                        fontWeight: FontWeight.bold,
                      ),
                isTime ? TxtStyle("من", 12) : TxtStyle("لليوم", 12),
              ],
            ),
            Column(
              children: [
                isTime
                    ? TxtStyle(pricePerHour, 14, fontWeight: FontWeight.bold)
                    : TxtStyle(
                        "$pricePerHour\$",
                        14,
                        fontWeight: FontWeight.bold,
                      ),
                isTime ? TxtStyle("إلى", 12) : TxtStyle("للساعة", 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
