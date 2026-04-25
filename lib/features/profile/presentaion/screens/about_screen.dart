import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/profile/presentaion/widget/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TopNavBar("عن التطبيق"),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset("assets/images/logo_white.png", height: 200.h),
                  TxtStyle(
                    "تفاصيل عن تطبيق الحجز المراد من المستخدمين معرفتها",
                    14,
                    longText: true,
                    color: darkGrey,
                    textAlignm: TextAlign.center,
                  ),
                  SizedBox(height: 100.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TxtStyle("تواصل معنا:", 18),
                  ),
                  SizedBox(height: 10.h),
                  ListItemWidget(
                    text: "091873878",
                    icon: Icons.phone,
                    onTap: () {},
                  ),
                  ListItemWidget(
                    text: "Bullstation@support.com",
                    icon: Icons.email,
                    onTap: () {},
                  ),
                  SizedBox(height: 100.h),
                  TxtStyle(
                    "Powered By: Bull-Station Team",
                    16,
                    color: darkBlue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
