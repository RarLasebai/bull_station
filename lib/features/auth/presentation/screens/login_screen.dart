import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/custom_text_field.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/phone_field.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/auth/application/login_cubit/login_cubit.dart';
import 'package:bull_station/features/auth/application/login_cubit/login_states.dart';
import 'package:bull_station/features/auth/presentation/screens/restore_pass_screen.dart';
import 'package:bull_station/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:bull_station/features/home/presentation/screens/home_screen.dart';
import 'package:bull_station/features/home/presentation/screens/owner_home_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: BlocProvider(
            create: (context) => LoginCubit(),

            child: BlocConsumer<LoginCubit, LoginStates>(
              listener: (context, state) {
                if (state is LoginSuccessState) {
                  state.loginResponseModel.user.accountType != "client"
                      ? Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OwnerHomeScreen(
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        )
                      : Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                } else if (state is UserNotFoundState) {
                  showToast(
                    context,
                    "رقم الهاتف أو كلمة المرور غير صحيحة، تحقق مجدداً.",
                  );
                } else if (state is LoginErrorState) {
                  showToast(
                    context,
                    "رقم الهاتف أو كلمة المرور غير صحيحة، تحقق مجدداً.",
                  );
                }
              },
              builder: (context, state) {
                LoginCubit loginCubit = LoginCubit.get(context);
                return Form(
                  key: loginCubit.loginFormKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/logo_white.png",
                          fit: BoxFit.fitWidth,
                          height: 200.h,
                          
                        ),
                        TxtStyle("تسجيل الدخول", 22),
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 30),
                          child: PhoneNumberField(
                            controller: loginCubit.phoneController,
                            onNumberChanged: (completeNumber) {
                              loginCubit.completePhoneNumber = completeNumber;
                            },
                            validator: (value) {
                              if (value == null || value.number.isEmpty) {
                                return "من فضلك لا تترك الحقل فارغاً";
                              } else {
                                return null;
                              }
                            },
                          ),
                          // CustomTextField(
                          //   hint: appLocalizations.phone,
                          //   controller: loginCubit.phoneController,
                          //   isPhone: true,

                          // ),
                        ),
                        CustomTextField(
                          hint: "كلمة المرور",
                          controller: loginCubit.passController,
                          suffixIcon: loginCubit.suffixIcon,
                          suffixOnTap: loginCubit.changePassVisibilty,
                          isPass: loginCubit.isPassword,
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
                          padding: const EdgeInsets.only(top: 30, bottom: 15),
                          child: ConditionalBuilder(
                            condition: state is LoginLoadingState,
                            fallback: (context) => CustomButton(
                              text: "تسجيل الدخول",
                              onTap: () {
                                if (loginCubit.loginFormKey.currentState!
                                    .validate()) {
                                  loginCubit.login(context);
                                }
                              },
                            ),

                            builder: (context) => const LoadingWidget(),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RestorePasswordScreen(),
                              ),
                            );
                          },
                          child: TxtStyle(
                            "نسيت كلمة المرور؟",
                            12,
                            color: darkGrey,
                            textDecoration: TextDecoration.underline,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: TxtStyle(
                            "ليس لديك حساب بعد؟ سجل الآن",
                            12,
                            color: darkGrey,
                            textDecoration: TextDecoration.underline,
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
