
import 'package:bull_station/features/home/application/map_cubit/map_states.dart';
import 'package:bull_station/features/home/data/services/map_service.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapCubit extends Cubit<MapState> {

  MapCubit() : super(MapInitial());

  void loadActiveTrucks() async {
    emit(MapLoading());
    try {
      final trucks = await MapService().getActiveTrucks();
      final markers = _convertToMarkers(trucks);
      emit(MapLoaded(markers));
    } catch (e) {
      emit(MapError("فشل تحميل الشاحنات"));
    }
  }

  Set<Marker> _convertToMarkers(List<TruckCardModel> trucks) {
    // منطق تحويل بيانات الباك إند إلى ماركرز لجوجل
    return trucks.map((t) {
      double lat = 0.0;
      double lng =0.0;
      return Marker(markerId: MarkerId(t.id.toString()), position: LatLng(lat, lng));
    }).toSet();
  }
}