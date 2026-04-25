// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bull_station/features/home/data/models/category_model.dart';
import 'package:bull_station/features/home/data/models/sub_category_model.dart';
import 'package:bull_station/features/truck/application/edit_truck_states.dart';
import 'package:bull_station/features/truck/data/models/truck_details_model.dart';
import 'package:bull_station/features/truck/data/services/truck_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditTruckCubit extends Cubit<EditTruckStates> {
  final TruckDetailsModel originalTruck;

  // Controllers for form fields
  final basicInfoFormKey = GlobalKey<FormState>();
  final pricesFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController yearOfManufactureController =
      TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController featuresController = TextEditingController();
  final TextEditingController pricePerDaycontroller = TextEditingController();
  final TextEditingController pricePerHourcontroller = TextEditingController();
  final TextEditingController workStartTimeController = TextEditingController();
  final TextEditingController workEndTimeController = TextEditingController();
  final TextEditingController deliveryPriceController = TextEditingController();
final TextEditingController pickupLocationController = TextEditingController();
final List<CategoryModel> categories; 
  List<SubCategoryModel> subCategories = [];
  int? selectedCategoryId;
  int? selectedSubCategoryId;
  // Separate lists for existing and new media
  List<String> existingTruckImages = [];
  List<File> newTruckImages = [];
  String? existingTruckVideo;
  File? newTruckVideo;
  String startHint = "00:00";
  String endHint = "00:00";
  bool isDeliveryEnabled = false;

  final Map<String, String> changedFields = {};

EditTruckCubit(this.originalTruck, this.categories) : super(EditTruckInitialState()) {
    editededOriginalTruck = originalTruck;
    _initializeForEdit();
  }

  static EditTruckCubit get(BuildContext context) => BlocProvider.of(context);
  TruckDetailsModel? editededOriginalTruck;

  void _initializeForEdit() {
    List<String> times = originalTruck.workHours.split(' - ');
    nameController.text = originalTruck.name;
    yearOfManufactureController.text = originalTruck.yearOfManufacture;
    modelController.text = originalTruck.model;
    descriptionController.text = originalTruck.description;
    sizeController.text = originalTruck.size;
    featuresController.text = originalTruck.features ?? '';
    pricePerDaycontroller.text = originalTruck.pricePerDay.replaceAll(
      '.00',
      '',
    );
    pricePerHourcontroller.text = originalTruck.pricePerHour.replaceAll(
      '.00',
      '',
    );
    workStartTimeController.text = formatTime(times[0]);
    workEndTimeController.text = formatTime(times[1]);
    deliveryPriceController.text = originalTruck.deliveryPrice;
    isDeliveryEnabled = originalTruck.deliveryAvailable;

    // Assign existing images and video from the model to their dedicated lists
    existingTruckImages = List<String>.from(originalTruck.images);
    existingTruckVideo = originalTruck.video;
    try {
      final currentCat = categories.firstWhere(
        (cat) => cat.name == originalTruck.category, 
        orElse: () => categories.first,
      );
      
      selectedCategoryId = currentCat.id;
      subCategories = currentCat.subCategoryModel;
      final currentSubCat = subCategories.firstWhere(
        (sub) => sub.name == originalTruck.subCategory,
        orElse: () => subCategories.first,
      );
      selectedSubCategoryId = currentSubCat.id;
    } catch (e) {
      print("Error initializing categories: $e");
    }
    emit(EditTruckInitialState());
  }

  void setBasicInfo() {
    if (selectedCategoryId == null || selectedSubCategoryId == null) {
    emit(EditTruckSubmittingErrorState("يرجى اختيار التصنيف والنوع الفرعي"));
    return;
  }
  
  // تحديث الـ changedFields قبل الانتقال للشاشة التالية
  changedFields['category_id'] = selectedCategoryId.toString();
  changedFields['sub_category_id'] = selectedSubCategoryId.toString();
    emit(EditTruckBasicInfoState());
  }

  void setPrice() {
    List<String> times = originalTruck.workHours.split(' - ');

    // 3. Compare fields and add them to the map if they changed
    if (nameController.text != originalTruck.name) {
      changedFields['name'] = nameController.text;
    }

    if (sizeController.text != originalTruck.size) {
      changedFields['size'] = sizeController.text;
    }
    if (featuresController.text != originalTruck.features) {
      changedFields['additional_features'] = featuresController.text;
    }
    if (descriptionController.text != originalTruck.description) {
      changedFields['description'] = descriptionController.text;
    }
    if (deliveryPriceController.text != originalTruck.deliveryPrice) {
      changedFields['delivery_price'] = deliveryPriceController.text;
    }
    if (isDeliveryEnabled != originalTruck.deliveryAvailable) {
      changedFields['delivery_available'] = isDeliveryEnabled ? '1' : '0';
    }
    if (modelController.text != originalTruck.model) {
      changedFields['model'] = modelController.text;
    }
    if (yearOfManufactureController.text != originalTruck.yearOfManufacture) {
      changedFields['year_of_manufacture'] = yearOfManufactureController.text;
    }
    if (pricePerDaycontroller.text != originalTruck.pricePerDay) {
      changedFields['price_per_day'] = pricePerDaycontroller.text;
    }
    if (pricePerHourcontroller.text != originalTruck.pricePerHour) {
      changedFields['price_per_hour'] = pricePerHourcontroller.text;
    }
    if (workStartTimeController.text != formatTime(times[0])) {
      changedFields['work_start_time'] = workStartTimeController.text;
    }
    if (workEndTimeController.text != formatTime(times[1])) {
      changedFields['work_end_time'] = workEndTimeController.text;
    }
    // التعامل مع الصور الجديدة:
    if (newTruckImages.isNotEmpty) {
      for (int i = 0; i < newTruckImages.length; i++) {
        changedFields['images[$i]'] = newTruckImages[i].path;
      }
    }

    // التعامل مع الفيديو الجديد:
    if (newTruckVideo != null) {
      changedFields['video'] = newTruckVideo!.path;
    }
    editededOriginalTruck = originalTruck.copyWith(
      name: nameController.text,
      features: featuresController.text,
      size: sizeController.text,
      model: modelController.text,
      yearOfManufacture: yearOfManufactureController.text,
      description: descriptionController.text,
      pricePerDay: pricePerDaycontroller.text,
      pricePerHour: pricePerHourcontroller.text,
      workHours:
          '${workStartTimeController.text} - ${workEndTimeController.text}',
      // pickupLocation: pickupLocation ?? this.pickupLocation,
      deliveryPrice: deliveryPriceController.text,
      deliveryAvailable: isDeliveryEnabled,
      // category: category ?? this.category,
      // subCategory: subCategory ?? this.subCategory,
      images: newTruckImages.isNotEmpty
          ? newTruckImages.map((e) => e.path).toList()
          : originalTruck.images,
      video: newTruckVideo?.path ?? originalTruck.video,
    );
    emit(EditTruckPriceState());
  }

  void setPhotoAndVideo() {
    emit(EditTruckPhotosState());
  }

  Future<void> pickTruckImages() async {
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        newTruckImages.clear();
        for (var pickedFile in pickedFiles) {
          newTruckImages.add(File(pickedFile.path));
        }
        if (newTruckImages.length >= 3) {
          emit(EditImagesPickedSuccessState(newTruckImages));
        } else {
          emit(EditImagesPickedErrorState("Please select at least 3 images."));
        }
      } else {
        emit(EditImagesPickedErrorState("No images selected."));
      }
    } catch (e) {
      emit(EditImagesPickedErrorState(e.toString()));
    }
  }

  Future<void> pickTruckVideo() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        newTruckVideo = File(pickedFile.path);
        emit(EditVideoPickedSuccessState(newTruckVideo!));
      } else {
        emit(EditVideoPickedErrorState("No video selected."));
      }
    } catch (e) {
      emit(EditVideoPickedErrorState(e.toString()));
    }
  }

  void toggleDelivery(bool value) {
    isDeliveryEnabled = value;

    if (!isDeliveryEnabled) {
      deliveryPriceController.text = '0';
      changedFields['delivery_price'] = '0';
      changedFields['delivery_available'] = '0';
    }

    emit(EditTruckDeliveryToggledState()); //
  }

  Future<void> submitTruck() async {
    emit(EditTruckSubmittingState());

    try {
      // 1. تنظيف الـ fields: تأكد أنك لا ترسل مسارات الملفات كـ Strings
      changedFields.removeWhere(
        (key, value) => key.startsWith('images[') || key == 'video',
      );

      // 2. استدعاء الخدمة بذكاء
      await TruckService().updateTruck(
        id: originalTruck.id,
        fields: changedFields,
        // نرسل الملفات فقط إذا كانت تحتوي على بيانات حقيقية من الـ Picker
        newImages: newTruckImages,
        newVideo: newTruckVideo,
      );

      emit(EditTruckSubmittingSuccessState());
    } catch (e) {
      emit(EditTruckSubmittingErrorState(e.toString()));
    }
  }

  Future<void> selectWorkStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final String hour = pickedTime.hour.toString().padLeft(2, '0');
      final String minute = pickedTime.minute.toString().padLeft(2, '0');

      final String formattedTime = "$hour:$minute";

      workStartTimeController.text = formattedTime;
      startHint = formattedTime;
      emit(EditStartTimePickedSuccessState(startHint));
    }
  }

  Future<void> selectWorkEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final String hour = pickedTime.hour.toString().padLeft(2, '0');
      final String minute = pickedTime.minute.toString().padLeft(2, '0');

      final String formattedTime = "$hour:$minute";

      workEndTimeController.text = formattedTime;
      endHint = formattedTime;

      emit(EditEndTimePickedSuccessState(endHint));
    }
  }

  String formatTime(String time) {
    // Splits "18:42:00" by ":" and takes the first two parts
    List<String> parts = time.split(':');
    return "${parts[0]}:${parts[1]}";
  }

  void onCategoryChanged(int? categoryId) {
    if (categoryId == null) return;
    
    selectedCategoryId = categoryId;
    selectedSubCategoryId = null; // تصفير الفرعي عند تغيير الرئيسي
    
    final category = categories.firstWhere((cat) => cat.id == categoryId);
    subCategories = category.subCategoryModel;

    // تسجيل التغيير لإرساله للسيرفر لاحقاً
    changedFields['category_id'] = categoryId.toString();
    
    emit(EditSubCategoryUpdatedState(subCategories));
  }

  void onSubCategoryChanged(int? subCategoryId) {
    if (subCategoryId == null) return;
    
    selectedSubCategoryId = subCategoryId;
    changedFields['sub_category_id'] = subCategoryId.toString();
    
    emit(EditSubCategorySelectedState(subCategoryId));
  }
}
