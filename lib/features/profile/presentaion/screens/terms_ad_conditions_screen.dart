import 'package:bull_station/core/utils/terms_and_conditions_text.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  final bool isOwner;
  const TermsAndConditionsScreen({super.key, required this.isOwner});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TopNavBar("الشروط والأحكام"),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Scrollbar(
            // إضافة شريط تمرير جانبي
            thumbVisibility: true, // جعله مرئياً دائماً أثناء السحب
            thickness: 6,
            radius: const Radius.circular(10),
            child: SingleChildScrollView(
              // Physics تجعل السكرول أكثر سلاسة
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  TxtStyle(
                    isOwner ? TermsTexts.ownerTerms : TermsTexts.renterTerms,
                    14,
                    color: Colors.black87,
                    longText: true,
                    terms: true,
                  ),

                  SizedBox(height: 15.h),

                  CustomButton(
                    text: "فهمت وموافق",
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 20), // مساحة إضافية في الأسفل
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
