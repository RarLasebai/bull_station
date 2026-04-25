import 'dart:io';

import 'package:bull_station/features/home/data/models/sub_category_model.dart';

abstract class EditTruckStates {}

class EditTruckInitialState extends EditTruckStates {}

class EditTruckBasicInfoState extends EditTruckStates {}

class EditTruckPriceState extends EditTruckStates {}

class EditTruckDeliveryToggledState extends EditTruckStates {}

class EditImagesPickedSuccessState extends EditTruckStates {
  final List<File> newImages;
  EditImagesPickedSuccessState(this.newImages);
}

class EditImagesPickedErrorState extends EditTruckStates {
  final String message;
  EditImagesPickedErrorState(this.message);
}

class EditVideoPickedSuccessState extends EditTruckStates {
  final File newVideo;
  EditVideoPickedSuccessState(this.newVideo);
}

class EditVideoPickedErrorState extends EditTruckStates {
  final String message;
  EditVideoPickedErrorState(this.message);
}

class EditTruckPhotosState extends EditTruckStates {}

class EditTruckSubmittingState extends EditTruckStates {}

class EditTruckSubmittingSuccessState extends EditTruckStates {}

class EditTruckSubmittingErrorState extends EditTruckStates {
  final String message;
  EditTruckSubmittingErrorState(this.message);
}

class EditStartTimePickedSuccessState extends EditTruckStates {
  final String pickeTime;
  EditStartTimePickedSuccessState(this.pickeTime);
}

class EditEndTimePickedSuccessState extends EditTruckStates {
  final String pickeTime;
  EditEndTimePickedSuccessState(this.pickeTime);
}

class EditTruckSubCategoryUpdatedState extends EditTruckStates {
  EditTruckSubCategoryUpdatedState();
}

class EditSubCategoryUpdatedState extends EditTruckStates {
  final List<SubCategoryModel> subCategories;
  EditSubCategoryUpdatedState(this.subCategories);
}

class EditSubCategorySelectedState extends EditTruckStates {
  final int subCategoryId;
  EditSubCategorySelectedState(this.subCategoryId);
}