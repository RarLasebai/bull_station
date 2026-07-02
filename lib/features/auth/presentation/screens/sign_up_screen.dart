import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/custom_radio_button.dart';
import 'package:bull_station/core/utils/widgets/custom_text_field.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/phone_field.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/auth/application/signup_cubit/sign_up_cubit.dart';
import 'package:bull_station/features/auth/application/signup_cubit/sign_up_states.dart';
import 'package:bull_station/features/auth/presentation/screens/login_screen.dart';
import 'package:bull_station/features/auth/presentation/screens/otp_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocProvider(
        create: (context) => SignupCubit(),
        child: BlocConsumer<SignupCubit, SignupStates>(
          listener: (context, signupState) {
            SignupCubit signupCubit = SignupCubit.get(context);

            if (signupState is CodeSentSuccessState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: signupCubit,
                    child: OtpScreen(
                      signupCubit: signupCubit,
                      verificationId: signupState.verificationId,
                    ),
                  ),
                ),
              );
            } else if (signupState is SignupErrorState) {
              showToast(context, signupState.message);
            }
          },
          builder: (context, state) {
            SignupCubit signupCubit = SignupCubit.get(context);
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Form(
                    key: signupCubit.signUpOneFormKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/images/logo_white.png",
                            fit: BoxFit.fitWidth,
                            height: 200.h,
                          ),
                          Center(child: TxtStyle("تسجيل حساب جديد", 25)),
                          SizedBox(height: 40.h),
                          PhoneNumberField(
                            controller: signupCubit.phoneController,
                            onNumberChanged: (completeNumber) {
                              print("الرقم المكتشف الآن: $completeNumber");
                              signupCubit.completePhoneNumber = completeNumber;
                            },
                            validator: (value) {
                              if (value == null || value.number.isEmpty) {
                                return "من فضلك لا تترك الحقل فارغاً";
                              } else {
                                return null;
                              }
                            },
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 30),
                            child: CustomTextField(
                              hint: "اسم المستخدم",
                              controller: signupCubit.userNameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "من فضلك لا تترك الحقل فارغاً";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          CustomTextField(
                            hint: "كلمة المرور",
                            controller: signupCubit.passController,
                            suffixIcon: signupCubit.suffixIcon,
                            suffixOnTap: signupCubit.changePassVisibilty,
                            isPass: signupCubit.isPassword,
                            isPassField: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "من فضلك لا تترك الحقل فارغاً";
                              } else if (value.length <= 7) {
                                return "كلمة المرور قصيرة جداً";
                              } else {
                                return null;
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            child: CustomTextField(
                              hint: "تأكيد كلمة المرور",
                              controller: signupCubit.confrimPassController,
                              suffixIcon: signupCubit.suffixIcon,
                              suffixOnTap: signupCubit.changePassVisibilty,
                              isPass: signupCubit.isPassword,
                              isPassField: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "من فضلك لا تترك الحقل فارغاً";
                                } else if (value !=
                                    signupCubit.passController.text) {
                                  return "كلمة المرور غير متطابقة";
                                } else if (value.length <= 7) {
                                  return "كلمة المرور قصيرة جداً";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          TxtStyle("اختر نوع الحساب", 16),
                          Padding(
                            padding: const EdgeInsets.only(left: 70.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomRadioButton(
                                  groupValue: signupCubit.groupValue,
                                  onChanged: (value) =>
                                      signupCubit.onChanged(value as String),
                                  title: "باحث عن معدة",
                                  value: 'client',
                                ),
                                CustomRadioButton(
                                  groupValue: signupCubit.groupValue,
                                  onChanged: (value) =>
                                      signupCubit.onChanged(value as String),
                                  title: "مالك معدة",
                                  value: 'truck_owner',
                                ),
                              ],
                            ),
                          ),
                          ConditionalBuilder(
                            condition: state is SignupLoadingState,
                            fallback: (context) => CustomButton(
                              text: "متابعة",
                              onTap: () {
                                if (signupCubit.signUpOneFormKey.currentState!
                                    .validate()) {
                                  signupCubit.verfiyPhone(context: context);
                                }
                              },
                            ),
                            builder: (context) => const LoadingWidget(),
                          ),
                          SizedBox(height: 15.h),
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Center(
                              child: TxtStyle(
                                "لديك حساب بالفعل؟ سجل الدخول",
                                14,
                                color: darkGrey,
                                textDecoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
