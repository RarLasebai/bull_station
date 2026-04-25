import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/features/booking/application/booking_cubit.dart';
import 'package:bull_station/features/booking/application/booking_states.dart';
import 'package:bull_station/features/booking/presentaion/widgets/booking_cost_card.dart';
import 'package:bull_station/features/booking/presentaion/widgets/booking_delivery_card.dart';
import 'package:bull_station/features/booking/presentaion/widgets/booking_duration_card.dart';
import 'package:bull_station/features/home/presentation/screens/home_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/truck_card_widget.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:bull_station/features/truck/data/models/truck_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TruckBookingScreen extends StatelessWidget {
  final TruckDetailsModel truckDetailsModel;
  const TruckBookingScreen({super.key, required this.truckDetailsModel});

  @override
  Widget build(BuildContext context) {
    final BookingCubit bookingCubit = BlocProvider.of<BookingCubit>(context);
  ;
    //   bookingCubit.setTruckPrices(
    //   dayPrice: double.parse(truckDetailsModel.pricePerDay),
    //   hourPrice: double.parse(truckDetailsModel.pricePerHour),
    //   deliveryCost: double.parse(truckDetailsModel.deliveryPrice),
    //   isDeliveryAvailable: truckDetailsModel.deliveryAvailable,
    // );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: TopNavBar("حجز المعدة"),
        body: SafeArea(
          child: SingleChildScrollView(
            child: BlocConsumer<BookingCubit, BookingStates>(
              listener: (context, state) {
                if (state is CreateBookingSuccessState) {
                  showToast(
                    context,
                    "تم إرسال طلب الحجز بنجاح",
                    color: Colors.green,
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              builder: (context, state) {
                return Form(
                  key: bookingCubit.bookingFormKey,
                  child: Column(
                    children: [
                      TruckCardWidget(
                        truckCardModel: TruckCardModel(
                          id: truckDetailsModel.id,
                          model: truckDetailsModel.model,
                          subCategory: truckDetailsModel.subCategory,
                          pricePerDay: truckDetailsModel.pricePerDay,
                          category: truckDetailsModel.category,
                          mainImage: truckDetailsModel.images[0],
                          name: truckDetailsModel.name,
                          status: truckDetailsModel.status,
                          pickupLocation: truckDetailsModel.pickupLocation,
                        ),
                      ),
                      Divider(color: darkGrey),
                      SizedBox(height: 20.h),
                      BookingDurationCard(
                        startDate: bookingCubit.startDate,
                        endDate: bookingCubit.endDate,
                        startTime: bookingCubit.startTime,
                        endTime: bookingCubit.endTime,
                        onTapDateStart: () =>
                            bookingCubit.selectDate(context, true),
                        onTapDateEnd: () =>
                            bookingCubit.selectDate(context, false),
                        onTapTimeStart: () => bookingCubit.selectTime(
                          context,
                          true,
                          truckDetailsModel.workHours,
                        ),
                        onTapTimeEnd: () => bookingCubit.selectTime(
                          context,
                          false,
                          truckDetailsModel.workHours,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      BookingDeliveryCard(
                        deliveryPrice: truckDetailsModel.deliveryPrice,
                        isDeliveryEnabled: bookingCubit.isDeliveryEnabled,
                        onChanged: (value) =>
                            bookingCubit.toggleDelivery(value!),
                      ),
                      SizedBox(height: 20.h),
                      BookingCostCard(),
                      SizedBox(height: 20.h),
                      CustomButton(
                        text: "أرسل الطلب",
                        onTap: () {
                          bookingCubit.createBooking(truckDetailsModel);
                        },
                        width: 190,
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
