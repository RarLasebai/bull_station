import 'dart:async';
import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/features/home/application/category_cubit/category_state.dart';
import 'package:bull_station/features/home/data/services/map_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bull_station/core/utils/widgets/custom_text_field.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/home/application/category_cubit/category_cubit.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/application/map_cubit/map_cubit.dart';
import 'package:bull_station/features/home/application/map_cubit/map_states.dart';
import 'package:bull_station/features/home/presentation/screens/truck_details_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/category_bar_widget.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late GoogleMapController mapController;
  final TextEditingController controller = TextEditingController();
  final LatLng _initialPosition = const LatLng(24.7136, 46.6753);
  int? selectedCategoryId;
  Timer? _debounce;
  TruckCardModel? selectedTruck;

  // 1. متغيرات الفلاتر المتقدمة الجديدة
  String? selectedModel;
  int? selectedYear;
  double selectedRadius = 50.0;

  List<String> modelsList = []; // الموديلات ستُجلب ديناميكياً
  bool isLoadingFilters = true; // مؤشر تحميل خاص بالموديلات

  // توليد السنوات تلقائياً من 2026 نزولاً إلى 1990 (37 سنة)
  final List<int> yearsList = List.generate(37, (index) => 2026 - index);

  // 2. دالة الـ initState لجلب الموديلات بمجرد فتح الشاشة
  @override
  void initState() {
    super.initState();
    _extractModelsFromTrucks();
  }

  Future<void> _extractModelsFromTrucks() async {
    try {
      // جلب كل الشاحنات النشطة من السيرفس
      final List<TruckCardModel> trucks = await MapService().getActiveTrucks();
      print("عدد الشاحنات المسترجعة: ${trucks.length}");
      // استخراج الموديلات بدون تكرار وترتيبها أبجدياً
      final Set<String> uniqueModels = trucks
          .map((truck) => truck.model)
          .where((model) => model.isNotEmpty)
          .toSet();

      setState(() {
        modelsList = uniqueModels.toList()..sort();
        isLoadingFilters = false; // انتهاء تحميل الموديلات
        print("الموديلات المستخرجة: $modelsList");
      });
    } catch (e) {
      setState(() => isLoadingFilters = false);
      print("خطأ أثناء استخراج الموديلات: $e");
    }
  }

  // 3. دالة البحث النصي مع كافة الفلاتر
  onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<MapCubit>().loadTrucksOnMap(
        name: query,
        categoryId: selectedCategoryId,
        model: selectedModel,
        year: selectedYear,
        radius: selectedRadius,
      );
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar("البحث"),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            children: [
              // 1. الخريطة
              BlocBuilder<MapCubit, MapState>(
                builder: (context, state) {
                  Set<Marker> markers = {};
                  if (state is MapLoaded) {
                    markers = state.markers.map((marker) {
                      return marker.copyWith(
                        onTapParam: () {
                          setState(() {
                            selectedTruck = state.trucks.firstWhere(
                              (t) => t.id.toString() == marker.markerId.value,
                            );
                          });
                        },
                      );
                    }).toSet();
                  }

                  return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 12,
                    ),
                    markers: markers,
                    onMapCreated: (GoogleMapController webController) {
                      mapController = webController;
                      context.read<MapCubit>().loadTrucksOnMap();
                    },
                    onTap: (_) => setState(() => selectedTruck = null),
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                  );
                },
              ),

              // 2. مربع البحث
              // 2. مربع البحث مع أيقونة التصفية
              Positioned(
                top: 20.h,
                left: 20.w,
                right: 20.w,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hint: "ابحث عن شاحنة...",
                        isSearch: true,
                        controller: controller,
                        onChanged: (value) => onSearchChanged(value),
                        validator: (_) => null,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // زر الفلتر المتقدم
                    GestureDetector(
                      onTap: () => _showFilterBottomSheet(context),
                      child: Container(
                        height:
                            50.h, // تأكدي من مطابقة ارتفاع الـ TextField عندكِ
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: lightRed, // أو اللون الأساسي للتطبيق
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. شريط التصنيفات (Category Bar)
              Positioned(
                top: 90.h,
                left: 0,
                right: 0,
                child: BlocBuilder<CategoryCubit, CategoryStates>(
                  builder: (context, state) {
                    if (state is GetCategorySuccessState) {
                      return buildCategoryBar(
                        categories: state.categories,
                        selectedId: selectedCategoryId,
                        onCategorySelected: (id) {
                          setState(() => selectedCategoryId = id);
                          context.read<MapCubit>().loadTrucksOnMap(
                            categoryId: id,
                            name: controller.text,
                            model: selectedModel,
                            year: selectedYear,
                            radius: selectedRadius,
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              // 4. كارت تفاصيل الشاحنة عند الضغط على ماركر
              if (selectedTruck != null)
                Positioned(
                  bottom: 30.h,
                  left: 20.w,
                  right: 20.w,
                  child: GestureDetector(
                    onTap: () {
                      final homeCubit = BlocProvider.of<HomeCubit>(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: homeCubit,
                            child: TruckDetailsScreen(
                              id: selectedTruck!.id,
                              homeCubit: homeCubit,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.network(
                              selectedTruck!.mainImage,
                              width: 80.w,
                              height: 80.w,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.car_crash),
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TxtStyle(
                                  selectedTruck!.name,
                                  14,
                                  fontWeight: FontWeight.bold,
                                ),
                                TxtStyle(
                                  selectedTruck!.category,
                                  13,
                                  color: Colors.grey,
                                ),
                                TxtStyle(
                                  "${selectedTruck!.pricePerDay} \$ / لليوم",
                                  14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 18.sp,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return StatefulBuilder(
          // لاستخدام setState داخل الـ BottomSheet نفسه
          builder: (context, setModalState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 20.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TxtStyle(
                      "تصفية البحث المتقدم",
                      18,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 20.h),

                    // 1. فلتر الموديل (Dropdown)
                    TxtStyle("الموديل", 14, fontWeight: FontWeight.w600),
                    DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text("اختر الموديل"),
                      value: selectedModel,
                      items: modelsList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() => selectedModel = value);
                      },
                    ),
                    SizedBox(height: 15.h),

                    // 2. فلتر سنة الصنع (Dropdown)
                    TxtStyle("سنة الصنع", 14, fontWeight: FontWeight.w600),
                    DropdownButton<int>(
                      isExpanded: true,
                      hint: const Text("اختر السنة"),
                      value: selectedYear,
                      items: yearsList.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setModalState(() => selectedYear = value);
                      },
                    ),
                    SizedBox(height: 15.h),

                    // 3. فلتر المسافة المحيطة (Slider)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TxtStyle(
                          "المسافة المحيطة (نطاق البحث)",
                          14,
                          fontWeight: FontWeight.w600,
                        ),
                        TxtStyle(
                          "${selectedRadius.toInt()} كم",
                          14,
                          color: lightRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    Slider(
                      value: selectedRadius,
                      min: 5.0,
                      max: 200.0,
                      divisions: 39,
                      activeColor: lightRed,
                      onChanged: (value) {
                        setModalState(() => selectedRadius = value);
                      },
                    ),
                    SizedBox(height: 25.h),

                    // أزرار التحكم
                    Row(
                      children: [
                        // زر مسح الفلاتر
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedModel = null;
                                selectedYear = null;
                                selectedRadius = 50.0;
                              });
                              Navigator.pop(bottomSheetContext);
                              // إعادة تحميل الخريطة بدون فلاتر متقدمة
                              context.read<MapCubit>().loadTrucksOnMap(
                                categoryId: selectedCategoryId,
                                name: controller.text,
                              );
                            },
                            child: const Text("مسح الكل"),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        // زر تطبيق الفلتر
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: lightRed,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(bottomSheetContext);
                              // استدعاء الكيوبيت وتمرير كل القيم المحددة للباك إند
                              context.read<MapCubit>().loadTrucksOnMap(
                                categoryId: selectedCategoryId,
                                name: controller.text,
                                model: selectedModel,
                                year: selectedYear,
                                radius: selectedRadius,
                                // إذا رغبتِ في تمرير موقع الخريطة الحالي لربطه بالمسافة:
                                lat: _initialPosition.latitude,
                                lng: _initialPosition.longitude,
                              );
                            },
                            child: const Text("تطبيق الفلتر"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
