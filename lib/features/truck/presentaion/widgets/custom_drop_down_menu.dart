import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropDownMenu extends StatelessWidget {
  // We receive the dynamic list and the selection handler
  final List<dynamic> items;
  final int? initialValue;
  final String hint;
  final Function(int?) onSelected;

  const CustomDropDownMenu({
    super.key,
    required this.items,
    required this.onSelected,
    required this.hint,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownMenu<int>(
        // Mapping the dynamic items to DropdownMenuEntry
        dropdownMenuEntries: items.map((item) {
          return DropdownMenuEntry<int>(
            value: item.id,
            label: item.name,
            style: MenuItemButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
          );
        }).toList(),
        textStyle: TextStyle(
          fontFamily: 'Changa',
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
        // Settings
        initialSelection: initialValue,
        hintText: hint,
        onSelected: onSelected,
        width: 365.w,
        selectedTrailingIcon: const Icon(Icons.keyboard_arrow_up_outlined),
        trailingIcon: const Icon(Icons.keyboard_arrow_down_outlined),

        // Your exact requested styling
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            fontFamily: 'Changa',
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
          hintStyle: TextStyle(
            fontFamily: 'Changa',
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
          filled: true,
          fillColor: softGrey,
          constraints: BoxConstraints.tightFor(height: 55.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(softGrey),
          maximumSize: WidgetStateProperty.all(Size(365.w, 200.h)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
          ),
        ),
      ),
    );
  }
}
