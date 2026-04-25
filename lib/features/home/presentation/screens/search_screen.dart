import 'package:bull_station/core/utils/widgets/custom_text_field.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late GoogleMapController mapController;
  final TextEditingController controller = TextEditingController();

  // إحداثيات مبدئية (يمكنكِ تعديلها لاحقاً لتكون موقع المستخدم)
  final LatLng _initialPosition = const LatLng(32.8872, 13.1913);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // جعل الـ AppBar شفافاً أو إزالته إذا كنتِ تفضلين أن تظهر الخريطة خلفه
      appBar: TopNavBar("البحث"),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            // استخدمنا Stack لنضع البحث فوق الخريطة
            children: [
              // 1. الخريطة (الطبقة السفلى وتأخذ كامل المساحة)
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 12,
                ),
                onMapCreated: (GoogleMapController webController) {
                  mapController = webController;
                },
                zoomControlsEnabled:
                    false, // إخفاء أزرار الزوم لجعل التصميم أنظف
                myLocationEnabled: true,
                myLocationButtonEnabled: false, // سنصنع زراً مخصصاً لاحقاً
              ),

              // 2. مربع البحث (الطبقة العليا)
              Positioned(
                top: 20.h,
                left: 20.w,
                right: 20.w,
                child: Container(
                  decoration: BoxDecoration(),
                  child: CustomTextField(
                    hint: "ابحث عن شاحنة...",
                    isSearch: true,
                    controller: controller,
                    validator: (_) => null,
                  ),
                ),
              ),

              // يمكنكِ هنا إضافة ويدجت TruckCardWidget لاحقاً بشكل أفقي في أسفل الشاشة
            ],
          ),
        ),
      ),
    );
  }
}
