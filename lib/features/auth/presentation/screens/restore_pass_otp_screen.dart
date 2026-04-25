// ignore_for_file: avoid_print

import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/auth/application/restore_pass_cubit/restore_pass_cubit.dart';
import 'package:bull_station/features/auth/application/restore_pass_cubit/restore_pass_states.dart';
import 'package:bull_station/features/auth/presentation/screens/change_password_screen.dart';
import 'package:bull_station/features/auth/presentation/widget/pinput_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestorePassOtpScreen extends StatelessWidget {
  final RestorePassCubit restorePassCubit;
  final String verId;
  const RestorePassOtpScreen({
    super.key,
    required this.restorePassCubit,
    required this.verId,
  });

  @override
  Widget build(BuildContext context) {
    final RestorePassCubit restorePassCubit = RestorePassCubit.get(context);

    return BlocProvider.value(
      value: BlocProvider.of<RestorePassCubit>(context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Form(
          key: restorePassCubit.otpFormKey,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TxtStyle("تأكيد رقم الهاتف", 22),
                  SizedBox(height: 10.h),
                  TxtStyle("أدخل رمز التحقق", 12, longText: true),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: PinputWidget(
                        otpController: restorePassCubit.otpController,
                      ),
                    ),
                  ),
                  BlocConsumer<RestorePassCubit, RestorePassStates>(
                    listener: (context, state) {
                      if (state is RestorePassOtpWrongState) {
                        showToast(
                          context,
                          "تحقق من الرمز المرسل إليك وأعد إدخاله مجدداً!",
                        );
                      }
                      if (state is OtpVerifiedSuccessState) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: restorePassCubit,
                              child: ChangePasswordScreen(
                                restorePassCubit: restorePassCubit,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is RestorePassLoadingState) {
                        return const LoadingWidget();
                      } else {
                        return CustomButton(
                          text: "تحقق",
                          onTap: () {
                            if (restorePassCubit.otpFormKey.currentState!
                                .validate()) {
                              restorePassCubit.verfiyOtp(verificationId: verId);
                            }
                          },
                        );
                      }
                    },
                  ),
                  SizedBox(height: 7.h),
                  GestureDetector(
                    onTap: () {
                      // forgetPassCubit.verfiyPhone(
                      //   phone: userModel.userPhone,
                      //   user: userModel,
                      // );
                      restorePassCubit.otpController.clear();
                    },
                    child: TxtStyle(
                      "أعد إرسال الرمز؟",
                      12,

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
