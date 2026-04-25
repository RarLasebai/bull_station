import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDeliveryCard extends StatelessWidget {
  final String deliveryPrice;
  final bool isDeliveryEnabled;
  final void Function(bool?)? onChanged;

  const BookingDeliveryCard({
    super.key,
    required this.deliveryPrice,
    required this.isDeliveryEnabled,
    this.onChanged,
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
          isDeliveryEnabled
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconTextWidget(
                      text: "الاستلام والتوصيل",
                      icon: Icons.location_on_outlined,
                      size: 14,
                    ),
                    SizedBox(height: 10.h),
                    // BookingInfoWidget(
                    //   title: "مكان الاستلام",
                    //   info: "حدد موقع الاستلام",
                    //   color: darkGrey,
                    // ),

                    // BookingInfoWidget(
                    //   title: "مكان التسليم",
                    //   info: "حدد موقع التسليم",
                    //   color: darkGrey,
                    // ),
                    Row(
                      children: [
                        Checkbox(
                          value: isDeliveryEnabled,
                          onChanged: onChanged,
                        ),
                        // SizedBox(width: 5.w),
                        TxtStyle(
                          "خدمة توصيل المعدة لمكانك (إضافة $deliveryPrice \$)",
                          12,
                          longText: true,
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  children: [
                    IconTextWidget(
                      text: "الاستلام والتوصيل",
                      icon: Icons.location_on_outlined,
                      size: 14,
                    ),
                    SizedBox(height: 10.h),
                    TxtStyle(
                      "خيار التوصيل لمكانك غير متاح",
                      12,
                      color: Colors.red,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
