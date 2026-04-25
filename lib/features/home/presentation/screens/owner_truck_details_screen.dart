import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/carsouel_widget.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/home/application/category_cubit/category_cubit.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/application/home_cubit/home_states.dart';
import 'package:bull_station/features/home/presentation/map_details_screen.dart';
import 'package:bull_station/features/home/presentation/screens/owner_home_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/filter_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/info_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/price_widget.dart';
import 'package:bull_station/features/truck/application/edit_truck_cubit.dart';
import 'package:bull_station/features/truck/data/models/truck_details_model.dart';
import 'package:bull_station/features/truck/presentaion/screens/add_truck_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerTruckDetailsScreen extends StatelessWidget {
  final HomeCubit? homeCubit;
  final String? status;
  final int? id;
  final bool isInReview;
  const OwnerTruckDetailsScreen({
    super.key,
    this.isInReview = false,
    this.homeCubit,
    this.status,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    String formatTime(String time) {
      // Splits "18:42:00" by ":" and takes the first two parts
      List<String> parts = time.split(':');
      return "${parts[0]}:${parts[1]}";
    }

    final bool isActive;
    if (status != null && status == "active") {
      isActive = true;
    } else {
      isActive = false;
    }
    return Scaffold(
      appBar: TopNavBar("تفاصيل المعدة"),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocProvider.value(
            value: BlocProvider.of<HomeCubit>(context)..getTruckDetails(id!),
            child: BlocConsumer<HomeCubit, HomeStates>(
              listener: (context, state) {
                if (state is DetailsLoadingState) {
                  showLoadingDialog(context);
                }
                if (state is TruckActivated ||
                    state is TruckDeactivated ||
                    state is TruckDeleted) {
                  if (Navigator.of(context).canPop()) {
                    if (state is TruckActivated) {
                      showToast(
                        context,
                        "تم إعادة عرض المعدة لباقي المستخدمين",
                        color: Colors.green,
                      );
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OwnerHomeScreen(),
                        ),
                      );
                    } else if (state is TruckDeactivated) {
                      showToast(
                        context,
                        "تم إخفاء المعدة عن المستخدمين",
                        color: Colors.orange,
                      );
                      Navigator.of(context).pop();
                      context.read<HomeCubit>().getMyTrucks();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OwnerHomeScreen(),
                        ),
                      );
                    } else if (state is TruckDeleted) {
                      showToast(context, "تم حذف المعدة من قاعدة البيانات");
                      Navigator.of(context).pop();
                      context.read<HomeCubit>().getMyTrucks();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OwnerHomeScreen(),
                        ),
                      );
                    }
                  }
                }
              },
              builder: (context, state) {
                if (state is DetailsLoadingState) {
                  return LoadingWidget();
                } else if (state is TruckDetailsSuccessState) {
                  TruckDetailsModel truckModel = state.truckDetailsModel;
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MapDetailsScreen(
                                          title: truckModel.pickupLocation,
                                          latitude: truckModel.latitude,
                                          longitude: truckModel.longitude,
                                        ),
                                      ),
                                    );
                                  },
                                  child: IconTextWidget(
                                    text:
                                        "${truckModel.pickupLocation} (اضغط للعرض)",
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
                                    desc:
                                        truckModel.features!.isEmpty ||
                                            truckModel.features == ""
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

                                Divider(
                                  color: darkGrey,
                                  endIndent: 15,
                                  indent: 15,
                                ),
                                isInReview
                                    ? Center(
                                        child: TxtStyle(
                                          "يقوم المدير بمراجعة البيانات، سيتم عرضها للمستخدمين قريباً.",
                                          14,
                                          longText: true,
                                          isDescribtion: true,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          isActive
                                              ? CustomButton(
                                                  text: "تعديل",
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BlocProvider<
                                                              EditTruckCubit
                                                            >(
                                                              create: (context) =>
                                                                  EditTruckCubit(
                                                                    truckModel,

                                                                    context
                                                                        .read<
                                                                          CategoryCubit
                                                                        >()
                                                                        .allCategories,
                                                                  ),
                                                              child: AddTruckInfoScreen(
                                                                isEdit: true,
                                                                truckModel:
                                                                    truckModel,
                                                              ),
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                  width: 125,
                                                )
                                              : SizedBox(),
                                          BlocConsumer<HomeCubit, HomeStates>(
                                            listener: (context, state) {},
                                            builder: (context, state) {
                                              return Center(
                                                child: CustomButton(
                                                  text: isActive
                                                      ? "إلغاء العرض"
                                                      : "عرض",
                                                  onTap: isActive
                                                      ? () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return Directionality(
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                                child: AlertDialog(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  content: SizedBox(
                                                                    width:
                                                                        320.w,
                                                                    child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        // Title
                                                                        const TxtStyle(
                                                                          "إلغاء العرض",
                                                                          14,
                                                                          textAlignm:
                                                                              TextAlign.center,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10.h,
                                                                        ),
                                                                        // Body text
                                                                        const TxtStyle(
                                                                          "هل تريد إخفاء هذه المركبة مؤقتاً عن بقية المستخدمين أم تريد حذفها نهائياً من التطبيق؟",
                                                                          12,
                                                                          longText:
                                                                              true,
                                                                          isDescribtion:
                                                                              true,
                                                                          color:
                                                                              darkGrey,
                                                                          textAlignm:
                                                                              TextAlign.center,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              20.h,
                                                                        ),
                                                                        // Buttons
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            CustomButton(
                                                                              text: "إلغاء العرض",
                                                                              onTap: () {
                                                                                homeCubit!.activateTruck(
                                                                                  false,
                                                                                  id!,
                                                                                );
                                                                              },
                                                                              width: 100,
                                                                              isSecondBtn: true,
                                                                            ),
                                                                            CustomButton(
                                                                              text: "حذف",
                                                                              onTap: () {
                                                                                homeCubit!.deleteTruck(
                                                                                  id!,
                                                                                );
                                                                              },
                                                                              width: 100,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  // Styling for the AlertDialog itself
                                                                  shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          5.r,
                                                                        ),
                                                                    side: const BorderSide(
                                                                      color:
                                                                          darkGrey,
                                                                    ),
                                                                  ),
                                                                  // This ensures no extra padding around the content
                                                                  contentPadding:
                                                                      EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10.w,
                                                                        vertical:
                                                                            15.h,
                                                                      ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      : () => homeCubit!
                                                            .activateTruck(
                                                              true,
                                                              id!,
                                                            ),
                                                  width: 125,
                                                  isSecondBtn: true,
                                                ),
                                              );
                                            },
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
