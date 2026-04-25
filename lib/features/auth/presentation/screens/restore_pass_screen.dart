// ignore_for_file: avoid_print

import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/phone_field.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/auth/application/restore_pass_cubit/restore_pass_cubit.dart';
import 'package:bull_station/features/auth/application/restore_pass_cubit/restore_pass_states.dart';
import 'package:bull_station/features/auth/presentation/screens/restore_pass_otp_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestorePasswordScreen extends StatelessWidget {
  final bool isProfile;
  // final UserModel? userModel;
  const RestorePasswordScreen({super.key, this.isProfile = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestorePassCubit(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.white),
          body: BlocConsumer<RestorePassCubit, RestorePassStates>(
            listener: (context, state) {
              RestorePassCubit restorePassCubit = RestorePassCubit.get(context);

              if (state is PhoneExistState) {
                restorePassCubit.verfiyPhone();
              }
              if (state is RestorePassCodeSentState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: restorePassCubit,
                      child: RestorePassOtpScreen(
                        restorePassCubit: restorePassCubit,
                        verId: state.verId,
                      ),
                    ),
                  ),
                );
              }
              if (state is PhoneNotExistState) {
                showToast(
                  context,
                  "الرقم غير موجود، تأكد منه أو قم بتسجيل حساب جديد!",
                );
              }
            },
            builder: (context, state) {
              RestorePassCubit restorePassCubit = RestorePassCubit.get(context);
              return Form(
                key: restorePassCubit.restorePasswordFormKey,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24, left: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isProfile == false
                            ? Image.asset(
                                "assets/images/logo_white.png",
                                fit: BoxFit.fitWidth,
                                height: 200.h,
                              )
                            : const SizedBox(),
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 16),
                          child: Center(
                            child: TxtStyle(
                              "استعادة كلمة المرور",
                              18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 20),
                          child: PhoneNumberField(
                            controller: restorePassCubit.phoneController,
                            onNumberChanged: (completeNumber) {
                              restorePassCubit.completePhoneNumber =
                                  completeNumber;
                            },
                            validator: (value) {
                              if (value == null || value.number.isEmpty) {
                                return "من فضلك لا تترك الحقل فارغاً";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        ConditionalBuilder(
                          condition: state is RestorePassLoadingState,
                          builder: (context) => LoadingWidget(),
                          fallback: (context) => CustomButton(
                            text: "استعادة",
                            onTap: () {
                              if (restorePassCubit
                                  .restorePasswordFormKey
                                  .currentState!
                                  .validate()) {
                                restorePassCubit.checkPhoneExist();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
