// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls
import 'package:bull_station/features/auth/application/restore_pass_cubit/restore_pass_states.dart';
import 'package:bull_station/features/auth/data/services/restore_pass_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestorePassCubit extends Cubit<RestorePassStates> {
  RestorePassCubit() : super(RestorePassInitialState());

  static RestorePassCubit get(BuildContext context) => BlocProvider.of(context);

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  GlobalKey<FormState> restorePasswordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  String? completePhoneNumber;
  FirebaseAuth auth = FirebaseAuth.instance;
  RestorePassService restorePassService = RestorePassService();
  String? userId;

  //Functions
  Future<void> checkPhoneExist() async {
    emit(RestorePassLoadingState());
    await restorePassService
        .checkPhoneExist(phone: completePhoneNumber!.trim())
        .then((value) {
          if (value.statusCode == 200) {
            emit(PhoneExistState());
          } else if (value.statusCode == 404) {
            emit(PhoneNotExistState());
          }
        })
        .catchError((onError) {
          emit(PhoneNotExistState());
        });
  }

  void verfiyPhone() async {
    emit(RestorePassLoadingState());
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: completePhoneNumber!.trim(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        timeout: const Duration(seconds: 0),
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) async {
          emit(RestorePassCodeSentState(verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      emit(RestorePassErrorState(e.toString()));
    }
  }
  // //2- verify with otp

  void verfiyOtp({required String verificationId}) async {
    emit(RestorePassLoadingState());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text,
      );
      User? user = ((await auth.signInWithCredential(credential)).user);

      if (user != null) {
        //uuser verified
        final token = await user.getIdToken();
        print(token);
      }
      emit(OtpVerifiedSuccessState());
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      emit(RestorePassOtpWrongState());
    }
  }

  void changePassword() async {
    emit(RestorePassLoadingState());
    await restorePassService
        .changePassword(
          phone: completePhoneNumber!.trim(),
          password: passwordController.text,
        )
        .then((value) {
          if (value.statusCode == 200) {
            emit(PasswordChangedSuccessState());
          }
        })
        .catchError((onError) {
          emit(RestorePassErrorState("Something Went Wrong"));
        });
  }

  //show-hide password
  IconData suffixIcon = Icons.visibility_outlined;
  bool isPassword = true;
  void changePassVisibilty() {
    isPassword = !isPassword;
    suffixIcon = isPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;

    emit(RestorePassChangePassVisibiltyState());
  }
}
