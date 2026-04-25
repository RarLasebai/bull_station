import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';

class TruckHeaderWidget extends StatelessWidget {
  final String title;
  final String icon;
  const TruckHeaderWidget({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            child: Image.asset("assets/icons/$icon.png"),
          ),
          SizedBox(height: 10),
          TxtStyle(title, 14, fontWeight: FontWeight.bold),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
