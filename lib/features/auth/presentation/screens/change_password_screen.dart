import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/custom_text_field.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/auth/application/restore_pass_cubit/restore_pass_cubit.dart';
import 'package:bull_station/features/auth/application/restore_pass_cubit/restore_pass_states.dart';
import 'package:bull_station/features/auth/presentation/screens/login_screen.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatelessWidget {
  final RestorePassCubit restorePassCubit;
  const ChangePasswordScreen({super.key, required this.restorePassCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<RestorePassCubit>(context),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.white),
          body: BlocConsumer<RestorePassCubit, RestorePassStates>(
            listener: (context, state) {
              if (state is RestorePassErrorState) {
                showToast(context, state.message);
              }
              if (state is PasswordChangedSuccessState) {
                showToast(
                  context,
                  "تم حفظ كلمة المرور الجديدة، قم بتسجيل الدخول الآن!",
                  color: Colors.green,
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
            builder: (context, state) {
              RestorePassCubit restorePassCubit = RestorePassCubit.get(context);
              return Form(
                key: restorePassCubit.changePasswordFormKey,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 24, left: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 16),
                          child: Center(
                            child: TxtStyle(
                              "إعادة تعيين كلمة المرور",
                              18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CustomTextField(
                          hint: "كلمة المرور",
                          controller: restorePassCubit.passwordController,
                          suffixIcon: restorePassCubit.suffixIcon,
                          suffixOnTap: restorePassCubit.changePassVisibilty,
                          isPass: restorePassCubit.isPassword,
                          isPassField: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "من فضلك لا تترك الحقل فارغاً";
                            } else {
                              return null;
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 30),
                          child: CustomTextField(
                            hint: "تأكيد كلمة المرور",
                            controller:
                                restorePassCubit.confirmPasswordController,
                            suffixIcon: restorePassCubit.suffixIcon,
                            suffixOnTap: restorePassCubit.changePassVisibilty,
                            isPass: restorePassCubit.isPassword,
                            isPassField: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "من فضلك لا تترك الحقل فارغاً";
                              } else if (value !=
                                  restorePassCubit.passwordController.text) {
                                return "كلمة المرور غير متطابقة";
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
                            text: "حفظ",
                            onTap: () {
                              if (restorePassCubit
                                  .changePasswordFormKey
                                  .currentState!
                                  .validate()) {
                                restorePassCubit.changePassword();
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
