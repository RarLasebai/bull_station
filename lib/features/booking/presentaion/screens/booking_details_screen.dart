import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/booking/application/booking_cubit.dart';
import 'package:bull_station/features/booking/application/booking_states.dart';
import 'package:bull_station/features/booking/data/model/booking_model.dart';
import 'package:bull_station/features/booking/presentaion/screens/payment_screen.dart';
import 'package:bull_station/features/booking/presentaion/widgets/success_payment_dialog.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/application/home_cubit/home_states.dart';
import 'package:bull_station/features/home/presentation/screens/home_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/truck_card_widget.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel bookingModel;
  final bool isOwner;
  const BookingDetailsScreen({
    super.key,
    required this.bookingModel,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().getTruckDetails(bookingModel.truck.id);
    String startDatetime = bookingModel.startDatetime.toString();
    String endDatetime = bookingModel.endDatetime.toString();
    String startDate = startDatetime.split(' ')[0];
    String endDate = endDatetime.split(' ')[0];
    String startTime = startDatetime.split(' ')[1].substring(0, 5);
    String endTime = endDatetime.split(' ')[1].substring(0, 5);
    Color statusColor = softGrey;
    String title = "status";
    if (bookingModel.status == "pending") {
      title = "قيد المراجعة";
      statusColor = yellowBg;
    } else if (bookingModel.status == "approved") {
      title = "تم القبول";
      statusColor = blueBg;
    } else if (bookingModel.status == "rejected") {
      title = "مرفوض";
      statusColor = redBg;
    } else if (bookingModel.status == "cancelled") {
      title = "ملغي";
      statusColor = redBg;
    } else if (bookingModel.status == "completed") {
      title = "مكتمل";
      statusColor = greenBg;
    } else if (bookingModel.status == "confirmed") {
      title = "تم التأكيد";
      statusColor = greenBg;
    }
    return SafeArea(
      child: Scaffold(
        appBar: TopNavBar("تفاصيل الحجز"),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 10, bottom: 10, right: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: statusColor),
                      borderRadius: BorderRadius.circular(5),
                      color: statusColor,
                    ),
                    child: TxtStyle("حالة الحجز: $title", 14),
                  ),
                  SizedBox(height: 30.h),
                  TxtStyle("تفاصيل المركبة", 14),
                  BlocBuilder<HomeCubit, HomeStates>(
                    builder: (context, state) {
                      if (state is DetailsLoadingState) {
                        return LoadingWidget();
                      } else if (state is TruckDetailsSuccessState) {
                        final truck = state.truckDetailsModel;
                        return TruckCardWidget(
                          truckCardModel: TruckCardModel(
                            id: truck.id,
                            model: truck.model,
                            subCategory: truck.subCategory,
                            pricePerDay: truck.pricePerDay,
                            category: truck.category,
                            name: truck.name,
                            mainImage: truck.images[0],
                            status: truck.status,
                            pickupLocation: truck.pickupLocation,
                          ),
                        );
                      } else
                        return SizedBox();
                    },
                  ),
                  SizedBox(height: 30.h),
                  TxtStyle("بيانات الحجز", 14),
                  SizedBox(height: 10.h),
                  Container(
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
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 14,
                              color: primary,
                            ),
                            SizedBox(width: 5.w),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                TxtStyle(
                                  "يبدأ يوم $startDate من $startTime",
                                  12,
                                ),
                                TxtStyle("ينتهي يوم $endDate عند $endTime", 12),
                              ],
                            ),
                          ],
                        ),
                        IconTextWidget(
                          text: "الإجمالي: ${bookingModel.totalPrice}\$",
                          icon: Icons.credit_card_outlined,
                          size: 12,
                          isBooking: true,
                        ),
                        IconTextWidget(
                          text:
                              "موقع الاستلام: ${bookingModel.truck.pickupLocation!}",
                          icon: Icons.location_on_outlined,
                          size: 12,
                          isBooking: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  //owner's pending + rejected + approved
                  //customer's pending + approved + rejected
                  //1- check رفض
                  //2- check if they back to home with names
                  bookingModel.status == "pending"
                      ? isOwner
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomButton(
                                    text: "قبول",
                                    onTap: () async {
                                      await context
                                          .read<BookingCubit>()
                                          .changeBookingStatus(
                                            bookingModel.id,
                                            "approve",
                                          );

                                      await context
                                          .read<BookingCubit>()
                                          .getBookings(true);

                                      if (context.mounted) {
                                        showToast(
                                          context,
                                          "تم قبول الحجز بنجاح، في انتظار تأكيد العميل بالدفع.",
                                          color: Colors.green,
                                        );
                                        Navigator.pop(context);
                                      }
                                    },
                                    width: 100,
                                  ),
                                  CustomButton(
                                    text: "رفض",
                                    isSecondBtn: true,
                                    onTap: () async {
                                      await context
                                          .read<BookingCubit>()
                                          .changeBookingStatus(
                                            bookingModel.id,
                                            "reject",
                                          );

                                      await context
                                          .read<BookingCubit>()
                                          .getBookings(true);

                                      if (context.mounted) {
                                        showToast(
                                          context,
                                          "تم رفض الحجز، سيتم  إخطار العميل بذلك.",
                                          color: Colors.green,
                                        );

                                        Navigator.pop(context);
                                      }
                                    },
                                    width: 100,
                                  ),
                                ],
                              )
                            : TxtStyle(
                                "في انتظار موافقة المالك على الحجز",
                                14,
                                longText: true,
                              )
                      : bookingModel.status == "approved"
                      ? !isOwner
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TxtStyle(
                                    "تمت الموافقة، قم بتأكيد الحجز بدفع المبلغ.",
                                    14,
                                    longText: true,
                                  ),
                                  //غالبا api منفصل لأن هذا متع تغيير الحالة ياخذ ف التوكن متع المالك ويقبل او يرفض
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      BlocConsumer<BookingCubit, BookingStates>(
                                        listener: (context, state) async {
                                          if (state is PaymentSuccessState) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) =>
                                                  const SuccessPaymentDialog(),
                                            );

                                            Future.delayed(
                                              const Duration(seconds: 2),
                                              () {
                                                if (context.mounted) {
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomeScreen(),
                                                    ),
                                                    (route) => false,
                                                  );
                                                }
                                              },
                                            );
                                          }
                                          if (state is PaymentFailedState) {
                                            showToast(
                                              context,
                                              "فشلت عملية الدفع",
                                              color: Colors.red,
                                            );
                                            await context
                                                .read<BookingCubit>()
                                                .getBookings(false);
                                          }
                                        },
                                        builder: (context, state) {
                                          if (state is PaymentLoadingState) {
                                            return const LoadingWidget();
                                          }

                                          return CustomButton(
                                            text: "الدفع",
                                            onTap: () async {
                                              await context
                                                  .read<BookingCubit>()
                                                  .initiatePayment(
                                                    bookingModel.id,
                                                  );

                                              if (context.mounted) {
                                                // هنا نقرأ الحالة الحالية بعد انتهاء العملية
                                                final currentState = context
                                                    .read<BookingCubit>()
                                                    .state;
                                                if (currentState
                                                    is PaymentInitiatedState) {
                                                  final result = await showModalBottomSheet(
                                                    context: context,
                                                    isScrollControlled:
                                                        true, // ليأخذ الويب فيو مساحة كافية
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                  20.r,
                                                                ),
                                                          ),
                                                    ),
                                                    builder: (context) => Container(
                                                      height:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.height *
                                                          0.85, // يغطي 90% من الشاشة
                                                      child: PaymentScreen(
                                                        paymentUrl: currentState
                                                            .paymentUrl,
                                                      ),
                                                    ),
                                                  );

                                                  // التحقق من النتيجة بعد إغلاق الـ BottomSheet
                                                  if (result == 'verify' &&
                                                      context.mounted) {
                                                    context
                                                        .read<BookingCubit>()
                                                        .verifyPaymentStatus(
                                                          bookingModel.id,
                                                        );
                                                    // final currentState = context
                                                    //     .read<BookingCubit>()
                                                    //     .state;
                                                  }
                                                } else if (currentState
                                                    is PaymentInitiationFailedState) {
                                                  showToast(
                                                    context,
                                                    "فشل في بدء عملية الدفع، حاول مرة أخرى لاحقًا",
                                                    color: Colors.red,
                                                  );
                                                  await context
                                                      .read<BookingCubit>()
                                                      .getBookings(false);
                                                  // Navigator.pop(context);
                                                }
                                              }
                                            },
                                            width: 100,
                                          );
                                        },
                                      ),
                                      CustomButton(
                                        text: "إلغاء",
                                        isSecondBtn: true,
                                        onTap: () async {
                                          await context
                                              .read<BookingCubit>()
                                              .changeBookingStatus(
                                                bookingModel.id,
                                                "cancel",
                                              );

                                          await context
                                              .read<BookingCubit>()
                                              .getBookings(false);

                                          if (context.mounted) {
                                            showToast(
                                              context,
                                              "تم إلغاء الحجز بنجاح",
                                              color: Colors.green,
                                            );

                                            Navigator.pop(context);
                                          }
                                        },
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : TxtStyle(
                                "لقد وافقت على هذا الحجز، انتظر من العميل تأكيد الحجز بالدفع.",
                                14,
                                longText: true,
                              )
                      : bookingModel.status == "cancelled"
                      ? isOwner
                            ? TxtStyle(
                                "قام العميل بإلغاء هذا الحجز",
                                14,
                                longText: true,
                              )
                            : TxtStyle(
                                "قمت بإلغاء هذا الحجز",
                                14,
                                longText: true,
                              )
                      : bookingModel.status == "confirmed"
                      ? TxtStyle(
                          "تم التأكيد،  الحجز قيد الإجراء الآن.",
                          14,
                          longText: true,
                        )
                      : bookingModel.status == "rejected"
                      ? TxtStyle("تم رفض هذا الحجز.", 14, longText: true)
                      : bookingModel.status == "completed"
                      ? TxtStyle("اكتمل هذا الحجز بنجاح.", 14, longText: true)
                      : SizedBox(),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
