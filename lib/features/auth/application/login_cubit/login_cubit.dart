// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/core/utils/services/notification_service.dart';
import 'package:bull_station/features/auth/application/login_cubit/login_states.dart';
import 'package:bull_station/features/auth/data/models/login_response_model.dart';
import 'package:bull_station/features/auth/data/services/login_services.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  String? completePhoneNumber;
  //Functions
  Future login(BuildContext context) async {
    emit(LoginLoadingState());
    LoginServices loginServices = LoginServices();
    loginServices
        .login(
          phone: completePhoneNumber!.trim(),
          password: passController.text,
          // firebaseIdToken: firebaseIdToken!,
        )
        .then((value) async {
          final Map<String, dynamic> responseData = jsonDecode(value.body);

          if (value.statusCode == 200) {
            final loginResponse = LoginResponseModel.fromJson(responseData);
            // Store data locally
            await storeDataLocally(loginResponse.user);
            await storeLoginToken(loginResponse.token);
context.read<HomeCubit>().initUser();            await NotificationService().updateDeviceToken(loginResponse.token);
            emit(LoginSuccessState(loginResponse));
          } else {
            final errorMessage = responseData['message'] ?? 'Signup failed';
            emit(LoginErrorState(errorMessage));
          }
        })
        .catchError((onError) {
          emit(LoginErrorState(onError.toString()));
        });
  }

  //show-hide password
  IconData suffixIcon = Icons.visibility_outlined;
  bool isPassword = true;
  void changePassVisibilty() {
    print("object");
    isPassword = !isPassword;
    suffixIcon = isPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;

    emit(LoginChangePassVisibiltyState());
  }
}
