import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors/colors.dart';
import 'txt_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final int width;
  final bool isSecondBtn;
  final bool isDetails;
  const CustomButton({
    required this.text,
    required this.onTap,
    this.width = 327,
    this.color = darkBlue,
    this.isDetails = false,
    this.isSecondBtn = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: isDetails ? 35.h : 50.h,
            width: width.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: isSecondBtn ? Colors.white : color,
              border: isSecondBtn
                  ? Border.all(color: darkBlue, width: 2)
                  : null,
            ),
            child: Center(
              child: TxtStyle(
                text,
                isDetails ? 11 : 13,
                textAlignm: TextAlign.center,
                color: isSecondBtn ? darkBlue : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
