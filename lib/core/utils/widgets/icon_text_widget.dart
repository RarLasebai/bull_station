import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconTextWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final double size;
  final Color color;
  final bool isBooking;
  const IconTextWidget({
    super.key,
    required this.text,
    this.icon = Icons.location_on_outlined,
    this.size = 10,
    this.color = Colors.black,
    this.isBooking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isBooking ? SizedBox(width: 5.w) : SizedBox(),
        Icon(
          icon,
          color: isBooking ? primary : color,
          size: isBooking ? 15 : size,
        ),
        SizedBox(width: 5),
        TxtStyle(text, size, color: color),
      ],
    );
  }
}
