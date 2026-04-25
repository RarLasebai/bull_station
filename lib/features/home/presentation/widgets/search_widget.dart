// ignore_for_file: deprecated_member_use

import 'package:bull_station/features/home/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 6,
            offset: Offset(0, 5), 
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: TextField(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        ),
        readOnly: true,
        decoration: InputDecoration(
          hintText: "البحث",
          prefixIcon: Icon(Icons.search),
          suffixIcon: Icon(Icons.arrow_forward_ios, size: 16),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 20.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
