import 'dart:ui' as ui;
import 'package:bull_station/features/home/application/map_cubit/map_states.dart';
import 'package:bull_station/features/home/data/services/map_service.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapInitial());

  // داخل MapCubit
void loadTrucksOnMap({
    int? categoryId, 
    double? radius,
    String? name,
    String? model,
    int? year,
    double? lat,
    double? lng,
  }) async {
  emit(MapLoading());
  try {
   final trucks = await MapService().getSearchTrucks(
        categoryId: categoryId, 
        radius: radius,
        name: name,
        model: model,
        year: year,
        lat: lat,
        lng: lng,
      );   
    // 1. إظهار الماركرز الحمراء فوراً (لضمان تجربة مستخدم سريعة)
    Set<Marker> initialMarkers = _convertToMarkers(trucks);
    emit(MapLoaded(initialMarkers, trucks));

    // 2. تحميل الأيقونات المخصصة
    final List<Marker> customMarkersList = await Future.wait(
      trucks.map((truck) async {
        BitmapDescriptor icon = BitmapDescriptor.defaultMarker;
        if (truck.mapIconUrl != null && truck.mapIconUrl!.isNotEmpty) {
          icon = await getMarkerIcon(truck.mapIconUrl!);
        }
        
        return Marker(
          markerId: MarkerId(truck.id.toString()),
          position: LatLng(truck.latitude ?? 0.0, truck.longitude ?? 0.0),
          icon: icon,
        );
      }),
    );

    emit(MapLoaded(customMarkersList.toSet(), trucks));
    
  } catch (e) {
    print("Map Error: $e"); 
    emit(MapError("فشل تحميل البيانات على الخريطة"));
  }
}
  Set<Marker> _convertToMarkers(List<TruckCardModel> trucks,{BitmapDescriptor? customIcon}) {
  return trucks.map((t) {
    return Marker(
      markerId: MarkerId(t.id.toString()),
      icon: customIcon ?? BitmapDescriptor.defaultMarker,
      position: LatLng(t.latitude!, t.longitude!),
      onTap: () {
      },
    );
  }).toSet();
}
Future<BitmapDescriptor> getMarkerIcon(String url) async {
  try {
    // 1. تحميل الصورة من الرابط
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // 2. تقليل حجم الصورة لتناسب الخريطة (مثلاً 100x100 بكسل)
      ui.Codec codec = await ui.instantiateImageCodec(
        response.bodyBytes, 
        targetWidth: 120.w.toInt(), // عرض الأيقونة
      );
      ui.FrameInfo fi = await codec.getNextFrame();
      final byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
      return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
    }
  } catch (e) {
    print("خطأ في تحميل أيقونة الماركر: $e");
  }
  // في حال فشل التحميل، نعود للماركر الأحمر الافتراضي
  return BitmapDescriptor.defaultMarker;
}
  // Set<Marker> _convertToMarkers(List<TruckCardModel> trucks) {
  //   return trucks.map((t) {
  //     return Marker(
  //       markerId: MarkerId(t.id.toString()),
  //       position: LatLng(t.latitude!, t.longitude!), // الإحداثيات الحقيقية من الموديل المعدل
  //       infoWindow: InfoWindow(
  //         title: t.model,
  //         snippet: "${t.pricePerDay} ريال",
  //       ),
  //     );
  //   }).toSet();
  // }
}