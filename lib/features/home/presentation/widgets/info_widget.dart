import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/truck/data/models/truck_owner_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoWidget extends StatelessWidget {
  final String title;
  final String? desc;
  final bool isSpecifications, isDriverData;
  final String? year;
  final String? model;
  final String? size;
  final TruckOwnerModel? truckOwnerModel;
  const InfoWidget(
    this.title, {
    super.key,
    this.isSpecifications = false,
    this.isDriverData = false,
    this.model,
    this.size,
    this.year,
    this.desc, this.truckOwnerModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TxtStyle(title, 16, fontWeight: FontWeight.bold),
        !isSpecifications && !isDriverData
            ? TxtStyle(
                desc!,
                12,
                fontWeight: FontWeight.w700,
                color: darkGrey,
                isDescribtion: true,
                longText: true,
              )
            : isDriverData
            ? Row(
                children: [
                  CircleAvatar(radius: 25, child: Icon(Icons.person)),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconTextWidget(
                        text: truckOwnerModel!.name,
                        icon: Icons.person,
                        color: Colors.black,
                        size: 14,
                      ),
                      IconTextWidget(
                        text: truckOwnerModel!.phone,
                        icon: Icons.phone,
                        color: Colors.black,
                        size: 14,
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          TxtStyle("السنة", 12),
                          TxtStyle(year!, 12, color: darkGrey),
                        ],
                      ),
                      SizedBox(width: 170.w),

                      Column(
                        children: [
                          TxtStyle("الموديل", 12),
                          TxtStyle(model!, 12, color: darkGrey),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TxtStyle("الحجم", 12),
                      TxtStyle(size!, 12, color: darkGrey),
                    ],
                  ),
                ],
              ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
