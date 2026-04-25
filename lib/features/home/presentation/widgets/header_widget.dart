import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/auth/data/models/user_model.dart';
import 'package:bull_station/features/home/presentation/screens/notification_screen.dart';
import 'package:bull_station/features/profile/presentaion/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderWidget extends StatelessWidget {
  final UserModel userModel;
  const HeaderWidget({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176.h,
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.r),
          bottomRight: Radius.circular(15.r),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[200], // لون احتياطي
            backgroundImage: userModel.identityImage != null
                ? NetworkImage(userModel.identityImage!)
                : null,
            child: userModel.identityImage == null
                ? Icon(
                    Icons.person,
                    size: 25,
                  ) // تظهر الأيقونة فقط إذا كانت الصورة نل
                : null,
          ),
          SizedBox(width: 10.w),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TxtStyle(
                  "مرحباً بك!",
                  16,
                  color: darkGrey,
                  fontWeight: FontWeight.bold,
                ),
                TxtStyle(
                  userModel.name,
                  14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          Spacer(),

          //customIcon
          InkWell(
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationScreen(isOwner: userModel.accountType == "client" ? false : true)),
            );
            },
            child: Container(
              height: 40.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(Icons.notifications_none_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
