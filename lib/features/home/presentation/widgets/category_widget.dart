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
      padding: const EdgeInsets.only(right: 10, top: 20, bottom: 20),
      child: Container(
        height: 72.h,
        width: 72.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: darkGrey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(categoryModel.icon, height: 30.h, width: 38.w),
            SizedBox(height: 8.h),
            TxtStyle(
              categoryModel.name,
              8,
              fontWeight: FontWeight.w500,
              textAlignm: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
