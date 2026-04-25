import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessPaymentDialog extends StatelessWidget {
  const SuccessPaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ليأخذ حجم المحتوى فقط
          children: [
            Container(
              padding: EdgeInsets.all(15.w),
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 50, color: Colors.white),
            ),
            SizedBox(height: 20.h),
            const TxtStyle("تم تأكيد الحجز بنجاح", 18),
            SizedBox(height: 10.h),
            const TxtStyle("شكراً لك! يمكنك متابعة تفاصيل حجزك من القائمة.", 14, longText: true),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}