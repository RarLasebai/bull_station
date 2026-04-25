import 'package:bull_station/core/utils/screens/show_terms_dialog.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/custom_text_field.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/auth/application/signup_cubit/sign_up_cubit.dart';
import 'package:bull_station/features/auth/application/signup_cubit/sign_up_states.dart';
import 'package:bull_station/features/auth/presentation/screens/success_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpVehicleOwnerScreen extends StatelessWidget {
  final SignupCubit signupCubit;
  const SignUpVehicleOwnerScreen({super.key, required this.signupCubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocProvider.value(
        value: BlocProvider.of<SignupCubit>(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: BlocConsumer<SignupCubit, SignupStates>(
              listener: (context, state) {
                if (state is SignupSuccessState) {
                  showTermsDialog(
                    context,
                    isOwner: true,
                    onAccept: () async {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuccessScreen(
                            isOwner: true,
                            userName: state.signUpResponse.user.name,
                          ),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                  );
                }
                if (state is SignupErrorState) {
                  showToast(context, state.message);
                }
              },
              builder: (context, state) {
                return Form(
                  key: signupCubit.signUpTwoFormKey,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          "assets/images/logo_white.png",
                          fit: BoxFit.fitWidth,
                          height: 200.h,
                        ),
                        Center(child: TxtStyle("أكمل تعبئة البيانات", 25)),
                        SizedBox(height: 12.h),
                        TxtStyle(
                          "معرف الشركة",
                          13,
                          fontWeight: FontWeight.bold,
                        ),
                        CustomTextField(
                          hint: "",
                          controller: signupCubit.fleetOwnerCode,
                          validator: (_) {
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),

                        TxtStyle(
                          "صورة الهوية",
                          13,
                          fontWeight: FontWeight.bold,
                        ),
                        GestureDetector(
                          onTap: () {
                            signupCubit.pickImage(imageType: 'identity');
                          },
                          child: ConditionalBuilder(
                            condition: signupCubit.identityImage != null,
                            builder: (context) => Container(
                              height: 143.h,
                              width: 365.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Image.file(
                                signupCubit.identityImage!,
                                fit: BoxFit.cover,
                                height: 150.h, // Or whatever size you need
                              ),
                            ),
                            fallback: (context) => Image.asset(
                              "assets/images/upload.png",
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        TxtStyle(
                          "صورة رخصة القيادة",
                          13,
                          fontWeight: FontWeight.bold,
                        ),
                        GestureDetector(
                          onTap: () {
                            signupCubit.pickImage(imageType: 'license');
                          },
                          child: ConditionalBuilder(
                            condition: signupCubit.drivingLicenseImage != null,
                            builder: (context) => Container(
                              height: 143.h,
                              width: 365.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Image.file(
                                signupCubit.drivingLicenseImage!,
                                fit: BoxFit.cover,
                                height: 150.h,
                              ),
                            ),
                            fallback: (context) => Image.asset(
                              "assets/images/upload.png",
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        ConditionalBuilder(
                          condition: state is! SignupLoadingState,
                          fallback: (context) => const LoadingWidget(),
                          builder: (context) => CustomButton(
                            text: "حفظ",
                            onTap: () {
                              if (signupCubit.identityImage != null &&
                                  signupCubit.drivingLicenseImage != null) {
                                signupCubit.signup(context, isOwner: true);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
