import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Color color;
  const LoadingWidget({super.key, this.color = primary});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 16),
      child: Center(
        child: CircularProgressIndicator(color: color),
      ),
    );
  }
}
