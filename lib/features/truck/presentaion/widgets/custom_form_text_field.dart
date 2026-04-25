import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFormTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final int width;
  final bool isNumbers,
      isPhone,
      isPass,
      
      isPassField,
      isDesc,
      isPrice,
      isSearch,
      isYear,
      isLocation;
  final VoidCallback? onTap;
  // final VoidCallback? onChanged;
  final void Function()? suffixOnTap;
  final void Function(String)? onChanged;

  final IconData suffixIcon;

  final FormFieldValidator<String> validator;

  const CustomFormTextField({
    required this.hint,
    required this.controller,
    required this.validator,
    this.suffixIcon = Icons.visibility_outlined,
    this.suffixOnTap,
    this.isYear = false,
    this.isNumbers = false,
    this.isPass = false,
    this.isPassField = false,
    this.isDesc = false,
    this.isPhone = false,
    this.isSearch = false,
    this.isPrice = false,
    this.isLocation = false,
    this.onTap,
    this.onChanged,
    this.width = 365,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: SizedBox(
          width: width.w,
          child: TextFormField(
            onChanged: onChanged,
            readOnly: isLocation,
            maxLines: isDesc == true ? 5 : 1,
            obscureText: isPass,
            keyboardType: isNumbers == true || isPrice == true
                ? TextInputType.number
                : TextInputType.text,
            inputFormatters: isPhone == true
                ? [LengthLimitingTextInputFormatter(8)]
                : isYear ? 
                [ LengthLimitingTextInputFormatter(4), // Limits to 10 characters
    FilteringTextInputFormatter.digitsOnly] : null,
            validator: validator,
            controller: controller,
            cursorColor: primary,
            style: TextStyle(
              fontFamily: 'Changa',
              color: Colors.black,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
            ),

            decoration: InputDecoration(
              enabled: isLocation ? false : true,
              prefixIcon: isSearch
                  ? IconButton(
                      onPressed: suffixOnTap,
                      icon: Icon(Icons.search, color: darkGrey),
                    )
                  : null,
              suffixIcon: isPhone
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: TxtStyle("09 218+", 13),
                    )
                  : isPassField
                  ? IconButton(
                      onPressed: suffixOnTap,
                      icon: Icon(suffixIcon, color: darkGrey),
                    )
                  : null,
              fillColor: softGrey,
              filled: true,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: const BorderSide(color: primary),
              ),
              hintText: hint,
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
                borderSide: const BorderSide(color: softGrey),
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
