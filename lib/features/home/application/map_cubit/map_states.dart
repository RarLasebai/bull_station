import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState {}

class MapInitial extends MapState {}
class MapLoading extends MapState {}
class MapLoaded extends MapState {
  final Set<Marker> markers;
final List<TruckCardModel> trucks; 
  MapLoaded(this.markers, this.trucks);}
class MapError extends MapState {
  final String message;
  MapError(this.message);
}