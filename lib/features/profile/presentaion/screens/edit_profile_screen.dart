import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/custom_text_field.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/auth/data/models/user_model.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/presentation/screens/home_screen.dart';
import 'package:bull_station/features/home/presentation/screens/owner_home_screen.dart';
import 'package:bull_station/features/profile/application/profile_cubit.dart';
import 'package:bull_station/features/profile/application/profile_states.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatelessWidget {
  final UserModel userModel;
  const EditProfileScreen({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        var profileCubit = ProfileCubit.get(context);
        return SafeArea(
          child: Scaffold(
            appBar: TopNavBar("تعديل البيانات"),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  //تعديل الصورة
                  SizedBox(height: 20.h),
                  TxtStyle("تعديل الصورة الشخصية", 14, color: darkGrey),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () => profileCubit.selectImage(context),
                    child: Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: darkGrey),
                        color: softGrey,
                      ),
                      child: _buildProfileImage(profileCubit, userModel),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TxtStyle("تعديل اسم المستخدم", 14, color: darkGrey),
                  CustomTextField(
                    hint: userModel.name,
                    controller: profileCubit.name,
                    validator: (_) {
                      return null;
                    },
                    isLable: true,
                  ),

                  // SizedBox(height: 20.h),
                  // TxtStyle("تعديل موقعك", 14, color: darkGrey),
                  // Container(
                  //   height: 180.h,
                  //   width: 330.w,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(15.r),
                  //     border: Border.all(color: darkGrey),
                  //     color: softGrey,
                  //   ),
                  // ),
                  BlocConsumer<ProfileCubit, ProfileStates>(
                    listener: (context, state) {
                      if (state is ProfileEditedSuccessState) {
                        context.read<HomeCubit>().initUser();
                        final user = context.read<HomeCubit>().currentUser;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("تم تحديث البيانات بنجاح"),
                          ),
                        );
                        // Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => user!.accountType == "client"
                                ? HomeScreen()
                                : OwnerHomeScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    builder: (context, state) {
                      return ConditionalBuilder(
                        condition: state is ProfileLoadingState,
                        builder: (context) => const LoadingWidget(),
                        fallback: (context) => CustomButton(
                          text: "حفظ",
                          onTap: () {
                            profileCubit.editProfile(context);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(ProfileCubit cubit, UserModel user) {
    // 1. إذا اختار المستخدم صورة جديدة من الاستوديو
    if (cubit.pickedImageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50.r), // نصف القطر لجعلها دائرة
        child: Image.file(
          cubit.pickedImageFile!,
          fit: BoxFit.cover, // مهم جداً لملء الدائرة
          width: 100.w,
          height: 100.h,
        ),
      );
    }

    // 2. إذا كانت الصورة موجودة على السيرفر (باستخدام المنطق المرن للحقول)
    final imageUrl =
        user.photo; 
    if (imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50.r),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 100.w,
          height: 100.h,
          errorBuilder: (context, error, stackTrace) =>
              Icon(Icons.person, size: 50.r),
        ),
      );
    }

    // 3. الحالة الافتراضية عند عدم وجود صورة
    return Icon(Icons.camera_alt, color: darkGrey, size: 30.r);
  }
}
