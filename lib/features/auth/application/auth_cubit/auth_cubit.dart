// ignore_for_file: avoid_print
import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/core/utils/services/notification_service.dart';
import 'package:bull_station/features/auth/application/auth_cubit/auth_states.dart';
import 'package:bull_station/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(BuildContext context) => BlocProvider.of(context);
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isSignedin = false;
  UserModel? userModel;

  void checkSign() async {
    emit(AuthLoadingState());
    try {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      isSignedin = sharedPreferences.getBool("is_signed_in") ?? false;
      if (isSignedin == true) {
        UserModel userModel = await getDataFromSharedPref();
        String? apiToken =
            await getLoginToken(); 
          NotificationService().updateDeviceToken(apiToken);
        
        print('Go To Home');
        emit(AuthSuccessState(userModel));
      } else {
        print('Go To Boarding');
        emit(AuthFailState());
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.toString()));
    }
  }
}
