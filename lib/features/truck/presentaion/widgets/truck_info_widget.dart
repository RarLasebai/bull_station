import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/truck/presentaion/widgets/custom_form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TruckInfoWidget extends StatelessWidget {
  final String title;
  final Color color;
  final bool isTime;
  final TextEditingController controller;
  final String hint;

  const TruckInfoWidget({
    super.key,
    required this.title,
    this.isTime = false,
    this.color = Colors.black,
    required this.controller,
    this.hint = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TxtStyle(title, 9),
        SizedBox(height: 5.h),
        SizedBox(
          height: 45.h,
          child: CustomFormTextField(
            hint: isTime ? hint : "",
            controller: controller,
            isNumbers: true,
            // isYear: true,
            isLocation: isTime,
            validator: (value) {
              if (value == null) {
                return "الحقل مطلوب!";
              } else {
                return null;
              }
            },
            width: 90,
          ),
        ),
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(5.r),
        //     color: softGrey,
        //   ),
        //   child: TxtStyle(info, 12, color: color),
        // ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
