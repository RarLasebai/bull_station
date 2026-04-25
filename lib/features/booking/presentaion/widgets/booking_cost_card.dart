import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/booking/application/booking_cubit.dart';
import 'package:bull_station/features/booking/application/booking_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingCostCard extends StatelessWidget {
  const BookingCostCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingStates>(
      buildWhen: (previous, current) => current is BookingCostUpdatedState,
      builder: (context, state) {
        final BookingCubit cubit = BlocProvider.of<BookingCubit>(context);

        return Container(
          width: 370.w,
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(color: darkGrey),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconTextWidget(
                    text: "إجمالي التكلفة",
                    icon: Icons.credit_card_outlined,
                    size: 14,
                  ),
                  SizedBox(height: 10.h),
                  TxtStyle("تكلفة الإيجار", 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TxtStyle("خدمة التوصيل", 12),
                  ),
                  TxtStyle("الإجمالي", 12, fontWeight: FontWeight.bold),
                ],
              ),
              SizedBox(width: 70.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  TxtStyle(cubit.totalBookingCost.toString(), 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TxtStyle(cubit.isDeliveryEnabled ? cubit.deliveryPrice.toString() : "0", 12),
                  ),
                  TxtStyle(cubit.grandTotal.toString(), 12, fontWeight: FontWeight.bold),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
