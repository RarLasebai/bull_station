import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessScreen extends StatelessWidget {
  final bool isOwner  ;
  final String userName;
  const SuccessScreen({super.key, required this.isOwner, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            Image.asset("assets/images/success.png"),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 10),
              child: TxtStyle(
                "تم تسجيل حسابك بنجاح! استمتع بتجربة تطبيقنا.",
                16,
                longText: true,
              ),
            ),
            CustomButton(
              text: "سجل الدخول",
              onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                // if (isOwner) {
                //   Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) => OwnerHomeScreen()),
                //     (Route<dynamic> route) => false,
                //   );
                // } else {
                //   Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(builder: (context) => HomeScreen()),
                //     (Route<dynamic> route) => false,
                //   );
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
