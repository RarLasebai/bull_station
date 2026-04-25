import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'txt_style.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const TopNavBar(this.title, {super.key, this.actions, this.leading});

  @override
  Size get preferredSize => const Size.fromHeight(75 + 1.0); // kToolbarHeight is the default AppBar height

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          AppBar(
            title: TxtStyle(title, 18, fontWeight: FontWeight.bold),
            centerTitle: true,
            toolbarHeight: 75.h,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 18),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Divider(height: 1, thickness: 1, color: darkGrey),
        ],
      ),
    );
  }
}
