// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/screens/splash_screen.dart';
import 'package:bull_station/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

//store data locally
Future storeDataLocally(UserModel user) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  await sharedPreferences.setString("user_model", jsonEncode(user.toJson()));
  print("data saved");
  setSignin();
}

Future<UserModel> getDataFromSharedPref() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.reload();
  String data = sharedPreferences.getString("user_model") ?? '';
  final userModel = UserModel.fromJson(jsonDecode(data));
  return userModel;
}

Future storeLoginToken(String loginToken) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  await sharedPreferences.setString("login_token", loginToken);
  print("data saved");
}

Future<String> getLoginToken() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  String loginToken = sharedPreferences.getString("login_token") ?? '';
  return loginToken;
}

Future setSignin() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setBool("is_signed_in", true);
  print("user login saved");
}

// Future saveFirebaseIdToken(String token) async {
//   final SharedPreferences sharedPreferences =
//       await SharedPreferences.getInstance();
//   await sharedPreferences.setString("firebase_id_token", token);
// }

Future<String?> getFirebaseIdToken() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    // Calling getIdToken() ensures you get a valid, unexpired token.
    return await user.getIdToken();
  }
  return null;
}

Future signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setBool("is_signed_in", false);
  // ignore: use_build_context_synchronously
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const SplashScreen()),
    (Route<dynamic> route) => false,
  );
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents closing on tap outside
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

Future<File?> pickImage(BuildContext context,
    {bool multiPhotos = false}) async {
  File? image;

  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showToast(context, "حدث خطأ ما $e");
  }
  return image;
}
