// ignore_for_file: avoid_print

import 'package:bull_station/core/utils/screens/show_terms_dialog.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/auth/application/signup_cubit/sign_up_cubit.dart';
import 'package:bull_station/features/auth/application/signup_cubit/sign_up_states.dart';
import 'package:bull_station/features/auth/presentation/screens/sign_up_vehicle_owner_screen.dart';
import 'package:bull_station/features/auth/presentation/screens/success_screen.dart';
import 'package:bull_station/features/auth/presentation/widget/pinput_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OtpScreen extends StatelessWidget {
  final String verificationId;
  final SignupCubit signupCubit;

  const OtpScreen({
    super.key,
    required this.signupCubit,
    required this.verificationId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<SignupCubit>(context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Form(
          key: signupCubit.otpFormKey,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TxtStyle("تأكيد رقم الهاتف", 22, fontWeight: FontWeight.bold),
                  SizedBox(height: 10.h),
                  TxtStyle(
                    "أدخل رمز التحقق",
                    12,
                    fontWeight: FontWeight.normal,
                    longText: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: PinputWidget(
                        otpController: signupCubit.otpController,
                      ),
                    ),
                  ),
                  BlocConsumer<SignupCubit, SignupStates>(
                    listener: (context, signupState) {
                      if (signupState is OtpWrongState) {
                        showToast(
                          context,
                          "تحقق من الرمز المرسل إليك وأعد إدخاله مجدداً!",
                        );
                      }
                      if (signupState is OtpVerifiedSuccessState) {
                        {
                          if (signupCubit.groupValue != "client") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: signupCubit,
                                  child: SignUpVehicleOwnerScreen(
                                    signupCubit: signupCubit,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            showTermsDialog(
                              context,
                              isOwner: false,
                              onAccept: () async {
                                signupCubit.signup(context);
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SuccessScreen(
                                      isOwner: false,
                                      userName:
                                          signupCubit.userNameController.text,
                                    ),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                            );
                          }
                          print("NEW USER");
                        }
                      }
                    },
                    builder: (context, signupState) {
                      SignupCubit signupCubit = SignupCubit.get(context);
                      if (signupState is SignupLoadingState) {
                        return const LoadingWidget();
                      } else {
                        return CustomButton(
                          text: "تحقق",
                          onTap: () {
                            print("OTP ${signupCubit.pin}");
                            if (signupCubit.otpFormKey.currentState!
                                .validate()) {
                              signupCubit.verfiyOtp(
                                context: context,
                                verificationId: verificationId,
                                onSuccess: ({required String userId}) {
                                  if (signupCubit.groupValue != "client") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider.value(
                                              value: signupCubit,
                                              child: SignUpVehicleOwnerScreen(
                                                signupCubit: signupCubit,
                                              ),
                                            ),
                                      ),
                                    );
                                  } else {
                                 
                                signupCubit.signup(context).then((_){
                                  
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SuccessScreen(
                                          isOwner: false,
                                          userName: "",
                                        ),
                                      ),
                                      (Route<dynamic> route) => false,
                                    );
                                });
                              
                                  }
                                  print("NEW USER");
                                },
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(height: 7.h),
                  GestureDetector(
                    onTap: () {
                      signupCubit.verfiyPhone(context: context);
                      signupCubit.otpController.clear();
                      //navigate to the same screen because of form key duplicating error
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtpScreen(
                            signupCubit: signupCubit,
                            verificationId: verificationId,
                          ),
                        ),
                      );
                    },
                    child: const TxtStyle(
                      "إعادة إرسال الرمز؟",
                      12,
                      fontWeight: FontWeight.normal,
                      textDecoration: TextDecoration.underline,
                    ),
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
