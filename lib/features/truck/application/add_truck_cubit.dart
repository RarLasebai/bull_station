// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bull_station/features/home/data/models/category_model.dart';
import 'package:bull_station/features/home/data/models/sub_category_model.dart';
import 'package:bull_station/features/truck/data/models/add_truck_model.dart';
import 'package:bull_station/features/truck/data/services/truck_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bull_station/features/truck/application/add_truck_states.dart';
import 'package:image_picker/image_picker.dart';

class AddTruckCubit extends Cubit<AddTruckStates> {
  AddTruckCubit(List<CategoryModel> initialCategories)
    : super(TruckInitialState()) {
    categories = initialCategories;
  }

  static AddTruckCubit get(BuildContext context) => BlocProvider.of(context);

  TextEditingController yearOfManufactureController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController featuresController = TextEditingController();
  TextEditingController pricePerDaycontroller = TextEditingController();
  TextEditingController pricePerHourcontroller = TextEditingController();
  TextEditingController workStartTimeController = TextEditingController();
  TextEditingController workEndTimeController = TextEditingController();
  TextEditingController deliveryPriceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController pickupLocationController = TextEditingController();
  double latitude = 0.0;
  double longitude = 0.0;
  GlobalKey<FormState> basicInfoFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> costFormKey = GlobalKey<FormState>();
  List<File> truckImages = [];
  File? truckVideo;
  bool isDeliveryEnabled = false;
  TruckModel? _truckModel;
  String startHint = "00:00";
  String endHint = "00:00";

  //what if they are meeting now? he iss kin
  void setBasicInfo() {
    _truckModel ??= TruckModel.initial();
    final updatedModel = _truckModel!.copyWith(
      categoryId: selectedCategoryId!,
      subCategoryId: selectedSubCategoryId!,
      name: nameController.text,
      yearOfManufacture: int.parse(yearOfManufactureController.text),
      size: sizeController.text,
      model: modelController.text,
      features: featuresController.text,
      description: descriptionController.text,
    );
    _truckModel = updatedModel;
    emit(TruckBasicInfoState(updatedModel));
  }

  void addPhotos() {
    List<String> truckImagePaths = truckImages
        .map((file) => file.path)
        .toList();
    String videoPath = truckVideo!.path;
    final updatedModel = _truckModel!.copyWith(
      images: truckImagePaths,
      video: videoPath,
    );
    _truckModel = updatedModel;
    emit(TruckPhotosState(updatedModel));
  }

  void setPricing() {
    final updatedModel = _truckModel!.copyWith(
      pricePerDay: double.parse(pricePerDaycontroller.text),
      pricePerHour: double.parse(pricePerHourcontroller.text),
      workStartTime: workStartTimeController.text,
      // workStartTime: "12:12",
      workEndTime: workEndTimeController.text,
      // workEndTime: "12:12",
      pickupLocation: pickupLocationController.text,
      latitude: latitude,
      longitude: longitude,
      deliveryAvailable: isDeliveryEnabled ? true : false,
      deliveryPrice: deliveryPriceController.text.isEmpty
          ? 0.0
          : double.parse(deliveryPriceController.text),
    );
    _truckModel = updatedModel;

    emit(TruckPricingState(updatedModel));
  }

  void toggleDelivery(bool value) {
    isDeliveryEnabled = value;
    emit(TruckDeliveryAvailableToggled());
  }

  Future<void> pickTruckImages() async {
    try {
      emit(ImagePickingLoadingState());

      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        truckImages.clear();
        for (var pickedFile in pickedFiles) {
          truckImages.add(File(pickedFile.path));
        }

        // Check if at least 3 images were selected
        if (truckImages.length >= 3) {
          emit(ImagesPickedSuccessState(truckImages));
        } else {
          // If fewer than 3 images are selected, you can emit an error state
          emit(ImagesPickedErrorState("Please select at least 3 images."));
        }
      } else {
        // No images were selected
        emit(ImagePickedErrorState("No images selected."));
      }
    } catch (e) {
      // Handle potential errors, like a user canceling the action or a plugin error
      emit(ImagePickedErrorState(e.toString()));
    }
  }

  Future<void> pickTruckVideo() async {
    try {
      emit(ImagePickingLoadingState());
      final picker = ImagePicker();
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

      if (pickedFile != null) {
        truckVideo = File(pickedFile.path);
        emit(VideoPickedSuccessState(truckVideo!));
      } else {
        emit(VideoPickedErrorState("No video selected."));
      }
    } catch (e) {
      emit(VideoPickedErrorState(e.toString()));
    }
  }

  Future<void> submitForm() async {
    try {
      emit(TruckLoadingState(state.truckModel!));

      // Access the complete form data from the current state
      final completedTruckData = state.truckModel;
      _truckModel;

      // Example:
      final response = await TruckService().submitTruck(
        truckModel: completedTruckData!,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(TruckSuccessState(completedTruckData));
      } else {
        emit(TruckErrorState(completedTruckData, 'Failed to submit form.'));
      }
    } catch (e) {
      emit(TruckErrorState(state.truckModel!, e.toString()));
    }
  }

  Future<void> selectWorkStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // استخدام padLeft لضمان وجود الصفر على اليسار إذا كان الرقم أقل من 10
      final String hour = pickedTime.hour.toString().padLeft(2, '0');
      final String minute = pickedTime.minute.toString().padLeft(2, '0');

      startHint = "$hour:$minute";
      workStartTimeController.text = startHint;
      emit(StartTimePickedSuccessState(startHint));
    }
  }

  Future<void> selectWorkEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // نفس التعديل لضمان تنسيق H:i
      final String hour = pickedTime.hour.toString().padLeft(2, '0');
      final String minute = pickedTime.minute.toString().padLeft(2, '0');

      endHint = "$hour:$minute";
      workEndTimeController.text = endHint;
      emit(EndTimePickedSuccessState(endHint));
    }
  }

  //Category and Subcategory Selection
  // Inside AddTruckCubit class

  List<CategoryModel> categories = [];
  List<SubCategoryModel> subCategories = [];

  int? selectedCategoryId;
  int? selectedSubCategoryId;

  // Update subcategories based on category selection
  void onCategoryChanged(int? categoryId) {
    selectedCategoryId = categoryId;
    selectedSubCategoryId = null; // Reset subcategory when category changes

    // Find the subcategories for the selected category
    final category = categories.firstWhere((cat) => cat.id == categoryId);
    subCategories = category
        .subCategoryModel; // Assuming CategoryModel has a subCategories list

    emit(SubCategoryUpdatedState(subCategories));
  }

  void onSubCategoryChanged(int? subCategoryId) {
    selectedSubCategoryId = subCategoryId;
    emit(SubCategorySelectedState(subCategoryId!));
  }
  void updateLocation(double lat, double lng) {
  latitude = lat;
  longitude = lng;
  emit(LocationUpdatedState()); // حالة جديدة لإعادة بناء الواجهة
}
}
