import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/profile/application/profile_cubit.dart';
import 'package:bull_station/features/profile/presentaion/screens/about_screen.dart';
import 'package:bull_station/features/profile/presentaion/screens/edit_profile_screen.dart';
import 'package:bull_station/features/profile/presentaion/screens/terms_ad_conditions_screen.dart';
import 'package:bull_station/features/profile/presentaion/widget/list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<HomeCubit>().currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return SafeArea(
      child: Scaffold(
        appBar: TopNavBar("الملف الشخصي"),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CircleAvatar(
                    radius: 60.r,
                    backgroundColor:
                        softGrey, // لون خلفية في حال كانت الصورة شفافة أو لم تحمل بعد
                    backgroundImage:
                        (user.identityImage != null &&
                            user.identityImage!.isNotEmpty)
                        ? NetworkImage(user.identityImage!)
                        : null,
                    child:
                        (user.identityImage == null ||
                            user.identityImage!.isEmpty)
                        ? Icon(Icons.person, size: 40.r)
                        : null,
                  ),
                ),
                TxtStyle(user.name, 18),
                TxtStyle(user.phone, 14, color: darkGrey),
                SizedBox(height: 70.h),

                ListItemWidget(
                  text: "تعديل البيانات",
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditProfileScreen(userModel: user),
                      ),
                    );
                  },
                ),

                ListItemWidget(
                  text: "الشروط والأحكام",
                  icon: Icons.policy,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermsAndConditionsScreen(
                          isOwner: user.accountType == "client" ? false : true,
                        ),
                      ),
                    );
                  },
                ),
                ListItemWidget(
                  text: "عن التطبيق",
                  icon: Icons.info,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  ),
                ),
                ListItemWidget(
                  text: "تسجيل الخروج",
                  icon: Icons.logout,
                  onTap: () {
                    context.read<ProfileCubit>().clearData();
                    signOut(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
