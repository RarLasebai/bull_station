import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/terms_and_conditions_text.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showTermsDialog(
  BuildContext context, {
  required VoidCallback onAccept,
  required bool isOwner,
}) {
  showDialog(
    context: context,
    // الخطوة 1: منع إغلاق الديالوق عند الضغط في أي مكان خارج الصندوق
    barrierDismissible: false,
    builder: (context) {
      // الخطوة 2: منع زر الرجوع في الهاتف من إغلاق النافذة
      return PopScope(
        canPop: false, // تعطيل إمكانية الرجوع
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            title: const TxtStyle(
              "الشروط والأحكام",
              16,
              fontWeight: FontWeight.bold,
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: TxtStyle(
                  isOwner ? TermsTexts.ownerTerms : TermsTexts.renterTerms,
                  12,
                  color: darkGrey,
                  longText: true,
                  terms: true,
                ),
              ),
            ),
            actions: [
              // نكتفي بزر واحد فقط للإلزام بالموافقة
              // أو نضع زر "خروج من التطبيق" إذا رفض
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // إغلاق الديالوق برمجياً فقط
                    onAccept(); // تنفيذ الدخول
                  },
                  child: const TxtStyle(
                    "أوافق وألتزم بالشروط",
                    14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
