import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/home/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryWidget({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w, top: 10.h, bottom: 10.h),
      child: Container(
        height: 105.h,
        width: 100.w,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: darkGrey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              categoryModel.icon,
              height: 38.h,
              width: 46.w,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 6.h),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: TxtStyle(
                  categoryModel.name,
                  11,
                  fontWeight: FontWeight.w500,
                  textAlignm: TextAlign.center,
                  longText: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
