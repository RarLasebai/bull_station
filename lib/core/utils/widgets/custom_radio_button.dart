// ignore_for_file: deprecated_member_use

import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final dynamic groupValue;
  final String value;

  final String title;
  final void Function(Object?)? onChanged;
  const CustomRadioButton({
    super.key,
        required this.value, 

    required this.groupValue,
    required this.title,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      activeColor: darkBlue,
      toggleable: true,
      title: TxtStyle(
        title,
        12,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    );
  }
}
