import 'dart:io';

import 'package:bull_station/features/home/data/models/category_model.dart';
import 'package:bull_station/features/home/data/models/sub_category_model.dart';
import 'package:bull_station/features/truck/data/models/add_truck_model.dart';

abstract class AddTruckStates {
  final TruckModel? truckModel;

  const AddTruckStates({this.truckModel});
}

class TruckInitialState extends AddTruckStates {
  TruckInitialState()
    : super(
        truckModel: TruckModel(
          name: "",
          categoryId: 1,
          subCategoryId: 1,
          yearOfManufacture: 1,
          size: '',
          model: '',
          description: '',
          pricePerDay: 1,
          pricePerHour: 1,
          workStartTime: '',
          workEndTime: '',
          pickupLocation: '',
          deliveryAvailable: true,
          features: '',
          latitude: 0.0,
          longitude: 0.0,
        ),
      );
}

class TruckBasicInfoState extends AddTruckStates {
  const TruckBasicInfoState(TruckModel truckModel)
    : super(truckModel: truckModel);
}

class TruckPhotosState extends AddTruckStates {
  const TruckPhotosState(TruckModel truckModel) : super(truckModel: truckModel);
}

class TruckPricingState extends AddTruckStates {
  const TruckPricingState(TruckModel truckModel)
    : super(truckModel: truckModel);
}

class TruckDeliveryAvailableToggled extends AddTruckStates {}

class TruckLoadingState extends AddTruckStates {
  const TruckLoadingState(TruckModel truckModel)
    : super(truckModel: truckModel);
}

class TruckSuccessState extends AddTruckStates {
  const TruckSuccessState(TruckModel truckModel)
    : super(truckModel: truckModel);
}

class ImagePickingLoadingState extends AddTruckStates {
  const ImagePickingLoadingState() : super();
}

class ImagesPickedSuccessState extends AddTruckStates {
  final List<File> truckImages;
  const ImagesPickedSuccessState(this.truckImages) : super();
}

class ImagesPickedErrorState extends AddTruckStates {
  final String message;
  const ImagesPickedErrorState(this.message) : super();
}

class ImagePickedErrorState extends AddTruckStates {
  final String message;
  const ImagePickedErrorState(this.message) : super();
}

class VideoPickingLoadingState extends AddTruckStates {
  const VideoPickingLoadingState() : super();
}

class VideoPickedSuccessState extends AddTruckStates {
  final File truckVideo;
  const VideoPickedSuccessState(this.truckVideo) : super();
}

class VideoPickedErrorState extends AddTruckStates {
  final String message;
  const VideoPickedErrorState(this.message) : super();
}

class StartTimePickedSuccessState extends AddTruckStates {
  final String pickeTime;
  const StartTimePickedSuccessState(this.pickeTime) : super();
}

class EndTimePickedSuccessState extends AddTruckStates {
  final String pickeTime;
  const EndTimePickedSuccessState(this.pickeTime) : super();
}

class TruckErrorState extends AddTruckStates {
  final String error;
  const TruckErrorState(TruckModel truckModel, this.error)
    : super(truckModel: truckModel);
}

class AddTruckCategoryLoadingState extends AddTruckStates {}

class AddTruckCategoryLoadedSuccessState extends AddTruckStates {
  final List<CategoryModel> categories;
  AddTruckCategoryLoadedSuccessState(this.categories);
}

class SubCategoryUpdatedState extends AddTruckStates {
  final List<SubCategoryModel> subCategories;
  // Passing the list helps the UI rebuild the second dropdown
  SubCategoryUpdatedState(this.subCategories);
}

class LocationUpdatedState extends AddTruckStates {}
class SubCategorySelectedState extends AddTruckStates {
  final int subCategoryId;
  SubCategorySelectedState(this.subCategoryId);
}
