import 'dart:io';

import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/features/auth/data/models/user_model.dart';
import 'package:bull_station/features/profile/application/profile_states.dart';
import 'package:bull_station/features/profile/service/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitialState());

  static ProfileCubit get(BuildContext context) => BlocProvider.of(context);
  TextEditingController name = TextEditingController();
  File profilePhoto = File("");
  Future<void> editLocation() async {
    emit(ProfileLoadingState());
    UserModel user = await ProfileService().updateLocation(
      location: "some location",
    );
    await storeDataLocally(user);
    emit(ProfileEditedSuccessState());
    // عند الخطأ:
    emit(ProfileErrorState(message: "حدث خطأ أثناء تعديل الموقع"));
  }
File? pickedImageFile; // لتخزين الصورة الجديدة التي اختارها المستخدم

// دالة منفصلة لاختيار الصورة فقط
Future<void> selectImage(BuildContext context) async {
  final image = await pickImage(context);
  if (image != null) {
    pickedImageFile = image;
    emit(ProfilePhotoPickedState());
  }
}
  Future<void> editProfile(BuildContext context) async {
    try {
      emit(ProfileLoadingState());

       final String? imagePath = pickedImageFile?.path;

      // 2. استدعاء السيرفس
      UserModel user = await ProfileService().updateProfile(
        name: name.text,
        identityImage: imagePath,
      );

      // 3. تحديث البيانات محلياً والنجاح
      await storeDataLocally(user);
      emit(ProfileEditedSuccessState());
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }
void clearData() {
  name.clear();
  pickedImageFile = null;
  emit(ProfileInitialState());
}
}
