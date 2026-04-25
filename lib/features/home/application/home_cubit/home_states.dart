import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:bull_station/features/truck/data/models/truck_details_model.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}
class UserLoadedState extends HomeStates {}
class HomeLoadingState extends HomeStates {}
class DetailsLoadingState extends HomeStates {}

class GetLatestTrucksSuccessState extends HomeStates {
  final List<TruckCardModel> trucks;

  GetLatestTrucksSuccessState({required this.trucks});
}

class GetMyTrucksSuccessState extends HomeStates {
  final List<TruckCardModel> trucks;

  GetMyTrucksSuccessState({required this.trucks});
}
class TruckDetailsSuccessState extends HomeStates {
  final TruckDetailsModel truckDetailsModel;

  TruckDetailsSuccessState({required this.truckDetailsModel});
}

class TruckActivated extends HomeStates {}

class TruckDeactivated extends HomeStates {}

class TruckDeleted extends HomeStates {}

class HomeErrorState extends HomeStates {
  final String message;

  HomeErrorState({required this.message});
}
