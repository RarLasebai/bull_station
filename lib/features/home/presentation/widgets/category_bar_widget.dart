import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildCategoryBar({
  required List<dynamic> categories,
  required int? selectedId,
  required Function(int?) onCategorySelected,
}) {
  return SizedBox(
    height: 45.h,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length + 1,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildCategoryItem(
            title: "الكل",
            isSelected: selectedId == null,
            onTap: () => onCategorySelected(null),
          );
        }

        final cat = categories[index - 1];
        return _buildCategoryItem(
          title: cat.name,
          isSelected: selectedId == cat.id,
          onTap: () => onCategorySelected(cat.id),
        );
      },
    ),
  );
}

Widget _buildCategoryItem({
  required String title,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.only(left: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        // اللون يتغير هنا بناءً على الاختيار
        color: isSelected ? lightRed : Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey.shade300,
        ),
      ),
      child: Center(
        child: TxtStyle(
          title,
          13,
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
