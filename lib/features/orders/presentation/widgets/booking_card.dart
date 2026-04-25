import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/booking/data/model/booking_model.dart';
import 'package:bull_station/features/booking/presentaion/screens/booking_details_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingCard extends StatelessWidget {
  final BookingModel bookingModel;
  final bool isOwner;
  const BookingCard({super.key, required this.bookingModel, this.isOwner = false});

  @override
  Widget build(BuildContext context) {
    String startDatetime = bookingModel.startDatetime.toString();
    String endDatetime = bookingModel.endDatetime.toString();
    String startDate = startDatetime.split(' ')[0];
    String endDate = endDatetime.split(' ')[0];
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: double.infinity,
        // height: 70.h,
        padding: EdgeInsets.only(top: 20, bottom: 20, right: 20),
        decoration: BoxDecoration(
          border: Border.all(color: darkGrey),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: TxtStyle(
                    "حجز رقم #${bookingModel.id}",
                    12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 79.w),

                FilterWidget(title: bookingModel.status, isStatus: true),
              ],
            ),
            TxtStyle(bookingModel.truck.name, 14, fontWeight: FontWeight.bold),
            IconTextWidget(
              text: "$startDate - $endDate",
              icon: Icons.calendar_today_rounded,
              size: 12,
            ),
            IconTextWidget(
              text: bookingModel.truck.pickupLocation!,
              icon: Icons.location_on_outlined,
              size: 12,
            ),
            IconTextWidget(
              text: "${bookingModel.totalPrice}\$",
              icon: Icons.credit_card_outlined,
              size: 12,
            ),
            Row(
              children: [
                Spacer(),
                CustomButton(
                  text: "عرض التفاصيل",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsScreen(
                          bookingModel: bookingModel,
                          isOwner: isOwner,
                        ),
                      ),
                    );
                  },
                  width: 120,
                  isDetails: true,
                ),
                SizedBox(width: 15.w),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
