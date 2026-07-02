import 'dart:async';

import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onNumberChanged;
  final FutureOr<String?> Function(PhoneNumber?)? validator;

  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.onNumberChanged,
    required this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 327.w,
      child: IntlPhoneField(
        textAlign: TextAlign.right,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(
            fontFamily: 'Changa',
            color: darkBlue,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),

          fillColor: Colors.white,
          filled: true,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: darkBlue),
          ),
          hintText: "رقم الهاتف",
          hintStyle: TextStyle(
            fontFamily: 'Changa',
            color: darkGrey,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
          errorStyle: TextStyle(
            height: 0,
            fontFamily: 'Changa',
            color: Colors.red,
            fontSize: 9.sp,
            fontWeight: FontWeight.bold,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
          errorBorder: OutlineInputBorder(
            gapPadding: 0,
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(5.r),
          ),
          enabledBorder: OutlineInputBorder(
            gapPadding: 0,
            borderSide: const BorderSide(color: darkGrey),
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),

        initialCountryCode: 'SA', // يمكنك تعيين رمز دولة افتراضي
        onChanged: (phone) {
          
          onNumberChanged("${phone.countryCode}${phone.number}");
          // onNumberChanged(phone.completeNumber);
                },
      ),
    );
  }
}
