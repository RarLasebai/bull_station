import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/home/presentation/widgets/filter_widget.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TruckCardWidget extends StatelessWidget {
  final TruckCardModel truckCardModel;
  const TruckCardWidget({super.key, required this.truckCardModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        // height: 100.h,
        width: 370.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: darkGrey),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 71.h,
                  width: 79.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5.r),
                    ),
                  ),
                  child: Image.network(
                    truckCardModel.mainImage,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TxtStyle(
                      truckCardModel.name.toString(),
                      11,
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: darkGrey,
                          size: 10,
                        ),
                        // TxtStyle(truckCardModel.location, 10),
                        TxtStyle(truckCardModel.pickupLocation.toString(), 10),
                      ],
                    ),
                    TxtStyle("${truckCardModel.pricePerDay}\$ / لليوم", 10),
                  ],
                ),
              ],
            ),
            FilterWidget(title: truckCardModel.subCategory),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }
}
