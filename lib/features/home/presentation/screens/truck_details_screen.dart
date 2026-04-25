import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/core/utils/widgets/carsouel_widget.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/booking/application/booking_cubit.dart';
import 'package:bull_station/features/booking/presentaion/screens/truck_booking_screen.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/application/home_cubit/home_states.dart';
import 'package:bull_station/features/home/presentation/map_details_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/filter_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/info_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class TruckDetailsScreen extends StatelessWidget {
  final int id;
  final HomeCubit homeCubit;
  const TruckDetailsScreen({
    super.key,
    required this.id,
    required this.homeCubit,
  });

  @override
  Widget build(BuildContext context) {
    final user = homeCubit.currentUser;
    final isOwner = user != null && user.accountType != "client";
    String formatTime(String time) {
      // Splits "18:42:00" by ":" and takes the first two parts
      List<String> parts = time.split(':');
      return "${parts[0]}:${parts[1]}";
    }

    return Scaffold(
      appBar: TopNavBar("تفاصيل المعدة"),

      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocProvider.value(
            value: homeCubit..getTruckDetails(id),
            child: BlocConsumer<HomeCubit, HomeStates>(
              listener: (context, state) {
                if (state is DetailsLoadingState) {
                  showLoadingDialog(context);
                }
              },
              builder: (context, state) {
                if (state is DetailsLoadingState) {
                  return LoadingWidget();
                } else if (state is TruckDetailsSuccessState) {
                  var truckModel = state.truckDetailsModel;
                  return Column(
                    children: [
                      CarsouelWidget(
                        truckImages: truckModel.images,
                        truckVideo: truckModel.video,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TxtStyle(
                                      truckModel.name,
                                      18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    FilterWidget(
                                      title: truckModel.subCategory.toString(),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => MapDetailsScreen(
                                        title: truckModel.pickupLocation,
                                        latitude: truckModel.latitude,
                                        longitude: truckModel.longitude,
                                      ),
                                    ));
                                  },
                                  child: IconTextWidget(
                                    text: "${truckModel.pickupLocation} (اضغط للعرض)",
                                    size: 12,
                                    color: blue,
                                  ),
                                ),
                                SizedBox(height: 15.h),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: TxtStyle(
                                    "أسعار الحجز:",
                                    14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                PriceWidget(
                                  pricePerDay: truckModel.pricePerDay
                                      .replaceAll('.00', ''),
                                  pricePerHour: truckModel.pricePerHour
                                      .replaceAll('.00', ''),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: TxtStyle(
                                    "ساعات العمل:",
                                    14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                PriceWidget(
                                  isTime: true,
                                  pricePerDay: formatTime(
                                    truckModel.workHours.split(' - ')[0],
                                  ),
                                  pricePerHour: formatTime(
                                    truckModel.workHours.split(' - ')[1],
                                  ).toString(),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InfoWidget(
                                    "الوصف",
                                    desc: truckModel.description,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InfoWidget(
                                    "مميزات إضافية",
                                    desc: truckModel.features!.isEmpty
                                        ? "لا يوجد"
                                        : truckModel.features!,
                                  ),
                                ),
                                InfoWidget(
                                  "المواصفات",
                                  isSpecifications: true,
                                  size: truckModel.size,
                                  year: truckModel.yearOfManufacture.toString(),
                                  model: truckModel.model,
                                ),
                                InfoWidget(
                                  "بيانات السائق",
                                  isDriverData: true,
                                  truckOwnerModel: truckModel.owner,
                                ),

                                Divider(
                                  color: darkGrey,
                                  endIndent: 15,
                                  indent: 15,
                                ),
                                isOwner
                                    ? SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          CustomButton(
                                            text: "احجز الآن",
                                            onTap: () {
                                              final bookingCubit = context
                                                  .read<BookingCubit>();

                                              // 1. تجهيز البيانات قبل الانتقال
                                              bookingCubit.getTruckCalendar(
                                                truckModel.id,
                                              );
                                              bookingCubit.setTruckPrices(
                                                dayPrice: double.parse(
                                                  truckModel.pricePerDay,
                                                ),
                                                hourPrice: double.parse(
                                                  truckModel.pricePerHour,
                                                ),
                                                deliveryCost: double.parse(
                                                  truckModel.deliveryPrice,
                                                ),
                                                isDeliveryAvailable: truckModel
                                                    .deliveryAvailable,
                                              );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TruckBookingScreen(
                                                        truckDetailsModel:
                                                            truckModel,
                                                      ),
                                                ),
                                              );
                                            },
                                            width: 125,
                                          ),
                                          CustomButton(
                                            text: "اتصل بالمالك",
                                            onTap: () async {
                                              final cleanNumber = truckModel
                                                  .owner
                                                  .phone
                                                  .replaceAll(
                                                    RegExp(r'[^\d+]'),
                                                    '',
                                                  );
                                              final Uri launchUri = Uri(
                                                scheme: 'tel',
                                                path: cleanNumber,
                                              );

                                              if (await canLaunchUrl(
                                                launchUri,
                                              )) {
                                                await launchUrl(launchUri);
                                              }
                                            },
                                            width: 125,
                                            isSecondBtn: true,
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
