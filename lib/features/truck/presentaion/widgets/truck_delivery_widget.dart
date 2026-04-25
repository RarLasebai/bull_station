import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/booking/presentaion/widgets/booking_info_widget.dart';
import 'package:bull_station/features/truck/presentaion/screens/location_picker_screen.dart';
import 'package:bull_station/features/truck/presentaion/widgets/custom_form_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class TruckDeliveryWidget extends StatelessWidget {
  final TextEditingController deliveryPriceController;
  final TextEditingController pickupLocationController;
  final Function(double lat, double lng)? onLocationPicked;
  final void Function(bool?)? onChanged;
  final bool isDeliveryEnabled;
  double? latitude;
  double? longitude;
  TruckDeliveryWidget({
    super.key,
    required this.deliveryPriceController,
    required this.isDeliveryEnabled,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.onChanged,
    required this.pickupLocationController,
    this.onLocationPicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370.w,
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: darkGrey),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTextWidget(
                text: "الاستلام والتوصيل",
                icon: Icons.location_on_outlined,
                size: 14,
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () async {
                  final LatLng? result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationPickerScreen(),
                    ),
                  );

                  if (result != null) {
                    print(
                      "الموقع المختار: ${result.latitude}, ${result.longitude}",
                    );
                    if (onLocationPicked != null) {
                      onLocationPicked!(result.latitude, result.longitude);
                    }
                    latitude = result.latitude;
                    longitude = result.longitude;
                  }
                },
                child: BookingInfoWidget(
                  title: "مكان المعدة",
                  info: latitude != 0.0 && longitude != 0.0
                      ? "تم تحديد الموقع بنجاح ✅"
                      : "حدد الموقع على الخريطة",
                  color: latitude != 0.0 && longitude != 0.0
                      ? Colors
                            .green 
                      : darkGrey,
                ),
              ),
              // TxtStyle("اسم المعدة", 13, fontWeight: FontWeight.bold),
              SizedBox(
                height: 45.h,
                width: 250.w,
                child: CustomFormTextField(
                  hint: "عنوان المكان",
                  controller: pickupLocationController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "من فضلك لا تترك الحقل فارغاً";
                    } else {
                      return null;
                    }
                  },
                ),
              ),

              Row(
                children: [
                  Checkbox(value: isDeliveryEnabled, onChanged: onChanged),
                  // SizedBox(width: 5.w),
                  TxtStyle(
                    "توصيل لمكان الزبون؟ حدد سعر التوصيل",
                    12,
                    longText: true,
                  ),
                ],
              ),
              SizedBox(
                height: 45.h,
                child: CustomFormTextField(
                  hint: "",
                  controller: deliveryPriceController,
                  isNumbers: true,
                  isLocation:
                      !isDeliveryEnabled, //to enable the field depending on the check box,
                  validator: (value) {
                    if (!isDeliveryEnabled && value == null) {
                      return "الحقل مطلوب!";
                    } else {
                      return null;
                    }
                  },
                  width: 90,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
