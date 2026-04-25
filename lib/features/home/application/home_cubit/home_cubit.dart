import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/features/auth/data/models/user_model.dart';
import 'package:bull_station/features/home/application/home_cubit/home_states.dart';
import 'package:bull_station/features/home/data/services/home_services.dart';
import 'package:bull_station/features/profile/service/profile_service.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:bull_station/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

UserModel? currentUser; // متغير عادي (ليس Future)

Future<void> initUser() async {
  // نستخدم await هنا مرة واحدة فقط عند التشغيل
  currentUser = await getDataFromSharedPref(); 
  String? fcmToken = await NotificationHelper().getToken();
  if (fcmToken != null) {
    await ProfileService().updateFCMToken(fcmToken: fcmToken);
  }
  emit(UserLoadedState());
}
  Future<List<TruckCardModel>> getAllTrucks() async {
    try {
      emit(HomeLoadingState());
      final trucks = await HomeServices().getAllTrucks();
      emit(GetLatestTrucksSuccessState(trucks: trucks));
      return trucks;
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
      throw Exception(e.toString());
    }
  }

  Future<List<TruckCardModel>> getMyTrucks() async {
    try {
      emit(HomeLoadingState());
      final trucks = await HomeServices().getMyTrucks();
      emit(GetMyTrucksSuccessState(trucks: trucks));
      return trucks;
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
      throw Exception(e.toString());
    }
  }

  Future getTruckDetails(int id) async {
    try {
      emit(DetailsLoadingState());
      final trucks = await HomeServices().getTruckDetails(id);
      emit(TruckDetailsSuccessState(truckDetailsModel: trucks));
      return trucks;
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
      throw Exception(e.toString());
    }
  }

  Future activateTruck(bool activate, int id) async {
    try {
      emit(DetailsLoadingState());
      final msg = await HomeServices().activateTruck(activate, id);
      activate ? emit(TruckActivated()) : emit(TruckDeactivated());
      return msg;
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
      throw Exception(e.toString());
    }
  }

  Future deleteTruck(int id) async {
    try {
      emit(DetailsLoadingState());
      final msg = await HomeServices().deleteTruck(id);
      emit(TruckDeleted());
      return msg;
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
      throw Exception(e.toString());
    }
  }
}
