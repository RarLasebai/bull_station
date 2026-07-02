// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/services/notification_service.dart';
import 'package:bull_station/features/auth/application/signup_cubit/sign_up_states.dart';
import 'package:bull_station/features/auth/data/models/sign_up_response_model.dart';
import 'package:bull_station/features/auth/data/services/signup_services.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class SignupCubit extends Cubit<SignupStates> {
  SignupCubit() : super(SignupInitialState());

  static SignupCubit get(BuildContext context) => BlocProvider.of(context);

  //Variables
  String? completePhoneNumber;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confrimPassController = TextEditingController();
  TextEditingController fleetOwnerCode = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> signUpOneFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> signUpTwoFormKey = GlobalKey<FormState>();
String currentVerificationId = "";
  String groupValue = "";
  String pin = "";
  String? userToken;

  File? identityImage;
  File? drivingLicenseImage;
  //Functions
  void onChanged(String value) {
    //this one is for the radio button
    groupValue = value;
    print(groupValue);
    emit(RadioButtonChangeState(value));
  }

  //verfiy phone number

  void verfiyPhone({required BuildContext context}) async {
    emit(SignupLoadingState());
    try {
      print("جاري الإرسال للرقم: ${completePhoneNumber!.trim()}");
      await auth.verifyPhoneNumber(
        phoneNumber: completePhoneNumber!.trim(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // في حال التحقق التلقائي (خاصة في أندرويد)
          await auth.signInWithCredential(credential);
          emit(OtpVerifiedSuccessState()); // الانتقال لحالة النجاح مباشرة
        },
        verificationFailed: (FirebaseAuthException e) {
          print("خطأ فيريفاير: ${e.code}");
          // ضروري جداً: إيميت للخطأ ليتوقف الـ Loading في الواجهة
          emit(SignupErrorState(e.message ?? e.toString()));
          
          if (e.code == 'invalid-phone-number') {
            showToast(context, 'رقم الهاتف غير صحيح');
          } else if (e.code == 'too-many-requests') {
            showToast(context, 'محاولات كثيرة، يرجى الانتظار');
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          this.currentVerificationId = verificationId; // تخزين المعرف الجديد
          emit(CodeSentSuccessState(verificationId)); // يتوقف الـ Loading هنا
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          // تخزين المعرف حتى لو انتهى الوقت
          this.currentVerificationId = verificationId;
        },
      );
    } catch (e) {
      emit(SignupErrorState(e.toString()));
    }
  }
  //verfiy OTP
  void verfiyOtp({
    required BuildContext context,
    required String verificationId, // المعرف المبدئي
    required Function onSuccess,
  }) async {
    emit(SignupLoadingState());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        // نستخدم المعرف الموجود في الكيوبت إذا كان متاحاً، وإلا نستخدم القادم من الشاشة
        verificationId: currentVerificationId.isNotEmpty ? currentVerificationId : verificationId,
        smsCode: otpController.text,
      );
      
      UserCredential userCredential = await auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        userToken = await user.getIdToken();
        emit(OtpVerifiedSuccessState());
      }
    } on FirebaseAuthException catch (e) {
      print("خطأ OTP: ${e.toString()}");
      emit(OtpWrongState()); // سيتوقف الـ Loading هنا ويظهر خطأ الكود
    } catch (e) {
      emit(SignupErrorState(e.toString()));
    }
  }
  Future signup(BuildContext context, {bool isOwner = false}) async {
    emit(SignupLoadingState());

    String? firebaseIdToken = await getFirebaseIdToken();
    SignupServices signupServices = SignupServices();
    isOwner ? 
          signupServices
        .sendSignUpRequest(
          name: userNameController.text,
          phone: completePhoneNumber!.trim(),
          password: passController.text,
          accountType: groupValue,
          identityImage: identityImage!,
          drivingLicenseImage: drivingLicenseImage!,
          firebaseIdToken: firebaseIdToken!,
          fleetOwnerCode: fleetOwnerCode.text,
          location: 'location',
        )  
        .then((signUpStream) async {
          signUpStream.stream.transform(utf8.decoder).listen((value) async {
            emit(SignupLoadingState());
            print(value);
            final Map<String, dynamic> responseData = jsonDecode(value);
            if (signUpStream.statusCode == 201) {
              final signUpResponse = SignUpResponse.fromJson(responseData);
              await storeDataLocally(signUpResponse.user);
              await storeLoginToken(signUpResponse.accessToken);
              context.read<HomeCubit>().initUser();
              await NotificationService().updateDeviceToken(
                signUpResponse.accessToken,
              );
              emit(SignupSuccessState(signUpResponse));
            } else {
              final errorMessage = responseData['message'] ?? 'Signup failed';
              emit(SignupErrorState(errorMessage));
            }
          });
        })
        .catchError((onError) {
          emit(SignupErrorState(onError.toString()));
        }) :  signupServices
        .sendSignUpRequest(
          name: userNameController.text,
          phone: completePhoneNumber!.trim(),
          password: passController.text,
          accountType: groupValue,
          // identityImage: identityImage!,
          // drivingLicenseImage: drivingLicenseImage!,
          firebaseIdToken: firebaseIdToken!,
          // fleetOwnerCode: fleetOwnerCode.text,
          location: 'location',
        )  
        .then((signUpStream) async {
          signUpStream.stream.transform(utf8.decoder).listen((value) async {
            emit(SignupLoadingState());
            print(value);
            final Map<String, dynamic> responseData = jsonDecode(value);
            if (signUpStream.statusCode == 201) {
              final signUpResponse = SignUpResponse.fromJson(responseData);
              await storeDataLocally(signUpResponse.user);
              await storeLoginToken(signUpResponse.accessToken);
              context.read<HomeCubit>().initUser();
              await NotificationService().updateDeviceToken(
                signUpResponse.accessToken,
              );
              emit(SignupSuccessState(signUpResponse));
            } else {
              final errorMessage = responseData['message'] ?? 'Signup failed';
              emit(SignupErrorState(errorMessage));
            }
          });
        })
        .catchError((onError) {
          emit(SignupErrorState(onError.toString()));
        }) ;
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

    emit(SignupChangePassVisibiltyState());
  }

  // Cubit Functions
  Future<void> pickImage({required String imageType}) async {
    emit(SignupLoadingState());
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (imageType == 'identity') {
        identityImage = File(pickedFile.path);
      } else if (imageType == 'license') {
        drivingLicenseImage = File(pickedFile.path);
      }
      // print(drivingLicenseImage!.path);
      emit(ImagePickedSuccessState());
    } else {
      print('No image selected.');
      print('No images selected.');
      emit(ImagePickedErrorState());
    }
  }
}
